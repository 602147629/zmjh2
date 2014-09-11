package com.test.game.Entitys.BevAi
{
	import com.test.game.BevTree.BevActionNode;
	import com.test.game.Entitys.MonsterEntity;
	
	public class BevMonsterLeftMove extends BevActionNode
	{
		public function BevMonsterLeftMove(name:String)
		{
			super(name);
		}
		
		override public function doJudge():Boolean
		{
			var result:Boolean = true;
			
			return result;
		}
		
		override public function doExecute():void
		{
			super.doExecute();
			if(entity == null) return;
			entity.moveLeft();
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}