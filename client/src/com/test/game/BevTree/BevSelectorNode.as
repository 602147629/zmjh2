package com.test.game.BevTree
{
	public class BevSelectorNode extends BevNode
	{
		public function BevSelectorNode(name:String){
			super(name);
		}
		
		override public function step():void
		{
			super.step();
		}
		
		override public function doJudge():Boolean
		{
			var result:Boolean = false;
			for(var i:int = 0; i < children.length; i++)
			{
				nowIndex = i;
				if(children[i].doJudge())
				{
					result = true;
					break;
				}
			}
			
			return result;
		}
		
		override public function doStart():void
		{
		}
		
		override public function doExecute():void
		{
		}
		
		override public function doEnd():void
		{
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}