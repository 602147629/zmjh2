package com.test.game.Mvc.control.key{
	import com.superkaka.game.ResourceOperation.BitmapDataPool;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Manager.BattleUIManager;
	import com.test.game.Manager.FbPlayersManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.ServerControllor;
	import com.test.game.Modules.MainGame.BossBattleBar;
	import com.test.game.Modules.MainGame.BuffShowView;
	import com.test.game.Modules.MainGame.LevelInfoView;
	import com.test.game.Modules.MainGame.Guide.FirstLevelGuideView;
	import com.test.game.Modules.MainGame.Guide.OneKeyEquipView;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.MainUI.PlayerKillingRoleStateView;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.MainUI.TreasureToolBar;
	import com.test.game.Modules.MainGame.Map.BaseMapBgView;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	import com.test.game.Modules.MainGame.Map.MainMapView;
	import com.test.game.Modules.MainGame.Map.PlayerKillingMapBgView;
	import com.test.game.Modules.MainGame.Map.PlayerKillingMapView;
	import com.test.game.Modules.MainGame.Mission.MissionHint;
	import com.test.game.Modules.MainGame.PlayerKilling.PlayerKillingTimeShow;
	import com.test.game.Mvc.BmdView.AutoPKSceneView;
	import com.test.game.Mvc.BmdView.GameSenceView;
	import com.test.game.Mvc.BmdView.PlayerKillingSceneView;
	import com.test.game.Mvc.control.logic.SkillsCollisionControl;
	
	public class LeaveGameControl extends BaseControl{
		public function LeaveGameControl(){
			super();
		}
		
		/**
		 *离开关卡
		 * 
		 */		
		public function leaveLevel():void{
			//伤害和被伤害检测处理
			ControlFactory.getIns().destroyControl(SkillsCollisionControl);
			//停止虚拟服务器
			ServerControllor.getIns().clear();
			BattleUIManager.getIns().resetCoolDownTime();
			BattleUIManager.getIns().hide();
			(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).gameRelive();
			MainMapView(ViewFactory.getIns().getView(MainMapView)).show();
			MainToolBar(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).show();
			BmdViewFactory.getIns().destroyView(GameSenceView);
			ViewFactory.getIns().destroyView(BaseMapView);
			ViewFactory.getIns().destroyView(BaseMapBgView);
			ViewFactory.getIns().destroyView(LevelInfoView);
			ViewFactory.getIns().destroyView(BuffShowView);
			ViewFactory.getIns().destroyView(BossBattleBar);
			if(ViewFactory.getIns().getView(BossBattleBar) != null){
				ViewFactory.getIns().destroyView(BossBattleBar);
			}
			if(ViewFactory.getIns().getView(FirstLevelGuideView) != null){
				ViewFactory.getIns().destroyView(FirstLevelGuideView);
			}
			
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).resetState();
			ViewFactory.getIns().getView(RoleStateView).show();
			ViewFactory.getIns().getView(MissionHint).show();
			ViewFactory.getIns().getView(ExtraBar).show();
			ViewFactory.getIns().getView(TreasureToolBar).show();
			ViewFactory.getIns().initView(OneKeyEquipView).show();
			
			//removeBitmapData();
		}
		
		private function removeBitmapData() : void{
			var arr:Array = [PlayerManager.getIns().player.fodder];
			BitmapDataPool.removeExceptData(arr);
		}
		
		public function leavePlayerKilling() : void{
			PlayerManager.getIns().updatePropertys();
			//伤害和被伤害检测处理
			ControlFactory.getIns().destroyControl(SkillsCollisionControl);
			//停止虚拟服务器
			ServerControllor.getIns().clear();
			BattleUIManager.getIns().resetCoolDownTime();
			BattleUIManager.getIns().hide();
			MainMapView(ViewFactory.getIns().getView(MainMapView)).show();
			MainToolBar(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).show();
			(ViewFactory.getIns().getView(PlayerKillingRoleStateView) as PlayerKillingRoleStateView).hide();
			BmdViewFactory.getIns().destroyView(PlayerKillingSceneView);
			ViewFactory.getIns().destroyView(PlayerKillingMapView);
			if(ViewFactory.getIns().getView(PlayerKillingMapBgView) != null){
				ViewFactory.getIns().destroyView(PlayerKillingMapBgView);
			}
			ViewFactory.getIns().getView(PlayerKillingTimeShow).hide();
			
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).resetState();
			ViewFactory.getIns().getView(RoleStateView).show();
			ViewFactory.getIns().getView(MissionHint).show();
			ViewFactory.getIns().getView(ExtraBar).show();
			ViewFactory.getIns().getView(TreasureToolBar).show();
			ViewFactory.getIns().initView(OneKeyEquipView).show();
			
			if(FbPlayersManager.getIns().playerDatas != null){
				FbPlayersManager.getIns().playerDatas.length = 0;
				FbPlayersManager.getIns().playerDatas = null;
			}
		}
		
		public function leaveAutoPK() : void{
			PlayerManager.getIns().updatePropertys();
			//伤害和被伤害检测处理
			ControlFactory.getIns().destroyControl(SkillsCollisionControl);
			//停止虚拟服务器
			ServerControllor.getIns().clear();
			BattleUIManager.getIns().resetCoolDownTime();
			BattleUIManager.getIns().hide();
			MainMapView(ViewFactory.getIns().getView(MainMapView)).show();
			MainToolBar(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).show();
			(ViewFactory.getIns().getView(PlayerKillingRoleStateView) as PlayerKillingRoleStateView).hide();
			BmdViewFactory.getIns().destroyView(AutoPKSceneView);
			ViewFactory.getIns().destroyView(PlayerKillingMapView);
			if(ViewFactory.getIns().getView(PlayerKillingMapBgView) != null){
				ViewFactory.getIns().destroyView(PlayerKillingMapBgView);
			}
			ViewFactory.getIns().getView(PlayerKillingTimeShow).hide();
			
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).resetState();
			ViewFactory.getIns().getView(RoleStateView).show();
			ViewFactory.getIns().getView(MissionHint).show();
			ViewFactory.getIns().getView(ExtraBar).show();
			ViewFactory.getIns().getView(TreasureToolBar).show();
			ViewFactory.getIns().initView(OneKeyEquipView).show();
			
			if(FbPlayersManager.getIns().playerDatas != null){
				FbPlayersManager.getIns().playerDatas.length = 0;
				FbPlayersManager.getIns().playerDatas = null;
			}
		}
		
		
	}
}