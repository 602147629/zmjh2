package com.test.game.Entitys.BevAi
{
	import com.test.game.BevTree.BevConditionNode;
	
	
	public class BevBoardRangeNode extends BevConditionNode
	{
		private var _stepTime:int;
		private var _result:Boolean;
		public function BevBoardRangeNode(name:String)
		{
			super(name);
		}
		
		override public function doJudge():Boolean
		{
			if(entity.x == entity.characterControl.limitLeftX){
				doCalculate();
			}else if(entity.x == entity.characterControl.limitRightX){
				doCalculate();
			}else{
				doOver();
			}
			return _result;
		}
		
		public function doCalculate() : void
		{
			_stepTime++;
			if(_stepTime == 60){
				_result = false;
			}else if(_stepTime == 61){
				_result = true;
				_stepTime = 0;
			}
		}
		private function doOver() : void
		{
			_stepTime = 0;
			_result = true;
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}