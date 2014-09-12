package com.test.game.process
{
	import com.superkaka.game.AgreeMent.IStepAble;
	import com.test.game.Entitys.MonsterEntity;
	
	public class HpConditionCompare implements IStepAble
	{
		public function HpConditionCompare(str:String)
		{
		}
		
		public function judge(entity:MonsterEntity) : Boolean{
			var result:Boolean = true;
			
			return result;
		}
		
		public function step():void
		{
		}
		
		public function get currentFrameCount():int
		{
			return 0;
		}
		
		public function set currentFrameCount(value:int):void
		{
		}
		
		public function get renderSpeed():Number
		{
			return 0;
		}
		
		public function set renderSpeed(value:Number):void
		{
		}
		
		public function get isStopRender():Boolean
		{
			return false;
		}
		
		public function set isStopRender(value:Boolean):void
		{
		}
	}
}