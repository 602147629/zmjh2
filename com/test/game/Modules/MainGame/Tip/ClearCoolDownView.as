package com.test.game.Modules.MainGame.Tip
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.ShopManager;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ClearCoolDownView extends BaseView
	{
		protected var _comfireFun:Function;
		protected var _cancelFun:Function;
		protected var _content:String;
		public function ClearCoolDownView()
		{
			super();
			start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("ClearCoolDownView") as Sprite;
				this.addChild(layer);
				
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
			(layer["QuitBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onQuitFun);
			(layer["ClearCoolDownBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onClearFun);
			initBg();
		}
		
		private function onQuitFun(e:MouseEvent) : void{
			this.hide();
			if(_comfireFun != null){
				_comfireFun();
			}
		}
		
		private function onClearFun(e:MouseEvent) : void{
			if(ShopManager.getIns().vipLv >= NumberConst.getIns().three){
				this.hide();
				if(_cancelFun != null){
					_cancelFun();
				}
			}
		}
		
		public function setFun(content:String, comfireFun:Function = null, cancelFun:Function = null) : void{
			_content = content;
			_comfireFun = comfireFun;
			_cancelFun = cancelFun;
			
			(layer["ContentTF"] as TextField).text = _content;
			this.show();
			
			getContainer().setChildIndex(this, getContainer().numChildren - 1);
			
			if(ShopManager.getIns().vipLv >= NumberConst.getIns().three){
				GreyEffect.reset(layer["ClearCoolDownBtn"] as SimpleButton);
			}else{
				GreyEffect.change(layer["ClearCoolDownBtn"] as SimpleButton);
			}
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