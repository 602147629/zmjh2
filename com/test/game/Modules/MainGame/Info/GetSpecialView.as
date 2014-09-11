package com.test.game.Modules.MainGame.Info
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
	import flash.text.TextField;
	
	public class GetSpecialView extends BaseView
	{
		private var _itemIcon:ItemIcon;
		public function GetSpecialView()
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
			_itemIcon = new ItemIcon();
			_itemIcon.selectable = false;
			_itemIcon.menuable = false;
			(layer["BookLayer"] as Sprite).addChild(_itemIcon);
			(layer["ConfirmBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onClose);
		}
		
		private function initParams():void{
			
		}
		
		private var _itemVo:ItemVo;
		private var _name:String;
		private var _callback:Function;
		public function setSpecial(itemVo:ItemVo, name:String = "", callback:Function = null) : void{
			_itemVo = itemVo;
			_name = name;
			_callback = callback;
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			_itemIcon.setData(_itemVo);
			(layer["BookName"] as TextField).text = _name;
			
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
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