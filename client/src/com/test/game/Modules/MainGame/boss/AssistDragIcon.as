package com.test.game.Modules.MainGame.boss
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.BossCardImage;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.events.MouseEvent;
	
	public class AssistDragIcon extends BaseSprite implements IGrid
	{
		public function AssistDragIcon()
		{
			this.buttonMode = true;
			super();
		}

		
		private var originalX:int;
		
		private var originalY:int;
		
		
		private var _data:*;
		
		private var _bossImage:BossCardImage;
		
		private var _menuable:Boolean = true;
		
		public var isDrag:Boolean;
		
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
			
			if(!_bossImage){
				_bossImage = new BossCardImage();
				this.addChild(_bossImage);	
			}
			
			_bossImage.setData(_data);
			
			originalX = this.x;
			originalY = this.y;
			
			
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
			this.startDrag();
			TipsManager.getIns().hideTip(null);
			isDrag = true;
			
		}
		
		protected function onStopDrag(event:MouseEvent):void
		{
			this.stopDrag();
			EventManager.getIns().dispatchEvent(
				new CommonEvent(EventConst.ASSIST_BOSS_STOP_DRAG,[this,_data]));
			isDrag = false;
		}
		
		public function setOriginalPosition():void{
			this.x = originalX;
			this.y = originalY;
		}
		
		override public function destroy() : void{
			if(_bossImage){
				_bossImage.destroy();
				_bossImage = null;
			}
			super.destroy();
		}
		
		
		
	}
}