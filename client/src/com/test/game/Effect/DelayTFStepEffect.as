package com.test.game.Effect
{
	import com.greensock.TweenLite;

	public class DelayTFStepEffect extends TFStepEffect
	{
		private var _delayStep:int = 0;
		public function DelayTFStepEffect()
		{
			super();
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
						TweenLite.delayedCall(1, delayFun);
					}
				}
			}
		}
		
		private function delayFun() : void{
			if(_callback != null){
				_callback();
			}
		}
		
		override public function completeAll() : void{
			TweenLite.killDelayedCallsTo(delayFun);
			_stepControl = false;
			_tf.text = _info;
		}
	}
}