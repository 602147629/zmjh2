package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class JingMai extends BaseConfiguration
	{

		private var _anti:Antiwear;
		public function JingMai(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["gold"] = 0;
			_anti["point_name"] = [];
			_anti["add_type"] = [];
			_anti["add_value"] = [];
			_anti["next"] = [];
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			name = data.name;
			gold = data.gold;
			point_name = data.point_name.split("|");
			add_type = data.add_type.split("|");
			add_value = data.add_value.split("|");
			next = data.next.split("|");
			
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
		
		public function get gold() : int{
			return _anti["gold"];
		}
		public function set gold(value:int) : void{
			_anti["gold"] = value;
		}
		
		public function get point_name() : Array{
			return _anti["point_name"];
		}
		public function set point_name(value:Array) : void{
			_anti["point_name"] = value;
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

		public function get next() : Array{
			return _anti["next"];
		}
		public function set next(value:Array) : void{
			_anti["next"] = value;
		}
		
	}
}