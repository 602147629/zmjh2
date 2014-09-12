package com.test.game.net.sm.Login{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	import com.test.game.Mvc.Vo.Player;
	
	public class NewPlayer extends SMessage{
		private var _player:Player;
		
		public function NewPlayer(player:Player){
			_player = player;
			super("RMConnector.Route");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"route" : {
					"module" : "Game",
					"path" : "RMLogin.NewPlayer"
				},
				"data" : {
					"name" : _player.name
				}
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
			
			_player = null;
		}
	}
}