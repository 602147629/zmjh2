package com.test.game.Entitys.BevAi
{
	import com.test.game.BevTree.BevConditionNode;
	
	public class BevIsOnAttackNode extends BevConditionNode
	{
		public function BevIsOnAttackNode(name:String)
		{
			super(name);
		}
		
		override public function doJudge():Boolean
		{
			var result:Boolean;
			if(entity != null){
				if(entity.characterJudge.isStartAttack)
					result = false;
				else
					result = true;
			}
			return result;
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}