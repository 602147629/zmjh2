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
	
	public class GetSkillBookView extends BaseView
	{
		public function GetSkillBookView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.GETSKILLBOOKVIEW)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.GETSKILLBOOKVIEW.split("/")[1]) as Sprite;
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
	
		private var _name:String;
		private var _callback:Function;
		public function setInfo(name:String = "", callback:Function = null) : void{
			_name = name;
			_callback = callback;
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
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