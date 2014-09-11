package com.test.game.Mvc.Proxy
{
	import com.superkaka.game.Const.ProtocolDict;
	import com.superkaka.mvc.Proxy.SocketProxy;
	
	public class GateSocketProxy extends SocketProxy
	{
		public function GateSocketProxy()
		{
			super();
			this.name = "GATE";
			ProtocolDict.getIns().registerDict(this.name,[3,3,5,6,7,2,2],[2,2,3,7,1,6,5]);
		}
		
		
		override public function destroy():void{
			super.destroy();
			
			ProtocolDict.getIns().reset(this.name);
		}
		
	}
}