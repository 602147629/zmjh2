package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Book extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function Book(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["type"] = "";
			_anti["message"] = "";
			_anti["location"] = "";
			_anti["sale_money"] = "";
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			name = data.name;
			type = data.type;
			message = data.message;
			location = data.location;
			sale_money = data.sale_money;
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
		
		public function get type() : String{
			return _anti["type"];
		}
		public function set type(value:String) : void{
			_anti["type"] = value;
		}
		
		public function get message() : String{
			return _anti["message"];
		}
		public function set message(value:String) : void{
			_anti["message"] = value;
		}
		
		public function get location() : String{
			return _anti["location"];
		}
		public function set location(value:String) : void{
			_anti["location"] = value;
		}
		
		
		public function get sale_money() : int{
			return _anti["sale_money"];
		}
		public function set sale_money(value:int) : void{
			_anti["sale_money"] = value;
		}
		
	}
}