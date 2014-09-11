package com.test.game.Effect
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.test.game.Manager.SceneManager;
	
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class CritEffect extends RenderEffect
	{
		public function CritEffect(pos:Point)
		{
			createCrit(pos);
		}
		
		private var _critImage:BaseNativeEntity;
		private var _layer:BaseNativeEntity;
		public function createCrit(pos:Point) : void{
			_layer = new BaseNativeEntity();
			_critImage = new BaseNativeEntity();
			_critImage.data.bitmapData = AUtils.getNewObj("CritImage") as BitmapData;
			_critImage.registerPoint = new Point(_critImage.width * .5, _critImage.height * .5)
			_layer.addChild(_critImage);
			_layer.x = pos.x;
			_layer.y = pos.y - _layer.height - 20;
			_layer.scaleXValue = .1;
			_layer.scaleYValue = .1;
			TweenLite.to(_layer, .33, {scaleXValue:.8, scaleYValue:.8, ease:Elastic.easeOut});
			TweenLite.delayedCall(.8, destroy);
			if(SceneManager.getIns().nowScene != null){
				SceneManager.getIns().nowScene.addChild(_layer);
			}
		}
		
		override public function destroy():void{
			if(_critImage){
				_critImage.destroy();
				_critImage = null;
			}
			if(_layer){
				_layer.destroy();
				_layer = null;
			}
			super.destroy();
		}
		
	}
}