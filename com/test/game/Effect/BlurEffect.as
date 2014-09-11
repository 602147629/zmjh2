package com.test.game.Effect
{
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Mvc.BmdView.GameSenceView;
	import com.test.game.Modules.MainGame.Map.BaseMapBgView;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class BlurEffect extends RenderEffect
	{
		public function BlurEffect(){
			super();
		}
		
		private var _blurList:Array;
		private var _blurCount:int = 10;
		public function createBlur() : void{
			if(_blurList == null)	_blurList = new Array();
			var blurList:Array = _blurList.concat();
			for each(var item:BaseNativeEntity in blurList){
				item.destroy();
			}
			blurList.length = 0;
			blurList = null;
			_blurList.length = 0;
			var gc:GameSenceView = BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView;
			var bg:BaseMapBgView = ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView;
			var map:BaseMapView = ViewFactory.getIns().getView(BaseMapView) as BaseMapView;
			if(gc.myPlayer != null && bg != null && map != null){
				var bitmapData:BitmapData = new BitmapData(940, 590, true, 0x00FFFFFF);
				for(var i:int = 0; i < _blurCount; i++){
					var bq:BaseNativeEntity = new BaseNativeEntity();
					bq.data.bitmapData = bitmapData;
					bq.data.bitmapData.copyPixels(bg.mapBg.data.bitmapData, bg.mapBg.data.bitmapData.rect, new Point(0, 0));
					bq.data.bitmapData.copyPixels(map.mapBitmap.data.bitmapData, map.mapBitmap.data.bitmapData.rect, new Point(0, 0));
					bq.scaleX *= (i / _blurCount);
					bq.scaleY *= (i / _blurCount);
					bq.alpha = .4;
					bq.x = gc.myPlayer.bodyPos.x / _blurCount * (_blurCount - i);
					bq.y = gc.myPlayer.bodyPos.y / _blurCount * (_blurCount - i);
					map.addChild(bq);
					_blurList.push(bq);
				}
				//bq.data.bitmapData.copyPixels(bg.mapBg.data.bitmapData, bg.mapBg.data.bitmapData.rect, new Point(0, 0));
				//bq.data.bitmapData.copyPixels(map.mapBitmap.data.bitmapData, map.mapBitmap.data.bitmapData.rect, new Point(0, 0));
			}
		}
		
		override public function destroy() : void{
			if(_blurList){
				_blurList.length = 0;
				_blurList = null;
			}
			super.destroy();
		}
	}
}