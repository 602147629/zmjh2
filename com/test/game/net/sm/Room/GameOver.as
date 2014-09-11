package com.test.game.net.sm.Room{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class GameOver extends SMessage{
		private var _result:int;
		private var _totalFrames:int;
		public function GameOver(result:int, totalFrames:int){
			_result = result;
			_totalFrames = totalFrames;
			super("RMRoom.GameOver");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"result" : _result,
				"totalFrames" : _totalFrames
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
		}
	}
}