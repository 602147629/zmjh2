package com.test.game.Modules.MainGame.Summer
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Effect.ViewTweenEffect;
	import com.test.game.Manager.ExtraBarManager;
	import com.test.game.Manager.LoadManager;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class SummerGiftView extends BaseView
	{
		public function SummerGiftView()
		{
			super();
		}
		
		override protected function getContainer() : BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.SUMMERGIFTVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.SUMMERGIFTVIEW.split("/")[1]) as Sprite;
				this.addChild(layer);
				layer.visible = false;
				
				initUI();
				initBg(); 
				setCenter();
				openTween();
			}
		}
		
		private function initUI() : void{
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			rechargeBtn.buttonMode = true;
			rechargeBtn.addEventListener(MouseEvent.CLICK, onShowRecharge);
			paiedBtn.buttonMode = true;
			paiedBtn.addEventListener(MouseEvent.CLICK, onPaied);
		}
		
		protected function onPaied(e:MouseEvent):void{
			(ViewFactory.getIns().initView(SummerGiftShowView) as SummerGiftShowView).showUIType(2);
			this.hide();
		}
		
		protected function onShowRecharge(e:MouseEvent) : void{
			(ViewFactory.getIns().initView(SummerGiftShowView) as SummerGiftShowView).showUIType(1);
			this.hide();
		}
		
		override public function show():void{
			if(layer == null) return;
			openTween();
			super.show();
		}
		
		private function openTween():void{
			var pos:Point = ExtraBarManager.getIns().getBtnPos("Activity");
			ViewTweenEffect.openTween(layer, pos.x, pos.y, centerX, centerY);
		}
		
		private function closeTween():void{
			var pos:Point = ExtraBarManager.getIns().getBtnPos("Activity");
			ViewTweenEffect.closeTween(layer, pos.x, pos.y, hide);	
		}
		
		protected function onClose(e:MouseEvent) : void{
			closeTween();
		}
		
		private function get rechargeBtn() : MovieClip{
			return layer["RechargeBtn"];
		}
		private function get paiedBtn() : MovieClip{
			return layer["PaiedBtn"];
		}
		private function get closeBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
	}
};