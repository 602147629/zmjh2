package com.test.game.net.sm.Player{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.SMessage;
	import com.test.game.Mvc.Vo.Item;
	
	public class RemoveItem extends SMessage{
		private var _item:Item;
		
		public function RemoveItem(item:Item){
			this._item = item;
			super("RMPlayer.RemoveItem");
		}
		
		override protected function writeBody():void{
			var jObj:Object = {
				"itemId" : this._item.id,
				"num" : this._item.num
			};
			body.writeUTFBytes(com.adobe.serialization.json.JSON.encode(jObj));
			
			this._item = null;
		}
	}
}

