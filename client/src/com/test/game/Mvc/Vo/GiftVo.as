package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class GiftVo extends BaseVO
	{
		public function GiftVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["isGet"] = false;
			_anti["getTime"] = "";
		}
		
		private var _anti:Antiwear;	
		
		/**
		 * 礼包ID
		 */
		public function get id() : int
		{
			return _anti["id"];
		}
		public function set id(value:int) : void
		{
			_anti["id"] = value;
		}
		
		/**
		 * 该礼包是否已经领取
		 */		
		public function get isGet() : Boolean
		{
			return _anti["isGet"];
		}
		public function set isGet(value:Boolean) : void
		{
			_anti["isGet"] = value;
		}
		
		/**
		 * 该礼包领取时间
		 */		
		public function get getTime() : String
		{
			return _anti["getTime"];
		}
		public function set getTime(value:String) : void
		{
			_anti["getTime"] = value;
		}
		
		
	}
}