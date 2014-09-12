package com.test.game.Entitys.BevAi
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Const.DirectConst;
	import com.test.game.BevTree.BevConditionNode;
	import com.test.game.BevTree.BevNode;
	
	public class BevDistanceNode extends BevConditionNode
	{
		private var _distance:uint;
		public function BevDistanceNode(name:String){
			super(name);
		}
		
		override public function setParams(...args):BevNode
		{
			super.setParams(args[0]);
			_distance = params[1];
			return this;
		}
		
		override public function doJudge():Boolean
		{
			var result:Boolean;
			if(target == null){
				result = false;
			}else{
				if(AUtils.getDisBetweenTwoEntity(entity, target) > _distance){
					result = true;
					entity.isInRange = false;
				}else{
					result = false;
					entity.isInRange = true;
					if(entity.x > target.x)
						entity.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
					else
						entity.faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
				}
			}
			return result;
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}