package com.test.game.Entitys.BevAi
{
	import com.test.game.BevTree.BevConditionNode;
	
	public class BevHurtNode extends BevConditionNode
	{
		public function BevHurtNode(name:String)
		{
			super(name);
		}
		
		override public function doJudge():Boolean
		{
			var result:Boolean = true;
			
			return result;
		}
	}
}