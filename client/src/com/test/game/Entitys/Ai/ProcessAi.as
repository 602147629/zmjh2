package com.test.game.Entitys.Ai
{
	import com.superkaka.game.AgreeMent.IStepAble;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.process.ProcessAnalysis;

	public class ProcessAi implements IStepAble
	{
		private var _currentFrameCount:int = 0;
		private var _renderSpeed:Number = 1;
		private var _isStopRender:Boolean;
		private var _process:ProcessAnalysis;
		
		public function ProcessAi(entity:MonsterEntity, aiObj:Object)
		{
			_process = new ProcessAnalysis(aiObj, entity);
		}
		
		public function step():void{
			if(_process != null && _process.locked) return;
			_process.step();
		}
		
		public function destroy():void{
			if(_process != null){
				_process.destroy();
				_process = null;
			}
		}
		
		public function get process() : ProcessAnalysis{
			return _process;
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