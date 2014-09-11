package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Shop extends BaseConfiguration
	{

		private var _anti:Antiwear;
		public function Shop()
		{
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["propId"] = 0;
			_anti["type"] = "";
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			name = data.name;
			propId = data.propId;
			type = data.type;
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
		
		public function get propId() : int{
			return _anti["propId"];
		}
		public function set propId(value:int) : void{
			_anti["propId"] = value;
		}
		
		public function get type() : String{
			return _anti["type"];
		}
		public function set type(value:String) : void{
			_anti["type"] = value;
		}
	}
}