package com.test.game.Mvc.Proxy
{
	import com.superkaka.game.Const.ProtocolDict;
	import com.superkaka.mvc.Proxy.SocketProxy;
	
	public class GameSocketProxy extends SocketProxy
	{
		public function GameSocketProxy()
		{
			super();
			this.name = "GAME";
			ProtocolDict.getIns().registerDict(this.name,[3,3,5,6,7,2,2],[2,2,3,7,2,5,8]);
		}
		
		override public function destroy():void{
			super.destroy();
			
			ProtocolDict.getIns().reset(this.name);
		}
	}
}