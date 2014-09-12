package com.test.game.Mvc.control.net.rm{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ProxyFactory;
	import com.superkaka.mvc.Control.net.rm.GameReceiveControl;
	import com.test.game.Const.PiPeiConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.JsonObjectToInstanceManager;
	import com.test.game.Manager.SocketConnectManager;
	import com.test.game.Mvc.Proxy.GateSocketProxy;
	import com.test.game.Mvc.Vo.Server;
	import com.test.game.Mvc.control.data.ServersControllor;
	
	import flash.utils.ByteArray;
	
	public class MyGateReceiveControl extends GameReceiveControl{
		public function MyGateReceiveControl(){
			super();
		}
		
		
		/**
		 * 获取副本信息返回
		 * 
		 */		
		public function GetServerInfoReturn(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------GetServerInfoReturn----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			//DebugArea.getIns().showInfo("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var serverArr:Array = jObj.servers;
			var key:String = jObj.key;//登录密钥
			var serverId:int = jObj.serverId;
			var connector:Object = jObj.connector;//连接服数据
			
			if(!connector){
				//全部连接服爆满
				trace("全部连接服爆满了！请稍后连接游戏！")
				
				return;
			}
			
			GameConst.loginKey = key;//登录key
			GameConst.gateServerId = serverId;//网关服务器id
			
			ProxyFactory.getIns().destroyProxy(GateSocketProxy);
			
			ServersControllor.getIns().servers.length = 0;
			for each(var sObj:Object in serverArr){
				ServersControllor.getIns().servers.push(JsonObjectToInstanceManager.getIns().getServer(sObj));
			}
			
			ServersControllor.getIns().curConnector = JsonObjectToInstanceManager.getIns().getConnector(connector);
			
			this.connectServer();
		}
		
		private function connectServer():void{
			//自动连接,随机选择服务器
			if(ServersControllor.getIns().servers.length > 0){
				var randIdx:int = int(Math.random()*ServersControllor.getIns().servers.length);
				var randServer:Server = ServersControllor.getIns().servers[randIdx];
				if(randServer){
					ServersControllor.getIns().curServer = randServer;
					SocketConnectManager.getIns().connectToGame(ServersControllor.getIns().curConnector.ip,ServersControllor.getIns().curConnector.port);
				}
			}
		}
		
		/**
		 * 不是最新版本
		 * 
		 */		
		public function VersionWrong(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------VersionWrong----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			DebugArea.getIns().showInfo("str:"+str);
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			
			EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.VERSION_WRONG));
		}
		
		
	}
}