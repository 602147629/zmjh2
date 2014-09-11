package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Charge extends BaseConfiguration
	{

		private var _anti:Antiwear;
		public function Charge(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["soul"] = 0;
			_anti["type"] = [];
			_anti["value"] = [];
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			name = data.name;
			soul = data.soul;
			type = data.type.split("|");
			value = data.value.split("|");
			
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
		
		public function get soul() : int{
			return _anti["soul"];
		}
		public function set soul(value:int) : void{
			_anti["soul"] = value;
		}
		
		
		public function get type() : Array{
			return _anti["type"];
		}
		public function set type(value:Array) : void{
			_anti["type"] = value;
		}
		
		public function get value() : Array{
			return _anti["value"];
		}
		public function set value(value:Array) : void{
			_anti["value"] = value;
		}

	}
}