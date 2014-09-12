package com.test.game.Modules.MainGame.boss
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	public class AttachDragIcon extends BaseSprite implements IGrid
	{
		public function AttachDragIcon()
		{
			this.buttonMode = true;
			super();
		}
		
		private var originalX:int;
		
		private var originalY:int;
		
		private var _image:BaseNativeEntity;
		
		private var _data:*;
		
		private var _colorBg:BaseNativeEntity;
		private var _stars:BaseNativeEntity;
		
		public var isDrag:Boolean;
		
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
		
		
		public function setLocked():void{
		}
		
		
		public function setData(data:*):void{
			
			
			if (!data) {
				return;
			}
			_data = data;
			
			if(!_image){
				_image  = new BaseNativeEntity();
				this.addChild(_image);
			}
			
			//颜色底
			if(!_colorBg){
				_colorBg  = new BaseNativeEntity();
				_colorBg.x=0;
				_colorBg.y=0;
				this.addChild(_colorBg);
			}
			
			//星星
			if(!_stars){
				_stars  = new BaseNativeEntity();
				_stars.x=5;
				_stars.y=32;
				this.addChild(_stars);
			}
			
			originalX = this.x;
			originalY = this.y;
			
			var _url:String = _data.type+_data.id.toString();
			_image.data.bitmapData = AUtils.getNewObj(_url) as BitmapData;
			
			_colorBg.data.bitmapData = AUtils.getNewObj(_data.bossUp.color) as BitmapData;
			var starId:String = "starIcon"+ _data.bossUp.star;
			_stars.data.bitmapData = AUtils.getNewObj(starId) as BitmapData;
			
			
			TipsManager.getIns().addTips(this,_data);
			
			
			initDragEvent();
			
			
		}
		
		private function initDragEvent():void{
			this.addEventListener(MouseEvent.MOUSE_DOWN,onStartDrag);
			this.addEventListener(MouseEvent.MOUSE_UP,onStopDrag);
		}
		
		protected function onStartDrag(event:MouseEvent):void
		{
			this.parent.parent.setChildIndex(this.parent, this.parent.parent.numChildren - 1);
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
			TipsManager.getIns().hideTip(null);
			isDrag = true;
			this.startDrag();
			
		}
		
		protected function onStopDrag(event:MouseEvent):void
		{
			this.stopDrag();
			isDrag = false;
			EventManager.getIns().dispatchEvent(
				new CommonEvent(EventConst.ATTACH_BOSS_STOP_DRAG,[this,_data]));
		}
		
		public function setOriginalPosition():void{
			this.x = originalX;
			this.y = originalY;
		}
		
		
		override public function destroy() : void
		{		
			removeComponent(_image);
			removeComponent(_colorBg);
			removeComponent(_stars);
			_data = null;
			
			super.destroy();	
		}

	}
}