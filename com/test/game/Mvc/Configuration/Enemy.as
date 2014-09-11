package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Enemy extends BaseConfiguration
	{
		private var _anti:Antiwear;
		
		public function Enemy(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["ID"] = 0;
			_anti["fodder"] = "";
			_anti["name"] = "";
			_anti["type"] = 0;
			_anti["sid"] = 0;
			_anti["ai"] = "";
			_anti["gender"] = "";
			_anti["hp"] = 0;
			_anti["atk"] = 0;
			_anti["def"] = 0;
			_anti["ats"] = 0;
			_anti["adf"] = 0;
			_anti["spd"] = 0;
			_anti["common_distance"] = 0;
			_anti["skill_distance"] = "";
			_anti["hue"] = 0;
		}
		
		override public function assign(data:Object):void{
			ID = data.ID;
			fodder = data.fodder;
			name = data.name;
			type = data.type;
			sid = data.sid;
			ai = data.ai;
			gender = data.gender;
			hp = data.hp;
			atk = data.atk;
			def = data.def;
			ats = data.ats;
			adf = data.adf;
			spd = data.spd;
			common_distance = data.common_distance;
			skill_distance = data.skill_distance;
			hue = data.hue;
		}
		
		public function get ID() : int{
			return _anti["ID"];
		}
		public function set ID(value:int) : void{
			_anti["ID"] = value;
		}
		
		public function get fodder() : String{
			return _anti["fodder"];
		}
		public function set fodder(value:String) : void{
			_anti["fodder"] = value;
		}
		
		public function get name() : String{
			return _anti["name"];
		}
		public function set name(value:String) : void{
			_anti["name"] = value;
		}
		
		public function get type() : int{
			return _anti["type"];
		}
		public function set type(value:int) : void{
			_anti["type"] = value;
		}
		
		public function get sid() : int{
			return _anti["sid"];
		}
		public function set sid(value:int) : void{
			_anti["sid"] = value;
		}
		
		public function get ai() : String{
			return _anti["ai"];
		}
		public function set ai(value:String) : void{
			_anti["ai"] = value;
		}
		
		public function get gender() : String{
			return _anti["gender"];
		}
		public function set gender(value:String) : void{
			_anti["gender"] = value;
		}
		
		public function get hp() : int{
			return _anti["hp"];
		}
		public function set hp(value:int) : void{
			_anti["hp"] = value;
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
		
		public function get spd() : int{
			return _anti["spd"];
		}
		public function set spd(value:int) : void{
			_anti["spd"] = value;
		}
		
		public function get common_distance() : int{
			return _anti["common_distance"];
		}
		public function set common_distance(value:int) : void{
			_anti["common_distance"] = value;
		}
		
		public function get skill_distance() : String{
			return _anti["skill_distance"];
		}
		public function set skill_distance(value:String) : void{
			_anti["skill_distance"] = value;
		}
		
		public function get hue() : int{
			return _anti["hue"];
		}
		public function set hue(value:int) : void{
			_anti["hue"] = value;
		}
	}
}