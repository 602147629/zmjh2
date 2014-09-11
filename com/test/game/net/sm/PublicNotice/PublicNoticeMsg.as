package com.test.game.net.sm.PublicNotice
{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	import com.test.game.Manager.PlayerManager;
	
	public class PublicNoticeMsg extends SMessage
	{
		private var _type:int;
		private var _info:String;
		
		public function PublicNoticeMsg(type:int,info:String){
			_type = type;
			_info = info;
			super("RMConnector.Route");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"route" : {
					"module" : "PublicNoticeManager",
					"path" : "RMPublicNotice.GetPublicNotice"
				},
				"data" : {
					"type" : _type,
					"name" : PlayerManager.getIns().player.name,
					"info" : _info
				}
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}