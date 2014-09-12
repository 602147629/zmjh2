package com.test.game.net.sm.Game{
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class OperationSend extends SMessage{
		private var _keyCode:int;
		private var _oper:int;
		
		public function OperationSend(keyCode:int,oper:int){
			_keyCode = keyCode;
			_oper = oper;
			
			super("RMGame.OperationGet",0,0);
		}
		
		override protected function writeBody():void{
			body.writeShort(this._keyCode);
			body.writeShort(this._oper);
		}
	}
}