package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class DungeonPassVo extends BaseVO
	{
		public function DungeonPassVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["name"] = "";
			_anti["lv"] = 0;
			_anti["hit"] = 0;
			_anti["time"] = 0;
			_anti["hurt"] = 0;
			_anti["add"] = 0;
		}
		
		private var _anti:Antiwear;	
		
		/**
		 * 关卡名称 
		 */
		//public var name:String;
		public function get name() : String
		{
			return _anti["name"];
		}
		public function set name(value:String) : void
		{
			_anti["name"] = value;
		}
		
		/**
		 * 评价
		 */		
		public function get lv() : int
		{
			return _anti["lv"];
		}
		public function set lv(value:int) : void
		{
			_anti["lv"] = value;
		}
		
		/**
		 * 连击
		 */		
		public function get hit() : int
		{
			return _anti["hit"];
		}
		public function set hit(value:int) : void
		{
			_anti["hit"] = value;
		}
		
		/**
		 * 时间
		 */		
		public function get time() : int
		{
			return _anti["time"];
		}
		public function set time(value:int) : void
		{
			_anti["time"] = value;
		}
		
		/**
		 * 受击
		 */		
		public function get hurt() : int
		{
			return _anti["hurt"];
		}
		public function set hurt(value:int) : void
		{
			_anti["hurt"] = value;
		}
		
		/**
		 * 附加分
		 */		
		public function get add() : int
		{
			return _anti["add"];
		}
		public function set add(value:int) : void
		{
			_anti["add"] = value;
		}
		

	}
}