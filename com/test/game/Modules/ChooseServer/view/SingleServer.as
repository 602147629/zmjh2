package com.test.game.Modules.ChooseServer.view{
	import com.superkaka.Tools.CommonEvent;
	import com.test.game.Mvc.Vo.Line;
	import com.test.game.Mvc.Vo.Server;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fl.controls.Button;
	
	public class SingleServer extends Sprite{
		public static const CHOOSE:String = "choose";
		
		private var _server:Server;
		
		private var _idTf:TextField;
		private var _btn:Button;
		
		public function SingleServer(){
			super();
		}
		
		public function initWithServer(server:Server):void{
			_server = server;
			
			_idTf = new TextField();
			_idTf.text = server.toString();
			this.addChild(_idTf);
			
			_btn = new Button();
			_btn.label = "进入";
			_btn.y = 30;
			this.addChild(_btn);
			_btn.addEventListener(MouseEvent.CLICK,__chooseLine);
		}
		
		protected function __chooseLine(evt:MouseEvent):void{
			this.dispatchEvent(new CommonEvent(CHOOSE,this._server));
		}		
		
		public function destroy():void{
			if(this._btn){
				this._btn.removeEventListener(MouseEvent.CLICK,__chooseLine);
			}
			this._btn = null;
			this._server = null;
			this._idTf = null;
		}
		
	}
}