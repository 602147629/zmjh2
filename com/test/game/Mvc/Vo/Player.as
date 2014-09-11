package com.test.game.Mvc.Vo{
	import com.superkaka.game.Base.BaseVO;
	
	public class Player extends BaseVO{
//		private var _pid:Number;//玩家角色用户id
//		private var _uid:int;//玩家uid
		private var _name:String;
		private var _index:int;
		private var _level:int;
		private var _exp:int;
		private var _gameKey:String;
		private var _property:Property;
		
		
		public function Player(){
			super();
			
			this._property = new Property();
		}
		
		
		public function destroy():void{
			this._property = null;
		}

//		public function get pid():Number
//		{
//			return _pid;
//		}
//
//		public function set pid(value:Number):void
//		{
//			_pid = value;
//		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

		public function get property():Property
		{
			return _property;
		}

		public function set property(value:Property):void
		{
			_property = value;
		}

		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;
		}

		public function get exp():int
		{
			return _exp;
		}

		public function set exp(value:int):void
		{
			_exp = value;
		}

//		public function get uid():int
//		{
//			return _uid;
//		}
//
//		public function set uid(value:int):void
//		{
//			_uid = value;
//		}

		public function get gameKey():String
		{
			return _gameKey;
		}

		public function set gameKey(value:String):void
		{
			_gameKey = value;
		}


	}
}