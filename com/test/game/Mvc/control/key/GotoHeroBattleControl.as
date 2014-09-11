package com.test.game.Mvc.control.key
{
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Manager.AssessManager;
	import com.test.game.Manager.AutoFightManager;
	import com.test.game.Manager.BattleUIManager;
	import com.test.game.Manager.ServerControllor;
	import com.test.game.Manager.StoryManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Modules.MainGame.HeroBattleBar;
	import com.test.game.Modules.MainGame.Guide.OneKeyEquipView;
	import com.test.game.Modules.MainGame.HeroFight.HeroGameOverView;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.MainUI.TreasureToolBar;
	import com.test.game.Modules.MainGame.Map.HeroMapView;
	import com.test.game.Modules.MainGame.Map.MainMapView;
	import com.test.game.Modules.MainGame.Mission.MissionHint;
	import com.test.game.Mvc.BmdView.HeroSceneView;
	import com.test.game.Mvc.control.logic.SkillsCollisionControl;
	
	public class GotoHeroBattleControl extends BaseControl
	{
		public function GotoHeroBattleControl()
		{
			super();
		}
		
		public function goToBattle():void{
			ControlFactory.getIns().initControl(SkillsCollisionControl);
			ServerControllor.getIns().start();
			ViewFactory.getIns().initView(HeroMapView);
		}
		
		public function initBattleView() : void{
			StoryManager.getIns().initParams();
			if(ViewFactory.getIns().getView(OneKeyEquipView) != null){
				ViewFactory.getIns().getView(OneKeyEquipView).hide();
			}
			ViewFactory.getIns().getView(TreasureToolBar).hide();
			ViewFactory.getIns().getView(ExtraBar).hide();
			ViewFactory.getIns().getView(MissionHint).hide();
			ViewFactory.getIns().initView(RoleStateView).show()
			BmdViewFactory.getIns().initView(HeroSceneView);
			AssessManager.getIns().clear();
			AutoFightManager.getIns().startAutoFight = false;
		}
		
		public function leaveBattle() : void{
			//伤害和被伤害检测处理
			ControlFactory.getIns().destroyControl(SkillsCollisionControl);
			//停止虚拟服务器
			ServerControllor.getIns().clear();
			BattleUIManager.getIns().hide();
			(BmdViewFactory.getIns().getView(HeroSceneView) as HeroSceneView).gameRelive();
			MainMapView(ViewFactory.getIns().getView(MainMapView)).show();
			MainToolBar(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).show();
			BmdViewFactory.getIns().destroyView(HeroSceneView);
			ViewFactory.getIns().destroyView(HeroMapView);
			ViewFactory.getIns().destroyView(HeroBattleBar);
			
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).resetState();
			ViewFactory.getIns().getView(RoleStateView).show();
			ViewFactory.getIns().getView(MissionHint).show();
			ViewFactory.getIns().getView(ExtraBar).show();
			ViewFactory.getIns().getView(TreasureToolBar).show();
			ViewFactory.getIns().initView(OneKeyEquipView).show();
			ViewFactory.getIns().initView(HeroGameOverView).hide();
		}
		
		public function gameRelive() : void{
			BattleUIManager.getIns().show();
			BattleUIManager.getIns().resetCoolDownTime();
			(ViewFactory.getIns().getView(HeroMapView) as HeroMapView).mapBitmap.filters = null;
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).show();
			(BmdViewFactory.getIns().getView(HeroSceneView) as HeroSceneView).gameRelive();
			(ViewFactory.getIns().getView(HeroBattleBar).show());
			SkillManager.getIns().isHurt();
		}
	}
}