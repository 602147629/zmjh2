package com.test.game.Entitys.BevAi
{
	import com.test.game.BevTree.BevConditionNode;
	import com.test.game.BevTree.BevNode;
	import com.test.game.BevTree.BevTreeConst;
	import com.test.game.BevTree.IBevTree;
	import com.test.game.Entitys.MonsterEntity;
	
	public class BevIntervalTime extends BevConditionNode implements IBevTree
	{
		private var _intervalTime:int;
		private var _nowTime:int;
		
		public function BevIntervalTime(name:String)
		{
			super(name);
		}
		
		override public function setParams(...args) : BevNode
		{
			_intervalTime = args[1] * 10;
			return this;
		}
		
		override public function doJudge():Boolean
		{
			var result:Boolean = true;
			if(nowStatus == BevTreeConst.IS_EXECUTE)
				result = false;
			else
				result = true;
			
			return result;
		}
		
		override public function doStart():void
		{
			super.doStart();
			_nowTime = _intervalTime;
		}
		
		override public function doExecute():void
		{
			super.doExecute();
			_nowTime--;
			if(_nowTime <= 0)
			{
				_nowTime = 0;
				doEnd();
			}
		}
		
		override public function doEnd() : void
		{
			super.doEnd();
		}
	}
}