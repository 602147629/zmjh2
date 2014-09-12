package com.test.game.net.sm.Room{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class CancelPipei extends SMessage{
		private var _playerData:Object;
		
		public function CancelPipei(playerData:Object){
			_playerData = playerData;
			super("RMConnector.Route");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"route" : {
					"module" : "Game",
					"path" : "RMRoom.CancelAutoPipei"
				},
				"data" : {
					
				}
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
		}
		
		override public function destroy():void{
			super.destroy();
			
		}
	}
}