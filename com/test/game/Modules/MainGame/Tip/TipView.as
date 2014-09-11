package com.test.game.Modules.MainGame.Tip
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.URLManager;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class TipView extends BaseView
	{
		protected var _comfireFun:Function;
		protected var _cancelFun:Function;
		protected var _content:String;
		public function TipView(){
			super();
			start();
		}
		
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.TIPVIEW.split("/")[1]) as Sprite;
				this.addChild(layer);
				
				(layer["payMoneyBtn"] as SimpleButton).visible = false;
				(layer["urlMc"] as Sprite).visible = false;
				
				initParams();
				initUI();
				setParams();
				setCenter();
			}
		}
		
		private function initParams():void{
			_comfireFun = null;
			_cancelFun = null;
		}
		
		private function initUI():void{
			/*(layer["ContentTF"] as TextField).embedFonts = true;
			(layer["ContentTF"] as TextField).defaultTextFormat = FontManager.getIns().getFontFormat();
			(layer["ContentTF"] as TextField).autoSize = TextFieldAutoSize.LEFT;
			(layer["ContentTF"] as TextField).border = true;*/
			(layer["ComfireBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onComfireFun);
			(layer["CancelBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onCancelFun);
			(layer["payMoneyBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onPayMoney);
			(layer["urlMc"] as Sprite).addEventListener(MouseEvent.CLICK, onPayMoneyHelp);
			initBg();
		}
		
		protected function onPayMoneyHelp(event:MouseEvent):void
		{
			URLManager.getIns().openPayHelp();
		}
		
		protected function onPayMoney(event:MouseEvent):void
		{
			ShopManager.getIns().payMoney();
			hide();
		}
		
		private function onComfireFun(e:MouseEvent) : void{
			this.hide();
			if(_comfireFun != null){
				_comfireFun();
			}
		}
		
		private function onCancelFun(e:MouseEvent) : void{
			this.hide();
			if(_cancelFun != null){
				_cancelFun();
			}
		}
		
		public function setFun(content:String, comfireFun:Function = null, cancelFun:Function = null, hideBtn:Boolean = false) : void{
			_content = content;
			_comfireFun = comfireFun;
			_cancelFun = cancelFun;
			
			if(hideBtn){
				(layer["ComfireBtn"] as SimpleButton).visible = false;
				(layer["CancelBtn"] as SimpleButton).visible = false;
			}else{
				(layer["ComfireBtn"] as SimpleButton).visible = true;
				(layer["CancelBtn"] as SimpleButton).visible = true;
			}
			
			(layer["ContentTF"] as TextField).text = _content;
			this.show();
			
			getContainer().setChildIndex(this, getContainer().numChildren - 1);
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameTipLayer;
		}
		
		override public function destroy() : void{
			if(layer != null){
				layer = null
			}
			super.destroy();
		}
	}
}