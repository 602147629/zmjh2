package com.test.game.Mvc.Vo{
	import com.superkaka.game.Base.BaseVO;
	
	/**
	 * 当前所在连接服数据 
	 * @author xmyi-0362
	 * 
	 */	
	public class Connector extends BaseVO{
		private var _id:int;
		private var _ip:String;
		private var _port:int;
		private var _max:int;
		private var _current:int;
		
		public function Connector(){
			super();
		}
		
		
		
		public function get port():int
		{
			return _port;
		}

		public function set port(value:int):void
		{
			_port = value;
		}

		public function get ip():String
		{
			return _ip;
		}

		public function set ip(value:String):void
		{
			_ip = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get max():int
		{
			return _max;
		}

		public function set max(value:int):void
		{
			_max = value;
		}

		public function get current():int
		{
			return _current;
		}

		public function set current(value:int):void
		{
			_current = value;
		}


	}
}