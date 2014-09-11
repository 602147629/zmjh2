package com.test.game.Mvc.Proxy
{
	import com.superkaka.game.Const.ProtocolDict;
	import com.superkaka.mvc.Proxy.SocketProxy;
	
	public class FbSocketProxy extends SocketProxy
	{
		public function FbSocketProxy()
		{
			super();
			this.name = "FB";
			ProtocolDict.getIns().registerDict(this.name,[3,3,5,6,7,2,2],[2,2,3,7,2,5,8]);
		}
		
		override public function destroy():void{
			super.destroy();
			
			ProtocolDict.getIns().reset(this.name);
		}
	}
}