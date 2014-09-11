package com.test.game.Entitys.BevAi
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Const.ActionState;
	import com.test.game.BevTree.BevActionNode;
	import com.test.game.BevTree.BevNode;
	import com.test.game.BevTree.BevParamsConst;
	import com.test.game.Const.CharacterType;
	import com.test.game.Mvc.Vo.EnemyVo;
	
	public class BevAttackMoveNode extends BevActionNode
	{
		private var _distance:int;
		private var _skill:String;
		public function BevAttackMoveNode(name:String)
		{
			super(name);
		}
		
		override public function setParams(...args):BevNode
		{
			super.setParams(args[0]);
			if(params.length >= 2){
				_skill = params[1];
			}else{
				_skill = BevParamsConst.COMMON;
			}
			return this;
		}
		
		override public function doJudge():Boolean
		{
			var result:Boolean = true;
			
			return result;
		}
		
		override public function doExecute():void
		{
			super.doExecute();
			if(entity == null 
				|| target == null 
				|| entity.curAction == ActionState.HIT1 
				|| entity.curAction == ActionState.SKILL1
				|| entity.curAction == ActionState.SKILL2
				|| entity.curAction == ActionState.SKILLOVER2
				|| entity.curAction == ActionState.SKILL3
				|| entity.curAction == ActionState.HURT
				|| entity.curAction == ActionState.DEAD
				|| entity.curAction == ActionState.GROUNDDEAD) return;
			calculateDistance();
			if(AUtils.getDisBetweenTwoEntity(entity, target) > _distance){
				if(entity.x > target.x)
					entity.moveLeft();
				else
					entity.moveRight();
			}/*else if(AUtils.getDisBetweenTwoEntity(entity, target) < _distance - entity.speedX){
				if(entity.x > target.x)
					entity.moveRight();
				else
					entity.moveLeft();
			}*/
			if(entity.y - target.y > 30){
				entity.moveUp();
			}else if(target.y - entity.y > 30){
				entity.moveDown();
			}
		}
		
		private function calculateDistance() : void{
			var arr:Array = (entity.charData as EnemyVo).skill_distance.split("|");
			if(_skill == BevParamsConst.SKILL){
				if(entity.hitType == 0){
					_distance = (entity.charData as EnemyVo).common_distance;
				}else{
					if(entity.hitType > arr.length){
						_distance = arr[0];
					}else{
						_distance = arr[entity.hitType - 1];
					}
				}
			}else{
				if(entity.charData.characterType != CharacterType.NORMAL_MONSTER){
					if(entity.hitType == 0){
						_distance = (entity.charData as EnemyVo).common_distance;
					}else{
						if(entity.hitType > arr.length){
							_distance = arr[0];
						}else{
							_distance = arr[entity.hitType - 1];
						}
					}
				}else{
					_distance = (entity.charData as EnemyVo).common_distance;
				}
			}
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}