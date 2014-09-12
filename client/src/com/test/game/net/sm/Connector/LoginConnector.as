package com.test.game.net.sm.Connector{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class LoginConnector extends SMessage{
		private var _uid:int;
		private var _loginKey:String;
		private var _gateServerId:int;
		private var _moduleId:int;
		
		public function LoginConnector(uid:int,loginKey:String,gateServerId:int,moduleId:int){
			this._uid = uid;
			this._loginKey = loginKey;
			this._gateServerId = gateServerId;
			this._moduleId = moduleId;
			
			super("RMConnector.Login");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"route" : {
					"module" : "Game",
					"moduleId" : this._moduleId,
					"path" : "RMLogin.GetUsersByUid"
				},
				"data" : {
					"uid" : this._uid,
					"key" : this._loginKey,
					"gateServerId" : this._gateServerId,
					"serverId" : 1
				}
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
		}
	}
}