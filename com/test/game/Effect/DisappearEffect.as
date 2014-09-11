package com.test.game.Effect
{
	public class DisappearEffect extends RenderEffect
	{
		private var _callback:Function;
		private var _obj:Object;
		public function DisappearEffect(obj:Object, alpha:Number, callback:Function){
			_obj = obj;
			_obj.alpha = alpha;
			_callback = callback;
			super();
		}
		
		private var _stepTime:int;
		//显示次数
		private var _showTime:int = 4;
		//间隔时间
		private var _intervalTime:int = 5;
		override public function step():void{
			_stepTime++;
			if(_stepTime < _showTime * _intervalTime * 2){
				if(_stepTime % (_intervalTime * 2) == 0){
					_obj.visible = true;
				}else if(_stepTime % _intervalTime == 0){
					_obj.visible = false;
				}
			}else{
				this.destroy();
			}
		}
		
		override public function destroy():void{
			super.destroy();
			if(_callback != null){
				_callback();
				_callback = null;
			}
			_obj = null;
		}
		
	}
}