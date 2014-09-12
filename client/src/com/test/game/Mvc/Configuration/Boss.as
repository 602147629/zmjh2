package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Boss extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function Boss(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["id"] = 0;
			_anti["fodder"] = "";
			_anti["name"] = "";
			_anti["sid"] = 0;
			_anti["gender"] = "";
			_anti["atk"] = 0;
			_anti["ats"] = 0;
			_anti["add_type"] = "";
			_anti["add_value"] = "";
			_anti["skill_entity"] = 0;
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			fodder = data.fodder;
			name = data.name;
			sid = data.sid;
			gender = data.gender;
			atk = data.atk;
			ats = data.ats;
			add_type = data.add_type;
			add_value = data.add_value;
			skill_entity = data.skill_entity;
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
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
		
		public function get sid() : int{
			return _anti["sid"];
		}
		public function set sid(value:int) : void{
			_anti["sid"] = value;
		}
		
		public function get gender() : String{
			return _anti["gender"];
		}
		public function set gender(value:String) : void{
			_anti["gender"] = value;
		}
		
		public function get atk() : int{
			return _anti["atk"];
		}
		public function set atk(value:int) : void{
			_anti["atk"] = value;
		}
		
		public function get ats() : int{
			return _anti["ats"];
		}
		public function set ats(value:int) : void{
			_anti["ats"] = value;
		}
		
		public function get add_type() : String{
			return _anti["add_type"];
		}
		public function set add_type(value:String) : void{
			_anti["add_type"] = value;
		}
		
		public function get add_value() : String{
			return _anti["add_value"];
		}
		public function set add_value(value:String) : void{
			_anti["add_value"] = value;
		}
		
		public function get skill_entity() : int{
			return _anti["skill_entity"];
		}
		public function set skill_entity(value:int) : void{
			_anti["skill_entity"] = value;
		}
	}
}