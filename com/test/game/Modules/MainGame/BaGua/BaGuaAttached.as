package com.test.game.Modules.MainGame.BaGua
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.TipsManager;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BaGuaAttached extends BaseSprite
	{

		public function BaGuaAttached()
		{
			this.buttonMode = true;
			super();
		}
		
		private var originalX:int;
		
		private var originalY:int;
		
		private var _image:BaseNativeEntity;
		
		private var _data:*;
		
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
		public function get index():int{
			return _index;
		}
		
		public function setLocked():void{
			
		}
		
		public function get image():BaseNativeEntity{
			return _image;
		}
		
		private var ht:Sprite; 
		public function setData(data:*):void{
			if (!data) {
				if(_image){
					_image.visible = false;	
				}
				return;
			}
			_data = data;
			
			if(!_image){
				_image  = new BaseNativeEntity();
				this.addChild(_image);
			}
			_image.visible = true;	
			
			index = int(data.id.toString().substr(3,1));
			originalX = this.x;
			originalY = this.y;
			
			var _url:String = "attachBaGua"+_data.id.toString();
			_image.data.bitmapData = AUtils.getNewObj(_url) as BitmapData;
			_image.mouseEnabled = false;
			
			createHitArea();
			TipsManager.getIns().addTips(this, _data);
			
			initDragEvent();
		}
		
		private function createHitArea() : void{
			if(ht == null){
				var bit:BitmapData = _image.data.bitmapData; 
				ht = new Sprite();
				ht.graphics.clear(); 
				ht.graphics.beginFill(0); 
				for(var x:uint=0;x<bit.width;x++){ 
					for(var y:uint=0;y<bit.height;y++){ 
						if(bit.getPixel32(x,y)){
							ht.graphics.drawRect(x,y,1,1);
						}
					} 
				} 
				ht.graphics.endFill(); 
				if(ht.parent == null){
					this.addChildAt(ht, 0);
					ht.visible = false;
				}
				this.hitArea = ht;
			}
		}
		
		private function initDragEvent():void{
			if(!this.hasEventListener(MouseEvent.MOUSE_DOWN)){
				this.addEventListener(MouseEvent.MOUSE_DOWN,onStartDrag);
				this.addEventListener(MouseEvent.MOUSE_UP,onStopDrag);
			}
		}
		
		protected function onStartDrag(event:MouseEvent):void
		{
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
				new CommonEvent(EventConst.ATTACHED_BAGUA_STOP_DRAG,[this,_data]));
		}
		
		public function setOriginalPosition():void{
			this.x = originalX;
			this.y = originalY;
		}
		
		
		override public function destroy() : void
		{		
			removeComponent(_image);
			_image = null;
			_data = null;
			if(this.hasEventListener(MouseEvent.MOUSE_DOWN)){
				this.removeEventListener(MouseEvent.MOUSE_DOWN,onStartDrag);
				this.removeEventListener(MouseEvent.MOUSE_UP,onStopDrag);
			}
			TipsManager.getIns().removeTips(this);
			if(ht != null){
				if(ht.parent != null){
					ht.parent.removeChild(ht);
				}
				ht.graphics.clear();
				ht = null;
			}
			this.hitArea = null;
			super.destroy();	
		}
	}
}