package com.test.game.Mvc.control.net.rm
{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Control.net.rm.GameReceiveControl;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	
	import flash.utils.ByteArray;
	
	public class MyPublicNoticeReceiveControl extends GameReceiveControl
	{
		public function MyPublicNoticeReceiveControl()
		{
			super();
		}
		
		/**
		 * 公告服务器返回
		 * 
		 */		
		public function PublicNoticeReturn(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------PublicNoticeReturn----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("公告返回 str:"+str);
			//DebugArea.getIns().showInfo("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			
			if(ViewFactory.getIns().getView(RoleStateView)){
				EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.PUBLIC_NOTICE,jObj));
			}
			
		}
		
	}
}