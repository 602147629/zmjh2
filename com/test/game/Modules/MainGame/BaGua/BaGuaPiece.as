package com.test.game.Modules.MainGame.BaGua
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.UI.ShortCutMenu;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class BaGuaPiece extends BaseSprite implements IGrid
	{
		
		public static const PROTECT_MENU:Array = ["聚灵保护"];
		public static const UNPROTECT_MENU:Array = ["解除保护"];
		
		public function BaGuaPiece()
		{
			this.buttonMode = true;
			
			
			super();
		}
		
		private var _shortCutMenu:ShortCutMenu;
		
		private var originalX:int;
		
		private var originalY:int;
		
		private var _image:BaseNativeEntity;
		
		private var _protectImage:BaseNativeEntity;
		
		private var _numBg:BaseNativeEntity;
		
		private var _numTxt:TextField;
		
		private var _data:BaGuaPieceVo;
		public function get data():BaGuaPieceVo{
			return _data;
		}

		public var isDrag:Boolean;
		
		private var _dragable:Boolean = true;
		public function set dragable(value:Boolean):void{
			_dragable = value;
		}
		
		private var _menuable:Boolean = true;
		public function set menuable(value:Boolean):void{
			_menuable = value;
		}
		
		private var _selectable:Boolean = true;
		public function set selectable(value:Boolean):void{
			_selectable = value;
		}
		
		private var _index:int;
		public function set index(value:int):void{
			_index = value;
		}
		
		private var _locked:Boolean;

		public function get locked():Boolean
		{
			return _locked;
		}

		public function setLocked():void{
			_locked = true;
			setData(_locked);
		}
		
		
		public function setData(data:*):void{
			
			
			if (!data) {
				this.visible = false;
				return;
			}
			
			this.visible = true;
			
			if(!_image){
				_image  = new BaseNativeEntity();
				this.addChild(_image);
			}
			
			if(!_protectImage){
				_protectImage  = new BaseNativeEntity();
				_protectImage.data.bitmapData = AUtils.getNewObj("baguaLocked") as BitmapData;
				this.addChild(_protectImage);
				_protectImage.visible = false;
			}
			
			//数字背景
			if(!_numBg){
				_numBg  = new BaseNativeEntity();
				_numBg.x=25;
				_numBg.y=25;
				_numBg.visible = false;
				this.addChild(_numBg);
			}
			
			//数字
			if(!_numTxt){
				_numTxt = new TextField();
				_numTxt.x = 22;
				_numTxt.y = 25;
				_numTxt.width =25;
				_numTxt.autoSize = TextFieldAutoSize.CENTER;
				_numTxt.textColor = 0Xffffff;
				_numTxt.filters = new Array( new GlowFilter(0X000000,1,2,2,255));
				_numTxt.mouseEnabled = false;
				_numTxt.visible = false;
				this.addChild(_numTxt);
			}
			
			
			originalX = this.x;
			originalY = this.y;
			
			if(_locked){
				_data = null;
				//锁定图标
				_image.data.bitmapData = AUtils.getNewObj("locked") as BitmapData;
				_image.x=3;
				_image.y=6;
				TipsManager.getIns().addTips(this,{title:"使用万能钥匙解锁",tips:""});
				initUnlockEvent();
			}else{
				_data = data;
				var _url:String = _data.type+_data.id.toString();
				_image.data.bitmapData = AUtils.getNewObj(_url) as BitmapData;
				
				TipsManager.getIns().addTips(this,_data);
				initDragEvent();
				
				updateProtect();
				this.addEventListener(MouseEvent.CLICK,showShortCut);
				this.addEventListener(MouseEvent.ROLL_OUT,hideShortCut);
			}
		}
		
		public function setNum(num:int):void
		{
			_numTxt.visible = true;
			_numBg.visible = true;
			_numBg.data.bitmapData = AUtils.getNewObj("numBg") as BitmapData;
			_numTxt.text = num.toString();
		}
		
		
		private function updateProtect():void{
			if(_data.protect == 0){
				_protectImage.visible = false;
			}else{
				_protectImage.visible = true;
			}
		}
		
		private function showShortCut(e:MouseEvent):void{
			var menu:Array = [];
			var type:String

			if(_data.protect == 0){
				menu=PROTECT_MENU;
			}else{
				menu=UNPROTECT_MENU;
			}
			
			type = ItemTypeConst.BAGUA;
			if( _menuable){
				if (!_shortCutMenu){
					_shortCutMenu = new ShortCutMenu();
					this.parent.addChild(_shortCutMenu);
				}
				this.parent.setChildIndex(_shortCutMenu, this.parent.numChildren - 1);
				_shortCutMenu.setData(menu, type, _data);
				_shortCutMenu.show();
				_shortCutMenu.x = this.x+e.localX+5;
				_shortCutMenu.y = this.y+e.localY+5;
			}
		
			TipsManager.getIns().hideTip(e);
		}
		
		
		private function hideShortCut(e:MouseEvent):void{
			if(_shortCutMenu && !_shortCutMenu.mouseOver){
				_shortCutMenu.hide();
			}
		}
		
		private function initUnlockEvent():void
		{
			if(!this.hasEventListener(MouseEvent.CLICK)){
				this.addEventListener(MouseEvent.CLICK,onUnlock);
			}
		}
		
		private function onUnlock(event:MouseEvent):void
		{
			if(PackManager.getIns().searchItemNum(NumberConst.getIns().wanNengKeyId)>0){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice(
					"使用一个万能钥匙解锁八卦牌背包？",sureUnlock);
			}else{
				(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
					"万能钥匙不足！");
			}
			
		}
		
		private function sureUnlock():void
		{
			EventManager.getIns().dispatchEvent(
				new CommonEvent(EventConst.BAGUA_UNLOCK,[_data]));
		}
		
		private function initDragEvent():void{
			if(!this.hasEventListener(MouseEvent.MOUSE_DOWN)){
				this.addEventListener(MouseEvent.MOUSE_DOWN,onStartDrag);
				this.addEventListener(MouseEvent.MOUSE_UP,onStopDrag);
			}
		}
		
		protected function onStartDrag(event:MouseEvent):void
		{
			if(_dragable){
				this.parent.parent.setChildIndex(this.parent, this.parent.parent.numChildren - 1);
				this.parent.setChildIndex(this, this.parent.numChildren - 1);
				TipsManager.getIns().hideTip(null);
				if(_shortCutMenu){
					_shortCutMenu.hide();
				}
				isDrag = true;
				this.startDrag();
			}

		}
		
		protected function onStopDrag(event:MouseEvent):void
		{
			if(_dragable){
				this.stopDrag();
				isDrag = false;
				EventManager.getIns().dispatchEvent(
					new CommonEvent(EventConst.BAGUA_STOP_DRAG,[this,_data]));
			}

		}
		
		public function setOriginalPosition():void{
			this.x = originalX;
			this.y = originalY;
		}
		
		
		override public function destroy() : void
		{		
			removeComponent(_image);
			removeComponent(_numBg);
			removeComponent(_numTxt);
			removeComponent(_protectImage);
			
			TipsManager.getIns().removeTips(this);
			_data = null;
			if(this.hasEventListener(MouseEvent.CLICK)){
				this.removeEventListener(MouseEvent.CLICK, onUnlock);
			}
			if(this.hasEventListener(MouseEvent.MOUSE_DOWN)){
				this.removeEventListener(MouseEvent.MOUSE_DOWN,onStartDrag);
				this.removeEventListener(MouseEvent.MOUSE_UP,onStopDrag);
			}
			
			super.destroy();	
		}
	}
}