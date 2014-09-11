package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class SignMonth extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function SignMonth()
		{
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["month"] = "";
			_anti["green"] = 0;
			_anti["blue"] = 0;
			_anti["purple"] = 0;
		}
		
		override public function assign(data:Object):void{
			month = data.month;
			green = data.green;
			blue = data.blue;
			purple = data.purple;
		}
		
		public function get month() : String{
			return _anti["month"];
		}
		public function set month(value:String) : void{
			_anti["month"] = value;
		}
		
		public function get green() : int{
			return _anti["green"];
		}
		public function set green(value:int) : void{
			_anti["green"] = value;
		}
		
		public function get blue() : int{
			return _anti["blue"];
		}
		public function set blue(value:int) : void{
			_anti["blue"] = value;
		}
		
		public function get purple() : int{
			return _anti["purple"];
		}
		public function set purple(value:int) : void{
			_anti["purple"] = value;
		}
	}
}