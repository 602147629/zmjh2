package com.test.game.process
{
	import com.superkaka.game.Const.ActionState;
	import com.test.game.Entitys.MonsterEntity;
	
	import flash.geom.Point;
	
	public class MonsterMove
	{
		private var _targetPoint:Point;
		public function MonsterMove(params:String)
		{
			var list:Array = params.split("|");
			_targetPoint = new Point(list[0], list[1]);
		}
		
		public function judge(entity:MonsterEntity) : Boolean{
			var result:Boolean = false;
			if(Math.abs(entity.x - entity.characterControl.limitLeftX - _targetPoint.x) < 10 && Math.abs(entity.y - _targetPoint.y) < 10){
				result = true;
				entity.setAction(ActionState.WAIT);
			}else{
				if(entity.x > entity.characterControl.limitLeftX + _targetPoint.x + 5){
					entity.moveLeft();
				}else if(entity.x < entity.characterControl.limitLeftX + _targetPoint.x -5){
					entity.moveRight();
				}
				
				if(entity.y > _targetPoint.y + 5){
					entity.moveUp();
				}else if(entity.y < _targetPoint.y - 5){
					entity.moveDown();
				}
			}
			
			return result;
		}
	}
}