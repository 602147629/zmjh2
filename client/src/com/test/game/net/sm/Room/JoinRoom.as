package com.test.game.net.sm.Room{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class JoinRoom extends SMessage{
		private var _key:String;
		private var _roomId:int;
		private var _gameKey:String;
		
		public function JoinRoom(key:String,roomId:int,gameKey:String){
			_key = key;
			_roomId = roomId;
			_gameKey = gameKey;
			super("RMRoom.JoinRoom");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"key" : _key,
				"gameKey" : _gameKey,
				"roomId" : _roomId
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
		}
	}
}