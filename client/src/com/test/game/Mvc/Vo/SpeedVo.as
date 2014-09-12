package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class SpeedVo extends BaseVO
	{
		private var _anti:Antiwear;
		private var _renderSpeed:Number;
		
		private var _baseSpeedX:Number;
		private var _baseSpeedY:Number;
		private var _changeSpeedX:Number;
		private var _changeSpeedY:Number;
		private var _speedX:Number;
		private var _speedY:Number;
		private function get doubleSpeed() : Number{
			return _anti["doubleSpeed"];
		}
		public function SpeedVo(){
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["doubleSpeed"] = 1.8;
		}
		
		public function changeSpeed(totalSpeed:int) : void{
			_baseSpeedX = totalSpeed * 5 / 8;
			_baseSpeedY = totalSpeed * 3 / 8;
			renderSpeed = 1;
		}
		
		public function set renderSpeed(value:Number):void
		{
			_renderSpeed = value;
			_changeSpeedX = _baseSpeedX * _renderSpeed;
			_changeSpeedY = _baseSpeedY * _renderSpeed;
		}
		
		public function setRun() : void{
			_speedX = _changeSpeedX * doubleSpeed;
			_speedY = _changeSpeedY * doubleSpeed;
		}
		public function setNormal() : void{
			_speedX = _changeSpeedX;
			_speedY = _changeSpeedY;
		}
		
		public function get isNormal() : Boolean{
			if(_speedX == _changeSpeedX){
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