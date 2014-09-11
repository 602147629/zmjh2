package com.test.game.Effect
{
	import com.superkaka.game.AgreeMent.IStepAble;
	import com.test.game.Manager.AnimationManager;
	
	public class BaseEffect implements IStepAble
	{
		private var _currentFrameCount:int;
		private var _renderSpeed:Number;
		private var _isStopRender:Boolean;
		
		public function BaseEffect()
		{
			_renderSpeed = 1;
			AnimationManager.getIns().addEntity(this);
		}
		
		public function step():void
		{
		}
		
		public function destroy() : void{
			AnimationManager.getIns().removeEntity(this);
		}
		
		public function get currentFrameCount():int
		{
			return _currentFrameCount;
		}
		
		public function set currentFrameCount(value:int):void
		{
			_currentFrameCount = value;
		}
		
		public function get renderSpeed():Number
		{
			return _renderSpeed;
		}
		
		public function set renderSpeed(value:Number):void
		{
			_renderSpeed = value;
		}
		
		public function get isStopRender():Boolean
		{
			return _isStopRender;
		}
		
		public function set isStopRender(value:Boolean):void
		{
			_isStopRender = value;
		}
	}
}