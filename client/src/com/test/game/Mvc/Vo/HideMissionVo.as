package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class HideMissionVo extends BaseVO
	{
		private var _anti:Antiwear;
		public function HideMissionVo()
		{
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["id"] = 0;
			_anti["missionConfig"] = new Array();
			_anti["isComplete"] = false;
			_anti["isShow"] = true;
		}
		
		/**
		 * 任务ID
		 */
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		/**
		 * 该任务是否领取奖励
		 */		
		public function get isComplete() : Boolean{
			return _anti["isComplete"];
		}
		public function set isComplete(value:Boolean) : void{
			_anti["isComplete"] = value;
		}
		
		public function get isShow() : Boolean{
			return _anti["isShow"];
		}
		public function set isShow(value:Boolean) : void{
			_anti["isShow"] = value;
		}
		
		public function get missionConfig() : Array{
			return _anti["missionConfig"];
		}
		public function set missionConfig(value:Array) : void{
			_anti["missionConfig"] = value;
		}
	}
}