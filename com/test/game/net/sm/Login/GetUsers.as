package com.test.game.net.sm.Login{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class GetUsers extends SMessage{
		private var _uid:int;
		private var _loginKey:String;
		private var _gateServerId:int;
		
		
		public function GetUsers(uid:int,loginKey:String,gateServerId:int){
			this._uid = uid;
			this._loginKey = loginKey;
			this._gateServerId = gateServerId;
			
			super("RMLogin.GetUsersByUid");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"uid" : this._uid,
				"key" : this._loginKey,
				"gateServerId" : this._gateServerId,
				"serverId" : 1
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
		}
	}
}