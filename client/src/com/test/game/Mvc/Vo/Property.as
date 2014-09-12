package com.test.game.Mvc.Vo{
	import com.superkaka.game.Base.BaseVO;
	
	public class Property extends BaseVO{
		private var _hp:int;
		private var _mp:int;
		private var _atk:int;
		private var _def:int;
		
		public function Property(){
			super();
		}

		


		public function get hp():int
		{
			return _hp;
		}

		public function set hp(value:int):void
		{
			_hp = value;
		}

		public function get mp():int
		{
			return _mp;
		}

		public function set mp(value:int):void
		{
			_mp = value;
		}

		public function get atk():int
		{
			return _atk;
		}

		public function set atk(value:int):void
		{
			_atk = value;
		}

		public function get def():int
		{
			return _def;
		}

		public function set def(value:int):void
		{
			_def = value;
		}


	}
}