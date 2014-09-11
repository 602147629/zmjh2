package com.test.game.Effect
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class DailyMissionFontEffect
	{
		public function DailyMissionFontEffect()
		{
		}
		
		private var _bneLayer:BaseNativeEntity;
		private var _bneFindName:BaseNativeEntity;
		public function initOtherFontEffect(inputLayer:BaseNativeEntity, assets:String, point:Point = null) : void{
			if(_bneFindName == null){
				_bneLayer = new BaseNativeEntity();
				if(point == null){
					_bneLayer.x = 80;
					_bneLayer.y = 0;
				}else{
					_bneLayer.x = point.x;
					_bneLayer.y = point.y;
				}
				inputLayer.addChild(_bneLayer);
				_bneFindName = new BaseNativeEntity();
				_bneFindName.data.bitmapData = AUtils.getNewObj(assets) as BitmapData;
				_bneFindName.registerPoint = new Point(_bneFindName.width * .5, _bneFindName.height * .5);
				_bneFindName.scaleXValue = 3;
				_bneFindName.scaleYValue = 3;
				_bneLayer.addChild(_bneFindName);
				TweenLite.to(_bneFindName, .7, {scaleXValue:1, scaleYValue:1, ease:Elastic.easeOut, onComplete:alphaBneChange});
			}
		}
		
		private function alphaBneChange() : void{
			TweenLite.delayedCall(.7,
				function () : void{
					TweenLite.to(_bneFindName, 1.3, {alpha:0, y:-120, onComplete:clearName});
				});
		}
		
		private function clearBneName() : void{
			if(_bneFindName != null){
				_bneFindName.destroy();
				_bneFindName = null;
			}
			if(_bneLayer != null){
				_bneLayer.destroy();
				_bneLayer = null;
			}
		}
		
		private var _layer:Sprite;
		private var _findName:Bitmap;
		public function initFontEffect(inputLayer:Sprite, assets:String, pos:Point = null):void{
			if(_findName == null){
				_layer = new Sprite();
				if(pos == null){
					_layer.x = 0;
					_layer.y = 0;
				}else{
					_layer.x = pos.x;
					_layer.y = pos.y;
				}
				if(_layer.parent != null){
					_layer.parent.removeChild(_layer);
				}
				inputLayer.addChild(_layer);
				_findName = new Bitmap();
				_findName.bitmapData = AUtils.getNewObj(assets) as BitmapData;
				_findName.x = -_findName.width * .5;
				_findName.y = -_findName.height * .5;
				_layer.scaleX = 3;
				_layer.scaleY = 3;
				_layer.addChild(_findName);
				TweenLite.to(_layer, .7, {scaleX:1, scaleY:1, ease:Elastic.easeOut, onComplete:alphaChange});
			}
		}
		private function alphaChange() : void{
			TweenLite.delayedCall(.7, 
				function () : void{
					TweenLite.to(_layer, 1.3, {alpha:0, y:-120, onComplete:clearName});
				});
		}
		
		private function clearName() : void{
			if(_findName != null){
				if(_findName.parent != null){
					_findName.parent.removeChild(_findName);
				}
				_findName = null;
			}
			if(_layer != null){
				if(_layer.parent != null){
					_layer.parent.removeChild(_layer);
				}
				_layer = null;
			}
		}
	}
}