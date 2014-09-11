package com.test.game.Mvc.control.net.rm{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ProxyFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Control.net.rm.GameReceiveControl;
	import com.test.game.Const.PiPeiConst;
	import com.test.game.Manager.DigitalManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.FbPlayersManager;
	import com.test.game.Manager.JsonObjectToInstanceManager;
	import com.test.game.Manager.PlayersManager;
	import com.test.game.Manager.RoomsManager;
	import com.test.game.Manager.ServerControllor;
	import com.test.game.Manager.SocketConnectManager;
	import com.test.game.Modules.GameMenu.view.GameMenuView;
	import com.test.game.Mvc.Proxy.FbSocketProxy;
	import com.test.game.Mvc.Vo.Player;
	import com.test.game.Mvc.Vo.Room;
	import com.test.game.Mvc.Vo.Seat;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class MyRoomReceiveControl extends GameReceiveControl{
		public function MyRoomReceiveControl(){
			super();
		}
		
		
//		/**
//		 * 加入房间成功 
//		 * 
//		 */		
//		public function JoinRoomSuccess(body:ByteArray):void{
//			trace("-----JoinRoomSuccess-----")
//			
////			if(GameConst.isAutoTest){
////				//自动开始游戏
////				var sm:com.test.game.net.sm.Game.StartGame = new com.test.game.net.sm.Game.StartGame();
////				var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
////				ssc.send(sm);
////			}else{
////				var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
////				gmv.joinRoomSuccess();
////			}
//		}
//		
//		/**
//		 * 加入房间失败 
//		 * 
//		 */		
//		public function JoinRoomFail(body:ByteArray):void{
//			trace("-----JoinRoomFail-----");
//			
//			
//		}
		
		/**
		 * 离开房间成功 
		 * 
		 */		
		public function LeftRoomSuccess(body:ByteArray):void{
			DebugArea.getIns().showInfo("-----LeftRoomSuccess-----")
			if(GameConst.isAutoTest){
				//延迟2秒自动进入房间
//				setTimeout(function(){
////					var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
////					var sm2:JoinRoom = new JoinRoom();
////					ssc.send(sm2);
//				},2000);
			}else{
				var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
				gmv.leftRoomSuccess();
			}
		}
		
		/**
		 * 接收玩家操作 
		 * @param body
		 * 
		 */		
		public function ReceiveOperation(command:ByteArray):void{
			var temp:ByteArray = new ByteArray();
			temp.endian = Endian.LITTLE_ENDIAN;
			command.readBytes(temp);
			ServerControllor.getIns().mutiCommands.push(temp);
//			ServerControllor.getIns().mutiCommands.push(new ByteArray());
		}
		
		/**
		 * 开始游戏（服务端广播） 
		 * 
		 */		
		public function StartGame(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------StartGame----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str);
			//DebugArea.getIns().showInfo("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var result:int = jObj.result;
			var random:int = jObj.random;
			var datas:Array = jObj.datas;
			
			DigitalManager.getIns().randomIndex = random;
			if(result == 1){
				//开始游戏成功
				
				FbPlayersManager.getIns().playerDatas = datas;
				EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.PIPEI_COMPLETE));
			}
			
