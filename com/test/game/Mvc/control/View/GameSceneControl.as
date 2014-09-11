package com.test.game.Mvc.control.View
{
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.CharacterType;
	import com.test.game.Effect.GrayFilterEffect;
	import com.test.game.Effect.ShakeEffect;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Manager.BattleUIManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Modules.MainGame.BossBattleBar;
	import com.test.game.Modules.MainGame.BuffShowView;
	import com.test.game.Modules.MainGame.GameOverView;
	import com.test.game.Modules.MainGame.LevelInfoView;
	import com.test.game.Modules.MainGame.Guide.FirstLevelGuideView;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.Map.BaseMapBgView;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	import com.test.game.Mvc.BmdView.FunnyBossSceneView;
	import com.test.game.Mvc.BmdView.GameSenceView;
	import com.test.game.Mvc.BmdView.HeroSceneView;
	import com.test.game.Mvc.BmdView.PlayerKillingSceneView;
	
	public class GameSceneControl extends BaseControl
	{
		public function GameSceneControl()
		{
			super();
		}
		
		public function shakeLayer(count:int, offset:Number = 1) : void{
			var gsv:GameSenceView = (BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView);
			var map:BaseView = MapManager.getIns().nowMap;
			var mapBg:BaseMapBgView = (ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView);
			var layers:Array = [gsv, map, mapBg];
			var shake:ShakeEffect = new ShakeEffect(layers, count / 2, offset);
		}
		
		/**
		 * 主角死亡初始化
		 * 
		 */		
		public function gameOverStart() : void{
			var grayMap:GrayFilterEffect = new GrayFilterEffect((ViewFactory.getIns().getView(BaseMapView) as BaseMapView).mapBitmap);
			grayMap.start();
			var grayMapBg:GrayFilterEffect = new GrayFilterEffect((ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView).mapBg);
			grayMapBg.start();
			BattleUIManager.getIns().hide();
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).hide();
			(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).hide();
			(ViewFactory.getIns().getView(BuffShowView) as BuffShowView).hide();
			
			if(ViewFactory.getIns().getView(BossBattleBar) != null)
				ViewFactory.getIns().getView(BossBattleBar).hide();
			
			if(ViewFactory.getIns().getView(FirstLevelGuideView) != null)
				ViewFactory.getIns().destroyView(FirstLevelGuideView);
		}
		
		/**
		 * 主角死亡显示界面
		 * 
		 */		
		public function gameOver() : void{
			(ViewFactory.getIns().initView(GameOverView) as GameOverView).show();
		}
		
		/**
		 * 原地复活
		 * 
		 */		
		public function gameRelive() : void{
			BattleUIManager.getIns().show();
			BattleUIManager.getIns().resetCoolDownTime();
			(ViewFactory.getIns().getView(BaseMapView) as BaseMapView).mapBitmap.filters = null;
			(ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView).mapBg.filters = null;
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).show();
			(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).show();
			(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).levelTimeEffect.start();
			(ViewFactory.getIns().getView(BuffShowView) as BuffShowView).show();
			(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).gameRelive();
			if(LevelManager.getIns().mainBossEntity != null){
				(ViewFactory.getIns().getView(BossBattleBar).show());
			}
			SkillManager.getIns().isHurt();
		}
		
		public function gameSceneInit() : void{
			BattleUIManager.getIns().mainBattleToolBar.resetCoolDownTime();
		}
		
		//检测是否所有Boss都死亡
		public function checkAllBossDead() : Boolean{
			var result:Boolean = true;
			var monsters:Vector.<MonsterEntity> = (BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).monsters;
			for(var i:int = 0; i < monsters.length; i++){
				if(monsters[i].charData.characterType == CharacterType.BOSS_MONSTER
					|| monsters[i].charData.characterType == CharacterType.ELITE_BOSS_MONSTER){
					if(monsters[i].charData.useProperty.hp > 0){
						result = false;
						break;
					}
				}
			}
			return result;
		}
		
		public function bossDeath() : void{
			if(BmdViewFactory.getIns().getView(GameSenceView) != null){
				(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).allMonsterDeath();
				(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).unResponse();
				allMonstersDeath();
			}else if(BmdViewFactory.getIns().getView(HeroSceneView) != null){
				(BmdViewFactory.getIns().getView(HeroSceneView) as HeroSceneView).checkSpecialMonsterDeath();
			}
		}
		
		public function playerDeath() : void{
			if(BmdViewFactory.getIns().getView(GameSenceView) != null){
				(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).gameOver();
			}else if(BmdViewFactory.getIns().getView(PlayerKillingSceneView) != null){
				(BmdViewFactory.getIns().getView(PlayerKillingSceneView) as PlayerKillingSceneView).gameOver();
			}
		}
		
		public function timeStart() : void{
			(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).levelTimeEffect.start();
		}
		
		public function timeStop() : void{
			(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).levelTimeEffect.stop();
		}
		
		public function gameStopRender() : void{
			if(BmdViewFactory.getIns().getView(GameSenceView) != null){
				(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).isStopRender = true;
			}else if(BmdViewFactory.getIns().getView(HeroSceneView) != null){
				(BmdViewFactory.getIns().getView(HeroSceneView) as HeroSceneView).isStopRender = true;
			}else if(BmdViewFactory.getIns().getView(FunnyBossSceneView) != null){
				(BmdViewFactory.getIns().getView(FunnyBossSceneView) as FunnyBossSceneView).isStopRender = true;
			}
			BattleUIManager.getIns().isStart = false;
		}
		
		public function gameStartRender() : void{
			if(BmdViewFactory.getIns().getView(GameSenceView) != null){
				(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).isStopRender = false;
			}else if(BmdViewFactory.getIns().getView(HeroSceneView) != null){
				(BmdViewFactory.getIns().getView(HeroSceneView) as HeroSceneView).isStopRender = false;
			}else if(BmdViewFactory.getIns().getView(FunnyBossSceneView) != null){
				(BmdViewFactory.getIns().getView(FunnyBossSceneView) as FunnyBossSceneView).isStopRender = false;
			}
			BattleUIManager.getIns().isStart = true;
		}
		
		public function allPlayersDeath() : void{
			SkillManager.getIns().unHurt();
		}
		
		public function allMonstersDeath() : void{
			SkillManager.getIns().unHurt();
		}
	}
}