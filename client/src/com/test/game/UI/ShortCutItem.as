package com.test.game.UI
{
	
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.mvc.Base.BaseSprite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	
	public class ShortCutItem extends BaseSprite
	{
		public function ShortCutItem()
		{
			this.buttonMode = true;
			
			initUI();
			initEvent();
		}
		public static const ITEM_SELECTED:String = "item_selected";
		
		public static const UP:String = "up";
		
		public static const DOWN:String = "down";
		
		private var _up:Sprite;
		
		private var _down:Sprite;
		
		private var _tf:TextField;
		
		private function initUI() : void
		{
			_up = drawSprite(35, 18, 0);
			_up.alpha = 0;
			addChild(_up);
			
			_down = drawSprite(35, 18, 1, 0x4b4c4a);
			_down.alpha = 1;
			addChild(_down);
			_down.visible = false;
			
			_tf = new TextField();
			_tf.width = 58;
			_tf.height = 18;
			_tf.textColor = 0xffffff;
			_tf.autoSize = TextFieldAutoSize.CENTER;
			_tf.mouseEnabled = false;
			addChild(_tf);
		}
		
		private var _type:String;
		public function initRender(name:String) : void
		{
			_tf.text = name;
			_type = name;
			_down.width = 56;
		}
		
		private function initEvent() : void
		{
			this.addEventListener(MouseEvent.ROLL_OVER,rollOver);
			this.addEventListener(MouseEvent.ROLL_OUT,rollOut);
			this.addEventListener(MouseEvent.CLICK,BtnClick);
		}
		
		private function BtnClick(e:MouseEvent):void{
			this.dispatchEvent(new CommonEvent(ITEM_SELECTED, _type));
		}
		
		private function rollOver(e:MouseEvent):void{
			_down.visible = true;
		}
		
		private function rollOut(e:MouseEvent):void{
			_down.visible = false;
		}
		
		override public function get width():Number{
			return _tf.textWidth + 4;
		}
		
		
		private function drawSprite(w:int, h:int, alpha:int = 1, color:uint = 0x000000) : Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(color, alpha);
			sp.graphics.drawRoundRect(0, 0, w, h, 8, 8);
			sp.graphics.endFill();
			return sp;
		}
		
		
		override public function destroy():void{
			removeComponent(_up);
			removeComponent(_down);
			removeComponent(_tf);
			super.destroy();
		}
		
	}
}