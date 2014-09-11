package com.test.game.Mvc.Vo{
	import com.superkaka.game.Base.BaseVO;
	
	public class Line extends BaseVO{
		private var _id:int;
		private var _name:String;
		
		public function Line(){
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


	}
}