//			if(!GameConst.isAutoTest){
//				var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
//				gmv.startGameReturn(result);
//			}
		}
		
		/**
		 * 房间信息发生变化 
		 * @param body
		 * 
		 */		
		public function RoomChanged(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------RoomChanged----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			//DebugArea.getIns().showInfo("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var roomObj:Object = jObj.room;
			
			var room:Room = JsonObjectToInstanceManager.getIns().getRoom(roomObj);
			
			room.init();
			
			var seats:Array = roomObj.seats;
			for each(var sObj:Object in seats){
				var seat:Seat = new Seat();
				seat.index = sObj.index;
				if(sObj.uid){
					var p:Player = PlayersManager.getIns().getPlayerByUid(sObj.gameKey);
					if(!p){
						p = new Player();
//						p.uid = sObj.uid;
					}
					seat.player = p;
				}
				room.updateSeat(seat);
			}
			
			RoomsManager.getIns().updateRoom(room);
			
//			if(!GameConst.isAutoTest){
//				//更新ui
//				var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
//				gmv.updateRoomListReturn();
//			}
		}
		
		/**
		 * 创建/加入房间返回
		 * 
		 */		
		public function CreateRoomReturn(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------Create/JoinRoomReturn----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str);
			//DebugArea.getIns().showInfo("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			
			//连接fb服务器
			var err:String = jObj.err;
			var type:int = jObj.type;
			var key:String = jObj.key;
			var roomId:int = jObj.roomId;
			var ip:String = jObj.ip;
			var port:int = jObj.port;				
			if(type == 0){
				//创建房间
				if(err == null){
					ProxyFactory.getIns().destroyProxy(FbSocketProxy);
					//创建房间成功
					GameConst.roomId = roomId;
					GameConst.roomKey = key;
					SocketConnectManager.getIns().connectToFb(ip,port);
					EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.JOIN_ROOM_SUCCESS));
				}else{
					//创建房间失败
					
				}
			}else if(type == 1){
				//加入房间
				if(err == null){
					ProxyFactory.getIns().destroyProxy(FbSocketProxy);
					//加入房间成功
					GameConst.roomId = roomId;
					GameConst.roomKey = key;
					SocketConnectManager.getIns().connectToFb(ip,port);
					EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.JOIN_ROOM_SUCCESS));
				}else{
					//加入房间失败
					
				}
			}else{
				//出错
				throw new Error("创建/加入房间出错！");
				EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.JOIN_ROOM_FAILURE));
			}
		}
		
		
		/**
		 * 加入房间返回
		 * 
		 */		
		public function JoinRoomReturn(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------JoinRoomReturn----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str);
			//DebugArea.getIns().showInfo("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var result:int = jObj.result;
			if(result == 1){
//				if(GameConst.isAutoTest){
//					//自动开战
//					var sm:com.test.game.net.sm.Game.StartGame = new com.test.game.net.sm.Game.StartGame();
//					var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
//					ssc.sendToFb(sm);
//				}
			}else{
				//加入房间失败
			}
		}
		
		
		/**
		 * 退出房间返回
		 * 
		 */		
		public function LeftRoomReturn(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------LeftRoomReturn----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str);
			//DebugArea.getIns().showInfo("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.LEAVE_ROOM_SUCCESS));
			GameConst.roomId = -1;
			//销毁fb连接
			ProxyFactory.getIns().destroyProxy(FbSocketProxy);
		}
		
		/**
		 * 自动匹配返回
		 * 
		 */		
		public function AutoPipeiReturn(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------AutoPipeiReturn----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str);
			//DebugArea.getIns().showInfo("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var result:int = jObj.result;
			if(result == 1){
				//成功
				EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.START_AUTO_PIPEI));
			}
			
			
		}
		
		
		/**
		 * 取消自动匹配返回
		 * 
		 */		
		public function CancelAutoPipeiReturn(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------CancelAutoPipeiReturn----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str);
			//DebugArea.getIns().showInfo("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var result:int = jObj.result;
			//if(result == 1){
				//成功
				EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.CANCEL_AUTO_PIPEI));
			//}
			
			
		}
		
		/**
		 * 副本结算
		 * 
		 */		
		public function GameAccount(body:ByteArray):void{
			DebugArea.getIns().showInfo("-------GameAccount----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str);
			//DebugArea.getIns().showInfo("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var data:Object = jObj.data;
			
			var result:int = data.result;//副本结局
			var type:int = data.type;//副本种类(0:1V1匹配pk，1:其他)
			
			if(data.result == 1){
				//胜利
				EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.RESULT_VICTORY, data));
			}else{
				//失败
				EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.RESULT_FAILURE, data));
			}
			
			
		}
		
	}
}