package com.test.game.Effect
{
	import com.superkaka.game.AgreeMent.IStepAble;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	
	public class RenderEffect implements IStepAble
	{
		private var _currentFrameCount:int;
		private var _renderSpeed:Number;
		private var _isStopRender:Boolean;
		public function RenderEffect()
		{
			_renderSpeed = 1;
			RenderEntityManager.getIns().addEntity(this);
		}
		
		public function destroy() : void{
			RenderEntityManager.getIns().removeEntity(this);
		}
		
		public function step():void
		{
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