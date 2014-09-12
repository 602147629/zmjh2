package com.test.game.Entitys.BevAi
{
	import com.superkaka.Tools.AUtils;
	import com.test.game.BevTree.BevConditionNode;
	import com.test.game.BevTree.BevNode;
	import com.test.game.BevTree.BevParamsConst;
	import com.test.game.Const.CharacterType;
	import com.test.game.Mvc.Vo.EnemyVo;
	
	public class BevAttackRangeNode extends BevConditionNode
	{
		private var _distance:uint;
		private var _skill:String;
		public function BevAttackRangeNode(name:String)
		{
			super(name);
		}
		
		override public function setParams(...args):BevNode{
			super.setParams(args[0]);
			if(params.length >= 2){
				_skill = params[1];
			}else{
				_skill = BevParamsConst.COMMON;
			}
			return this;
		}
		
		override public function doJudge():Boolean{
			var result:Boolean = false;
			calculateDistance();
			if(target != null){
				if(AUtils.getDisBetweenTwoEntity(entity, target) > _distance)
					result = true;
				/*else if(AUtils.getDisBetweenTwoEntity(entity, target) < _distance - entity.speedX)
					result = true;*/
				else if(Math.abs(entity.y - target.y) > 30)
					result = true;
				else
					result = false;
				
				var enemyVo:EnemyVo = entity.charData as EnemyVo;
				if(enemyVo.ID == 1104
					|| enemyVo.ID == 2104
					|| enemyVo.ID == 3104){
					if(Math.abs(entity.y - target.y) <= 80){
						result = false;
					}
				}
			}
			return result;
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