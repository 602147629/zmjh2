package com.test.game.net.sm.Line{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	import com.test.game.Mvc.Vo.Line;
	
	public class ChooseLine extends SMessage{
		private var _line:Line;
		
		public function ChooseLine(line:Line){
			this._line = line;
			super("RMConnector.Route",1,1,1);
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"route" : {
					"module" : "Game",
					"path" : "RMLine.ChooseLine"
				},
				"data" : {
					"id" : _line.id
				}
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
			
			_line = null;
		}
	}
}