package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Mission extends BaseConfiguration
	{
		public function Mission()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["lv"] = 0;
			_anti["mission_name"] = "";
			_anti["mission_rules_level"] = 0;
			_anti["mission_rules"] = "";
			_anti["mission_description"] = "";
			_anti["equipment"] = "";
			_anti["item"] = "";
			_anti["item_number"] = "";
			_anti["gold"] = 0;
			_anti["soul"] = 0;
			_anti["exp"] = 0;
			_anti["newFunction"] = 0;
			_anti["evaluation"] = 0;
		}
		
		private var _anti:Antiwear;
		
		
		override public function assign(data:Object):void{
			id = data.id;
			lv = data.lv;
			mission_name = data.mission_name;
			mission_rules_level = data.mission_rules_level;
			mission_rules = data.mission_rules;
			mission_description = data.mission_description;
			equipment = data.equipment;
			item = data.item;
			item_number = data.item_number;
			gold = data.gold;
			soul = data.soul;
			exp = data.exp;
			newFunction = data.newFunction;
			evaluation = data.evaluation;
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		public function get lv() : int{
			return _anti["lv"];
		}
		public function set lv(value:int) : void{
			_anti["lv"] = value;
		}
		
		public function get mission_name() : String{
			return _anti["mission_name"];
		}
		public function set mission_name(value:String) : void{
			_anti["mission_name"] = value;
		}
		

		public function get mission_rules_level() : String{
			return _anti["mission_rules_level"];
		}
		public function set mission_rules_level(value:String) : void{
			_anti["mission_rules_level"] = value;
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
		
		

		
		public function get equipment() : String{
			return _anti["equipment"];
		}
		public function set equipment(value:String) : void{
			_anti["equipment"] = value;
		}
		
		public function get item() : String{
			return _anti["item"];
		}
		public function set item(value:String) : void{
			_anti["item"] = value;
		}
		
		
		public function get item_number() : String{
			return _anti["item_number"];
		}
		public function set item_number(value:String) : void{
			_anti["item_number"] = value;
		}
		
		public function get gold() : int{
			return _anti["gold"];
		}
		public function set gold(value:int) : void{
			_anti["gold"] = value;
		}
		
		public function get soul() : int{
			return _anti["soul"];
		}
		public function set soul(value:int) : void{
			_anti["soul"] = value;
		}
		
		public function get exp() : int{
			return _anti["exp"];
		}
		public function set exp(value:int) : void{
			_anti["exp"] = value;
		}
		
		public function get newFunction() : String{
			return _anti["newFunction"];
		}
		public function set newFunction(value:String) : void{
			_anti["newFunction"] = value;
		}
		
		public function get evaluation() : int{
			return _anti["evaluation"];
		}
		public function set evaluation(value:int) : void{
			_anti["evaluation"] = value;
		}

	}
}