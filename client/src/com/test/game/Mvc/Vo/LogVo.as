package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.NumberConst;
	
	public class LogVo extends BaseVO
	{
		
		public function LogVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			_giftLogs = new Vector.<LogGiftVo>;
			_missionLogs = new Vector.<LogMissionVo>;
			_anti["nameChange"] = NumberConst.getIns().zero;
		}
		
		private var _anti:Antiwear;
		
		//任务记录
		private var _missionLogs:Vector.<LogMissionVo>;
		public function get missionLogs():Vector.<LogMissionVo>
		{
			return _missionLogs;
		}
		public function set missionLogs(value:Vector.<LogMissionVo>):void
		{
			_missionLogs = value;
		}
		
		
		//礼包记录
		private var _giftLogs:Vector.<LogGiftVo>;
		public function get giftLogs():Vector.<LogGiftVo>
		{
			return _giftLogs;
		}
		public function set giftLogs(value:Vector.<LogGiftVo>):void
		{
			_giftLogs = value;
		}
		
		//改名记录
		public function get nameChange():int
		{
			return _anti["nameChange"];
		}
		public function set nameChange(value:int):void
		{
			_anti["nameChange"] = value;
		}
		
	
	}
}