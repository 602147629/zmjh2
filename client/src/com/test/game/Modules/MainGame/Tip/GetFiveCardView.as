package com.test.game.Modules.MainGame.Tip
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class GetFiveCardView extends BaseView
	{
		public function GetFiveCardView()
		{
			super();
		}
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.GETFIVECARDVIEW)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.GETFIVECARDVIEW.split("/")[1]) as Sprite;
				this.addChild(layer);
				
				initParams();
				initUI();
				setParams();
				setCenter();
			}
		}
		
		private function initUI():void{
			(layer["CloseBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onClose);
			(layer["ConfirmBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onClose);
		}
		
		private function initParams():void{
			
		}
		
		private var _itemVo:Vector.<ItemVo>;
		private var _callback:Function;
		public function setSpecial(itemVo:Vector.<ItemVo>, callback:Function = null) : void{
			_itemVo = itemVo;
			_callback = callback;
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			setIcon();
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
		}
		
		private function setIcon():void{
			for(var i:int = 0; i < _itemVo.length; i++){
				var icon:ItemIcon = new ItemIcon();
				icon.setData(_itemVo[i]);
				icon.x = 52 + i * 60;
				icon.y = 113;
				layer.addChild(icon);
			}
		}
		
		private function onClose(e:MouseEvent) : void{
			this.hide();
			if(_callback != null){
				_callback();
			}
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
	}
}