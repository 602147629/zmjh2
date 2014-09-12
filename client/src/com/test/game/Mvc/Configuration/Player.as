package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Player extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function Player(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["lv"] = 0;
			_anti["exp"] = 0;
			_anti["dailyexp"] = 0;
			_anti["dailygold"] = 0;
			_anti["dailysoul"] = 0;
		}
		
		override public function assign(data:Object):void{
			lv = data.lv;
			exp = data.exp;
			dailyexp = data.dailyexp;
			dailygold = data.dailygold;
			dailysoul = data.dailysoul;
		}
		
		public function get lv() : int{
			return _anti["lv"];
		}
		public function set lv(value:int) : void{
			_anti["lv"] = value;
		}
		
		public function get exp() : int{
			return _anti["exp"];
		}
		public function set exp(value:int) : void{
			_anti["exp"] = value;
		}
		
		public function get dailyexp() : int{
			return _anti["dailyexp"];
		}
		public function set dailyexp(value:int) : void{
			_anti["dailyexp"] = value;
		}
		
		public function get dailygold() : int{
			return _anti["dailygold"];
		}
		public function set dailygold(value:int) : void{
			_anti["dailygold"] = value;
		}
		
		public function get dailysoul() : int{
			return _anti["dailysoul"];
		}
		public function set dailysoul(value:int) : void{
			_anti["dailysoul"] = value;
		}
	}
}