package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class PublicNotice extends BaseConfiguration
	{
		public function PublicNotice()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["message"] = "";
		}
		
		private var _anti:Antiwear;
		
		
		override public function assign(data:Object):void{
			id = data.id;
			name = data.name;
			message = data.message;
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


	}
}