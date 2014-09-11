package com.test.game.Effect
{
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;

	public class GrayFilterEffect extends RenderEffect
	{
		private var _obj:Object;
		private var _count:Number;
		private var _startTween:Boolean;
		public function GrayFilterEffect(input:Object){
			_obj = input;
			super();
		}
		
		override public function step() : void{
			super.step();
			if(_startTween){
				_count += .01;
				if(_count >= 0.05){
					var filter:ColorMatrixFilter = new ColorMatrixFilter(
						[_count,_count,_count,0,0,
							_count,_count,_count,0,0,
							_count,_count,_count,0,0,
							0,0,0,1,0]);
					_obj.filters = new Array(filter, blur);
					if(_count >= .5){
						_startTween = false;
						destroy();
					}
				}
			}
		}
		
		private var blur:BlurFilter;
		public function start() : void{
			_count = 0;
			blur = new BlurFilter();
			blur.blurX = 10;//水平模糊
			blur.blurY = 10;//垂直模糊

			var filter:ColorMatrixFilter = new ColorMatrixFilter(
				[0.5, 0.5, 0.5, 0, 0,
					0,0,0,0,0,
					0,0,0,0,0,
					0,0,0,1,0]);
			_obj.filters = new Array(filter, blur);
			_startTween = true;
		}
		
		public function stop() : void{
			_startTween = false;
			_obj.filter = null;
		}
		
		override public function destroy() : void{
			_obj = null;
			super.destroy();
		}
	}
}