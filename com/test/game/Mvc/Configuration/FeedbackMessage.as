package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class FeedbackMessage extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function FeedbackMessage()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["field"] = "";
			_anti["info"] = "";
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			field = data.field;
			info = data.info;
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		public function get field() : String{
			return _anti["field"];
		}
		public function set field(value:String) : void{
			_anti["field"] = value;
		}
		
		public function get info() : String{
			return _anti["info"];
		}
		public function set info(value:String) : void{
			_anti["info"] = value;
		}
	}
}