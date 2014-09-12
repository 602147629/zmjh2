package com.test.game.Mvc.control.net.rm{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.mvc.Control.net.rm.GameReceiveControl;
	import com.test.game.Const.PiPeiConst;
	import com.test.game.Manager.EventManager;
	
	import flash.utils.ByteArray;
	
	public class MyCommonReceiveControl extends GameReceiveControl{
		public function MyCommonReceiveControl(){
			super();
		}
		
		
		/**
		 * 收到提示信息
		 * 
		 */		
		public function GetMsg(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------GetMsg----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			DebugArea.getIns().showInfo("str:"+str);
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var id:int = jObj.id;
			//EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent("aaa",));
			
			EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.GET_MESSAGE, id));
			//EventManager.getIns().EventDispather.addEventListener("aaa");
		}
		
		/**
		 * 收到公告信息
		 * 
		 */		
		public function GetNotice(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------GetNotice----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			DebugArea.getIns().showInfo("str:"+str);
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var notice:String = jObj.notice;
			
			EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.GET_NOTICE, notice));
		}
		
		
	}
}