package com.test.game.BevTree
{

	public class BevConditionNode extends BevNode
	{
		public function BevConditionNode(name:String)
		{
			super(name);
		}
		
		override public function doJudge():Boolean
		{
			return false;
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}