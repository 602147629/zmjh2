package com.test.game.net.sm.Login{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	import com.test.game.Mvc.Vo.Player;
	
	public class ChoosePlayer extends SMessage{
		private var _player:Player;
		
		public function ChoosePlayer(player:Player){
			_player = player;
			super("RMConnector.Route");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"route" : {
					"module" : "Game",
					"path" : "RMLogin.ChoosePlayer"
				},
				"data" : {
					"index" : _player.index
				}
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
			
			_player = null;
		}
	}
}