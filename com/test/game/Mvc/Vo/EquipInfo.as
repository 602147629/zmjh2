package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.test.game.Const.NumberConst;
	
	public class EquipInfo 
	{
		public function EquipInfo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			weapon = NumberConst.getIns().zero;
			head = NumberConst.getIns().zero;
			neck = NumberConst.getIns().zero;
			clothes = NumberConst.getIns().zero;
			shoulder = NumberConst.getIns().zero;
			shoes = NumberConst.getIns().zero;
		}
		
		private var _anti:Antiwear;
	
	
		public function get head() : int
		{
			return 	_anti["head"];
		}
		public function set head(value:int) : void
		{
			_anti["head"] = value;
		}
		
		public function get neck() : int
		{
			return 	_anti["neck"];
		}
		public function set neck(value:int) : void
		{
			_anti["neck"] = value;
		}
		
		public function get weapon() : int
		{
			return 	_anti["weapon"];
		}
		public function set weapon(value:int) : void
		{
			_anti["weapon"] = value;
		}
		
		public function get clothes() : int
		{
			return 	_anti["clothes"];
		}
		public function set clothes(value:int) : void
		{
			_anti["clothes"] = value;
		}
		
		public function get shoulder() : int
		{
			return 	_anti["shoulder"];
		}
		public function set shoulder(value:int) : void
		{
			_anti["shoulder"] = value;
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

