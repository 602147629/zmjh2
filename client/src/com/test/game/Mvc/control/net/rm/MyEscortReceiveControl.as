package com.test.game.Mvc.control.net.rm
{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.mvc.Control.net.rm.GameReceiveControl;
	import com.test.game.Const.EscortEventConst;
	import com.test.game.Manager.EventManager;
	
	import flash.utils.ByteArray;
	
	public class MyEscortReceiveControl extends GameReceiveControl
	{
		public function MyEscortReceiveControl()
		{
			super();
		}
		
		/**
		 * 匹配护镖返回
		 * 
		 */		
		public function MatchEscortReturn(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------MatchEscortReturn----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("护镖匹配返回 str:"+str);
			//DebugArea.getIns().showInfo("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var result:int = jObj.result;
			//if(result == 1){
				//成功
				EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(EscortEventConst.START_ESCORT, jObj));
			//}
		}
		
		
		/**
		 * 取消匹配护镖返回
		 * 
		 */		
		public function CancelMatchEscortReturn(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------CancelMatchEscortReturn----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str);
			//DebugArea.getIns().showInfo("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var result:int = jObj.result;
			//if(result == 1){
			//成功
			EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(EscortEventConst.CANCEL_MATCH_ESCORT));
			//}
		}
	}
}