package com.test.game.Mvc.Vo{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	
	
	public class SkillInfo {
		
		public function SkillInfo(){
			_anti = new Antiwear(new binaryEncrypt());
			skillArr = [];
			skill_H = 0;
			skill_I = 0;
			skill_O = 0;
			skill_U = 0;
			skill_L = 0;
			super();
		}
		
		private var _anti:Antiwear;
		
		public function initData(data:Object) : void{
			skill_H = data.skill_H;
			skill_I = data.skill_I;
			skill_O = data.skill_O;
			skill_U = data.skill_U;
			skill_L = data.skill_L;
		}
		
		/**
		 * 武学1
		 */		
		
		public function get kungfu1() : int
		{
			return 	_anti["kungfu1"];
		}
		public function set kungfu1(value:int) : void
		{
			_anti["kungfu1"] = value;
		}
		
		/**
		 * 武学2
		 */		
		
		public function get kungfu2() : int
		{
			return 	_anti["kungfu2"];
		}
		public function set kungfu2(value:int) : void
		{
			_anti["kungfu2"] = value;
		}
		
		/**
		 * 全部技能
		 */		
		private var _skillArr:Array;
		public function get skillArr() : Array
		{
			return _skillArr;
		}
		public function set skillArr(value:Array) : void
		{
			_skillArr = value;
		}
		
		
		
		/**
		 * 技能 U
		 */		
		
		public function get skill_H() : int
		{
			return 	_anti["skill_H"];
		}
		public function set skill_H(value:int) : void
		{
			_anti["skill_H"] = value;
		}
		
		
		
		/**
		 * 技能 U
		 */		
		
		public function get skill_U() : int
		{
			return 	_anti["skill_U"];
		}
		public function set skill_U(value:int) : void
		{
			_anti["skill_U"] = value;
		}
		
		/**
		 * 技能I 
		 */		
		//public var skill2:String;
		public function get skill_I() : int
		{
			return 	_anti["skill_I"];
		}
		public function set skill_I(value:int) : void
		{
			_anti["skill_I"] = value;
		}
		
		/**
		 * 技能O
		 */		
		//public var skill3:String;
		public function get skill_O() : int
		{
			return 	_anti["skill_O"];
		}
		public function set skill_O(value:int) : void
		{
			_anti["skill_O"] = value;
		}

		/**
		 * 技能 L
		 */		
		
		public function get skill_L() : int
		{
			return 	_anti["skill_L"];
		}
		public function set skill_L(value:int) : void
		{
			_anti["skill_L"] = value;
		}
		

	}
}