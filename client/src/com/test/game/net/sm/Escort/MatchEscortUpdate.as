package com.test.game.net.sm.Escort
{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class MatchEscortUpdate extends SMessage
	{
		private var _playerHp:int;
		private var _carHp:int;
		private var _carTime:int;
		private var _carX:int;
		private var _carY:int;
		
		public function MatchEscortUpdate(playerHp:int, carTime:int,carHp:int,  carX:int, carY:int){
			_playerHp = playerHp;
			_carTime = carTime;
			_carHp = carHp;
			_carX = carX;
			_carY = carY;
			super("RMConnector.Route");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"route" : {
					"module" : "Game",
					"path" : "RMRoom.AutoPipeiEscortUpdate"
				},
				"data" : {
					"playerHp" : _playerHp,
					"carTime" : _carTime,
					"carHp" : _carHp,
					"carX" : _carX,
					"carY" : _carY
				}
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}