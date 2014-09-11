package com.test.game.Entitys.Monsters
{
	import com.superkaka.game.Const.ActionState;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	import flash.geom.Point;
	
	public class JianMoWangHunEntity extends BaseMonsterEntity
	{
		public function JianMoWangHunEntity(charVo:CharacterVo, hasMainAI:Boolean = true)
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
					//hitType = 0;
					break;
				case ActionState.SKILL1:
					checkFrameSKill(keyFrame, this.curAction);
					//hitType = 1;
					break;
				case ActionState.SKILL2:
					releaseSkill2(keyFrame);
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
		
		private var _startSkill2:Boolean;
		private var _countSkill2:int;
		private var _pointArr:Array = new Array();
		private function releaseSkill2(keyFrame:int):void{
			if(keyFrame == 6){
				_startSkill2 = true;
				_pointArr.push(new Point(-200, 0));
				_pointArr.push(new Point(-120, 35));
				_pointArr.push(new Point(0, 50));
				_pointArr.push(new Point(120, 35));
				_pointArr.push(new Point(200, 0));
				_pointArr.push(new Point(120, -35));
				_pointArr.push(new Point(0, -50));
				_pointArr.push(new Point(-120, -35));
				
				_pointArr.push(new Point(-200, 0));
				_pointArr.push(new Point(-120, 35));
				_pointArr.push(new Point(0, 50));
				_pointArr.push(new Point(120, 35));
				_pointArr.push(new Point(200, 0));
				_pointArr.push(new Point(120, -35));
				_pointArr.push(new Point(0, -50));
				_pointArr.push(new Point(-120, -35));
			}
		}
		
		override public function step() : void{
			super.step();
			if(_startSkill2 == true){
				if(_countSkill2 % 4 == 0){
					var point:Point = _pointArr.shift();
					SkillManager.getIns().createPosSkill(this.x + point.x, -520, this.y + point.y, this, 11103);
				}
				if(_countSkill2 / 4 == 15){
					_startSkill2 = false;
					_countSkill2 = 0;
				}else{
					_countSkill2++;
				}
			}
		}
		
		override protected function doWhenActionOver(...args) : void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT1:
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.SKILL1:
				case ActionState.SKILL2:
				case ActionState.SKILL3:
					_characterControl.setAttackEnd();
					this.resetSkillParams();
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.HURT:
					unMoveHurt();
					resetSkillParams();
					isAirHurt();
					break;
				case ActionState.DEAD:
				case ActionState.GROUNDDEAD:
					this.dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_DEAD_EVENT));
					//this.destroy();
					break;
				case ActionState.FALL:
					isAirHurt();
					if(curRenderIndex == 50){
						standUp();
						unMoveHurt();
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