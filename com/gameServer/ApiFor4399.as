package com.gameServer
{
	
	
	import com.superkaka.Tools.DebugArea;
	import com.test.game.Const.DebugConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Event.ServerEvent;
	import com.test.game.Manager.SaveManager;
	
	import flash.display.Stage;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	
	import unit4399.events.SaveEvent;
	
	public class ApiFor4399 extends EventDispatcher
	{
		public var serviceHold:*;
		private var _stage:Stage;
		private static var _instance : ApiFor4399;

		public static function getIns():ApiFor4399
		{
			if(_instance == null){
				_instance = new ApiFor4399();
			}
			return _instance;
		}
		
		public function ApiFor4399(target:IEventDispatcher=null)
		{
			super();
		}
		
		
			
		public function get stage() : Stage
		{
			return _stage;
		}
		public function set stage(value:Stage) : void
		{
			_stage = value;
			
			serviceHold = Main.serviceHold;
			//initInfoTxt();
			initEvent();
			if(Main.serviceHold==null){
				showInfo("壳为空！");
			}else{
				showInfo("壳存在！");
			}
		}
		
		private function initEvent() : void
		{
			stage.addEventListener(SaveEvent.SAVE_GET,saveProcess);
			stage.addEventListener(SaveEvent.SAVE_SET,saveProcess);
			stage.addEventListener(SaveEvent.SAVE_LIST,saveProcess);
			//登录成功
			stage.addEventListener(SaveEvent.LOG,saveProcess);
			//调用4399存档界面，进行存档时，返回的档索引
			stage.addEventListener("saveBackIndex",saveProcess);
			//网络存档失败
			stage.addEventListener("netSaveError", netSaveErrorHandler, false, 0, true);
			//网络取档失败
			stage.addEventListener("netGetError", netGetErrorHandler, false, 0, true);
			//游戏防多开
			stage.addEventListener("multipleError", multipleErrorHandler, false, 0, true);
			//调用获取游戏是否多开的状态接口时，返回状态值
			stage.addEventListener("StoreStateEvent", getStoreStateHandler, false, 0, true);
			//调用读档接口且该档被封时，则会触发该事件
			stage.addEventListener("getDataExcep", getDataExcepHandler, false, 0, true);
			
			stage.addEventListener("userLoginOut", onUserLogOutHandler, false, 0, true);
			//关闭登陆窗口
			stage.addEventListener("MVC_CLOSE_PANEL", closePanelHandler, false, 0, true);
			
		}
		private function closePanelHandler (e:Event):void{  
			this.stage.dispatchEvent(new ServerEvent(EventConst.CLOSE_PANEL, e));
		}

		
		private function onUserLogOutHandler(e:Event) : void{
			DebugArea.getIns().showResult("-----logout-----", DebugConst.NORMAL);
			this.stage.dispatchEvent(new ServerEvent(EventConst.USER_LOGIN_OUT, e));
		}
		
		private var infoTxt:TextField;
		
		private function initInfoTxt():void{
			infoTxt = new TextField();
			infoTxt.border=true;
			infoTxt.width = 100;
			infoTxt.height = 200;
			infoTxt.wordWrap = true;
			infoTxt.x = 800;
			infoTxt.y = 50;
			infoTxt.text="开始操作！\r";
			stage.addChild(infoTxt);
		}
		private function showInfo(info:String):void{
			
			//infoTxt.text+=info+"\r";

		}
		
		private function saveProcess(e:SaveEvent):void{ 
			switch(e.type){ 
				case SaveEvent.SAVE_GET:
					//读档完成发出的事件
					//index:存档的位置
					//data:存档内容
					//datetime:存档时间
					//title:存档标题
					//e.ret = {"index":0,"data":"abc","datetime":"2010-11-02 16:30:59","title":"标题"}
					showInfo("获取到存档！");
					showInfo("存档序号： "+e.ret["index"]);
					showInfo("存档标题： "+e.ret["title"]);
					showInfo("存档内容： ");
					showInfo(e.ret["data"]);
					showInfo("存档时间： "+e.ret["datetime"]);
					this.stage.dispatchEvent(new ServerEvent(EventConst.SERVER_LOAD_DATA, e.ret));
					break;
				case SaveEvent.SAVE_SET:
					if(e.ret as Boolean == true){
						showInfo("存档成功！");
						this.stage.dispatchEvent(new ServerEvent(EventConst.SERVER_SAVE_DATA, e.ret,true));
						//存档成功
					}else{
						showInfo("存档失败！");
						this.stage.dispatchEvent(new ServerEvent(EventConst.SERVER_SAVE_DATA, e.ret,true));
						//存档失败
					}
					break;
				case "saveBackIndex":
					var tmpObj:Object = e.ret as Object;
					if(tmpObj == null || int(tmpObj.idx) == -1){
						trace("返回的存档索引值出错了");
						showInfo("返回的存档索引值出错了！");
						this.stage.dispatchEvent(new ServerEvent(EventConst.SERVER_BACK_INDEX, e.ret,false));
						break;
					}
					showInfo("返回的存档索引值(从0开始算)："+tmpObj.idx);
					trace("返回的存档索引值(从0开始算)："+tmpObj.idx);
					this.stage.dispatchEvent(new ServerEvent(EventConst.SERVER_BACK_INDEX, e.ret,true));
					break;
				case SaveEvent.SAVE_LIST:
					var data:Array = e.ret as Array;
					this.stage.dispatchEvent(new ServerEvent(EventConst.SERVER_GET_LIST, e.ret));
					if(data == null) break;
					for(var i:* in data){
						var obj:Object = data[i];
						if(obj == null) continue;
						
						//其中status表示存档状态。"0":正常 "1":临时封 "2":永久封
						//当status为"1"(临时封)或"2"(永久封)时，请在存档列表上加以提示
						//在点击该档位且status为"1"(临时封)时，请加带有申诉功能的提示框，允许玩家向客服申诉处理
						//    申诉入口：http://app.my.4399.com/r.php?app=feedback
						//    提供给玩家举报其他作弊玩家的入口：http://app.my.4399.com/r.php?app=feedback-report
						//在点击该档位且status为"2"(永久封)时，请加提示框且无需做申诉处理的功能
						var tmpStr:String = "存档的位置:" + obj.index + "存档时间:" + obj.datetime +"存档标题:"+ obj.title +"存档状态:"+ obj.status;
						trace(tmpStr);
					}
					break;
				case SaveEvent.LOG:
					//登录完成发出的事件 
					//e.ret =  {uid:439911,name:nickName}; 
					DebugArea.getIns().showResult("uid:" + e.ret.uid, DebugConst.NORMAL);
					this.stage.dispatchEvent(new ServerEvent(EventConst.USER_LOGIN_IN, e.ret));
					break;
			}
		}
		
		private function netSaveErrorHandler(evt:Event):void{
			showInfo("网络存档失败了！");
			trace("网络存档失败了！");}
		
		private function netGetErrorHandler(evt:DataEvent):void{
			var tmpStr:String = "网络取"+ evt.data +"档失败了！";
			showInfo(tmpStr);
			trace(tmpStr);
		}
		
		private function multipleErrorHandler(evt:Event):void{
			showInfo("游戏多开了！");
			trace("游戏多开了！");    
		}
		
		private function getStoreStateHandler(evt:DataEvent):void{
			//0:多开了，1：没多开，-1：请求数据出错了，-2：没添加存档API的key，-3：未登录不能取状态
			showInfo("存档状态序号："+evt.data);
			this.stage.dispatchEvent(new ServerEvent(EventConst.GET_STORE_STATE, evt.data));
			trace(evt.data);
		}
		
		private function getDataExcepHandler(evt:SaveEvent):void{
			//其中status表示存档状态。"0":正常 "1":临时封 "2":永久封
			//当status为"1"(临时封)时，请加带有申诉功能的提示框，允许玩家向客服申诉处理
			//    申诉入口：http://app.my.4399.com/r.php?app=feedback
			//    提供给玩家举报其他作弊玩家的入口：http://app.my.4399.com/r.php?app=feedback-report
			//当status为"2"(永久封)时，请加提示框且无需做申诉处理的功能
			var obj:Object = evt.ret as Object;
			var tmpStr:String = "存档的位置:" + obj.index +"存档状态:"+ obj.status
			showInfo(tmpStr);
			trace(tmpStr);
		}
		
		
		/**
		 * 读档参数类型：
		 * @param   ui      是否打开读档UI  默认为 true （类型：Boolean）
		 * @param   index   如果不开启UI，指定读档的位置（0-7）默认为0(类型:int)
		 */
		public function getData(ui:Boolean, index:int) : void
		{
			showInfo("开始读档");
			

			serviceHold.getData(ui,index);
			
			//读取存档列表操作完成 stage发出 "getuserdatalist"事件
		}
		
		/**
		 * 存档参数类型：
		 * @param   title   存档标题(类型为String)
		 * @param   data    存档数据（类型 Object,Array,String,Number,XML）
		 *                  Object,Array类型只能由String,Number,Array,Object 三种组合
		 * @param   ui      是否打开存档UI  默认为 true(类型：Boolean)
		 * @param   index   如果不开启UI，指定存档的位置（0-7）默认为0 (类型: int)
		 */
		public function saveData(title:String, data:*, ui:Boolean, index:int) : void
		{
			trace("saveData");
			showInfo("开始存档\r");
			serviceHold.saveData(title,data,ui,index);
		}
		
		
		/**
		 *  读取存档列表
		 * 
		 */		
		public function getList() : void
		{
			trace("getList");
			showInfo("开始读取存档列表\r");
			serviceHold.getList();
		}
		
		/**
		 * 开启存读档UI（可以保存，又可以读取）
		 * @param   title   存档标题
		 * @param   data    存档数据（类型 Object,Array,String,Number,XML）
		 *                  Object,Array类型只能由： String,Number,Array,Object 三种组合
		 */
		public function openSaveUI(title:String, data:Object) : void
		{
			serviceHold.openSaveUI(title,data);
			//玩家选择存档操作 stage发出 "saveuserdata"事件
			//玩家选择读档操作 stage发出 "getuserdata"事件
		}
		
		/**
		 * 获取游戏是否多开的状态 
		 * 
		 */		
		public function getStoreState() : void
		{
			serviceHold.getStoreState(); 
			//获取状态操作完成 stage发出 "StoreStateEvent"事件
		}
		
		/**
		 * 退出游戏 
		 * 
		 */
		public function quitGame() : void
		{
			DebugArea.getIns().showResult("server quitGame", DebugConst.NORMAL);
			serviceHold.userLogOut();
		}


	}
}