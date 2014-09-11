package com.test.game.Effect
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.test.game.Manager.SceneManager;
	
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class EvasionEffect extends RenderEffect
	{
		public function EvasionEffect(pos:Point){
			super();
			createEvasion(pos);
		}
		
		private var _stepTime:int = 0;
		override public function step():void{
			if(_stepTime > 15){
				_evasionImage.y -= 8;
			}
			_stepTime++;
		}
		
		private var _evasionImage:BaseNativeEntity;
		private var _layer:BaseNativeEntity;
		public function createEvasion(pos:Point) : void{
			_layer = new BaseNativeEntity();
			_evasionImage = new BaseNativeEntity();
			_evasionImage.data.bitmapData = AUtils.getNewObj("EvasionImage") as BitmapData;
			_layer.addChild(_evasionImage);
			_layer.registerPoint = new Point(_layer.width * .5, _layer.height * .5)
			_layer.x = pos.x - _layer.width * .5;
			_layer.y = pos.y - _layer.height;
			_layer.scaleXValue = .1;
			_layer.scaleYValue = .1;
			TweenLite.to(_layer, .5, {scaleXValue:.8, scaleYValue:.8, ease:Elastic.easeOut});
			TweenLite.delayedCall(1, destroy);
			if(SceneManager.getIns().nowScene != null){
				SceneManager.getIns().nowScene.addChild(_layer);
			}
		}
		
		override public function destroy():void{
			if(_evasionImage){
				_evasionImage.destroy();
				_evasionImage = null;
			}
			if(_layer){
				_layer.destroy();
				_layer = null
			}
			super.destroy();
		}
	}
}