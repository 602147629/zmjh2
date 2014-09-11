package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Character extends BaseConfiguration
	{
		
		private var _anti:Antiwear;
		public function Character(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["lv"] = 0;
			
			_anti["hp"] = 0;
			_anti["mp"] = 0;
			_anti["atk"] = 0;
			_anti["def"] = 0;
			_anti["ats"] = 0;
			_anti["adf"] = 0;
			_anti["spd"] = 0;
			_anti["atk_spd"] = 0;
			_anti["evasion"] = 0;
			_anti["crit"] = 0;
			_anti["hit"] = 0;
			_anti["toughness"] = 0;
			_anti["hp_regain"] = 0;
			_anti["mp_regain"] = 0;
			
			_anti["location"] = "";
			_anti["info"] = "";
			_anti["type"] = 0;
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			name = data.name;
			lv = data.lv;
			
			hp = data.hp;
			mp = data.mp;
			atk = data.atk;
			def = data.def;
			ats = data.ats;
			adf = data.adf;
			spd = data.spd;
			atk_spd = data.atk_spd;
			evasion = data.evasion;
			crit = data.crit;
			hit = data.hit;
			toughness = data.toughness;
			hp_regain = data.hp_regain;
			mp_regain = data.mp_regain;
			
			location = data.location;
			info = data.info;
			type = data.type;

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
		
		public function get lv() : int{
			return _anti["lv"];
		}
		public function set lv(value:int) : void{
			_anti["lv"] = value;
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
		
		public function get evasion() : int{
			return _anti["evasion"];
		}
		public function set evasion(value:int) : void{
			_anti["evasion"] = value;
		}
		
		public function get crit() : int{
			return _anti["crit"];
		}
		public function set crit(value:int) : void{
			_anti["crit"] = value;
		}
		
		public function get hit() : int{
			return _anti["hit"];
		}
		public function set hit(value:int) : void{
			_anti["hit"] = value;
		}
		
		public function get toughness() : int{
			return _anti["toughness"];
		}
		public function set toughness(value:int) : void{
			_anti["toughness"] = value;
		}
		

		public function get spd() : int{
			return _anti["spd"];
		}
		public function set spd(value:int) : void{
			_anti["spd"] = value;
		}
		
		
		public function get atk_spd() : int{
			return _anti["atk_spd"];
		}
		public function set atk_spd(value:int) : void{
			_anti["atk_spd"] = value;
		}
		
		
		public function get hp_regain() : int{
			return _anti["hp_regain"];
		}
		public function set hp_regain(value:int) : void{
			_anti["hp_regain"] = value;
		}
		
		public function get mp_regain() : int{
			return _anti["mp_regain"];
		}
		public function set mp_regain(value:int) : void{
			_anti["mp_regain"] = value;
		}
		

		public function get location() : String{
			return _anti["location"];
		}
		public function set location(value:String) : void{
			_anti["location"] = value;
		}

		public function get info() : String{
			return _anti["info"];
		}
		public function set info(value:String) : void{
			_anti["info"] = value;
		}
		
		
		public function get type() : int{
			return _anti["type"];
		}
		public function set type(value:int) : void{
			_anti["type"] = value;
		}
	}
}