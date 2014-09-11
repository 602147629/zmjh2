package com.test.game.Entitys.BevAi
{
	import com.superkaka.game.Const.ActionState;
	import com.test.game.BevTree.BevConditionNode;
	import com.test.game.BevTree.BevNode;
	
	public class BevAttackAirNode extends BevConditionNode
	{
		private var _distance:int;
		public function BevAttackAirNode(name:String){
			super(name);
		}
		
		override public function setParams(...args):BevNode
		{
			super.setParams(args[0]);
			_distance = params[1];
			return this;
		}
		
		override public function doJudge():Boolean{
			var result:Boolean = false;
			
			if(target != null){
				if(entity.bodyAction.y > -(_distance - 5)){
					result = false;
					if(entity.curAction == ActionState.WAIT || entity.curAction == ActionState.WALK){
						entity.bodyAction.y -= 5;
					}
				}else if(entity.bodyAction.y < -(_distance + 5)){
					result = false;
					if(entity.curAction == ActionState.WAIT || entity.curAction == ActionState.WALK){
						entity.bodyAction.y += 5;
					}
				}else{
					result = true;
				}
			}
			return result;
		}
	}
}