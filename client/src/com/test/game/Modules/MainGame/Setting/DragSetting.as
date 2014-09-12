package com.test.game.Modules.MainGame.Setting
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class DragSetting
	{
		private var _isStartDrag:Boolean
		private var _layer:Sprite;
		private var _drag:Sprite;
		private var _callback:Function;
		public function DragSetting(layer:Sprite, drag:Sprite, callback:Function)
		{
			_layer = layer;
			_drag = drag;
			_callback = callback;
			_layer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_layer.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_layer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
			_layer.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			_isStartDrag = false;
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			if(_isStartDrag){
				if(_callback != null){
					_callback();
				}
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void{
			_isStartDrag = true;
			if(_callback != null){
				_callback();
			}
		}
		
		protected function onMouseUp(event:MouseEvent):void{
			_isStartDrag = false;
		}
	}
}