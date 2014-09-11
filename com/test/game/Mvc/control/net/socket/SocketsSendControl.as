package com.test.game.Mvc.control.net.socket
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.mvc.ProxyFactory;
	import com.superkaka.mvc.Control.SocketSendControl;
	import com.superkaka.mvc.Control.net.SMessage;
	import com.test.game.Const.PiPeiConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.Mvc.Proxy.FbSocketProxy;
	import com.test.game.Mvc.Proxy.GameSocketProxy;
	import com.test.game.Mvc.Proxy.GateSocketProxy;
	
	public class SocketsSendControl extends SocketSendControl
	{
		public function SocketsSendControl()
		{
			super();
		}
		
		//Gate服发送
		public function sendToGate(sm:SMessage):void{
			var sp:GateSocketProxy = ProxyFactory.getIns().getProxy(GateSocketProxy) as GateSocketProxy;
			if(sp){
				sp.send(sm);
			}else{
				trace("没有连接GATE服务器");
				DebugArea.getIns().showInfo("Gate服发送");
			}
			sm.destroy();
		}
		
		//Game服发送
		public function send(sm:SMessage):void{
			var sp:GameSocketProxy = ProxyFactory.getIns().getProxy(GameSocketProxy) as GameSocketProxy;
			if(sp){
				sp.send(sm);
			}else{
				trace("没有连接GAME服务器");
				DebugArea.getIns().showInfo("Game服发送");
				EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.GET_NOTICE, "服务器已关闭！"));
			}
			sm.destroy();
		}
		
		//FB服发送
		public function sendToFb(sm:SMessage):void{
			var sp:FbSocketProxy = ProxyFactory.getIns().getProxy(FbSocketProxy) as FbSocketProxy;
			if(sp){
				sp.send(sm);
			}else{
				trace("没有连接FB服务器");
				DebugArea.getIns().showInfo("FB服发送");
			}
			sm.destroy();
		}
	}
}

