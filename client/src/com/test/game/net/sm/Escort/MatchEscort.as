package com.test.game.net.sm.Escort
{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class MatchEscort extends SMessage
	{
		private var _playerData:Object;
		private var _occupation:int;
		private var _playerlv:int;
		private var _isEscort:int;
		private var _equipmentCount:int;
		
		public function MatchEscort(playerData:Object, occupation:int, lv:int, isEscort:int, equipmentCount:int){
			_playerData = playerData;
			_occupation = occupation;
			_playerlv = lv;
			_isEscort = isEscort;
			_equipmentCount = equipmentCount;
			super("RMConnector.Route");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"route" : {
					"module" : "Game",
					"path" : "RMRoom.AutoPipeiEscort"
				},
				"data" : {
					"playerData" : _playerData,
					"pipeiData" : {
						"occupation" : _occupation,
						"playerLv" : _playerlv,
						"isEscort" : _isEscort,
						"equipmentCount" : _equipmentCount
					}
				}
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
		}
		
		override public function destroy():void{
			super.destroy();
			
			_playerData = null;
		}
	}
}