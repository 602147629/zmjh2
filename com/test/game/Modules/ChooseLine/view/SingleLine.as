package com.test.game.Modules.ChooseLine.view{
	import com.superkaka.Tools.CommonEvent;
	import com.test.game.Mvc.Vo.Line;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fl.controls.Button;
	
	public class SingleLine extends Sprite{
		public static const CHOOSE:String = "choose";
		
		private var _line:Line;
		
		private var _idTf:TextField;
		private var _btn:Button;
		
		public function SingleLine(){
			super();
		}
		
		public function initWithLine(line:Line):void{
			_line = line;
			
			_idTf = new TextField();
			_idTf.text = line.id + " 线->" + line.name;
			this.addChild(_idTf);
			
			_btn = new Button();
			_btn.label = "进入";
			_btn.y = 30;
			this.addChild(_btn);
			_btn.addEventListener(MouseEvent.CLICK,__chooseLine);
		}
		
		protected function __chooseLine(evt:MouseEvent):void{
			this.dispatchEvent(new CommonEvent(CHOOSE,this._line));
		}		
		
		public function destroy():void{
			if(this._btn){
				this._btn.removeEventListener(MouseEvent.CLICK,__chooseLine);
			}
			this._btn = null;
			this._line = null;
			this._idTf = null;
		}
		
	}
}