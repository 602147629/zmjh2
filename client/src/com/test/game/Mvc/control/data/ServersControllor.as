package com.test.game.Mvc.control.data{
	import com.superkaka.Tools.Singleton;
	import com.test.game.Mvc.Vo.Connector;
	import com.test.game.Mvc.Vo.Server;
	
	public class ServersControllor extends Singleton{
		public var servers:Vector.<Server> = new Vector.<Server>();
		public var curServer:Server;
		public var curConnector:Connector;
		
		
		public function ServersControllor(){
			super();
		}
		
		
		public static function getIns():ServersControllor{
			return Singleton.getIns(ServersControllor);
		}
		
		
		
	}
}