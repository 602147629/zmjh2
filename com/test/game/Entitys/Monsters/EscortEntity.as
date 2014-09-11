package com.test.game.Entitys.Monsters
{
	import com.superkaka.game.Const.ActionState;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	public class EscortEntity extends BaseMonsterEntity
	{
		public function EscortEntity(charVo:CharacterVo, hasMainAI:Boolean=true)
		{
			super(charVo, hasMainAI);
		}
		
		
		override protected function doWhenActionOver(...args) : void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
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