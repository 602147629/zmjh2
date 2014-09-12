package com.test.game.Modules.MainGame.boss
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.BossCardImage;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class AttachedDragIcon extends BaseSprite implements IGrid
	{
		public function AttachedDragIcon()
		{
			this.buttonMode = true;
			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("attachedBossIcon") as Sprite;
				_obj.x = -19;
				_obj.y = -17;
				this.addChild(_obj);
			}

			
			super();
		}
		
		private var _obj:Sprite;
		
		private var originalX:int;
		
		private var originalY:int;
		
		private var _menuable:Boolean = true;
		
		public function set menuable(value:Boolean):void{
			_menuable = value;
		}
		
		private var _selectable:Boolean = true;
		
		public function set selectable(value:Boolean):void{
			_selectable = value;
		}
		
		private var _enable:Boolean = true;//是否启用
		public function get enable():Boolean
		{
			return _enable;
		}

		public function set enable(value:Boolean):void
		{
			_enable = value;
			lock.visible = !value;
		}
		
		private var _index:int;
		
		public function set index(value:int):void{
			_index = value;
		}
		
		public function get index():int{
			return _index;
		}

		public function get bossImage():BossCardImage{
			return _bossImage;
		}
		
		private var _data:ItemVo;
		
		public function get data():ItemVo{
			return _data;
		}
		
		private var _bossImage:BossCardImage;

		public function setLocked():void{
		}
		
		public function setData(data:*):void{

			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("attachedBossIcon") as Sprite;
				_obj.x = -19;
				_obj.y = -17;
				this.addChild(_obj);
			}
			
			if (!data) {
				if(_bossImage){
					_bossImage.visible = false;	
				}
				return;
			}
			
			if(!_bossImage){
				_bossImage = new BossCardImage();
				this.addChild(_bossImage);	
			}
			
			_data = data;
			_bossImage.visible = true;

			originalX = _bossImage.x;
			originalY = _bossImage.y;
			
			_bossImage.setData(_data);
			
			TipsManager.getIns().addTips(_bossImage,_data);
			
			initDragEvent();
		}
		
		private function initDragEvent():void{
			_bossImage.addEventListener(MouseEvent.MOUSE_DOWN,onStartDrag);
			_bossImage.addEventListener(MouseEvent.MOUSE_UP,onStopDrag);
		}
		
		protected function onStartDrag(event:MouseEvent):void
		{
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
			TipsManager.getIns().hideTip(null);
			_bossImage.startDrag();
			
		}
		
		protected function onStopDrag(event:MouseEvent):void
		{
			_bossImage.stopDrag();
			EventManager.getIns().dispatchEvent(
				new CommonEvent(EventConst.ATTACHED_BOSS_STOP_DRAG,[this,_data]));
		}
		
		
		public function setOriginalPosition():void{
			if(_bossImage == null) return;
			_bossImage.x = originalX;
			_bossImage.y = originalY;
		}

		
		private function get lock():Sprite{
			return _obj["lock"];
		}

		override public function destroy() : void
		{	
			if(_bossImage != null){
				if(_bossImage.hasEventListener(MouseEvent.MOUSE_DOWN)){
					_bossImage.removeEventListener(MouseEvent.MOUSE_DOWN,onStartDrag);
				}
				
				if(_bossImage.hasEventListener(MouseEvent.MOUSE_UP)){
					_bossImage.removeEventListener(MouseEvent.MOUSE_UP,onStopDrag);
				}
			}
			if(_bossImage){
				_bossImage.destroy();
				_bossImage = null;
			}
			
			removeComponent(_obj);
			_data = null;
			
			super.destroy();
			
			
		}


	}
}