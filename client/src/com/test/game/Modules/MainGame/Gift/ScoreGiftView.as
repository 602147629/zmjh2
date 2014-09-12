package com.test.game.Modules.MainGame.Gift
{
	import com.adobe.crypto.MD5;
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.DebugConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.GiftManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.URLManager;
	import com.test.game.Modules.MainGame.Info.CongratulationView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	public class ScoreGiftView extends BaseView
	{
		public function ScoreGiftView()
		{
			_anti = new Antiwear(new binaryEncrypt());
			super();		
		}

		private var _anti:Antiwear;
		
		//private static const KEYS:String = "1beffebbe8f20a0ff53b8fa238a87f23";
		private static const URLNAME:String = "http://my.4399.com/jifen/api-apply?";
		
		private static const KEYS:String = "02c7cc76654e77a32aa4c3d7fa5d096d";
		//private static const URLNAME:String = "http://my.4399.com/jifen/activation?";
		
		private function set giftId(value:int):void{
			_anti["scoreGiftId"] = value;
		}
		
		private function get giftId():int{
			return _anti["scoreGiftId"];
		}
		
		
		private function get giftNetId():int{
			return _anti["giftNetId"];
		}
		private function set giftNetId(value:int):void{
			_anti["giftNetId"] = value;
		}
		
		override public function init() : void{
			super.init();
			
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("ScoreGiftView") as Sprite;
				this.addChild(layer);
				setCenter();
			}

			
			initBg();
			initURL();
			initEvent();
			update();
		}
		
		
		
		private function initEvent():void
		{
			getGiftBtn.addEventListener(MouseEvent.CLICK,getGift);
			getCodeBtn.addEventListener(MouseEvent.CLICK,getCode);
			closeBtn.addEventListener(MouseEvent.CLICK,closeView);
		}
		
		protected function closeView(event:MouseEvent):void
		{
			resetCodeTxt();
			this.hide();
		}
		
		
		override public function show():void{
			super.show();
			resetCodeTxt();
		}
		
		private var _urlLoader:URLLoader;
		private function initURL() : void
		{
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_urlLoader.addEventListener(flash.events.Event.COMPLETE, urlCompleteHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlErrorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlErrorHandler);
		}
		
		
		private function urlCompleteHandler(e:flash.events.Event) : void
		{
			resetCodeTxt();
			var checkList:Array = new Array();
			checkList = dataAnalysis(e.target.data);
			DebugArea.getIns().showInfo("---" + checkList[0] + "---" + checkList[1] + "---", DebugConst.NORMAL);
			trace(checkList[0], checkList[1]);
			switch(checkList[0])
			{
				//未知错误
				case "99":
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"激活失败！");
					break; 
				//激活成功
				case "100":
					getActivity();
					break;
				//参数错误
				case "101":
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"激活失败！");
					break;
				//激活码不存在
				case "102":
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"激活码不存在！");
					break;
				//激活码还没被兑换
				case "103":
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"激活码还没被兑换！");
					break;
				//激活码被使用过了哦
				case "104":
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"激活码被使用过了哦！");
					break;
				//激活码只能被领取者使用
				case "105":
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"激活码只能被领取者使用！");
					break;
				//您的账号已经使用此礼包的激活码，不能再使用咯~
				case "106":
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"您的账号已经使用此礼包的激活码，不能再使用咯！");
					break;
				//token无效
				case "107":
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"激活失败！");
					break;
				//激活码失效了
				case "108":
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"激活码失效了！");
					break;
				//激活失败
				case "109":
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"激活失败！");
					break;
				//您的账号已经今天使用过激活码，不能再使用咯~
				case "110":
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"您的账号已经今天使用过激活码，不能再使用咯~！");
					break;
				default:
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"激活失败！");
					break;
			}

		}
		
		/**
		 * 激活成功
		 * @param str
		 * 
		 */		
		private function getActivity() : void
		{
			SaveManager.getIns().onSaveGame(
				function():void{
					switch(giftNetId)
					{
						case NumberConst.getIns().scoreGiftNetId:
							GiftManager.getIns().addGift(NumberConst.getIns().guiZuGiftId, false);
							break;
						case "864":
							GiftManager.getIns().addGift(NumberConst.getIns().wuYiGiftId, false);
							break;
						case NumberConst.getIns().duanwuGiftNetId:
							GiftManager.getIns().addGift(NumberConst.getIns().duanwuGiftId, false);
							break;
						case NumberConst.getIns().fiveGiftNetId:
							GiftManager.getIns().addGift(NumberConst.getIns().fiveYearsGiftId, false);
							break;
						case NumberConst.getIns().qiXiGiftNetId:
							GiftManager.getIns().addGift(NumberConst.getIns().qiXiGiftId, false);
							break;
						case NumberConst.getIns().zhongQiuNetId:
							GiftManager.getIns().addGift(NumberConst.getIns().zhongQiuGiftId, false);
							break;
					}
				},
				function():void{
					var giftStr:String;
					switch(giftNetId){
						case NumberConst.getIns().scoreGiftNetId:
							giftStr = "领取贵族礼包成功，请到道具栏打开礼包哦！";
							break;
						case "864":
							giftStr = "领取五一礼包成功，请到道具栏打开礼包哦！";
							break;
						case NumberConst.getIns().duanwuGiftNetId:
							giftStr = "领取端午礼包成功，请到道具栏打开礼包哦！";
							break;
						case NumberConst.getIns().fiveGiftNetId:
							giftStr = "领取尊享礼包成功，请到道具栏打开礼包哦！";
							break;
						case NumberConst.getIns().qiXiGiftNetId:
							giftStr = "领取七夕礼包成功，请到道具栏打开礼包哦！";
							break;
						case NumberConst.getIns().zhongQiuNetId:
							giftStr = "领取中秋礼包成功，请到道具栏打开礼包哦";
							break;
					}
					(ViewFactory.getIns().initView(CongratulationView) as CongratulationView).startPlay(giftId);
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).hide();
					update();
					hide();
				});
		}
		
		
		/**
		 * 分析从网页返回的数据
		 * @param str
		 * @return 
		 * 
		 */		
		private function dataAnalysis(str:String) : Array
		{
			var lastList:Array = new Array();
			var newStr:String = str.slice(1, str.length - 1);
			var arrList:Array = newStr.split(","); 
			for(var i:int = 0; i < arrList.length; i++)
			{
				var newList:Array = arrList[i].split(":");
				newList[1] = newList[1].slice(1, newList[1].length - 1);
				lastList[i] = newList[1];
			}
			lastList[1] = lastList[1].slice(1, lastList[1].length - 1);
			return lastList;
		}
		
		/**
		 * 加载异常
		 * @param e
		 * 
		 */		
		private function urlErrorHandler(e:IOErrorEvent) : void
		{
			(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
				"网络异常，请重新输入激活码！");
			resetCodeTxt();
		}
		
		
		/**
		 * 开始发送激活码
		 * 
		 */		
		private function sendCode() : void
		{
			sendData();
		}
		

		
		/**
		 * 收到返回的数据重新设置界面状态
		 * 
		 */		
		private function resetCodeTxt() : void
		{
			codeTxt.text = "";
		}
		
		/**
		 * 发送激活码数据
		 * 
		 */		
		private function sendData() : void
		{
			if(codeTxt.text == "") 
			{
				resetCodeTxt();
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"请输入激活码！");
				return;
			}
			
			if(PackManager.getIns().checkMaxRoomByNum(1)){
				urlData();
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"系统正在处理当中，请稍等...",null,null,true);
			}else{
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"背包空间不足！\n请留出空间后再领取");
			}

		}
		
		/**
		 * url数据发送
		 * 
		 */		
		private function urlData() : void
		{
			var activityStr:String = codeTxt.text;
			
			var urlVariables:URLVariables = new URLVariables();
			
			urlVariables.activation = activityStr;
			urlVariables.gid = NumberConst.getIns().gameId;
			urlVariables.product_id = giftNetId;
			urlVariables.type = 1;
			urlVariables.uid = GameConst.UID;
			var token:String = MD5.hash(urlVariables.activation + urlVariables.gid + urlVariables.product_id + urlVariables.type + urlVariables.uid + KEYS);
			

/*			urlVariables.activation = activityStr;
			urlVariables.uid = GameConst.UID;
			urlVariables.uniqueId = NumberConst.getIns().gameId;
			var token:String = MD5.hash(urlVariables.activation + "-" + urlVariables.uid + "-" + urlVariables.uniqueId + "-" + KEYS);*/
			
			
			urlVariables.token = token;
			
			var urlRequest:URLRequest = new URLRequest(URLNAME + Math.random());
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVariables;
			
			_urlLoader.load(urlRequest);
		}
		
		
		override public function update():void{
			codeTxt.text = "";
		}
		
		
		public function setData(id:int):void{
			giftName.gotoAndStop("gift"+id);
			giftId = id;
			switch(giftId){
				case NumberConst.getIns().guiZuGiftId:
					giftNetId = NumberConst.getIns().scoreGiftNetId;
					break;
				case NumberConst.getIns().duanwuGiftId:
					giftNetId = NumberConst.getIns().duanwuGiftNetId;
					break;
				case NumberConst.getIns().fiveYearsGiftId:
					giftNetId = NumberConst.getIns().fiveGiftNetId;
					break;
				case NumberConst.getIns().qiXiGiftId:
					giftNetId = NumberConst.getIns().qiXiGiftNetId;
					break;
				case NumberConst.getIns().zhongQiuGiftId:
					giftNetId = NumberConst.getIns().zhongQiuNetId;
					break;
			}
		}
		
		protected function getGift(event:MouseEvent):void
		{
			//GiftManager.getIns().addGift(NumberConst.getIns().guiZuGiftId);
			sendCode();
		}
		
		protected function getCode(event:MouseEvent):void{
			switch(giftId){
				case NumberConst.getIns().guiZuGiftId:
					URLManager.getIns().openIntegrationURL();
					break;
				case NumberConst.getIns().duanwuGiftId:
					URLManager.getIns().openDuwuIntegrationURL();
					break;
				case NumberConst.getIns().fiveYearsGiftId:
					URLManager.getIns().openFiveYearsURL();
					break;
				case NumberConst.getIns().qiXiGiftId:
					URLManager.getIns().openQiXiURL();
					break;
				case NumberConst.getIns().zhongQiuGiftId:
					URLManager.getIns().openZhongQiuURL();
					break;
			}
		}


		private function get codeTxt():TextField
		{
			return layer["codeTxt"];
		}
		
		private function get getGiftBtn():SimpleButton
		{
			return layer["getGiftBtn"];
		}
		
		private function get getCodeBtn():SimpleButton
		{
			return layer["getCodeBtn"];
		}
		
		private function get giftName():MovieClip
		{
			return layer["giftName"];
		}
		
		private function get giftTypeTxt():TextField
		{
			return layer["giftTypeTxt"];
		}
		

		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy():void{
			
			getGiftBtn.removeEventListener(MouseEvent.CLICK,getGift);
			getCodeBtn.removeEventListener(MouseEvent.CLICK,getCode);
			closeBtn.removeEventListener(MouseEvent.CLICK,closeView);
			
			super.destroy();
		}
		
	}
}