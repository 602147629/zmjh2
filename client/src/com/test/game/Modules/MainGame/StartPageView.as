package com.test.game.Modules.MainGame
{
	import com.gameServer.ApiFor4399;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.DebugConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.DebugManager;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.GiftManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.URLManager;
	import com.test.game.Manager.Enemy.EnemyManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Modules.MainGame.Info.CongratulationView;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.MainUI.TreasureToolBar;
	import com.test.game.Modules.MainGame.Map.MainMapView;
	import com.test.game.Modules.MainGame.Mission.MissionHint;
	import com.test.game.Modules.MainGame.SaveAndLoad.SaveListView;
	import com.test.game.Modules.MainGame.Summer.SummerGiftView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.PublicNoticeView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.control.View.GameSceneControl;
	import com.test.game.Mvc.control.View.PassLevelControl;
	import com.test.game.Mvc.control.View.PlayerUIControl;
	import com.test.game.Mvc.control.data.DataControl;
	import com.test.game.Mvc.control.key.InitLoadingCompleteControl;
	import com.test.game.cartoon.NewGameCartoon;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class StartPageView extends BaseView
	{
		public function StartPageView(){
			super();
		}
		
		override public function init():void{
			super.init();
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.INFOVIEW),
				AssetsUrl.getAssetObject(AssetsConst.STARTPAGEVIEW),
				AssetsUrl.getAssetObject(AssetsConst.STARTGAMEVIEW),
				AssetsUrl.getAssetObject(AssetsConst.TIPVIEW)
			];
			
			AssetsManager.getIns().addQueen([], arr, start, LoadManager.getIns().onProgress);
			AssetsManager.getIns().start();
			DebugArea.getIns().showResult("---------InitStartPageView-------", DebugConst.NORMAL);
		}
		
		private function start(...args) : void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.STARTPAGEVIEW.split("/")[1]) as Sprite;
				this.addChild(layer);
				
				ViewFactory.getIns().initView(TipView).hide();
				ViewFactory.getIns().initView(NoticeView).hide();
				
				initParams();
				initUI();
				setParams();
				DebugArea.getIns().showResult("---------LoadCompleteStartPageView-------", DebugConst.NORMAL);
			}
		}
		
		private function initParams():void{
			
		}		
		
		public var saveListView:SaveListView;
		private function initUI():void{
			(layer["NewGameBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onNewGame);
			(layer["GetRecordBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onGetRecord);
			(layer["UpdateInfoBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onUpdateInfo);
			(layer["TurnToBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onTurnToBtn);
			(layer["QuitGameBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onQuitGame);
			(layer["Version"] as TextField).text = GameConst.VERSION;
			
			saveListView = new SaveListView();
			saveListView.x = 270;
			saveListView.y = 130;
			saveListView.visible = false;
			this.addChild(saveListView);
		}
		
		override public function show():void{
			super.show();
			
			SoundManager.getIns().bgSoundPlay(AssetsConst.STARTPAGESOUND);
		}
		
		private function onNewGame(e:MouseEvent) : void{
			if(GameConst.localLogin){
				if(GameConst.localData){
					startGame();
					//SocketConnectManager.getIns().connectToGate();
				}else{
					saveListView.saveShow();
				}
			}else{
				saveListView.saveShow();
			}
		}
		
		private function onGetRecord(e:MouseEvent) : void{
			saveListView.loadShow();
		}
		
		private function onUpdateInfo(e:MouseEvent) : void{
			ViewFactory.getIns().initView(UpdateInfoView).show();
		}
		
		private function onTurnToBtn(e:MouseEvent) : void{
			URLManager.getIns().openForumURL();
		}
		
		private function onQuitGame(e:MouseEvent) : void{
			ApiFor4399.getIns().quitGame();
		}
		
		private var _isNew:Boolean;
		public function get isNew() : Boolean{
			return _isNew;
		}
		public function set isNew(value:Boolean) : void{
			_isNew = value;
		}
		public function startGame(isNew:Boolean = false) : void{
			_isNew = isNew;
			var arr:Array = [
				AssetsUrl.ACTIONS,
				AssetsUrl.getAssetObject(AssetsConst.ICONVIEW),
				AssetsUrl.getAssetObject(AssetsConst.SKILL_COLLISION),
				AssetsUrl.getAssetObject(AssetsConst.DISPOSITIONUI),
				AssetsUrl.getAssetObject(AssetsConst.MAINUI),
				AssetsUrl.getAssetObject(AssetsConst.MAINMAPVIEW),
				AssetsUrl.getAssetObject(AssetsConst.MAINMAPSOUND),
				AssetsUrl.getAssetObject(AssetsConst.BURINGCARTOON),
				AssetsUrl.getAssetObject(AssetsConst.FIGHTEFFECT),
				AssetsUrl.getAssetObject(AssetsConst.EFFECT),
				AssetsUrl.getAssetObject(AssetsConst.GUIDE),
				AssetsUrl.getAssetObject(AssetsConst.MISSIONVIEW),
				AssetsUrl.getAssetObject(AssetsConst.SIGNINVIEW)
			];
			
			if(GameConst.localData){
				arr.push(AssetsUrl.PLAYER_DATA);
			}
			
			if(_isNew){
				arr.push(AssetsUrl.getAssetObject(AssetsConst.NEWGAMECARTOON));
				var loadingFodder:Array = MapManager.getIns().preLoadingFodder("1_10", 0);
				arr = arr.concat(AssetsUrl.getFodderObject(loadingFodder));
				arr = arr.concat(AssetsUrl.getFodderObject(MapManager.getIns().getPlayerFodder(1)));
				arr = arr.concat(AssetsUrl.getFodderObject(MapManager.getIns().getPlayerFodder(2)));
				var equip:Array = PlayerManager.getIns().getNewGameEquipped(1, "KuangWu");
				for(var i:int = 0; i < equip.length; i++){
					arr.push(AssetsUrl.getAssetObject("Role/" + equip[i]));
				}
				var partnerEquip:Array = PlayerManager.getIns().getNewGameEquipped(2, "XiaoYao");
				for(var j:int = 0; j < partnerEquip.length; j++){
					arr.push(AssetsUrl.getAssetObject("Role/" + partnerEquip[j]));
				}
				var nowSound:String = SoundManager.getIns().soundName("1_10");
				arr = arr.concat([AssetsUrl.getAssetObject(nowSound)]);
				arr = arr.concat(MapManager.getIns().mapBgResource("1_10", 0));
				arr = arr.concat([
					AssetsUrl.getAssetObject(MapManager.getIns().mapResource("1_10", 0)),
					AssetsUrl.getAssetObject(AssetsConst.LEVELINFOVIEW),
					AssetsUrl.getAssetObject(AssetsConst.PASSLEVELVIEW),
					AssetsUrl.getAssetObject(AssetsConst.DUNGEONUI),
					AssetsUrl.getAssetObject(AssetsConst.BOSSFIGHTSOUND),
					AssetsUrl.getAssetObject(AssetsConst.PASSLEVELSOUND),
					AssetsUrl.getAssetObject(AssetsConst.XIAOYAOHITSOUND),
					AssetsUrl.getAssetObject(AssetsConst.KUANGWUHITSOUND),
					AssetsUrl.getAssetObject(AssetsConst.COMMONSOUND),
					AssetsUrl.getAssetObject(AssetsConst.WEATHEREFFECT),
					AssetsUrl.getAssetObject(AssetsConst.WEATHERBLACKSOUND),
					AssetsUrl.getAssetObject(AssetsConst.WEATHERRAINSOUND),
					AssetsUrl.getAssetObject(AssetsConst.HIDEMISSIONSCENE),
					AssetsUrl.getAssetObject(AssetsConst.BOSSBATTLEBAR),
					AssetsUrl.getAssetObject(AssetsConst.NEWGAMECARTOONSOUND)
				]);
			}
			
			AssetsManager.getIns().addQueen([], arr, onStart, LoadManager.getIns().onProgress);
			AssetsManager.getIns().start();
		}
		
		private var _newGameCartoon:NewGameCartoon;
		private function onStart(...args):void{
			ControlFactory.getIns().initControl(DataControl);
			ControlFactory.getIns().initControl(PlayerUIControl);
			ControlFactory.getIns().initControl(GameSceneControl);
			ControlFactory.getIns().initControl(PassLevelControl);
			
			PlayerManager.getIns().reqPlayerData(null);
			
			EnemyManager.getIns().initEnemyData();
			SkillManager.getIns().initSkillData();
			DebugManager.getIns().init();
			
			var initLoadingComplete:InitLoadingCompleteControl = ControlFactory.getIns().getControl(InitLoadingCompleteControl) as InitLoadingCompleteControl;
			initLoadingComplete.execute();

			ViewFactory.getIns().getView(StartPageView).hide();
			ViewFactory.getIns().initView(MainMapView).show();
			ViewFactory.getIns().initView(TipViewWithoutCancel).hide();
			ViewFactory.getIns().initView(MissionHint).show();
			ViewFactory.getIns().initView(MainToolBar).show();
			ViewFactory.getIns().initView(TreasureToolBar).show();
			ViewFactory.getIns().initView(ExtraBar).show();
			
			ViewFactory.getIns().initView(MainToolBar).update();
			ViewFactory.getIns().initView(ExtraBar).update();
			ViewFactory.getIns().initView(RoleStateView).show();
			ViewFactory.getIns().initView(PublicNoticeView);
			
			//显示每日签到界面
			if(PlayerManager.getIns().player.mainMissionVo.id > 1011){
				if(PlayerManager.getIns().player.signInVo.canSignIn
					&& PlayerManager.getIns().player.signInVo.signInCount < 25){
					ViewFactory.getIns().initView(SignInView).show();
				}
			}
			
			
			if(GiftManager.getIns().checkGift(NumberConst.getIns().huiKuiGiftId) != NumberConst.getIns().one){
				(ViewFactory.getIns().initView(CongratulationView) as CongratulationView).startPlay(NumberConst.getIns().huiKuiGiftId);
				GiftManager.getIns().addGift(NumberConst.getIns().huiKuiGiftId, false);
			}
			
			if(ViewFactory.getIns().getView(ExtraBar) != null){
				(ViewFactory.getIns().getView(ExtraBar) as ExtraBar).renderPosition();
			}
			
			DeformTipManager.getIns().allCheck();
			
			if(_isNew){
				_newGameCartoon = new NewGameCartoon();
				_newGameCartoon.init();
			}else{
				if(PlayerManager.getIns().player.summerCarnivalInfo.checkShowView()){
					ViewFactory.getIns().initView(SummerGiftView).show();
				}
			}
		}
		
		public function clearGameCartoon() : void{
			if(_newGameCartoon != null){
				_newGameCartoon.onSkipAll();
			}
		}
		
		public function quitGameCartoon() : void{
			if(_newGameCartoon != null){
				_newGameCartoon.onClearAll();
			}
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
	}
}