package com.test.game.Mvc.control.Escort
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.ResourceOperation.BitmapDataPool;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.AssessManager;
	import com.test.game.Manager.BattleUIManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EscortManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.FbPlayersManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.ServerControllor;
	import com.test.game.Modules.MainGame.BossBattleBar;
	import com.test.game.Modules.MainGame.LevelInfoView;
	import com.test.game.Modules.MainGame.Escort.EscortBar;
	import com.test.game.Modules.MainGame.Escort.EscortView;
	import com.test.game.Modules.MainGame.Guide.FirstLevelGuideView;
	import com.test.game.Modules.MainGame.Guide.OneKeyEquipView;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.MainUI.TreasureToolBar;
	import com.test.game.Modules.MainGame.Map.BaseMapBgView;
	import com.test.game.Modules.MainGame.Map.EscortMapView;
	import com.test.game.Modules.MainGame.Map.MainMapView;
	import com.test.game.Modules.MainGame.Mission.MissionHint;
	import com.test.game.Mvc.BmdView.EscortSceneView;
	import com.test.game.Mvc.BmdView.LootSceneView;
	import com.test.game.Mvc.control.logic.SkillsCollisionControl;
	
	public class EscortControl extends BaseControl
	{
		public function EscortControl()
		{
			super();
		}
		
		private var convoyType:int;
		public function gotoEscortBattle() : void{
			(ViewFactory.getIns().getView(EscortView) as EscortView).hide();
			var nowInfo:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.LEVEL, "level_id", PlayerManager.getIns().getSimpleDungeonName(NumberConst.getIns().exceptionEscort));
			ControlFactory.getIns().initControl(SkillsCollisionControl);
			ServerControllor.getIns().start();
			EscortManager.getIns().nowIndex = nowInfo.level_id;
			EscortManager.getIns().levelData = nowInfo;
			EscortManager.getIns().mapType = 0;
			LevelManager.getIns().nowIndex = nowInfo.level_id;
			LevelManager.getIns().levelData = nowInfo;
			LevelManager.getIns().mapType = 0;
			ViewFactory.getIns().initView(EscortMapView);
			convoyType = 1;
		}
		
		public function initEscortBattleView() : void{
			EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.HIDE_PARTNER_ROLE));
			if(ViewFactory.getIns().getView(OneKeyEquipView) != null){
				ViewFactory.getIns().getView(OneKeyEquipView).hide();
			}
			ViewFactory.getIns().getView(TreasureToolBar).hide();
			ViewFactory.getIns().getView(ExtraBar).hide();
			ViewFactory.getIns().getView(MissionHint).hide();
			ViewFactory.getIns().initView(RoleStateView).show();
			ViewFactory.getIns().initView(LevelInfoView);
			ViewFactory.getIns().initView(BaseMapBgView);
			ViewFactory.getIns().initView(EscortBar);
			if(convoyType == 1){
				BmdViewFactory.getIns().initView(EscortSceneView);
			}else{
				BmdViewFactory.getIns().initView(LootSceneView);
			}
			(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).hideQuit();
			AssessManager.getIns().clear();
		}
		
		public function leaveEscort() : void{
			PlayerManager.getIns().updatePropertys();
			//伤害和被伤害检测处理
			ControlFactory.getIns().destroyControl(SkillsCollisionControl);
			//停止虚拟服务器
			ServerControllor.getIns().clear();
			BattleUIManager.getIns().resetCoolDownTime();
			BattleUIManager.getIns().hide();
			MainMapView(ViewFactory.getIns().getView(MainMapView)).show();
			MainToolBar(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).show();
			BmdViewFactory.getIns().destroyView(EscortSceneView);
			ViewFactory.getIns().destroyView(EscortMapView);
			ViewFactory.getIns().destroyView(BaseMapBgView);
			ViewFactory.getIns().destroyView(LevelInfoView);
			ViewFactory.getIns().destroyView(BossBattleBar);
			ViewFactory.getIns().destroyView(EscortBar);
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
			
			if(FbPlayersManager.getIns().playerDatas != null){
				FbPlayersManager.getIns().playerDatas.length = 0;
				FbPlayersManager.getIns().playerDatas = null;
			}
		}
		
		public function gotoLootBattle() : void{
			var nowInfo:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.LEVEL, "level_id", PlayerManager.getIns().getSimpleDungeonName(NumberConst.getIns().exceptionEscort));
			ControlFactory.getIns().initControl(SkillsCollisionControl);
			ServerControllor.getIns().start();
			EscortManager.getIns().nowIndex = nowInfo.level_id;
			EscortManager.getIns().levelData = nowInfo;
			EscortManager.getIns().mapType = 0;
			LevelManager.getIns().nowIndex = nowInfo.level_id;
			LevelManager.getIns().levelData = nowInfo;
			LevelManager.getIns().mapType = 0;
			ViewFactory.getIns().initView(EscortMapView);
			convoyType = 2;
		}
		
		public function leaveLoot() : void{
			PlayerManager.getIns().updatePropertys();
			//伤害和被伤害检测处理
			ControlFactory.getIns().destroyControl(SkillsCollisionControl);
			//停止虚拟服务器
			ServerControllor.getIns().clear();
			BattleUIManager.getIns().resetCoolDownTime();
			BattleUIManager.getIns().hide();
			MainMapView(ViewFactory.getIns().getView(MainMapView)).show();
			MainToolBar(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).show();
			BmdViewFactory.getIns().destroyView(LootSceneView);
			ViewFactory.getIns().destroyView(EscortMapView);
			ViewFactory.getIns().destroyView(BaseMapBgView);
			ViewFactory.getIns().destroyView(LevelInfoView);
			ViewFactory.getIns().destroyView(BossBattleBar);
			ViewFactory.getIns().destroyView(EscortBar);
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
			
			if(FbPlayersManager.getIns().playerDatas != null){
				FbPlayersManager.getIns().playerDatas.length = 0;
				FbPlayersManager.getIns().playerDatas = null;
			}
		}
		
		private function removeBitmapData() : void{
			var arr:Array = [PlayerManager.getIns().player.fodder];
			BitmapDataPool.removeExceptData(arr);
		}
	}
}