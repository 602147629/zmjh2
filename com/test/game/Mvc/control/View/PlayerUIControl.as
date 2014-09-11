package com.test.game.Mvc.control.View
{
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Const.CharacterType;
	import com.test.game.Manager.BattleUIManager;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Modules.MainGame.BossBattleBar;
	import com.test.game.Modules.MainGame.HeroBattleBar;
	import com.test.game.Modules.MainGame.LevelUpView;
	import com.test.game.Modules.MainGame.Info.InfoView;
	import com.test.game.Modules.MainGame.MainUI.PlayerKillingRoleStateView;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.Setting.SoundSettingView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Mvc.BmdView.GameSenceView;
	import com.test.game.Mvc.BmdView.PlayerKillingSceneView;
	
	public class PlayerUIControl extends BaseControl
	{
		public function PlayerUIControl()
		{
			super();
		}
		
		public function skillMpSet(input:Array, type:int) : void{
			switch(type){
				case CharacterType.PLAYER:
					if(BattleUIManager.getIns().mainBattleToolBar != null){
						BattleUIManager.getIns().mainBattleToolBar.skillMpSet(input);
					}
					break;
				case CharacterType.PARTNER_PLAYER:
					if(BattleUIManager.getIns().partnerBattleToolBar != null){
						BattleUIManager.getIns().partnerBattleToolBar.skillMpSet(input);
					}
					break;
			}
		}
		
		public function setHP(useHp:Number, totalHp:Number, type:int, index:int = 0) : void{
			switch(type){
				case CharacterType.PLAYER:
					if(ViewFactory.getIns().getView(RoleStateView) != null){
						(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).setHp(useHp, totalHp);
					}
					break;
				case CharacterType.NORMAL_MONSTER:
					break;
				case CharacterType.BOSS_MONSTER:
				case CharacterType.ELITE_BOSS_MONSTER:
					if(ViewFactory.getIns().getView(BossBattleBar) != null){
						if(index == 0){
							(ViewFactory.getIns().getView(BossBattleBar) as BossBattleBar).reduceMainHp(useHp/totalHp);
						}else if(index == 1){
							(ViewFactory.getIns().getView(BossBattleBar) as BossBattleBar).reduceMinorHp(useHp/totalHp);
						}
					}
					break;
				case CharacterType.HERO_MONSTER:
					if(ViewFactory.getIns().getView(HeroBattleBar) != null){
						if(index == 0){
							(ViewFactory.getIns().getView(HeroBattleBar) as HeroBattleBar).reduceMainHp(useHp/totalHp);
						}else if(index == 1){
							(ViewFactory.getIns().getView(HeroBattleBar) as HeroBattleBar).reduceMinorHp(useHp/totalHp);
						}
					}
					break;
				case CharacterType.OTHER_PLAYER:
					if(ViewFactory.getIns().getView(PlayerKillingRoleStateView) != null){
						(ViewFactory.getIns().getView(PlayerKillingRoleStateView) as PlayerKillingRoleStateView).setHp(useHp, totalHp);
					}
					break;
				case CharacterType.PARTNER_PLAYER:
					if(ViewFactory.getIns().getView(RoleStateView) != null){
						(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).setOtherHp(useHp, totalHp, index);
					}
					break;
			}
		}
		
		public function setMP(useMp:Number, totalMp:Number, type:int, index:int = 0) : void{
			switch(type){
				case CharacterType.PLAYER:
					if(ViewFactory.getIns().getView(RoleStateView) != null){
						(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).setMp(useMp, totalMp);
					}
					break;
				case CharacterType.OTHER_PLAYER:
					if(ViewFactory.getIns().getView(PlayerKillingRoleStateView) != null){
						(ViewFactory.getIns().getView(PlayerKillingRoleStateView) as PlayerKillingRoleStateView).setMp(useMp, totalMp);
					}
					break;
				case CharacterType.PARTNER_PLAYER:
					if(ViewFactory.getIns().getView(RoleStateView) != null){
						(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).setOtherMp(useMp, totalMp, index);
					}
					break;
			}
		}
		
		public function resetHp(hp:int, type:int, index:int) : void{
			switch(type){
				case CharacterType.HERO_MONSTER:
					if(ViewFactory.getIns().getView(HeroBattleBar) != null){
						if(index == 0){
							(ViewFactory.getIns().getView(HeroBattleBar) as HeroBattleBar).resetMainHp(hp);
						}else if(index == 1){
							(ViewFactory.getIns().getView(HeroBattleBar) as HeroBattleBar).resetMinorHp(hp);
						}
					}
					break;
				case CharacterType.BOSS_MONSTER:
				case CharacterType.ELITE_BOSS_MONSTER:
					if(ViewFactory.getIns().getView(BossBattleBar) != null){
						if(index == 0){
							(ViewFactory.getIns().getView(BossBattleBar) as BossBattleBar).resetMainHp(hp);
						}else if(index == 1){
							(ViewFactory.getIns().getView(BossBattleBar) as BossBattleBar).resetMinorHp(hp);
						}
					}
					break;
			}
			
		}
		
		public function setAnger(rate:Number, type:int) : void{
			switch(type){
				case CharacterType.PLAYER:
					if(BattleUIManager.getIns().mainBattleToolBar != null){
						BattleUIManager.getIns().mainBattleToolBar.setAnger(rate);
					}
					break;
				case CharacterType.OTHER_PLAYER:
					
					break;
				case CharacterType.PARTNER_PLAYER:
					if(BattleUIManager.getIns().partnerBattleToolBar != null){
						BattleUIManager.getIns().partnerBattleToolBar.setAnger(rate);
					}
					break;
			}
		}
		
		public function onBuringDown(type:int) : void{
			switch(type){
				case CharacterType.PLAYER:
					if(BattleUIManager.getIns().mainBattleToolBar != null){
						BattleUIManager.getIns().mainBattleToolBar.onBuringDown();
					}
					break;
				case CharacterType.PARTNER_PLAYER:
					if(GameSceneManager.getIns().partnerOperate){
						if(BattleUIManager.getIns().partnerBattleToolBar != null){
							BattleUIManager.getIns().partnerBattleToolBar.onBuringDown();
						}
					}
					break;
				case CharacterType.OTHER_PLAYER:
					
					break;
			}
		}
		
		public function removeBuringDown(type:int) : void{
			switch(type){
				case CharacterType.PLAYER:
					if(BattleUIManager.getIns().mainBattleToolBar != null){
						BattleUIManager.getIns().mainBattleToolBar.removeBuringDown();
					}
					if(BmdViewFactory.getIns().getView(GameSenceView) != null){
						(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).myPlayer.setGlowFilter();
					}
					break;
				case CharacterType.PARTNER_PLAYER:
					if(BattleUIManager.getIns().partnerBattleToolBar != null){
						BattleUIManager.getIns().partnerBattleToolBar.removeBuringDown();
					}
					if(BmdViewFactory.getIns().getView(GameSenceView) != null){
						(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).partnerPlayer.setGlowFilter();
					}
					break;
			}
			if(BmdViewFactory.getIns().getView(PlayerKillingSceneView) != null){
				(BmdViewFactory.getIns().getView(PlayerKillingSceneView) as PlayerKillingSceneView).playerSetGlowFilter();
			}
		}
		
		public function addBossCount(rate:Number, type:int) : void{
			switch(type){
				case CharacterType.PLAYER:
					if(ViewFactory.getIns().getView(RoleStateView) != null){
						(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).addBossCount(rate);
					}
					break;
				case CharacterType.OTHER_PLAYER:
					if(ViewFactory.getIns().getView(PlayerKillingRoleStateView) != null){
						(ViewFactory.getIns().getView(PlayerKillingRoleStateView) as PlayerKillingRoleStateView).addBossCount(rate);
					}
					break;
			}
		}
		
		public function conjureAngerAndBoss() : void{
			var gsv:GameSenceView = (BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView);
			if(gsv != null){
				gsv.myPlayer.charData.angerCount++;
				//gsv.myPlayer.charData.bossCount++;
			}
		}
		
		public function playerLevelUp(callback:Function = null) : void{
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).upDataLevel(PlayerManager.getIns().player.character.lv);
			(ViewFactory.getIns().initView(LevelUpView) as LevelUpView).callback = callback;
			(ViewFactory.getIns().initView(LevelUpView) as LevelUpView).show();
		}
		
		public function setSkillColdDown(count:int, time:int, type:int) : void{
			switch(type){
				case CharacterType.PLAYER:
					if(BattleUIManager.getIns().mainBattleToolBar != null){
						BattleUIManager.getIns().mainBattleToolBar.setCoolDown(count, time);
					}
					break;
				case CharacterType.PARTNER_PLAYER:
					if(BattleUIManager.getIns().partnerBattleToolBar != null){
						BattleUIManager.getIns().partnerBattleToolBar.setCoolDown(count, time);
					}
					break;
				case CharacterType.OTHER_PLAYER:
					break;
			}
		}
		
		public function setMonsterHp(rate:Number) : void{
			
		}
		
		
		public function pauseGame() : void{
			if(gamePauseJudge){
				(ViewFactory.getIns().initView(InfoView) as InfoView).setInfo({title:"", detail:"游戏暂停，按P键或点击屏幕恢复"}, startGame);
				(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameStopRender();
			}
		}
		
		public function startGame() : void{
			if(gamePauseJudge){
				(ViewFactory.getIns().initView(InfoView) as InfoView).hide();
				(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameStartRender();
			}
		}
		
		public function get gamePauseJudge() : Boolean{
			var result:Boolean = true;
			
			if(!(ViewFactory.getIns().initView(TipView) as TipView).isClose){
				result = false;
			}
			if(ViewFactory.getIns().getView(SoundSettingView) != null && !ViewFactory.getIns().getView(SoundSettingView).isClose){
				result = false;
			}
			
			return result;
		}
	}
}