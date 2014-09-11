package com.test.game.net.sm.Room{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class ApplyJoinRoom extends SMessage{
		private var _serverId:int;
		private var _roomId:int;
		
		public function ApplyJoinRoom(roomId:int,serverId:int){
			_serverId = serverId;
			_roomId = roomId;
			super("RMRoom.ApplyJoinRoom");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"serverId" : _serverId,
				"roomId" : _roomId
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
		}
	}
}