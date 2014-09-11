package com.test.game.Mvc.Vo{
	import com.superkaka.game.Base.BaseVO;
	
	public class Server extends BaseVO{
		private var _id:int;
		private var _name:String;
		private var _max:int;
		private var _current:int;
		
		public function Server(){
			super();
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
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