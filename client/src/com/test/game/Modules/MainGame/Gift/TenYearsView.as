package com.test.game.Modules.MainGame.Gift
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.URLManager;
	import com.test.game.Manager.Gift.TenYearsGiftManager;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class TenYearsView extends BaseView
	{
		public function TenYearsView()
		{
			super();
		}
		
		override public function init():void{
			super.init();
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("ScoreGiftView") as Sprite;
				this.addChild(layer);
				
				initUI();
				initParams();
				initBg();
				
				setCenter();
			}
		}
		
		private function initParams():void{
			
		}
		
		private function initUI():void{
			getGiftBtn.addEventListener(MouseEvent.CLICK, onGetGift);
			getCodeBtn.addEventListener(MouseEvent.CLICK, onGetCode);
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			giftName.gotoAndStop("gift6025");
		}
		
		protected function onClose(event:MouseEvent):void{
			this.hide();
		}
		
		protected function onGetCode(event:MouseEvent):void{
			URLManager.getIns().openTenYearsURL();
		}
		
		protected function onGetGift(event:MouseEvent):void{
			if(codeTxt.text == ""){
				update();
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"请输入激活码！");
				return;
			}
			
			if(PackManager.getIns().checkMaxRoomByNum(1)){
				TenYearsGiftManager.getIns().sendData(codeTxt.text);
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"系统正在处理当中，请稍等...", null, null, true);
			}else{
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"背包空间不足！\n请留出空间后再领取");
			}
		}
		
		override public function show():void{
			super.show();
			
			update();
		}
		
		override public function update():void{
			resetCodeTxt();
		}
			
		private function resetCodeTxt() : void{
			codeTxt.text = "";
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		private function get codeTxt():TextField
		{
			return layer["codeTxt"];
		}
		
		private function get getGiftBtn():SimpleButton{
			return layer["getGiftBtn"];
		}
		
		private function get getCodeBtn():SimpleButton{
			return layer["getCodeBtn"];
		}
		
		private function get giftName():MovieClip{
			return layer["giftName"];
		}
		
		private function get giftTypeTxt():TextField{
			return layer["giftTypeTxt"];
		}
		
		private function get closeBtn():SimpleButton{
			return layer["closeBtn"];
		}
	}
}