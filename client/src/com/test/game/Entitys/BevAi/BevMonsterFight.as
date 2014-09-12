package com.test.game.Entitys.BevAi
{
	import com.test.game.BevTree.BevActionNode;
	import com.test.game.BevTree.BevNode;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Manager.RoleManager;
	
	public class BevMonsterFight extends BevActionNode
	{
		private var _coldTime:int;
		private var _nowTime:int;
		private var _judge:Boolean;
		public function BevMonsterFight(name:String)
		{
			super(name);
		} 
		
		override public function setParams(...args) : BevNode
		{
			super.setParams(args[0]);
			_coldTime = params[1] * 10;
			return this;
		}
		
		override public function doJudge():Boolean
		{
			return true;
		}
		
		override public function doStart():void
		{
			super.doStart();
			if(_judge) return;
			_judge = true;
			_nowTime = _coldTime;
		}
		
		override public function doExecute():void
		{
			super.doExecute();
			_nowTime--;
			if(_nowTime == int(_coldTime * .8)){
				if(target is CharacterEntity){
					entity.attackTarget(target as CharacterEntity);
				}
			}
			if(_nowTime <= 0)
				doEnd();
		}
		
		override public function doEnd():void
		{
			super.doEnd();
			_judge = false;
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}