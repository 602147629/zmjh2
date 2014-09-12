package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class SkillUpVo extends BaseVO
	{

		private var _anti:Antiwear;
		public function get skillLevels() : Array{
			return _anti["skillLevels"];
		}
		public function set skillLevels(value:Array) : void{
			_anti["skillLevels"] = value;
		}
		
		public function get skillBooks1() : Array{
			return _anti["skillBooks1"];
		}
		public function set skillBooks1(value:Array) : void{
			_anti["skillBooks1"] = value;
		}
		
		public function get skillBooks2() : Array{
			return _anti["skillBooks2"];
		}
		public function set skillBooks2(value:Array) : void{
			_anti["skillBooks2"] = value;
		}
		
		public function get skillBooks3() : Array{
			return _anti["skillBooks3"];
		}
		public function set skillBooks3(value:Array) : void{
			_anti["skillBooks3"] = value;
		}
		
		public function get skillBooks4() : Array{
			return _anti["skillBooks4"];
		}
		public function set skillBooks4(value:Array) : void{
			_anti["skillBooks4"] = value;
		}
		
		public function get skillBooks5() : Array{
			return _anti["skillBooks5"];
		}
		public function set skillBooks5(value:Array) : void{
			_anti["skillBooks5"] = value;
		}
		
		public function get skillBooks6() : Array{
			return _anti["skillBooks6"];
		}
		public function set skillBooks6(value:Array) : void{
			_anti["skillBooks6"] = value;
		}
		
		public function get skillBooks7() : Array{
			return _anti["skillBooks7"];
		}
		public function set skillBooks7(value:Array) : void{
			_anti["skillBooks7"] = value;
		}
		
		public function get skillBooks8() : Array{
			return _anti["skillBooks8"];
		}
		public function set skillBooks8(value:Array) : void{
			_anti["skillBooks8"] = value;
		}
		
		public function get skillBooks9() : Array{
			return _anti["skillBooks9"];
		}
		public function set skillBooks9(value:Array) : void{
			_anti["skillBooks9"] = value;
		}
		
		public function get skillBooks10() : Array{
			return _anti["skillBooks10"];
		}
		public function set skillBooks10(value:Array) : void{
			_anti["skillBooks10"] = value;
		}
		
		public function SkillUpVo(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["skillBooks1"] = [];
			_anti["skillBooks2"] = [];
			_anti["skillBooks3"] = [];
			_anti["skillBooks4"] = [];
			_anti["skillBooks5"] = [];
			_anti["skillBooks6"] = [];
			_anti["skillBooks7"] = [];
			_anti["skillBooks8"] = [];
			_anti["skillBooks9"] = [];
			_anti["skillBooks10"] = [];
			_anti["skillLevels"] = [];
		}
		
		public function init(data:Object) : void{
			skillBooks1 = data.skillBooks1;
			skillBooks2 = data.skillBooks2;
			skillBooks3 = data.skillBooks3;
			skillBooks4 = data.skillBooks4;
			skillBooks5 = data.skillBooks5;
			skillBooks6 = data.skillBooks6;
			skillBooks7 = data.skillBooks7;
			skillBooks8 = data.skillBooks8;
			skillBooks9 = data.skillBooks9;
			skillBooks10 = data.skillBooks10;
			skillLevels = data.skillLevels;
		}
	}
}