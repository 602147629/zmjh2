package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class DailyMission extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function DailyMission(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["mission_name"] = "";
			_anti["mission_rules"] = "";
			_anti["mission_description"] = "";
			_anti["goldOrSoul"] = 0;
			_anti["reward1"] = 0;
			_anti["reward2"] = 0;
			
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			mission_name = data.mission_name;
			mission_rules = data.mission_rules;
			mission_description = data.mission_description;
			goldOrSoul = data.goldOrSoul;
			reward1 = data.reward1;
			reward2 = data.reward2;
			
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		
		public function get mission_name() : String{
			return _anti["mission_name"];
		}
		public function set mission_name(value:String) : void{
			_anti["mission_name"] = value;
		}
		
		public function get mission_rules() : String{
			return _anti["mission_rules"];
		}
		public function set mission_rules(value:String) : void{
			_anti["mission_rules"] = value;
		}
		
		public function get mission_description() : String{
			return _anti["mission_description"];
		}
		public function set mission_description(value:String) : void{
			_anti["mission_description"] = value;
		}
		
		public function get goldOrSoul() : int{
			return _anti["goldOrSoul"];
		}
		public function set goldOrSoul(value:int) : void{
			_anti["goldOrSoul"] = value;
		}
		
		public function get reward1() : int{
			return _anti["reward1"];
		}
		public function set reward1(value:int) : void{
			_anti["reward1"] = value;
		}
		
		public function get reward2() : int{
			return _anti["reward2"];
		}
		public function set reward2(value:int) : void{
			_anti["reward2"] = value;
		}
		

	}
}