package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.NumberConst;
	
	public class LogGiftVo extends BaseVO
	{
		public function LogGiftVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			id =  NumberConst.getIns().zero;
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
		
		public function set id(value:int) : void
		{
			_anti["id"] = value;
		}
		public function get id() : int
		{
			return 	_anti["id"];
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