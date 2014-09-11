package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class CharactersUp extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function CharactersUp()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["hp_rate"] = 0;
			_anti["mp_rate"] = 0;
			_anti["atk_rate"] = 0;
			_anti["def_rate"] = 0;
			_anti["ats_rate"] = 0;
			_anti["adf_rate"] = 0;
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			name = data.name;
			hp_rate = data.hp_rate;
			mp_rate = data.mp_rate;
			atk_rate = data.atk_rate;
			def_rate = data.def_rate;
			ats_rate = data.ats_rate;
			adf_rate = data.adf_rate;
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		public function get name() : String{
			return _anti["name"];
		}
		public function set name(value:String) : void{
			_anti["name"] = value;
		}
		
		public function get hp_rate() : Number{
			return _anti["hp_rate"];
		}
		public function set hp_rate(value:Number) : void{
			_anti["hp_rate"] = value;
		}
		
		public function get mp_rate() : Number{
			return _anti["mp_rate"];
		}
		public function set mp_rate(value:Number) : void{
			_anti["mp_rate"] = value;
		}
		
		public function get atk_rate() : Number{
			return _anti["atk_rate"];
		}
		public function set atk_rate(value:Number) : void{
			_anti["atk_rate"] = value;
		}
		
		public function get def_rate() : Number{
			return _anti["def_rate"];
		}
		public function set def_rate(value:Number) : void{
			_anti["def_rate"] = value;
		}
		
		public function get ats_rate() : Number{
			return _anti["ats_rate"];
		}
		public function set ats_rate(value:Number) : void{
			_anti["ats_rate"] = value;
		}
		
		public function get adf_rate() : Number{
			return _anti["adf_rate"];
		}
		public function set adf_rate(value:Number) : void{
			_anti["adf_rate"] = value;
		}
	}
}