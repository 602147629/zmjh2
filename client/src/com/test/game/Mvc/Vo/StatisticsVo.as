package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.StatisticsManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Manager.Gift.ContinueLandManager;
	
	public class StatisticsVo extends BaseVO
	{
		private var _anti:Antiwear;
		
		public function get statisticsTime() : String{
			return _anti["statisticsTime"];
		}
		public function set statisticsTime(value:String) : void{
			_anti["statisticsTime"] = value;
		}
		public function get publicNoticeCount() : int{
			return _anti["publicNoticeCount"];
		}
		public function set publicNoticeCount(value:int) : void{
			_anti["publicNoticeCount"] = value;
		}
		public function get weatherPropCount() : int{
			return _anti["weatherPropCount"];
		}
		public function set weatherPropCount(value:int) : void{
			_anti["weatherPropCount"] = value;
		}
		
		public function get funnyBossCount() : int{
			return _anti["funnyBossCount"];
		}
		public function set funnyBossCount(value:int) : void{
			_anti["funnyBossCount"] = value;
		}
		
		public function get midAutumnCount() : int{
			return _anti["midAutumnCount"];
		}
		public function set midAutumnCount(value:int) : void{
			_anti["midAutumnCount"] = value;
		}
		
		public function StatisticsVo(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["statisticsTime"] = "";
			_anti["publicNoticeCount"] = 0;
			_anti["weatherPropCount"] = 0;
			_anti["funnyBossCount"] = 0;
			_anti["midAutumnCount"] = 0;
		}
		
		public function judgeStatistics() : Boolean{
			var isSave:Boolean = false;
			if(statisticsTime != ""){
				var result:Boolean = TimeManager.getIns().checkEveryDayPlay(statisticsTime.split("_")[0]);
				if(!result){
					statisticsTime = TimeManager.getIns().returnTimeNowStr();
					StatisticsManager.getIns().sendData();
					ContinueLandManager.getIns().sendData();
					publicNoticeCount = NumberConst.getIns().zero;
					weatherPropCount = NumberConst.getIns().zero;
					funnyBossCount = NumberConst.getIns().zero;
					midAutumnCount = NumberConst.getIns().zero;
					isSave = true;
				}
			}else{
				statisticsTime = TimeManager.getIns().returnTimeNowStr();
				StatisticsManager.getIns().sendData();
				ContinueLandManager.getIns().sendData();
				publicNoticeCount = NumberConst.getIns().zero;
				weatherPropCount = NumberConst.getIns().zero;
				funnyBossCount = NumberConst.getIns().zero;
				midAutumnCount = NumberConst.getIns().zero;
				isSave = true;
			}
			return isSave;
		}
	}
}