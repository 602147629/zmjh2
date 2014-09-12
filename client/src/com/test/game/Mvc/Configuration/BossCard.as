package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class BossCard extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function BossCard(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["fodder"] = "";
			_anti["name"] = "";
			_anti["gender"] = 0;
			_anti["atk"] = 0;
			_anti["ats"] = 0;
			_anti["add_type"] = "";
			_anti["add_value"] = 0;
			_anti["skill_energy"] = 0;
			_anti["skill_info"] = "";
			_anti["boss_info"] = "";
			_anti["attachPos"] = -1;
			_anti["sid"] = 0;

		}
		
		override public function assign(data:Object):void{
			id = data.id;
			fodder = data.fodder;
			name = data.name;
			gender = data.gender;
			atk = data.atk;
			ats = data.ats;
			add_type = data.add_type.split("|");
			add_value = data.add_value.split("|");
			for(var i:int = 0;i<add_value.length;i++){
				add_value[i] = int(add_value[i]);
			}
			skill_info = data.skill_info;
			skill_energy = data.skill_energy;
			boss_info = data.boss_info;
			sid = data.sid;

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
		
		public function get fodder() : String{
			return _anti["fodder"];
		}
		public function set fodder(value:String) : void{
			_anti["fodder"] = value;
		}
		
		
		public function get atk() : int{
			return _anti["atk"];
		}
		public function set atk(value:int) : void{
			_anti["atk"] = value;
		}
		
		public function get gender() : int{
			return _anti["gender"];
		}
		public function set gender(value:int) : void{
			_anti["gender"] = value;
		}
		
		
		public function get ats() : int{
			return _anti["ats"];
		}
		public function set ats(value:int) : void{
			_anti["ats"] = value;
		}
		

		
		public function get add_type() : Array{
			return _anti["add_type"];
		}
		public function set add_type(value:Array) : void{
			_anti["add_type"] = value;
		}
		
		public function get add_value() : Array{
			return _anti["add_value"];
		}
		public function set add_value(value:Array) : void{
			_anti["add_value"] = value;
		}
		
		public function get skill_info() : String{
			return _anti["skill_info"];
		}
		public function set skill_info(value:String) : void{
			_anti["skill_info"] = value;
		}
		
		public function get boss_info() : String{
			return _anti["boss_info"];
		}
		public function set boss_info(value:String) : void{
			_anti["boss_info"] = value;
		}
		
		public function get skill_energy() : int{
			return _anti["skill_energy"];
		}
		public function set skill_energy(value:int) : void{
			_anti["skill_energy"] = value;
		}
		
		public function get attachPos() : int{
			return _anti["attachPos"];
		}
		public function set attachPos(value:int) : void{
			_anti["attachPos"] = value;
		}
		
		public function get sid() : int{
			return _anti["sid"];
		}
		public function set sid(value:int) : void{
			_anti["sid"] = value;
		}

	}
}