package com.test.game.Modules.MainGame.PlayerKilling
{
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class PlayerKillingTimeShow extends BaseView
	{
		public function PlayerKillingTimeShow()
		{
			super();
			start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("PlayerKillingTimeShow") as Sprite;
				layer.x = GameConst.stage.stageWidth * .5 - layer.width * .5;
				layer.y = 30;
				this.addChild(layer);
				
				initParams();
				initUI();
				setParams();
			}
		}
		
		private function initParams():void{
			
		}
		
		private function initUI():void{
			minute1.gotoAndStop(1);
			minute2.gotoAndStop(1);
			second1.gotoAndStop(1);
			second2.gotoAndStop(1);
		}
		
		private var _min:int;
		private var _sec:int;
		public function setTime(count:int) : void{
			if(layer == null && !isClose) return;
			count = 120 - count;
			count = (count>120?120:count);
			_min = count / 60;
			minute1.gotoAndStop(1);
			minute2.gotoAndStop(int(_min % 10) + 1);
			_sec = count % 60;
			second1.gotoAndStop(int(_sec / 10) + 1);
			second2.gotoAndStop(int(_sec % 10) + 1);
		}
		
		override public function hide():void{
			setTime(0);
			super.hide();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		private function get minute1() : MovieClip{
			return layer["Minute1"];
		}
		private function get minute2() : MovieClip{
			return layer["Minute2"];
		}
		private function get second1() : MovieClip{
			return layer["Second1"];
		}
		private function get second2() : MovieClip{
			return layer["Second2"];
		}
	}
}