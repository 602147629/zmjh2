package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class PkExp extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function PkExp()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["lv"] = 0;
			_anti["exp"] = 0;
			_anti["winnerexp"] = 0;
			_anti["loserexp"] = 0;
			_anti["winnersoul"] = 0;
			_anti["losersoul"] = 0;
		}
		
		override public function assign(data:Object):void{
			lv = data.lv;
			exp = data.exp;
			winnerexp = data.winnerexp;
			loserexp = data.loserexp;
			winnersoul = data.winnersoul;
			losersoul = data.losersoul;
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
		
		public function get winnerexp() : int{
			return _anti["winnerexp"];
		}
		public function set winnerexp(value:int) : void{
			_anti["winnerexp"] = value;
		}
		
		public function get loserexp() : int{
			return _anti["loserexp"];
		}
		public function set loserexp(value:int) : void{
			_anti["loserexp"] = value;
		}
		
		public function get winnersoul() : int{
			return _anti["winnersoul"];
		}
		public function set winnersoul(value:int) : void{
			_anti["winnersoul"] = value;
		}
		
		public function get losersoul() : int{
			return _anti["losersoul"];
		}
		public function set losersoul(value:int) : void{
			_anti["losersoul"] = value;
		}
	}
}