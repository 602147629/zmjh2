package com.test.game.Manager{
	import com.superkaka.Tools.Singleton;
	import com.test.game.Mvc.Vo.Connector;
	import com.test.game.Mvc.Vo.Room;
	import com.test.game.Mvc.Vo.Server;
	
	/**
	 * 将json对象转换成相对应的实例 
	 * @author xmyi-0362
	 * 
	 */	
	public class JsonObjectToInstanceManager extends Singleton{
		public function JsonObjectToInstanceManager(){
			super();
		}
		
		public static function getIns():JsonObjectToInstanceManager{
			return Singleton.getIns(JsonObjectToInstanceManager);
		}
		
		
		/**
		 *获取房间对象 
		 */	
		public function getRoom(roomObj:Object):Room{
			var room:Room = new Room();
			room.id = roomObj.id;
			room.maxChildren = roomObj.maxChildren;
			room.isFight = int(roomObj.isFight)==1?true:false;
			
			return room;
		}
		
		/**
		 *获取服务器对象
		 */	
		public function getServer(sObj:Object):Server{
			var server:Server = new Server();
			server.buildFromObject(sObj);
			
			return server;
		}
		
		/**
		 *获取连接服对象
		 */	
		public function getConnector(cObj:Object):Connector{
			var connector:Connector = new Connector();
			connector.buildFromObject(cObj);
			
			return connector;
		}
	}
	
}