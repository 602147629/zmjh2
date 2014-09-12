package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class EightDiagramSuits extends BaseConfiguration
	{

		
		private var _anti:Antiwear;
		public function EightDiagramSuits(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["name"] = new Array();
			_anti["name"] = new Array();
			_anti["name"] = new Array();

		}
		
		override public function assign(data:Object):void{
			id = data.id;
			name = data.name;
			first_add = data.first_add.split("|");
			second_add = data.second_add.split("|");
			third_add = data.third_add.split("|");
	
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
		

		

		public function get first_add() : Array{
			return _anti["first_add"];
		}
		public function set first_add(value:Array) : void{
			_anti["first_add"] = value;
		}
		
		
		public function get second_add() : Array{
			return _anti["second_add"];
		}
		public function set second_add(value:Array) : void{
			_anti["second_add"] = value;
		}
		
		
		public function get third_add() : Array{
			return _anti["third_add"];
		}
		public function set third_add(value:Array) : void{
			_anti["third_add"] = value;
		}

	}
}