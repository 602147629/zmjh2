package com.test.game.Entitys.Monsters
{
	import com.superkaka.game.Const.ActionState;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	public class MingHuoFenShenEntity extends BaseMonsterEntity
	{
		private var _skill2Count:int = 0;
		public function MingHuoFenShenEntity(charVo:CharacterVo)
		{
			super(charVo);
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
				case ActionState.SKILL3:
					checkFrameSKill(keyFrame, this.curAction);
					//hitType = 1;
					break;
				case ActionState.SKILL2:
					if(keyFrame == 2){
						_skill2Count++;
					}
					checkFrameSKill(keyFrame, this.curAction);
					//hitType = 1;
					break;
				case ActionState.DEAD:
					if(this.mainAi != null){
						this.mainAi.lock();
					}
					break;
				case ActionState.GROUNDDEAD:
					if(this.mainAi != null){
						this.mainAi.lock();
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
					_skill2Count = 0;
					resetSkillParams();
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.SKILL2:
					if(_skill2Count < 7){
						this.setAction(ActionState.SKILL1, true);
					}else{
						_skill2Count = 0;
						_characterControl.setAttackEnd();
						this.resetSkillParams();
						this.setAction(ActionState.WAIT);
					}
					break;
				case ActionState.SKILL1:
				case ActionState.SKILL3:
					_characterControl.setAttackEnd();
					this.resetSkillParams();
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.HURT:
					unMoveHurt();
					isAirHurt();
					resetSkillParams();
					_skill2Count = 0;
					break;
				case ActionState.DEAD:
				case ActionState.GROUNDDEAD:
					_skill2Count = 0;
					this.dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_DEAD_EVENT));
					//this.destroy();
					break;
				case ActionState.FALL:
					_skill2Count = 0;
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