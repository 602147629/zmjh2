package com.test.game.Modules.MainGame.Info
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.Characteren;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.ItemVo;
	
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class GetBookView extends BaseView
	{
		public var bookItem:ItemVo;
		public function GetBookView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.GETBOOKVIEW)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.GETBOOKVIEW.split("/")[1]) as Sprite;
				this.addChild(layer);
				
				initParams();
				initUI();
				setParams();
				setCenter();
			}
		}
		
		private function initUI():void{
			(layer["CloseBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onClose);
			var bookIcon:Characteren = new Characteren();
			(layer["BookLayer"] as Sprite).addChild(bookIcon);
			(layer["ConfirmBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onClose);
		}
		
		private function initParams():void{
			
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			((layer["BookLayer"] as Sprite).getChildAt(0) as Characteren).data.bitmapData = AUtils.getNewObj("book" + bookItem.id) as BitmapData;
			(layer["BookName"] as TextField).text = bookItem.name;
		}
		
		private function onClose(e:MouseEvent) : void{
			this.hide();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
	}
}