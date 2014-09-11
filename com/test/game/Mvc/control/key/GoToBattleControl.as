package com.test.game.Mvc.control.key{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.AssessManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.ServerControllor;
	import com.test.game.Manager.StoryManager;
	import com.test.game.Manager.Pipei.PlayerKillingManager;
	import com.test.game.Modules.GameMenu.view.GameMenuView;
	import com.test.game.Modules.MainGame.BuffShowView;
	import com.test.game.Modules.MainGame.LevelInfoView;
	import com.test.game.Modules.MainGame.Guide.OneKeyEquipView;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.MainUI.TreasureToolBar;
	import com.test.game.Modules.MainGame.Map.BaseMapBgView;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	import com.test.game.Modules.MainGame.Map.MainMapView;
	import com.test.game.Modules.MainGame.Map.PlayerKillingMapBgView;
	import com.test.game.Modules.MainGame.Map.PlayerKillingMapView;
	import com.test.game.Modules.MainGame.Map.TeamMapView;
	import com.test.game.Modules.MainGame.Mission.MissionHint;
	import com.test.game.Modules.MainGame.PlayerKilling.PlayerKillingTimeShow;
	import com.test.game.Mvc.BmdView.AutoPKSceneView;
	import com.test.game.Mvc.BmdView.GameSenceView;
	import com.test.game.Mvc.BmdView.PlayerKillingSceneView;
	import com.test.game.Mvc.BmdView.TeamGameSceneView;
	import com.test.game.Mvc.control.logic.SkillsCollisionControl;
	
	public class GoToBattleControl extends BaseControl{
		public var reEnterBattle:Boolean;
		public function GoToBattleControl(){
			super();
		}
		
		/**
		 *进入关卡
		 * 
		 */		
		public function goToBattle(data:Object, isReStart:Boolean = false):void{
			//DebugArea.getIns().showResult("------onEnterBattle_3------:", DebugConst.NORMAL);
			//伤害和被伤害检测处理
			ControlFactory.getIns().initControl(SkillsCollisionControl);
			//开启虚拟服务器
			ServerControllor.getIns().start();
			//隐藏开始界面
			var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
			if(gmv){
				gmv.hide();
			}
			//IMEManager.getIns().setEnglishIMEStatus();
			GuideManager.getIns().destoryGuideMC();
			LevelManager.getIns().nowIndex = data.level_id;
			LevelManager.getIns().levelData = data;
			reEnterBattle = isReStart;
			ViewFactory.getIns().initView(BaseMapView);
			//发送加载完毕
			/*if(!GameConst.isSingleGame){
				var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
				var sm2:LoadingComplete = new LoadingComplete();
				ssc.send(sm2);
			}*/
		}
		
		public function initBattleView() : void{
			StoryManager.getIns().initParams();
			if(ViewFactory.getIns().getView(OneKeyEquipView) != null){
				ViewFactory.getIns().getView(OneKeyEquipView).hide();
			}
			ViewFactory.getIns().getView(TreasureToolBar).hide();
			ViewFactory.getIns().getView(ExtraBar).hide();
			ViewFactory.getIns().getView(MissionHint).hide();
			ViewFactory.getIns().initView(RoleStateView).show();
			ViewFactory.getIns().initView(BuffShowView).show();
			ViewFactory.getIns().initView(LevelInfoView);
			ViewFactory.getIns().initView(BaseMapBgView);
			BmdViewFactory.getIns().initView(GameSenceView);
			AssessManager.getIns().clear();
		}
		
		public function gotoPlayerKilling() : void{
			//伤害和被伤害检测处理
			ControlFactory.getIns().initControl(SkillsCollisionControl);
			//开启虚拟服务器
			ServerControllor.getIns().playerKillingStart();
			ViewFactory.getIns().initView(PlayerKillingMapView);
		}
		
		public function gotoAutoPK() : void{
			//伤害和被伤害检测处理
			ControlFactory.getIns().initControl(SkillsCollisionControl);
			ServerControllor.getIns().start();
			ViewFactory.getIns().initView(PlayerKillingMapView);
		}
		
		public function initPlayerKillingView() : void{
			EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.HIDE_PARTNER_ROLE));
			if(ViewFactory.getIns().getView(OneKeyEquipView) != null){
				ViewFactory.getIns().getView(OneKeyEquipView).hide();
			}
			ViewFactory.getIns().getView(TreasureToolBar).hide();
			ViewFactory.getIns().getView(ExtraBar).hide();
			ViewFactory.getIns().getView(MissionHint).hide();
			ViewFactory.getIns().getView(MainMapView).hide();
			ViewFactory.getIns().getView(MainToolBar).hide();
			ViewFactory.getIns().initView(RoleStateView).show();
			ViewFactory.getIns().initView(PlayerKillingMapBgView);
			ViewFactory.getIns().initView(PlayerKillingTimeShow).show();
			if(PlayerKillingManager.getIns().pkType == 0){
				BmdViewFactory.getIns().initView(PlayerKillingSceneView);
			}else if(PlayerKillingManager.getIns().pkType == 1 || PlayerKillingManager.getIns().pkType == 2){
				BmdViewFactory.getIns().initView(AutoPKSceneView);
			}
			EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.HIDE_PARTNER_ROLE));
		}
		
		public function gotoTeamBattle(data:Object, isReStart:Boolean = false) : void{
			//DebugArea.getIns().showResult("------onEnterBattle_3------:", DebugConst.NORMAL);
			//伤害和被伤害检测处理
			ControlFactory.getIns().initControl(SkillsCollisionControl);
			//开启虚拟服务器
			ServerControllor.getIns().playerKillingStart();
			LevelManager.getIns().nowIndex = data.level_id;
			LevelManager.getIns().levelData = data;
			reEnterBattle = isReStart;
			ViewFactory.getIns().initView(TeamMapView);
		}
		
		public function initTeamBattleView() : void{
			if(ViewFactory.getIns().getView(OneKeyEquipView) != null){
				ViewFactory.getIns().getView(OneKeyEquipView).hide();
			}
			ViewFactory.getIns().getView(TreasureToolBar).hide();
			ViewFactory.getIns().getView(ExtraBar).hide();
			ViewFactory.getIns().getView(MissionHint).hide();
			ViewFactory.getIns().initView(RoleStateView).show();
			ViewFactory.getIns().initView(BuffShowView).show();
			ViewFactory.getIns().initView(LevelInfoView);
			ViewFactory.getIns().initView(BaseMapBgView);
			BmdViewFactory.getIns().initView(TeamGameSceneView);
			AssessManager.getIns().clear();
		}
		
	}
}