package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Special extends BaseConfiguration
	{
		public function Special()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["type"] = "";
			_anti["message"] = "";
			_anti["bid"] = 0;
			_anti["sale_money"] = 0;
		}
		
		private var _anti:Antiwear;
		
		
		override public function assign(data:Object):void{
			id = data.id;
			name = data.name;
			type = data.type;
			message = data.message;
			bid = data.bid;
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
		
		public function get bid() : int{
			return _anti["bid"];
		}
		public function set bid(value:int) : void{
			_anti["bid"] = value;
		}
		
		public function get sale_money() : int{
			return _anti["sale_money"];
		}
		public function set sale_money(value:int) : void{
			_anti["sale_money"] = value;
		}
		
		
		
	}
}