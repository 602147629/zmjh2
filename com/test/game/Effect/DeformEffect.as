package com.test.game.Effect
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;

	public class DeformEffect extends BaseEffect
	{
		private var _disp:DisplayObject;
		private var _name:String;
		public function get name() : String
		{
			return _name;
		}
		private var t:TweenLite;
		private var _startWid:Number;
		private var _startHei:Number;
		private var _startY:Number;
		public function DeformEffect(disp:DisplayObject, name:String)
		{
			_disp = disp;
			_name = name;
			_startWid = _disp.width;
			_startHei = _disp.height;
			_startY = _disp.y;
			super();
		}
		
		public function play():void{
			onChange();
		}
		
		private function onChange() : void{
			TweenLite.to(_disp, .15, {scaleY:1.1, scaleX:.85, y:_startY - 7, onComplete:onContinue_1});
		}
		
		private function onContinue_1() : void{
			TweenLite.to(_disp, .15, {scaleY:.9, scaleX:1.05, y:_startY, onComplete:onContinue_2});
		}
		
		private function onContinue_2() : void{
			TweenLite.to(_disp, .075, {scaleY:1.05, scaleX:.95, onComplete:onContinue_3});
		}
		
		private function onContinue_3() : void{
			TweenLite.to(_disp, .075, {scaleY:.95, scaleX:1.05, onComplete:onContinue_4});
		}
		
		private function onContinue_4() : void{
			TweenLite.to(_disp, .075, {scaleY:1, scaleX:.95, onComplete:onContinue_5});
		}
		
		private function onContinue_5() : void{
			_disp.scaleX = 1;
			_disp.scaleY = 1;
			TweenLite.delayedCall(1, onChange);
		}
		
		
		public function stop() : void{
			TweenLite.killDelayedCallsTo(onChange);
			TweenLite.killTweensOf(_disp, false);
			_disp.scaleX = 1;
			_disp.scaleY = 1;
			_disp.width = _startWid;
			_disp.height = _startHei;
			_disp.y = _startY;
		}
		
		override public function destroy():void{
			stop();
			t=null;
			super.destroy();
		}
	}
}