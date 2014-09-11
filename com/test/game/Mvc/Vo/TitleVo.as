package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class TitleVo extends BaseVO
	{
		public function TitleVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			_anti["titleNow"] = -1;
			_anti["titleShow"] = 1;
			_anti["titleOwned"] = [];
		}
		
		private var _anti:Antiwear;
		
		public function get titleNow():int
		{
			return _anti["titleNow"];
		}
		public function set titleNow(value:int):void
		{
			_anti["titleNow"] = value;
		}
		
		public function get titleShow():int
		{
			return _anti["titleShow"];
		}
		public function set titleShow(value:int):void
		{
			_anti["titleShow"] = value;
		}
		
		public function get titleOwned():Array
		{
			return _anti["titleOwned"];
		}
		public function set titleOwned(value:Array):void
		{
			_anti["titleOwned"] = value;
		}
	}
}