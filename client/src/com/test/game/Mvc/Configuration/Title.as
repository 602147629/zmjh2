package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Title extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function Title(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["type"] = "";
			_anti["message"] = "";
			_anti["add_type"] = [];
			_anti["add_value"] = [];

		}
		
		override public function assign(data:Object):void{
			id = data.id;
			name = data.name;
			type = data.type;
			message = data.message;
			add_type = data.add_type.split("|");
			add_value = data.add_value.split("|");
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
		
		
		
		public function get message() : String{
			return _anti["message"];
		}
		public function set message(value:String) : void{
			_anti["message"] = value;
		}
		
		public function get type() : String{
			return _anti["type"];
		}
		public function set type(value:String) : void{
			_anti["type"] = value;
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
		


	}
}