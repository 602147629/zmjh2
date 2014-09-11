package com.test.game.Effect
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;

	public class ViewTweenEffect extends BaseEffect
	{
		public function ViewTweenEffect()
		{
			super();
		}
		
		public static function openTween(layer:Sprite, xPos:int, yPos:int, centerX:int, centerY:int) : void{
			layer.scaleX = layer.scaleY = 0;
			layer.visible = true;
			TweenMax.fromTo(layer, 0.4, {scaleX:0, scaleY:0, x:xPos, y:yPos}, {scaleX:1, scaleY:1, x:centerX, y:centerY});
		}
		
		public static function closeTween(layer:Sprite, xPos:int, yPos:int, callback:Function) : void{
			TweenMax.to(layer, 0.4, {scaleX:0,scaleY:0, x:xPos, y:yPos, onComplete: callback});		
		}
	}
}