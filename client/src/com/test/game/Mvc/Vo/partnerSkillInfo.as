package com.test.game.Mvc.Vo{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	
	
	public class partnerSkillInfo {
		
		public function partnerSkillInfo(){
			_anti = new Antiwear(new binaryEncrypt());
			skill_4 = 0;
			skill_6 = 0;
			skill_7 = 0;
			skill_5 = 0;
			skill_8 = 0;
			super();
		}
		
		private var _anti:Antiwear;
		
		/**
		 * 按键4
		 */		
		
		public function get skill_4() : int
		{
			return 	_anti["skill_4"];
		}
		public function set skill_4(value:int) : void
		{
			_anti["skill_4"] = value;
		}
		
		
		
		/**
		 * 按键5
		 */		
		
		public function get skill_5() : int
		{
			return 	_anti["skill_5"];
		}
		public function set skill_5(value:int) : void
		{
			_anti["skill_5"] = value;
		}
		
		/**
		 * 按键6 
		 */		
		public function get skill_6() : int
		{
			return 	_anti["skill_6"];
		}
		public function set skill_6(value:int) : void
		{
			_anti["skill_6"] = value;
		}
		
		/**
		 * 按键7
		 */		
		
		public function get skill_7() : int
		{
			return 	_anti["skill_7"];
		}
		public function set skill_7(value:int) : void
		{
			_anti["skill_7"] = value;
		}

		/**
		 * 按键8
		 */		
		
		public function get skill_8() : int
		{
			return 	_anti["skill_8"];
		}
		public function set skill_8(value:int) : void
		{
			_anti["skill_8"] = value;
		}
		

	}
}