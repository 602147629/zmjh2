package com.test.game.Effect
{
	import com.greensock.TweenMax;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;

	public class FuzzyEffect extends BaseEffect
	{
		private var _itemsStart:Array;
		private var _itemsEnd:Array;
		public function FuzzyEffect(){
			super();
		}
		
		public function addItem(sp:Sprite, isStart:Boolean) : void{
			if(isStart){
				if(_itemsStart == null){
					_itemsStart = new Array();
				}
				_itemsStart.push(sp);
			}else{
				if(_itemsEnd == null){
					_itemsEnd = new Array();
				}
				_itemsEnd.push(sp);
			}
		}
		
		public function start() : void{
			AnimationManager.getIns().addEntity(this);
			for(var i:int = 0; i < _itemsStart.length; i++){
				if(_itemsStart[i] is BaseMapView){
					var bitmapData:BitmapData = new BitmapData(940, 590, true, 0x00FFFFFF);
					bitmapData.draw(_itemsStart[i].layer);
					var bitmap:Bitmap = new Bitmap(bitmapData);
					_itemsStart[i].layer.addChild(bitmap);
					TweenMax.to(bitmap, 1.5, {blurFilter:{blurX:10, blurY:10, remove:true}});
				}else{
					TweenMax.to(_itemsStart[i], 1.5, {blurFilter:{blurX:10, blurY:10, remove:true}});
				}
			}
		}
		
		private var _bpList:Array = new Array();
		public function resume() : void{
			clearBp();
			for(var i:int = 0; i < _itemsEnd.length; i++){
				if(_itemsEnd[i] is BaseMapView){
					var bitmapData:BitmapData = new BitmapData(940, 590, true, 0x00FFFFFF);
					bitmapData.draw(_itemsEnd[i].layer);
					var bitmap:Bitmap = new Bitmap(bitmapData);
					bitmap.filters = [new BlurFilter(10, 10)];
					_itemsEnd[i].layer.addChild(bitmap);
					TweenMax.to(bitmap, 2, {blurFilter:{blurX:0, blurY:0}, onComplete:removeBitmap, onCompleteParams:[bitmap]});
				}else{
					if(_itemsEnd[i] != null){
						_itemsEnd[i].layer.filters = [new BlurFilter(10, 10)];
						TweenMax.to(_itemsEnd[i].layer, 2, {blurFilter:{blurX:0, blurY:0}});
					}
				}
			}
		}
		
		private function clearBp():void{
			for(var i:int = 0; i < _bpList.length; i++){
				removeBitmap(_bpList[i] as Bitmap);
			}
			_bpList.length = 0;
		}
		
		private function removeBitmap(bp:Bitmap) : void{
			if(bp != null){ 
				if(bp.parent != null){
					bp.parent.removeChild(bp);
				}
				bp.filters = null;
				bp.bitmapData.dispose();
				bp = null;
			}
		}
		
		public function clear() : void{
			AnimationManager.getIns().removeEntity(this);
			if(_itemsStart != null)
				_itemsStart.length = 0;
			if(_itemsEnd != null)
				_itemsEnd.length = 0;
		}
		
		override public function destroy():void{
			if(_itemsStart != null){
				_itemsStart.length = 0;
				_itemsStart = null;
			}
			if(_itemsEnd != null){
				_itemsEnd.length = 0;
				_itemsEnd = null;
			}
			super.destroy();
		}
	}
}