package com.test.game.Modules.MainGame.Map
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Manager.LevelManager;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class BaseMapBgView extends BaseView
	{
		private var _offsetX:Number;
		public function BaseMapBgView(){
			super();
		}
		
		override public function init():void{
			this.getContainer().addChildAt(this, 0);
			start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = new Sprite();
				
				initParams();
				initUI();
				setParams();
			}
		}
		
		private function initParams():void{
			
		}
		
		public var mapBg:BaseNativeEntity;
		public function initUI() : void{
			var arr:Array = LevelManager.getIns().nowIndex.split("_");
			mapBg = new BaseNativeEntity();
			if(LevelManager.getIns().mapType == 0){
				if(arr[1] < 10){
					if(arr[0] == 4){
						mapBg.data.bitmapData = AUtils.getNewObj("MapBg" + arr[0] + "_" + Math.ceil(arr[1] / 3)) as BitmapData;
					}else{
						mapBg.data.bitmapData = AUtils.getNewObj("MapBg" + arr[0]) as BitmapData;
					}
				}else{
					mapBg.data.bitmapData = AUtils.getNewObj("MapHideBg" + arr[0]) as BitmapData;
				}
			}else if(LevelManager.getIns().mapType == 1){
				if(arr[1] < 4){
					if(arr[0] == 4){
						mapBg.data.bitmapData = AUtils.getNewObj("MapBg" + arr[0] + "_" + arr[1]) as BitmapData;
					}else{
						mapBg.data.bitmapData = AUtils.getNewObj("MapBg" + arr[0]) as BitmapData;
					}
				}else{
					mapBg.data.bitmapData = AUtils.getNewObj("MapHideBg" + arr[0]) as BitmapData;
				}
			}
			mapBg.x = -50;
			mapBg.y = -50;
			this.addChild(mapBg);
			if(ViewFactory.getIns().getView(BaseMapView) != null){
				_offsetX = (this.width - 100 - GameConst.stage.stageWidth) / (ViewFactory.getIns().getView(BaseMapView).width - GameConst.stage.stageWidth);
			}
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().bgLayer;
		}
		
		/**
		 * 移动地图 
		 * @param p
		 * 
		 */		
		public function offsetPoint(p:Point):void{
			this.x += p.x * _offsetX;
			if(this.x > 0){
				this.x = 0;
			}
		}
		
		override public function destroy():void{
			if(mapBg){
				mapBg.destroy();
				mapBg = null;
			}
			super.destroy();
		}
	}
}