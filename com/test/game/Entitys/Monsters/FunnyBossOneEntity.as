package com.test.game.Entitys.Monsters
{
	import com.superkaka.game.Const.ActionState;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Manager.DigitalManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	public class FunnyBossOneEntity extends BaseMonsterEntity
	{
		public function FunnyBossOneEntity(charVo:CharacterVo, hasMainAI:Boolean=true)
		{
			super(charVo, hasMainAI);
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT1:
					checkFrameCommon(keyFrame, 1);
					break;
				case ActionState.SKILL1:
				case ActionState.SKILL3:
				case ActionState.SKILL4:
				case ActionState.SKILL5:
					checkFrameSKill(keyFrame, this.curAction);
					break;
				case ActionState.SKILL2:
					onReleaseSkillTwo();
					checkFrameSKill(keyFrame, this.curAction);
					break;
				case ActionState.DEAD:
					if(this.mainAi != null){
						this.mainAi.lock();
						charVo.useProperty.hp = 0;
						changeHp(0);
					}
					break;
				case ActionState.GROUNDDEAD:
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
		
		
		private var _skillStepCount:int;
		private function onReleaseSkillTwo() : void{
			_skillStepCount++;
			if(_skillStepCount % 3 == 0){
				SkillManager.getIns().createPosSkill(this.x + DigitalManager.getIns().getOneStauts() * 450 * Math.random(), -550, this.y, this, 206);
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
					this.dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_DEAD_EVENT));
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
					break;
			}
		}
	}
}