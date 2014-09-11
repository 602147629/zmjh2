package com.test.game.Manager{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Const.ProtocolDict;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ProxyFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Control.RMessageControl;
	import com.superkaka.mvc.View.Net.SMessageTest;
	import com.test.game.Const.DebugConst;
	import com.test.game.Const.PiPeiConst;
	import com.test.game.Mvc.Proxy.FbSocketProxy;
	import com.test.game.Mvc.Proxy.GameSocketProxy;
	import com.test.game.Mvc.Proxy.GateSocketProxy;
	import com.test.game.Mvc.control.data.ProtocalControl;
	import com.test.game.Mvc.control.data.ServersControllor;
	import com.test.game.Mvc.control.key.GoToPlayerChooseControl;
	import com.test.game.Mvc.control.key.InitLoadingCompleteControl;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	import com.test.game.net.sm.Connector.LoginConnector;
	import com.test.game.net.sm.Gate.LoginGate;
	import com.test.game.net.sm.Room.JoinRoom;
	
	import flash.utils.ByteArray;
	
	public class SocketConnectManager extends Singleton{
		private var rmc:RMessageControl;
		
		
		public function SocketConnectManager(){
			super();
			
			var pc:ProtocalControl = ControlFactory.getIns().getControl(ProtocalControl) as ProtocalControl;
			var json:Object = pc.getProtocolJson();
			trace("json:"+json);
			
			//协议
			ProtocolDict.getIns().initToServerFileDict(json.protocolToServerFile);
			ProtocolDict.getIns().initToServerFuncDict(json.protocolToServerFunc);
			
			ProtocolDict.getIns().initToClientFileDict(json.protocolToClientFile);
			ProtocolDict.getIns().initToClientFuncDict(json.protocolToClientFunc);
		}
		
		public static function getIns():SocketConnectManager{
			return Singleton.getIns(SocketConnectManager);
		}
		
		
		public function connectToGate():void{
			DebugArea.getIns().showResult("------connectToGate------", DebugConst.NORMAL);
			if(ProxyFactory.getIns().getProxy(GateSocketProxy)){
				return;
			}
			//gate服务器
			var sp:GateSocketProxy = ProxyFactory.getIns().initProxy(GateSocketProxy) as GateSocketProxy;
			sp.connectTo(GameConst.GATE_IP,GameConst.GATE_PORT,onGateConnect,onData,onGateDisConnect,onIOError);
		}
		
		private function onIOError():void{
			EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.GET_NOTICE, "服务器已关闭！"));
		}
		
		public function connectToGame(ip:String,port:int):void{
			if(ProxyFactory.getIns().getProxy(GameSocketProxy)){
				return;
			}
			//game服务器
			var sp:GameSocketProxy = ProxyFactory.getIns().initProxy(GameSocketProxy) as GameSocketProxy;
			sp.connectTo(ip,port,onGameConnect,onData,onGameDisConnect);
		}
		
		public function connectToFb(ip:String,port:int):void{
			if(ProxyFactory.getIns().getProxy(FbSocketProxy)){
				return;
			}
			//fb服务器
			var sp:FbSocketProxy = ProxyFactory.getIns().initProxy(FbSocketProxy) as FbSocketProxy;
			sp.connectTo(ip,port,onFbConnect,onData,onFbDisConnect);
		}
		
		private function onData(data:ByteArray,codeName:String):void{
			if(!rmc){
				rmc = ControlFactory.getIns().getControl(RMessageControl) as RMessageControl;
			}
			
			rmc.analysicsMessage("com.test.game.Mvc.control.net.rm.",data,codeName);
		}
		
		/**
		 * gate服务器断开 
		 * 
		 */		
		private function onGateDisConnect():void{
			ProxyFactory.getIns().destroyProxy(GateSocketProxy);
			
			
			//此处处理 1：获得到服务器数据，自动断开的连接，不处理。2：GATE服务器连接数满了，自动重试
			
//			setTimeout(this.connectToGate,2000);
		}
		
		/**
		 * 连接上gate服务器 
		 * 
		 */	
		private function onGateConnect():void{
			//登录gate
			var sm:LoginGate = new LoginGate(GameConst.UID);
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.sendToGate(sm);
			
			if(!GameConst.isPressureTest){
				var initLoadingComplete:InitLoadingCompleteControl = ControlFactory.getIns().getControl(InitLoadingCompleteControl) as InitLoadingCompleteControl;
				initLoadingComplete.execute();
			}
		}
		
		/**
		 * 连接上game服务器 
		 * 
		 */	
		private function onGameConnect():void{
			//登录game
//			var sm:GetUsers = new GetUsers(GameConst.UID,GameConst.loginKey,GameConst.gateServerId);
//			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
//			ssc.send(sm);
			
			
			var sm:LoginConnector = new LoginConnector(GameConst.UID,GameConst.loginKey,GameConst.gateServerId,ServersControllor.getIns().curServer.id);
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
			
			
			if(!GameConst.isPressureTest){
				GoToPlayerChooseControl(ControlFactory.getIns().getControl(GoToPlayerChooseControl)).goToPlayerChoose();
			}
			
			var smt:SMessageTest = ViewFactory.getIns().getView(SMessageTest) as SMessageTest;
			if(smt){
				smt.setSocketProxy(ProxyFactory.getIns().getProxy(GameSocketProxy) as GameSocketProxy)
			}
		}
		
		
		private function onGameDisConnect():void{
			ProxyFactory.getIns().destroyProxy(GameSocketProxy);
			trace("onGameDisConnect");
			//此处处理 1：登录GAME服务器人数已满，无法登录。2：游戏中网络原因链路突然断开。
			if(1){
				//第一种情况
//				this.connectToGate();
			}
		}
		
		
		/**
		 * 连接上fb服务器 
		 * 
		 */	
		private function onFbConnect():void{
			//加入房间
			var sm:JoinRoom = new JoinRoom(GameConst.roomKey,GameConst.roomId,MyUserManager.getIns().socketPlayer.gameKey);
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.sendToFb(sm);
			
		}
		
		
		private function onFbDisConnect():void{
			ProxyFactory.getIns().destroyProxy(FbSocketProxy);
			trace("onFbDisConnect");
			
		}
		
	}
}