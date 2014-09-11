package com.test.game.Mvc.control.net.rm{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Control.net.rm.LoginReceiveControl;
	import com.test.game.Manager.JsonObjectToInstanceManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.PlayersManager;
	import com.test.game.Manager.PublicNoticeManager;
	import com.test.game.Manager.RoomsManager;
	import com.test.game.Mvc.Vo.Line;
	import com.test.game.Mvc.Vo.Player;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.Vo.Room;
	import com.test.game.Mvc.Vo.Seat;
	
	import flash.utils.ByteArray;
	
	public class MyLineReceiveControl extends LoginReceiveControl{
		public function MyLineReceiveControl(){
			super();
		}
		
		/**
		 * 获取所有房间信息完毕
		 * @param body
		 * 
		 */		
		public function AllRooms(body:ByteArray):void{
			trace("-------AllRooms----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			
			var rooms:Vector.<Room> = new Vector.<Room>();
			var rs:Array = jObj.rooms;
			for each(var rObj:Object in rs){
				var room:Room = JsonObjectToInstanceManager.getIns().getRoom(rObj);
				
				room.init();
				
				var seats:Array = rObj.seats;
				for each(var sObj:Object in seats){
					var seat:Seat = new Seat();
					seat.index = sObj.index;
					if(sObj.uid){
						var p:Player = PlayersManager.getIns().getPlayerByUid(sObj.uid);
						if(!p){
							//throw new Error("MyLineReceiveControl->AllRooms() error!can not get player!uid:"+sObj.uid);
							p = new Player();
//							p.uid = sObj.uid;
						}
						seat.player = p;
					}
					room.updateSeat(seat);
				}
				
				rooms.push(room);
			}
			
			RoomsManager.getIns().updateRooms(rooms);
			
//			if(!GameConst.isAutoTest){
//				var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
//				gmv.updateRoomListReturn();
//			}
		}
		
		/**
		 * 获取所有玩家信息成功
		 * @param body
		 * 
		 */		
		public function AllPlayers(body:ByteArray):void{
			trace("-------AllPlayers----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			
			var players:Array = jObj.players;
			
			PlayersManager.getIns().clear();
			
			for each(var playerObj:Object in players){
				var player:Player = new Player();
				player.buildFromObject(playerObj);
				
				PlayersManager.getIns().addPlayer(player);
			}
		
//			if(!GameConst.isAutoTest){
//				var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
//				gmv.showAllPlayersReturn();
//			}
		}
		
		/**
		 * 选线后服务端推送的数据
		 * @param body
		 * 
		 */		
		public function AllPlayersInLogin(body:ByteArray):void{
			trace("-------AllPlayersInLogin----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str);
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			
			var players:Array = jObj.players;
			
			PlayersManager.getIns().clear();
			
			for each(var playerObj:Object in players){
				var player:Player = new Player();
				player.buildFromObject(playerObj);
				
				PlayersManager.getIns().addPlayer(player);
			}
			
//			if(!GameConst.isAutoTest){
//				var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
//				gmv.showAllPlayersReturn();
//			}
		}
		
		
		/**
		 * 选择线返回 
		 * @param body
		 * 
		 */		
		public function ChooseLineReturn(body:ByteArray):void{
			trace("-------ChooseLineReturn----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			
			
			
//			if(!GameConst.isAutoTest){
//				//切换场景
//				GoToGameMenuControl(ControlFactory.getIns().getControl(GoToGameMenuControl)).goToGameMenu();
//			}else{
//				//自动创建队伍
//				var sm:CreateRoom = new CreateRoom();
//				var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
//				ssc.send(sm);
//			}
			
//			//自动加入队伍
//			var sm:JoinRoom = new JoinRoom();
//			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
//			ssc.send(sm);
		}
		
		/**
		 * 选择线返回(已满) 
		 * @param body
		 * 
		 */		
		public function ChooseLineFull(body:ByteArray):void{
			trace("-------ChooseLineFull----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			
		}
		
		/**
		 * 获取线列表返回 
		 * @param body
		 * 
		 */		
		public function GetLinesReturn(body:ByteArray):void{
			trace("--GetLinesReturn--")
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var arr:Array = jObj.lines;
			var lines:Vector.<Line> = new Vector.<Line>();
			for each(var obj:Object in arr){
				var line:Line = new Line();
				line.buildFromObject(obj);
				
				lines.push(line);
			}
			
			/*if(!GameConst.isAutoTest){
				var clv:ChooseLineView = ViewFactory.getIns().getView(ChooseLineView) as ChooseLineView;
				clv.getLineReturn(lines);
			}*/
		}
		
		
		/**
		 * 玩家加入游戏
		 * @param body
		 * 
		 */		
		public function PlayerJoin(body:ByteArray):void{
			trace("-------PlayerJoin----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var pObj:Object = jObj.player;
			trace("玩家："+pObj.name+"加入游戏");
			
			
			var player:Player = new Player();
			player.buildFromObject(pObj);
			
			PlayersManager.getIns().addPlayer(player);
			
			/*if(!GameConst.isAutoTest){
				var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
				gmv.playerJoinReturn(player);
			}*/
			
		}
		
		/**
		 * 玩家离开游戏
		 * @param body
		 * 
		 */		
		public function PlayerLeft(body:ByteArray):void{
			trace("-------PlayerLeft----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str);
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var gameKey:String = jObj.gameKey;
			
			var player:Player = PlayersManager.getIns().getPlayerByUid(gameKey);
			if(player != null){
				trace("玩家："+player.name+"离开游戏");
				
				PlayersManager.getIns().removePlayer(gameKey);
			}
			/*if(!GameConst.isAutoTest){
				var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
				gmv.playerLeftReturn(player);
			}*/
			
		}
		
	}
}