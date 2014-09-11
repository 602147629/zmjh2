package com.test.game.Mvc.control.key
{
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.BuffConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.DialogEffect;
	import com.test.game.Manager.AssessManager;
	import com.test.game.Manager.BattleUIManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.GiftManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.ServerControllor;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Modules.MainGame.Guide.OneKeyEquipView;
	import com.test.game.Modules.MainGame.Info.CongratulationView;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.MainUI.TreasureToolBar;
	import com.test.game.Modules.MainGame.Map.BaseMapBgView;
	import com.test.game.Modules.MainGame.Map.MainMapView;
	import com.test.game.Modules.MainGame.Map.NewGameMapView;
	import com.test.game.Modules.MainGame.Mission.MissionHint;
	import com.test.game.Mvc.BmdView.NewGameSceneView;
	import com.test.game.Mvc.control.logic.SkillsCollisionControl;
	import com.test.game.cartoon.NewGameCartoon;
	
	public class NewGameControl extends BaseControl
	{
		public function NewGameControl()
		{
			super();
		}
		
		public function gotoNewGame() : void{
			var nowInfo:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.LEVEL, "level_id", "1_10");
			ControlFactory.getIns().initControl(SkillsCollisionControl);
			ServerControllor.getIns().start();
			LevelManager.getIns().nowIndex = nowInfo.level_id;
			LevelManager.getIns().levelData = nowInfo;
			ViewFactory.getIns().initView(NewGameMapView);
		}
		
		
		public function initNewGameBattle() : void{
			if(ViewFactory.getIns().getView(OneKeyEquipView) != null){
				ViewFactory.getIns().getView(OneKeyEquipView).hide();
			}
			ViewFactory.getIns().getView(TreasureToolBar).hide();
			ViewFactory.getIns().getView(ExtraBar).hide();
			ViewFactory.getIns().getView(MissionHint).hide();
			ViewFactory.getIns().initView(RoleStateView).hide();
			ViewFactory.getIns().initView(BaseMapBgView);
			BmdViewFactory.getIns().initView(NewGameSceneView);
			AssessManager.getIns().clear();
		}
		
		public function leaveNewGame():void{
			leaveNewGameOnly();
			beginningGift();
		}
		
		private function beginningGift() : void{
			(ViewFactory.getIns().initView(CongratulationView) as CongratulationView).startPlay(NumberConst.getIns().beginnerGiftId, laoxiuBuff);
			GiftManager.getIns().addGift(NumberConst.getIns().beginnerGiftId);
		}
		
		private function laoxiuBuff() : void{
			(ViewFactory.getIns().initView(CongratulationView) as CongratulationView).startPlay(BuffConst.BUFF_LAOXIU, lastOne);
		}
		
		private function lastOne() : void{
			GuideManager.getIns().missionGuideSetting("任务");
			ShopManager.getIns().setVipGet();
		}
		
		public function leaveNewGameOnly() : void{
			//伤害和被伤害检测处理
			ControlFactory.getIns().destroyControl(SkillsCollisionControl);
			//停止虚拟服务器
			ServerControllor.getIns().clear();
			BattleUIManager.getIns().resetCoolDownTime();
			BattleUIManager.getIns().hide();
			MainMapView(ViewFactory.getIns().getView(MainMapView)).show();
			MainToolBar(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).show();
			BmdViewFactory.getIns().destroyView(NewGameSceneView);
			ViewFactory.getIns().destroyView(NewGameMapView);
			ViewFactory.getIns().destroyView(BaseMapBgView);
			
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).resetState();
			ViewFactory.getIns().getView(RoleStateView).show();
			ViewFactory.getIns().getView(MissionHint).show();
			ViewFactory.getIns().getView(ExtraBar).show();
			ViewFactory.getIns().getView(TreasureToolBar).show();
			ViewFactory.getIns().initView(OneKeyEquipView).show();
		}
		
		public function quitAll() : void{
			//伤害和被伤害检测处理
			ControlFactory.getIns().destroyControl(SkillsCollisionControl);
			//停止虚拟服务器
			ServerControllor.getIns().clear();
			
			BmdViewFactory.getIns().destroyView(NewGameSceneView);
			ViewFactory.getIns().destroyView(NewGameMapView);
			ViewFactory.getIns().destroyView(BaseMapBgView);
		}
		
		public function initDialog(type:int, callback:Function) : void{
			DialogEffect.init(type, callback);
		}
		
		public function initCartoon(type:int, callback:Function) : void{
			switch(type){
				case 1:
					NewGameCartoon.showCartoon(1, -10, -50, callback);
					break;
				case 2:
					NewGameCartoon.showCartoon(2, -70, -40, callback);
					break;
				case 3:
					NewGameCartoon.showCartoon(3, -70, -40, callback);
					break;
				case 4:
					NewGameCartoon.showCartoon(4, -105, -75, callback);
					break;
			}
		}
		
	}
}