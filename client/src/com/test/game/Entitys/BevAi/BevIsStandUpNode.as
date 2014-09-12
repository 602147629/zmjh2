package com.test.game.Entitys.BevAi
{
	import com.test.game.BevTree.BevConditionNode;
	
	public class BevIsStandUpNode extends BevConditionNode{
		
		public function BevIsStandUpNode(name:String){
			super(name);
		}
		
		override public function doJudge():Boolean{
			var result:Boolean = false;
			if(entity.charData.characterJudge.isStandUp){
				result = true;
			}
			return result;
		}
	}
}