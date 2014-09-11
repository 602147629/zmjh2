package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Festivals extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function Festivals()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			number = data.number;
			type = data.type;
			prop_id = data.prop_id;
			prop_number = data.prop_number;
			gold = data.gold;
			soul = data.soul;
			title = data.title;
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		public function get number() : int{
			return _anti["number"];
		}
		public function set number(value:int) : void{
			_anti["number"] = value;
		}
		
		public function get type() : int{
			return _anti["type"];
		}
		public function set type(value:int) : void{
			_anti["type"] = value;
		}
		
		public function get prop_id() : String{
			return _anti["prop_id"];
		}
		public function set prop_id(value:String) : void{
			_anti["prop_id"] = value;
		}
		
		public function get prop_number() : String{
			return _anti["prop_number"];
		}
		public function set prop_number(value:String) : void{
			_anti["prop_number"] = value;
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
		
		public function get title() : int{
			return _anti["title"];
		}
		public function set title(value:int) : void{
			_anti["title"] = value;
		}
	}
}