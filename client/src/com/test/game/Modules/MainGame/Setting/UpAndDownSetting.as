package com.test.game.Modules.MainGame.Setting
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class UpAndDownSetting{
		private var _upBtn:SimpleButton;
		private var _downBtn:SimpleButton;
		private var _upCallback:Function;
		private var _downCallback:Function;
		public function UpAndDownSetting(upBtn:SimpleButton, downBtn:SimpleButton, upCallback:Function, downCallback:Function){
			_upBtn = upBtn;
			_downBtn = downBtn;
			_upCallback = upCallback;
			_downCallback = downCallback;
			_upBtn.addEventListener(MouseEvent.CLICK, onUp);
			_downBtn.addEventListener(MouseEvent.CLICK, onDown);
		}
		
		protected function onDown(event:MouseEvent):void{
			if(_downCallback != null){
				_downCallback();
			}
		}
		
		protected function onUp(event:MouseEvent):void{
			if(_upCallback != null){
				_upCallback();
			}
		}
	}
}