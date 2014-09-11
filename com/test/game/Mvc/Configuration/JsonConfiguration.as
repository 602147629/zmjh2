package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class JsonConfiguration extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function JsonConfiguration(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			_anti["data"] = "";
		}
		
		public function get data() : String{
			return _anti["data"];
		}
		public function set data(value:String) : void{
			_anti["data"] = value;
		}
		
	}
}