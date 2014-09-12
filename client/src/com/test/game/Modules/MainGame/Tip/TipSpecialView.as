package com.test.game.Modules.MainGame.Tip
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class TipSpecialView extends BaseView
	{
		protected var _comfireFun:Function;
		protected var _cancelFun:Function;
		protected var _content:String;
		public function TipSpecialView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.TIPVIEW)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("SpecialTipView") as Sprite;
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
			(layer["ComfireBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onComfireFun);
			(layer["CancelBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onCancelFun);
			initBg();
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
		
		public function setFun(content:String, comfireFun:Function = null, cancelFun:Function = null) : void{
			_content = content;
			_comfireFun = comfireFun;
			_cancelFun = cancelFun;
			
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