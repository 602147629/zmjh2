package com.test.game.Entitys.Monsters
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.mvc.ControlFactory;
	import com.test.game.Const.ImmunityConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.EnemyVo;
	import com.test.game.Mvc.control.View.PlayerUIControl;
	
	public class YuanNvEntity extends BaseMonsterEntity
	{
		private static const DEATHTIME:int = 60;
		private var _deathTime:int;
		public var isAlreadyDead:Boolean = false;
		public function YuanNvEntity(charVo:CharacterVo, hasMainAI:Boolean = true)
		{
			super(charVo, hasMainAI);
			this.characterJudge.hurtReduceType = ImmunityConst.ATS_IMMUNITY;
			this.characterJudge.hurtReduceNum = NumberConst.getIns().percent90;
			this.bodyAction.alphaValue = .8;
		}
		
		override public function setAction(actionState:uint,resetWhenSameAction:Boolean = false):void{
			if(charVo.useProperty.hp == 0) return;
			if(actionState == ActionState.SKILL2 && curAction == ActionState.SKILL2) return;
			super.setAction(actionState,resetWhenSameAction);
			if(actionState == ActionState.SKILL2){
				togetherReleaseSkill();
			}
		}
		
		private function togetherReleaseSkill() : void{
			if(SceneManager.getIns().nowScene != null){
				var monsters:Vector.<MonsterEntity> = SceneManager.getIns().monsters;
				for(var i:int = 0; i < monsters.length; i++){
					if((monsters[i].charData as EnemyVo).ID == 2209
						|| (monsters[i].charData as EnemyVo).ID == 4209
						|| (monsters[i].charData as EnemyVo).ID == 6023){
						monsters[i].setAction(ActionState.SKILL2);
					}
				}
			}
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT1:
					checkFrameCommon(keyFrame, 1);
					//hitType = 0;
					break;
				case ActionState.SKILL1:
				case ActionState.SKILL2:
				case ActionState.SKILL3:
				case ActionState.SKILL4:
				case ActionState.SKILL5:
					checkFrameSKill(keyFrame, this.curAction);
					//hitType = 1;
					break;
				case ActionState.DEAD:
					_deathTime = 0;
					if(this.mainAi != null){
						this.mainAi.lock();
						charVo.useProperty.hp = 0;
						changeHp(0);
					}
					break;
				case ActionState.GROUNDDEAD:
					_deathTime = 0;
					if(this.mainAi != null){
						this.mainAi.lock();
						charVo.useProperty.hp = 0;
						changeHp(0);
					}
					if(keyFrame < 6){
						groundDeadMove();
					}
					break;
			}
		}
		
		override protected function doWhenActionOver(...args) : void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT1:
					resetSkillParams();
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.SKILL1:
				case ActionState.SKILL2:
				case ActionState.SKILL3:
				case ActionState.SKILL4:
				case ActionState.SKILL5:
					_characterControl.setAttackEnd();
					this.resetSkillParams();
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.HURT:
					unMoveHurt();
					isAirHurt();
					resetSkillParams();
					break;
				case ActionState.DEAD:
				case ActionState.GROUNDDEAD:
					if(!isAlreadyDead){
						_deathTime++;
						if(_deathTime >= DEATHTIME){
							this.changeHp(-this.charVo.totalProperty.hp);
							this.setAction(ActionState.SKILL3);
							this.isLock = false;
							this.isAlreadyDead = false;
							this.characterJudge.isUnMoveStatus = false;
							this.characterJudge.isTemptation = false;
							(ControlFactory.getIns().getControl(PlayerUIControl) as PlayerUIControl).resetHp(charVo.useProperty.hp, charVo.characterType, charVo.characterBarIndex);
						}
					}else{
						this.dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_DEAD_EVENT));
					}
					//this.dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_DEAD_EVENT));
					//this.destroy();
					break;
				case ActionState.FALL:
					isAirHurt();
					if(curRenderIndex == 30){
						standUp();
						unMoveHurt();
						resetSkillParams();
					}
					break;
				default:
					if(this.curAction == ActionState.NONE)
						this.setAction(ActionState.WAIT);
					this.setAction(this.curAction, true);
					resetShadow();
					break;
			}
		}
	}
}