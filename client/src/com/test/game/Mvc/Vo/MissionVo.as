package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class MissionVo extends BaseVO
	{
		
		public function MissionVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["isComplete"] = false;
		}
		
		private var _anti:Antiwear;	
		
		/**
		 * 任务ID
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
		 * 该任务是否领取奖励
		 */		
		public function get isComplete() : Boolean
		{
			return _anti["isComplete"];
		}
		public function set isComplete(value:Boolean) : void
		{
			_anti["isComplete"] = value;
		}

		

	}
}