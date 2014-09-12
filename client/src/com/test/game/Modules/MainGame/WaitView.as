package com.test.game.Modules.MainGame
{
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class WaitView extends BaseView
	{
		public function WaitView()
		{
			super();
			start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("WaitShow") as Sprite;
				this.addChild(layer);
				
				initParams();
				initUI();
				setParams();
				setCenter();
			}
		}
		
		private var _blackBg:BaseNativeEntity;
		private function initUI():void{
			initBg();
			
			var rect:Sprite = new Sprite();
			rect.graphics.beginFill(0x000000, 1);
			rect.graphics.drawRect(0,0,GameConst.stage.stageWidth,GameConst.stage.stageHeight);
			rect.graphics.endFill();
			
			var bitmapData:BitmapData = new BitmapData(GameConst.stage.stageWidth, GameConst.stage.stageHeight);
			bitmapData.draw(rect);
			
			_blackBg = new BaseNativeEntity();
			_blackBg.data.bitmapData = bitmapData;
		}
		
		private function initParams():void{
			
		}		
		
		public function showProgress(...args):void{
			
		}
		
		override public function show():void{
			if(layer == null) return;
			if(_blackBg.parent != null){
				_blackBg.parent.removeChild(_blackBg);
			}
			super.show();
		}
		
		public function addBlackBg() : void{
			this.addChildAt(_blackBg, 0);
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameInfoLayer;
		}
	}
}