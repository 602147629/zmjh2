package com.test.game.Modules.MainGame.SaveAndLoad
{
	import com.gameServer.ApiFor4399;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ProxyFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.DebugConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Event.ServerEvent;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.SocketConnectManager;
	import com.test.game.Modules.MainGame.SelectPlayerView;
	import com.test.game.Modules.MainGame.StartPageView;
	import com.test.game.Modules.MainGame.WaitView;
	import com.test.game.Modules.MainGame.Info.InfoView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Proxy.FbSocketProxy;
	import com.test.game.Mvc.Proxy.GameSocketProxy;
	import com.test.game.Mvc.Proxy.GateSocketProxy;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SaveListView extends Sprite
	{
		private var _obj:Sprite;
		private var _title:MovieClip;
		private var _saveComponentArr:Vector.<SaveComponent>;
		
		private var _type:String;
		public var saveType:int;
		
		public function SaveListView()
		{
			super();
			rederView();
		}
		
		private function rederView():void
		{
			_obj = AssetsManager.getIns().getAssetObject("saveViewBG") as Sprite;
			this.addChild(_obj);	
			
			_title  = AssetsManager.getIns().getAssetObject("saveTitle") as MovieClip;
			_title.x = 50;
			this.addChild(_title);
			
			closeBtn.addEventListener(MouseEvent.CLICK,onClose);
			
			renderSaveComponents();
			initEvents();
		}
		
		private function initEvents():void{
			ApiFor4399.getIns().stage.addEventListener(EventConst.SERVER_GET_LIST,onGetList);
			ApiFor4399.getIns().stage.addEventListener(EventConst.SERVER_SAVE_DATA,onSave);
			ApiFor4399.getIns().stage.addEventListener(EventConst.SERVER_LOAD_DATA,onLoad);
			ApiFor4399.getIns().stage.addEventListener(EventConst.CLOSE_PANEL,onCloseMVC);
			ApiFor4399.getIns().stage.addEventListener(EventConst.USER_LOGIN_OUT,onUserLoginOut);
			ApiFor4399.getIns().stage.addEventListener(EventConst.USER_LOGIN_IN, onLoginIn);
			ApiFor4399.getIns().stage.addEventListener(EventConst.GET_STORE_STATE, onGetStoreState);
		}
		
		protected function onGetStoreState(e:ServerEvent):void{
			DebugArea.getIns().showResult("------StoreState------:" + e.targetData, DebugConst.NORMAL);
			if(e.targetData == "1"){
				SaveManager.getIns().saveFunction();
			}else if(e.targetData == "0"){
				(ViewFactory.getIns().initView(TipView) as TipView).setFun(
					"游戏多开了，无法保存游戏存档，请关闭该页面！", null, null, true);
			}else if(e.targetData == "-3"){
				(ViewFactory.getIns().initView(TipView) as TipView).setFun(
					"游戏未登录，无法保存游戏存档，请重新登录！", null, null, true);
			}else{
				(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"网络异常，请检测网络连接是否正常。如一直无法操作请刷新网页。", null, null);
			}
		}
		
		private function onLoginIn(e:ServerEvent):void{
			DebugArea.getIns().showResult("------logreturn------" + e.targetData.uid, DebugConst.NORMAL);
			GameConst.LOG_DATA = e.targetData as Object;
			GameConst.UID = GameConst.LOG_DATA.uid;
			
			SocketConnectManager.getIns().connectToGate();
			
			SaveManager.getIns().quitToMain();
		}
		
		//退出登陆
		private function onUserLoginOut(e:ServerEvent):void{
			DebugArea.getIns().showResult("------logout------", DebugConst.NORMAL);
			ProxyFactory.getIns().destroyProxy(GameSocketProxy);
			ProxyFactory.getIns().destroyProxy(FbSocketProxy);
			ProxyFactory.getIns().destroyProxy(GateSocketProxy);
			
			this.clear();
			onClose();
			SaveManager.getIns().quitToMain();
		}
		
		
		private function clear():void{
			for(var i :int = 0; i <6 ; i++){
				_saveComponentArr[i].setData();
			}
		}
		
		//关闭登陆窗口
		private function onCloseMVC(e:ServerEvent):void{
			ViewFactory.getIns().initView(WaitView).hide();
		}
		
		private function setData(targetData:*):void
		{
			for(var j:int = 0; j < 6; j++){
				_saveComponentArr[j].resetData();
			}
			for(var i :int = 0; i < targetData.length ; i++){
				if(targetData[i] != null){
					_saveComponentArr[targetData[i].index].setData(targetData[i]);
				}
			}
		}
		
		private function renderSaveComponents():void{
			_saveComponentArr = new Vector.<SaveComponent>;
			var index:int =0;
			for(var j:int = 0;j<3;j++){
				for(var i:int = 0;i<2;i++){
					var saveComponent:SaveComponent = new SaveComponent(index);
					saveComponent.x= 42+i*200;
					saveComponent.y= 58+j*75;
					this.addChild(saveComponent);
					_saveComponentArr.push(saveComponent);
					index++;
				}
			}
		}
		
		
		private function onGetList(e:ServerEvent):void{
			this.visible = true;
			if(e.targetData != null){
				setData(e.targetData);
			}else{
				clear();
			}
			ViewFactory.getIns().initView(WaitView).hide();
		}
		
		private function onSave(e:ServerEvent):void{
			ViewFactory.getIns().initView(WaitView).hide();
			this.visible = false;
			if(saveType == 0){
				(ViewFactory.getIns().initView(InfoView) as InfoView).setType(1, null, null);
				SaveManager.getIns().startSaveCallback();
			}else if(saveType == 2){
				SaveManager.getIns().startSaveCallback();
			}else{
				(ViewFactory.getIns().initView(InfoView) as InfoView).setType(3, null, 
					function() : void{
						ViewFactory.getIns().destroyView(SelectPlayerView);
						(ViewFactory.getIns().getView(StartPageView) as StartPageView).startGame(true);
					});
			}
		}
		
		private function onLoad(e:ServerEvent):void{
			ViewFactory.getIns().initView(WaitView).hide();
			PlayerManager.getIns().playerData = e.targetData.data;
			this.visible = false;
			(ViewFactory.getIns().initView(InfoView) as InfoView).setType(2, null, 
				function() : void{
					(ViewFactory.getIns().getView(StartPageView) as StartPageView).startGame();
				});
		}
		
		protected function onClose(event:MouseEvent = null):void
		{
			this.visible = false;
			
		}
		
		private function setComponentsType(type:int):void{
			for each(var component:SaveComponent in _saveComponentArr){
				component.setType(type);
			}
		}
		
		public function saveShow():void{
			_type = "save";
			_title.gotoAndStop(1);
			setComponentsType(1);
			//this.visible = true;
			ApiFor4399.getIns().getList();
			ViewFactory.getIns().initView(WaitView).show();
		}
		
		public function loadShow():void{
			_type = "load";
			_title.gotoAndStop(2);
			setComponentsType(2);
			//this.visible = true;
			ApiFor4399.getIns().getList();
			ViewFactory.getIns().initView(WaitView).show();
		}
		
		private function get closeBtn():SimpleButton
		{
			return _obj["closeBtn"];
		}
		
	}
}