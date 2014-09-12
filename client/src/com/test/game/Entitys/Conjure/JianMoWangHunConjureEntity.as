package com.test.game.Entitys.Conjure
{
	import com.superkaka.game.Const.ActionState;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	import flash.geom.Point;
	
	public class JianMoWangHunConjureEntity extends ConjureEntity
	{
		public function JianMoWangHunConjureEntity(charVo:CharacterVo, data:Object)
		{
			super(charVo, data);
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.SKILL2:
					releaseSkill2(keyFrame);
					break;
				case ActionState.WAIT:
					if(keyFrame == 3){
						this.setAction(ActionState.SKILL2);
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
	}
}