package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class HeroUp extends BaseConfiguration
	{
		public function HeroUp()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["hp"] = 0;
			_anti["mp"] = 0;
			_anti["atk"] = 0;
			_anti["def"] = 0;
			_anti["ats"] = 0;
			_anti["adf"] = 0;
		}
		
		private var _anti:Antiwear;
		
		
		override public function assign(data:Object):void{
			id = data.id;
			hp = data.hp;
			mp = data.mp;
			atk = data.atk;
			def = data.def;
			ats= data.ats;
			adf= data.adf;
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		
		public function get hp() : int{
			return _anti["hp"];
		}
		public function set hp(value:int) : void{
			_anti["hp"] = value;
		}
		
		public function get mp() : int{
			return _anti["mp"];
		}
		public function set mp(value:int) : void{
			_anti["mp"] = value;
		}
		
		public function get atk() : int{
			return _anti["atk"];
		}
		public function set atk(value:int) : void{
			_anti["atk"] = value;
		}
		
		public function get def() : int{
			return _anti["def"];
		}
		public function set def(value:int) : void{
			_anti["def"] = value;
		}
		
		public function get ats() : int{
			return _anti["ats"];
		}
		public function set ats(value:int) : void{
			_anti["ats"] = value;
		}
		
		public function get adf() : int{
			return _anti["adf"];
		}
		public function set adf(value:int) : void{
			_anti["adf"] = value;
		}
		

	}
}