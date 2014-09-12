package com.test.game.Effect
{
	import flash.filters.ColorMatrixFilter;

	public class GreyEffect extends RenderEffect
	{
		public function GreyEffect()
		{
			super();
		}
		
		public static function change(obj:Object,num:Number = 0.5) : void{
			var filter:ColorMatrixFilter = new ColorMatrixFilter(
				[num,num,num,0,0,
					num,num,num,0,0,
					num,num,num,0,0,
					0,0,0,1,0]);
			obj.filters = new Array(filter);
		}
		
		public static function reset(obj:Object) : void{
			obj.filters = null;
		}
	}
}