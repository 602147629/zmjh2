package com.test.game.Effect
{
	import flash.text.TextField;

	public class TFStepEffect extends BaseEffect
	{
		protected var _callback:Function;
		protected var _tf:TextField;
		protected var _info:String;
		protected var _stepTime:int;
		protected var _infoLen:int;
		protected var _infoCount:int;
		protected var _stepControl:Boolean;
		public function get stepControl() : Boolean{
			return _stepControl;
		}
		public function TFStepEffect(){
			super();
		}
		
		public function initParams(tf:TextField, info:String, callback:Function = null) : void{
			_tf = tf;
			_info = info;
			_infoLen = _info.length;
			_infoCount = 0;
			_stepTime = 0;
			_stepControl = true;
			_callback = callback;
		}
		
		override public function step() : void{
			if(_stepControl){
				_stepTime++;
				if(_stepTime % 3 == 0){
					_infoCount++;
					if(_infoCount <= _infoLen){
						_tf.text = _info.slice(0, _infoCount);
					}else{
						_stepControl = false;
						if(_callback != null){
							_callback();
						}
					}
				}
			}
		}
		
		public function completeAll() : void{
			_stepControl = false;
			_tf.text = _info;
		}
	}
}