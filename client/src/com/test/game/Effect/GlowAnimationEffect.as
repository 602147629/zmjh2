package com.test.game.Effect
{
	
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;

	public class GlowAnimationEffect extends BaseEffect
	{
		private var _obj:DisplayObject;
		private var _color:int;
		private var _isPlay:Boolean;
		private var _glow:GlowFilter;
		public function GlowAnimationEffect()
		{
			super();
		}
		
		public function init(obj:DisplayObject, color:int = 0xffff33) : void{
			_obj = obj;
			_color = color;
			_glow = new GlowFilter(color);
			_glow.blurX = 3;
			_glow.blurY = 3;
		}
		
		private var _step:int;
		override public function step():void{
			if(_isPlay){
				if(_step < 20){
					_glow.blurX += .5;
					_glow.blurY += .5;
					_obj.filters = [_glow];
				}
				if(_step >= 20 && _step < 40){
					_glow.blurX -= .5;
					_glow.blurY -= .5;
					_obj.filters = [_glow];
				}
				_step++;
				if(_step == 40){
					_step = 0;
				}
			}
		}
		
		public function start() : void{
			_isPlay = true;
		}
		
		public function stop() : void{
			_isPlay = false;
			_step = 0;
			_glow.blurX = 3;
			_glow.blurY = 3;
			_obj.filters = null;
		}
		
		override public function  destroy():void{
			super.destroy();
		}
	}
}