package com.test.game.Effect
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;

	public class WeatherShowEffect extends BaseEffect
	{
		
		private var _obj:Sprite;
		public function WeatherShowEffect(){
			super();
		}
		
		public function start(obj:Sprite) : void{
			_obj = obj;
			_obj["WeatherBg"].scaleY = 0;
			_obj["WeatherFont"].alpha = 0;
			TweenLite.to(_obj["WeatherBg"], .5, {scaleY:.6, onComplete:statusComplete});
		}
		
		private function statusComplete() : void{
			if(_obj != null){
				TweenLite.to(_obj["WeatherFont"], .5, {alpha:1});
				TweenLite.delayedCall(1, changeAlpha);
			}
		}
		
		private function changeAlpha() : void{
			if(_obj != null){
				TweenLite.to(_obj, .5, {alpha:0, onComplete:allComplete});
			}
		}
		
		private function allComplete() : void{
			clear();
		}
		
		public function clear() : void{
			TweenLite.killDelayedCallsTo(changeAlpha);
			TweenLite.killTweensOf(_obj);
			
			if(_obj != null){
				if(_obj.parent != null){
					_obj.parent.removeChild(_obj);
				}
				_obj = null;
			}
		}
	}
}