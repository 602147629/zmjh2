package com.test.game.Entitys.Roles
{
	import com.superkaka.game.AgreeMent.IStepAble;
	
	public class SpeedEntity implements IStepAble
	{
		private var _currentFrameCount:int;
		private var _renderSpeed:Number;
		private var _isStopRender:Boolean;
		
		private var _baseSpeedX:Number;
		private var _baseSpeedY:Number;
		private var _changeSpeedX:Number;
		private var _changeSpeedY:Number;
		private var _speedX:Number;
		private var _speedY:Number;
		public function SpeedEntity(speedX:Number, speedY:Number)
		{
			_baseSpeedX = speedX;
			_baseSpeedY = speedY;
			renderSpeed = 1;
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
			_changeSpeedX = _baseSpeedX * _renderSpeed;
			_changeSpeedY = _baseSpeedY * _renderSpeed;
		}
		
		public function get isStopRender():Boolean
		{
			return _isStopRender;
		}
		
		public function set isStopRender(value:Boolean):void
		{
			_isStopRender = value;
		}
		
		public function setRun() : void{
			_speedX = _changeSpeedX * 1.8;
			_speedY = _changeSpeedY * 1.8;
		}
		public function setNormal() : void{
			_speedX = _changeSpeedX;
			_speedY = _changeSpeedY;
		}
		
		public function get isNormal() : Boolean{
			if(_speedX == _baseSpeedX){
				return true;
			}else{
				return false;
			}
		}
		
		public function get speedX() : int{
			return _speedX;
		}
		public function get speedY() : int{
			return _speedY;
		}
	}
}