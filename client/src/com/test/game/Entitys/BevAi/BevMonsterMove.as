package com.test.game.Entitys.BevAi
{
	import com.test.game.BevTree.BevActionNode;
	import com.test.game.Entitys.MonsterEntity;
	
	public class BevMonsterMove extends BevActionNode
	{
		private var _moveFrame:int;
		public function BevMonsterMove(name:String)
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
			_moveFrame++;
			if(_moveFrame < 100)
				entity.moveLeft();
			else if(_moveFrame >= 100)
				entity.moveRight();
			
			if(_moveFrame >= 200)
				_moveFrame = 0;
		}
	}
}