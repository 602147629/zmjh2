package com.test.game{
	import com.Open4399Tools.Open4399Tools;
	import com.gameServer.ApiFor4399;
	import com.gameServer.RankFor4399;
	import com.gameServer.ShopFor4399;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Keyboard.CommonKeyboardInput;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.MvcFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.DebugConst;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.AssetsUrlManager;
	import com.test.game.Manager.AutoFightManager;
	import com.test.game.Manager.BattleUIManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.EscortManager;
	import com.test.game.Manager.GameConstManager;
	import com.test.game.Manager.PublicNoticeManager;
	import com.test.game.Manager.SocketConnectManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Manager.URLManager;
	import com.test.game.Manager.WuYiManager;
	import com.test.game.Manager.Extra.DoubleDungeonManager;
	import com.test.game.Manager.Extra.OnlineBonusManager;
	import com.test.game.Manager.Layer.AnimationLayerManager;
	import com.test.game.Manager.Pipei.PlayerKillingManager;
	import com.test.game.Modules.MainGame.StartPageView;
	import com.test.game.Modules.MainGame.BaGua.SuanGuaView;
	import com.test.game.Modules.MainGame.Tip.HackTipView;
	import com.test.game.Mvc.BmdView.GameSenceView;
	import com.test.game.Mvc.control.data.DataControl;
	import com.test.game.Mvc.control.key.StartUpControl;
	import com.test.game.Time.HackChecker;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import unit4399.YuanChuangInface;
	
	public class GameMain{
		private var my_load:Loader;
		private var _stopRender:Boolean = false;
		public function GameMain(root:DisplayObjectContainer){
			LayerManager.getIns().init(root);
			AssetsUrlManager.getIns().init();
			AssetsManager.getIns().addQueen([],[
				AssetsUrl.JSON_DATA,
				AssetsUrl.getAssetObject(AssetsConst.STARTPAGESOUND),
				AssetsUrl.getAssetObject(AssetsConst.LOADVIEW),
				AssetsUrl.getAssetObject(AssetsConst.COMMON)], preLoad, null);
			AssetsManager.getIns().start();
			DebugArea.getIns().showResult("---------InitGameMain---------", DebugConst.NORMAL);
		}
		
		private function preLoad(...args) : void{
			StartUpControl(ControlFactory.getIns().initControl(StartUpControl)).startGame();
			MvcFactory.getIns().start();
			
			ConfigurationManager.getIns().init();
			URLManager.getIns().init();
			
			if(!GameConst.localLogin){
				ApiFor4399.getIns().serviceHold = Main.serviceHold;
				RankFor4399.getIns().serviceHold = Main.serviceHold;
				ShopFor4399.getIns().serviceHold = Main.serviceHold;
			}else{
				my_load = new Loader();
				my_load.load(new URLRequest("Assets/ctrlmov4V122.swf"));
				my_load.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteFun);
			}
			
			GameConst.stage.addEventListener(Event.ENTER_FRAME,__enterFrame);
//			GameConst.stage.addEventListener(Event.EXIT_FRAME,__exitFrame);
			GameConst.stage.addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			GameConst.stage.addEventListener(KeyboardEvent.KEY_UP,__keyUp);
			
			Open4399Tools.getIns().init();
			TimeManager.getIns().reqTime();
			//FontManager.getIns().init();
			ControlFactory.getIns().initControl(DataControl);
			ViewFactory.getIns().initView(StartPageView).show();
			
			HackChecker.enabledCheckSpeedUp(1000, 50);
			HackChecker.hackHandler = cheatFunction;
			HackChecker.resetHandler = resetFunction;
			DebugArea.getIns().showResult("---------LoadCompleteGameMain-------", DebugConst.NORMAL);
			
			
			if(GameConst.localLogin){
				setTimeout(function(){
					SocketConnectManager.getIns().connectToGate();
				},3000);
			}
		}
		
		
		private function cheatFunction() : void{
			(ViewFactory.getIns().initView(HackTipView) as HackTipView).setFun("请不要使用加速工具，关闭加速工具后才能继续游戏！", null, null, true);
			AnimationManager.getIns().isStop = true;
			if(BmdViewFactory.getIns().getView(GameSenceView) != null){
				(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).hackStopRender = true;
			}
			_stopRender = true;
		}
		
		private function resetFunction() : void{
			AnimationManager.getIns().isStop = false;
			if(BmdViewFactory.getIns().getView(GameSenceView) != null){
				(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).hackStopRender = false;
			}
			_stopRender = false;
			(ViewFactory.getIns().initView(HackTipView) as HackTipView).hide();
		}
		
		
		private function onCompleteFun(e:Event) : void{
			var gameID:String = "100021992";
			var loader:* = my_load.content;
			YuanChuangInface.getInstance().setInterface(
				GameConst.stage,
				loader,
				gameID
			);
			
			ApiFor4399.getIns().serviceHold = YuanChuangInface.getInstance();
			RankFor4399.getIns().serviceHold = YuanChuangInface.getInstance();
			ShopFor4399.getIns().serviceHold = YuanChuangInface.getInstance();
		}
		
		protected function __keyUp(evt:KeyboardEvent):void{
			CommonKeyboardInput.getIns().keyboard.keyUp(evt.keyCode);
		}
		
		protected function __keyDown(evt:KeyboardEvent):void{
			//DebugArea.getIns().showInfo("-----按下按键：" + evt.keyCode + "-----", DebugConst.NORMAL);
			if(ViewFactory.getIns().getView(SuanGuaView) && !ViewFactory.getIns().getView(SuanGuaView).isClose){
				(ViewFactory.getIns().getView(SuanGuaView) as SuanGuaView).suanGuaKeydown(evt.keyCode)
			}else{
				CommonKeyboardInput.getIns().keyboard.keyDown(evt.keyCode);
			}
			
		}		
		
		protected function __enterFrame(event:Event):void{
			//PhysicsWorld.getIns().step();
			//RenderEntityManager.getIns().step();
			AnimationManager.getIns().step();
			AnimationLayerManager.getIns().step();
			AutoFightManager.getIns().step();
			//AutoPKManager.getIns().step();
			if(!_stopRender){
				DoubleDungeonManager.getIns().step();
				OnlineBonusManager.getIns().step();
				PlayerKillingManager.getIns().step();
				WuYiManager.getIns().step();
				DailyMissionManager.getIns().step();
				EscortManager.getIns().step();
				PublicNoticeManager.getIns().step();
				BattleUIManager.getIns().step();
			}
		}
		
		protected function __exitFrame(event:Event):void{
//			KeyboardInput.getIns().step();
		}
	}
}