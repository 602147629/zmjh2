package com.test.game.net.sm.Room{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class AutoPipei extends SMessage{
		private var _playerData:Object;
		private var _occupation:int;
		private var _playerlv:int;
		private var _fightLv:int;
		private var _fightResult:int;
		private var _equipmentCount:int;
		public function AutoPipei(playerData:Object, occupation:int, lv:int, fightLv:int, fightResult:int, equipmentCount:int){
			_playerData = playerData;
			_occupation = occupation;
			_playerlv = lv;
			_fightLv = fightLv;
			_fightResult = fightResult;
			_equipmentCount = equipmentCount;
			super("RMConnector.Route");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"route" : {
					"module" : "Game",
					"path" : "RMRoom.AutoPipei"
				},
				"data" : {
					"playerData" : _playerData,
					"pipeiData" : {
						"occupation" : _occupation,
						"playerLv" : _playerlv,
						"playerFightLv" : _fightLv,
						"fightResult" : _fightResult,
						"equipmentCount" : _equipmentCount
					}
				}
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
		}
		
		override public function bodyJson():String{
//			body.compress(CompressionAlgorithm.ZLIB);
			return body.readUTFBytes(body.length);
		}
		
		override public function destroy():void{
			super.destroy();
			
			_playerData = null;
		}
	}
}