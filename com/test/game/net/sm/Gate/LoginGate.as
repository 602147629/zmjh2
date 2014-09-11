package com.test.game.net.sm.Gate
{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class LoginGate extends SMessage{
		private var _uid:int;
		
		public function LoginGate(uid:int){
			_uid = uid;
			super("RMGate.Login");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"uid" : _uid,
				"serverId" : 1,
				"version" : "V1.14"
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
		}
	}
}