package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class UpdateMessage extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function UpdateMessage()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["version"] = 0;
			_anti["sequence"] = 0;
			info = "";
		}
		
		override public function assign(data:Object):void{
			version = data.version;
			sequence = data.sequence;
			info = data.info;
		}
		
		public function get version() : int{
			return _anti["version"];
		}
		public function set version(value:int) : void{
			_anti["version"] = value;
		}
		
		public function get sequence() : int{
			return _anti["sequence"];
		}
		public function set sequence(value:int) : void{
			_anti["sequence"] = value;
		}
		
		public var info:String;
	}
}