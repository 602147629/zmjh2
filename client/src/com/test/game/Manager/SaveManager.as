package com.test.game.Manager
{
	import com.gameServer.ApiFor4399;
	import com.greensock.TweenLite;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.AgreeMent.IStepAble;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Effect.ExpBar;
	import com.test.game.Manager.Extra.DoubleDungeonManager;
	import com.test.game.Manager.Extra.OnlineBonusManager;
	import com.test.game.Manager.Pipei.PlayerKillingManager;
	import com.test.game.Modules.MainGame.BagView;
	import com.test.game.Modules.MainGame.DoubleDungeonView;
	import com.test.game.Modules.MainGame.EliteSelectView;
	import com.test.game.Modules.MainGame.SelectPlayerView;
	import com.test.game.Modules.MainGame.SignInView;
	import com.test.game.Modules.MainGame.StartPageView;
	import com.test.game.Modules.MainGame.UpdateInfoView;
	import com.test.game.Modules.MainGame.WaitView;
	import com.test.game.Modules.MainGame.Achieve.AchieveView;
	import com.test.game.Modules.MainGame.BaGua.BaGuaView;
	import com.test.game.Modules.MainGame.BaGua.CouponBaguaView;
	import com.test.game.Modules.MainGame.BaGua.SuanGuaView;
	import com.test.game.Modules.MainGame.DungeonMenu.DungeonMenu;
	import com.test.game.Modules.MainGame.Escort.EscortResultView;
	import com.test.game.Modules.MainGame.Escort.EscortView;
	import com.test.game.Modules.MainGame.Escort.LootResultView;
	import com.test.game.Modules.MainGame.Escort.LootWaitView;
	import com.test.game.Modules.MainGame.FirstCharge.FirstChargeView;
	import com.test.game.Modules.MainGame.Gift.GiftView;
	import com.test.game.Modules.MainGame.Gift.ScoreGiftView;
	import com.test.game.Modules.MainGame.Guide.NewFunctionView;
	import com.test.game.Modules.MainGame.Guide.OneKeyEquipView;
	import com.test.game.Modules.MainGame.HeroFight.HeroGameOverView;
	import com.test.game.Modules.MainGame.HeroScript.HeroScriptView;
	import com.test.game.Modules.MainGame.JingMai.JingMaiView;
	import com.test.game.Modules.MainGame.JingMai.XueDaoView;
	import com.test.game.Modules.MainGame.Load.GongGaoView;
	import com.test.game.Modules.MainGame.MainUI.BattleToolBar;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.MainUI.PlayerKillingRoleStateView;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.MainUI.TreasureToolBar;
	import com.test.game.Modules.MainGame.Map.MainMapView;
	import com.test.game.Modules.MainGame.Mission.MissionHint;
	import com.test.game.Modules.MainGame.Mission.MissionView;
	import com.test.game.Modules.MainGame.PlayerKilling.PlayerKillingFightView;
	import com.test.game.Modules.MainGame.PlayerKilling.PlayerKillingWaitView;
	import com.test.game.Modules.MainGame.Role.RoleDetailView;
	import com.test.game.Modules.MainGame.Shop.ShopView;
	import com.test.game.Modules.MainGame.Skill.SkillButtonSetView;
	import com.test.game.Modules.MainGame.Skill.SkillLearnView;
	import com.test.game.Modules.MainGame.SkillUp.SkillUpView;
	import com.test.game.Modules.MainGame.Strengthen.StrengthenView;
	import com.test.game.Modules.MainGame.Summer.SummerGiftShowView;
	import com.test.game.Modules.MainGame.Summer.SummerGiftView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewForShopPay;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Modules.MainGame.Treasure.AllTreasureView;
	import com.test.game.Modules.MainGame.Vip.VipView;
	import com.test.game.Modules.MainGame.boss.BossView;
	import com.test.game.Mvc.BmdView.AutoPKSceneView;
	import com.test.game.Mvc.BmdView.EscortSceneView;
	import com.test.game.Mvc.BmdView.GameSenceView;
	import com.test.game.Mvc.BmdView.HeroSceneView;
	import com.test.game.Mvc.BmdView.LootSceneView;
	import com.test.game.Mvc.BmdView.NewGameSceneView;
	import com.test.game.Mvc.BmdView.PlayerKillingSceneView;
	import com.test.game.Mvc.BmdView.RoleEntityView;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.Escort.EscortControl;
	import com.test.game.Mvc.control.key.GotoHeroBattleControl;
	import com.test.game.Mvc.control.key.LeaveGameControl;
	import com.test.game.Mvc.control.key.NewGameControl;
	
	import flash.external.ExternalInterface;
	
	public class SaveManager extends Singleton{
		private var _onlyJudgeMulti:Boolean = false;
		public function SaveManager(){
			super();
		}
		
		public static function getIns():SaveManager{
			return Singleton.getIns(SaveManager);
		}

		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public var saveCallback:Function;
		public var storeCallback:Function;
		
		
		public function quitToMain() : void{
			if(BmdViewFactory.getIns().getView(GameSenceView) != null){
				(ControlFactory.getIns().getControl(LeaveGameControl) as LeaveGameControl).leaveLevel();
			}
			if(BmdViewFactory.getIns().getView(PlayerKillingSceneView) != null){
				(ControlFactory.getIns().getControl(LeaveGameControl) as LeaveGameControl).leavePlayerKilling();
			}
			if(BmdViewFactory.getIns().getView(AutoPKSceneView) != null){
				(ControlFactory.getIns().getControl(LeaveGameControl) as LeaveGameControl).leaveAutoPK();
			}
			if(BmdViewFactory.getIns().getView(EscortSceneView) != null){
				(ControlFactory.getIns().getControl(EscortControl) as EscortControl).leaveEscort();
			}
			if(BmdViewFactory.getIns().getView(LootSceneView) != null){
				(ControlFactory.getIns().getControl(EscortControl) as EscortControl).leaveLoot();
			}
			if(BmdViewFactory.getIns().getView(NewGameSceneView) != null){
				(ControlFactory.getIns().getControl(NewGameControl) as NewGameControl).leaveNewGame();
			}
			if(BmdViewFactory.getIns().getView(HeroSceneView) != null){
				(ControlFactory.getIns().getControl(GotoHeroBattleControl) as GotoHeroBattleControl).leaveBattle();
			}
			if(BmdViewFactory.getIns().getView(RoleEntityView) != null){
				BmdViewFactory.getIns().destroyView(RoleEntityView);
			}
			ViewFactory.getIns().initView(WaitView).show();
			if(ViewFactory.getIns().getView(StartPageView).isClose){
				(ViewFactory.getIns().initView(WaitView) as WaitView).addBlackBg();
			}
			TweenLite.delayedCall(.5, function () : void{ViewFactory.getIns().getView(WaitView).hide()});
			
			//TipsManager.getIns().clear();
			(ViewFactory.getIns().getView(StartPageView) as StartPageView).quitGameCartoon();
			resetView();
			ViewFactory.getIns().getView(StartPageView).show();
		}
		
		public function resetView() : void{
			GuideManager.getIns().clear();
			DoubleDungeonManager.getIns().clear();
			OnlineBonusManager.getIns().clear();
			AutoFightManager.getIns().clear();
			PlayerKillingManager.getIns().clear();
			DailyMissionManager.getIns().clear();
			EscortManager.getIns().clear();
			SceneManager.getIns().clear();
			PublicNoticeManager.getIns().clear();
			BattleUIManager.getIns().clear();
			GameSceneManager.getIns().clear();
			
			hideView(EliteSelectView);
			hideView(SkillLearnView);
			hideView(SkillButtonSetView);
			hideView(BossView);
			hideView(MissionView);
			hideView(StrengthenView);
			hideView(MissionHint);
			hideView(DungeonMenu);
			hideView(ExtraBar);
			hideView(MainToolBar);
			hideView(RoleDetailView);
			hideView(TipViewWithoutCancel);
			hideView(TipView);
			hideView(BagView);
			hideView(RoleStateView);
			hideView(MainMapView);
			hideView(ExpBar);
			hideView(TreasureToolBar);
			hideView(GiftView);
			hideView(SelectPlayerView);
			hideView(UpdateInfoView);
			hideView(NewFunctionView);
			hideView(OneKeyEquipView);
			hideView(PlayerKillingRoleStateView);
			hideView(SuanGuaView);
			hideView(BaGuaView);
			hideView(SignInView);
			hideView(DoubleDungeonView);
			hideView(SkillUpView);
			hideView(AllTreasureView);
			hideView(ShopView);
			hideView(ScoreGiftView);
			hideView(TipViewForShopPay);
			hideView(VipView);
			hideView(PlayerKillingFightView);
			hideView(PlayerKillingWaitView);
			hideView(GongGaoView);
			hideView(CouponBaguaView);
			hideView(EscortView);
			hideView(LootWaitView);
			hideView(EscortResultView);
			hideView(LootResultView);
			hideView(AchieveView);
			hideView(FirstChargeView);
			hideView(JingMaiView);
			hideView(XueDaoView);
			hideView(SummerGiftView);
			hideView(SummerGiftShowView);
			hideView(HeroScriptView);
			
			if(ViewFactory.getIns().getView(MissionView) != null){
				(ViewFactory.getIns().getView(MissionView) as MissionView).resetMissionType();
			}
			if(ViewFactory.getIns().getView(EliteSelectView) != null){
				(ViewFactory.getIns().getView(EliteSelectView) as EliteSelectView).clear();
			}
			if(ViewFactory.getIns().getView(SuanGuaView) != null){
				(ViewFactory.getIns().getView(SuanGuaView) as SuanGuaView).sureReStart();
			}
			
			var viewList:Vector.<IStepAble> = RenderEntityManager.getIns().childrensList;
			for(var i:int = viewList.length - 1; i >= 0; i--){
				if(viewList[i] != null && viewList[i] is BaseView){
					hideView(viewList[i] as Class);
				}
			}
			
			if(PlayerManager.getIns().player != null){
				PlayerManager.getIns().playerClear();
			}
		}
		
		private function hideView(cls:Class) : void{
			if(ViewFactory.getIns().getView(cls) != null){
				ViewFactory.getIns().getView(cls).hide();
			}
		}
		
		//单独多开判断
		public function onJudgeMulti(storeCallbackInput:Function = null) : void{
			_onlyJudgeMulti = true;
			storeCallback = storeCallbackInput;
			judgeUserID();
		}
		
		/**
		 * 保存存档
		 * @param storeCallbackInput	先判断网络连接和多开情况，这时候数据不改变，判断若返回成功，则会执行saveFunction函数，并调用storeCallbackInput函数改变数据，然后提交保存
		 * @param saveCallbackInput		先判断是否保存成功，判断若保存成功，则会调用saveCallbackInput函数，saveCallbackInput函数一般为界面的刷新
		 * 
		 */		
		public function onSaveGame(storeCallbackInput:Function = null, saveCallbackInput:Function = null, saveType:int = 0) : void{
			storeCallback = storeCallbackInput;
			saveCallback = saveCallbackInput;
			_onlyJudgeMulti = false;
			//onlySave();return;
			(ViewFactory.getIns().getView(StartPageView) as StartPageView).saveListView.saveType = saveType;
			if(GameConst.localLogin){
				if(GameConst.localData){
					PlayerManager.getIns().getPlayerDataJson();
					startStoreCallback();
					startSaveCallback();
				}else{
					judgeUserID();
				}
			}else{
				judgeUserID();
			}
		}
		
		//1、论坛防多开判断
		public function judgeUserID() : void{
			if(!GameConst.localLogin){
				var result:Boolean;
				var webuid:int = ExternalInterface.call("UniLogin.getUid");
				var myUid:int = GameConst.LOG_DATA.uid;
				result = (webuid == myUid);
				if(!result){
					(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun("当前账号不是最新账号，请重新登录！", null, null);
				}else{
					//2、网络连接和多开情况判断
					ApiFor4399.getIns().getStoreState();
				}
			}else{
				ApiFor4399.getIns().getStoreState();
			}
		}
		
		public function onlySave(saveCallbackInput:Function = null, saveType:int = 0) : void{
			(ViewFactory.getIns().getView(StartPageView) as StartPageView).saveListView.saveType = saveType;
			saveCallback = saveCallbackInput;
			var data:String = PlayerManager.getIns().getPlayerDataJson();
			var saveTitle:String = player.name + "|" + player.character.characterConfig.name +"    lv."+ player.character.lv.toString();
			ApiFor4399.getIns().saveData(saveTitle,data,false,PlayerManager.getIns().saveIndex);
		}
		
		//3、网络连接和多开情况正常，则执行该函数保存数据
		public function saveFunction() : void{
			startStoreCallback();
			if(!_onlyJudgeMulti){
				var data:String = PlayerManager.getIns().getPlayerDataJson();
				var saveTitle:String = player.name + "|" + player.character.characterConfig.name +"    lv."+ player.character.lv.toString();
				ApiFor4399.getIns().saveData(saveTitle,data,false,PlayerManager.getIns().saveIndex);
			}
		}
		
		
		private function startStoreCallback() : void{
			if(storeCallback != null){
				storeCallback();
			}
		}
		public function startSaveCallback() : void{
			if(saveCallback != null){
				saveCallback();
			}
		}
		
		
	}
}