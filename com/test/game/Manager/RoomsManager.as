package com.test.game.Manager{
	import com.superkaka.Tools.Singleton;
	import com.test.game.Mvc.Vo.Room;
	
	public class RoomsManager extends Singleton{
		private var _rooms:Vector.<Room>;
		
		public function RoomsManager(){
			super();
			_rooms = new Vector.<Room>();
		}
		
		
		public static function getIns():RoomsManager{
			return Singleton.getIns(RoomsManager);
		}
		
		/**
		 * 更新全部房间信息 
		 * @param rooms
		 * 
		 */		
		public function updateRooms(rooms:Vector.<Room>):void{
			_rooms = rooms;
		}
		
		/**
		 * 销毁房间 
		 * @param rooms
		 * 
		 */		
		public function destroyRoom(roomId:int):void{
			var len:uint = _rooms.length;
			for(var i:uint=0;i<len;i++){
				var room:Room = _rooms[i];
				if(room.id == roomId){
					room.destroy();
					_rooms.splice(i,1);
					return;
				}
			}
		}
		
		/**
		 * 更新单个房间信息 
		 * @param rooms
		 * 
		 */		
		public function updateRoom(room:Room):void{
			var len:uint = _rooms.length;
			for(var i:uint=0;i<len;i++){
				var r:Room = _rooms[i];
				if(r.id == room.id){
					if(room.GetUsersLen() == 0 || room.isFight){
						//销毁房间
						this.destroyRoom(room.id);
					}else{
						//更新房间信息
						_rooms[i] = room;
					}
					return;
				}
			}
			//新房间
			_rooms.push(room);
		}
		
		/**
		 * 根据玩家uid获取玩家所在房间 
		 * @param uid
		 * @return 
		 * 
		 */
		public function getRoomByUid(gameKey:String):Room{
			for each(var room:Room in this._rooms){
				if(room.getSeatByUid(gameKey)){
					return room;
				}
			}
			return null;
		}

		public function get rooms():Vector.<Room>
		{
			return _rooms;
		}

		
	}
}