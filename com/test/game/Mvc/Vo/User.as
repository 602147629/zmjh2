package com.test.game.Mvc.Vo{
	import com.superkaka.game.Base.BaseVO;
	
	public class User extends BaseVO{
		private var _uid:int;//玩家帐号用户id
		
		
		public function User(){
			super();
		}

		public function get uid():int
		{
			return _uid;
		}

		public function set uid(value:int):void
		{
			_uid = value;
		}
	}
}