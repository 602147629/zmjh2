package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class StrengthenUp extends BaseConfiguration
	{
		public function StrengthenUp()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["hp_rate"] = 0;
			_anti["mp_rate"] = 0;
			_anti["atk_rate"] = 0;
			_anti["def_rate"] = 0;
			_anti["ats_rate"] = 0;
			_anti["adf_rate"] = 0;
		}
		
		private var _anti:Antiwear;
		
		
		override public function assign(data:Object):void{
			id = data.id;
			hp = data.hp_rate;
			mp = data.mp_rate;
			atk = data.atk_rate;
			def = data.def_rate;
			ats= data.ats_rate;
			adf= data.adf_rate;
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		
		public function get hp() : int{
			return _anti["hp_rate"];
		}
		public function set hp(value:int) : void{
			_anti["hp_rate"] = value;
		}
		
		public function get mp() : int{
			return _anti["mp_rate"];
		}
		public function set mp(value:int) : void{
			_anti["mp_rate"] = value;
		}
		
		public function get atk() : int{
			return _anti["atk_rate"];
		}
		public function set atk(value:int) : void{
			_anti["atk_rate"] = value;
		}
		
		public function get def() : int{
			return _anti["def_rate"];
		}
		public function set def(value:int) : void{
			_anti["def_rate"] = value;
		}
		
		public function get ats() : int{
			return _anti["ats_rate"];
		}
		public function set ats(value:int) : void{
			_anti["ats_rate"] = value;
		}
		
		public function get adf() : int{
			return _anti["adf_rate"];
		}
		public function set adf(value:int) : void{
			_anti["adf_rate"] = value;
		}
		

	}
}