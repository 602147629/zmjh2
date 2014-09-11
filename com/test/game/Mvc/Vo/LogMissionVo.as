package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class LogMissionVo extends BaseVO
	{
		public function LogMissionVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			type =  "";
			num  = 0;
			time =  "";
		}
		
		private var _anti:Antiwear;
		
		public function set type(value:String) : void
		{
			_anti["type"] = value;
		}
		public function get type() : String
		{
			return 	_anti["type"];
		}
		
		public function set num(value:int) : void
		{
			_anti["num"] = value;
		}
		public function get num() : int
		{
			return 	_anti["num"];
		}
		
		public function set time(value:String) : void
		{
			_anti["time"] = value;
		}
		public function get time() : String
		{
			return 	_anti["time"];
		}
	}
}