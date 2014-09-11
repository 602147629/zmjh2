package com.test.game.Mvc.Vo
{
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class EquipVo extends BaseVO
	{
		public function EquipVo()
		{
			//_anti = new Antiwear(new binaryEncrypt());
		}
		private var _anti:Antiwear;
		
		private var _superWeapon:int;

		public function get superWeapon():int
		{
			return _superWeapon;
		}

		public function set superWeapon(value:int):void
		{
			_superWeapon = value;
		}

		
		public function get helmet() : int
		{
			return 	_anti["helmet"];
		}
		public function set helmet(value:int) : void
		{
			_anti["helmet"] = value;
		}
		
		public function get glove() : int
		{
			return 	_anti["glove"];
		}
		public function set glove(value:int) : void
		{
			_anti["glove"] = value;
		}
		
		public function get weapon() : int
		{
			return 	_anti["weapon"];
		}
		public function set weapon(value:int) : void
		{
			_anti["weapon"] = value;
		}
		
		public function get armor() : int
		{
			return 	_anti["armor"];
		}
		public function set armor(value:int) : void
		{
			_anti["armor"] = value;
		}
		
		public function get trousers() : int
		{
			return 	_anti["trousers"];
		}
		public function set trousers(value:int) : void
		{
			_anti["trousers"] = value;
		}
		
		public function get shoes() : int
		{
			return 	_anti["shoes"];
		}
		public function set shoes(value:int) : void
		{
			_anti["shoes"] = value;
		}
	}
}

