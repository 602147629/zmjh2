package com.test.game.net.sm.Escort
{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class CancelMatchEscort extends SMessage
	{
		public function CancelMatchEscort(){
			super("RMConnector.Route");
		}

		
		override protected function writeBody():void{
			var jObj:Object = {
				"route" : {
					"module" : "Game",
					"path" : "RMRoom.CancelAutoPipeiEscort"
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