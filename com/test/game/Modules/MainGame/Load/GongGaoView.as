package com.test.game.Modules.MainGame.Load
{
	import com.greensock.TweenLite;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class GongGaoView extends BaseView
	{
		public function GongGaoView()
		{
			super();
			start();
		}
		
		private function start() : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("GongGaoView") as Sprite;
				layer.x = int(GameConst.stage.stageWidth * .5 - layer.width * .5) + 20;
				layer.y = 100;
				this.addChild(layer);
				this.mouseEnabled = false;
				this.mouseChildren = false;
				
				initParams();
				setParams();
			}
		}
		
		private function initParams():void{

		}
		
		public function setInfo(content:String) : void{
			gongGaoTF.text = content;
			show();
			TweenLite.delayedCall(10, hide);
		}
		
		override public function hide() : void{
			TweenLite.killDelayedCallsTo(hide);
			super.hide();
		}
		
		private function get gongGaoTF() : TextField{
			return layer["GongGaoTF"];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameInfoLayer;
		}
	}
}