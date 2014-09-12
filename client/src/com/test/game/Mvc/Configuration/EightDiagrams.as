package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class EightDiagrams extends BaseConfiguration
	{

		private var _anti:Antiwear;
		public function EightDiagrams(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["color"] = "";
			_anti["exp"] = "";
			_anti["add_type"] = [];
			_anti["add_value"] = [];
			_anti["info"] = 0;
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			name = data.name;
			color = data.color;
			exp = data.exp;
			add_type = data.add_type.split("|");
			add_value = data.add_value.split("|");
			info = data.info;
			
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
		
		public function get color() : String{
			return _anti["color"];
		}
		public function set color(value:String) : void{
			_anti["color"] = value;
		}
		
		public function get exp() : int{
			return _anti["exp"];
		}
		public function set exp(value:int) : void{
			_anti["exp"] = value;
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

		public function get info() : String{
			return _anti["info"];
		}
		public function set info(value:String) : void{
			_anti["info"] = value;
		}
		
	}
}