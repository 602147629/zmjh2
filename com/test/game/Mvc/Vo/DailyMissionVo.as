package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.TimeManager;
	
	public class DailyMissionVo extends BaseVO{
		private var _anti:Antiwear;
		public function DailyMissionVo(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["missionTime"] = "";
			_anti["missionType"] = 0;
			_anti["missionDungeon"] = "";
			_anti["missionCount"] = 0;
			_anti["isComplete"] = false;
			_anti["materialType"] = 0;

		}
		
	
		public function get materialType() : int{
			return _anti["materialType"];
		}
		public function set materialType(value:int) : void{
			_anti["materialType"] = value;
		}
		
		//任务时间
		public function get missionTime() : String{
			return _anti["missionTime"];
		}
		public function set missionTime(value:String) : void{
			_anti["missionTime"] =  value;
		}
		//任务类型
		public function get missionType() : int{
			return _anti["missionType"];
		}
		public function set missionType(value:int) : void{
			_anti["missionType"] = value;
		}
		//任务关卡
		public function get missionDungeon() : String{
			return _anti["missionDungeon"];
		}
		public function set missionDungeon(value:String) : void{
			_anti["missionDungeon"] = value;
		}
		//任务次数
		public function get missionCount() : int{
			return _anti["missionCount"];
		}
		public function set missionCount(value:int) : void{
			_anti["missionCount"] = value;
		}
		//是否完成
		public function get isComplete() : Boolean{
			return _anti["isComplete"]
		}
		public function set isComplete(value:Boolean) : void{
			_anti["isComplete"] = value;
		}
		
		//判断是否刷新每日任务
		public function judgeResetDailyMission() : void{
			if(missionTime == ""){
				initDailyMission();
			}else{
				var result:Boolean = TimeManager.getIns().checkEveryDayPlay(missionTime.split("_")[0]);
				if(!result){
					initDailyMission();
				}
			}
			
			if(missionDungeon == ""){
				missionDungeon = PlayerManager.getIns().getRandomDungeonName();
			}
			
			if(missionType==NumberConst.getIns().negativeOne && missionTime!="" ){
				var time:int = (TimeManager.getIns().compareTime(missionTime,TimeManager.getIns().curTimeStr))/(1000*60);
				if(time>=(missionCount -5)*5 && missionCount>5){
					getNextDailyMission();
				}else{
					DailyMissionManager.getIns().startCreatNextDaily = true;
				}
			}
		}
		
		private function initDailyMission() : void{
			missionTime = TimeManager.getIns().curTimeStr;
			missionCount = 0;
			missionDungeon = PlayerManager.getIns().getRandomDungeonName();
			missionType = int(Math.random() * 4) + 1;
			if(judgeBossLevel(missionDungeon)){
				materialType = int(Math.random() * 3);
			}
			isComplete = false;
		}
		
		public function getNextDailyMission() : void{
			missionCount++;
			isComplete = false;
			missionType = int(Math.random() * 4) + 1;
			if(judgeBossLevel(missionDungeon)){
				materialType = int(Math.random() * 3);
			}
		}
		
		private function judgeBossLevel(dungeon:String) : Boolean{
			var result:Boolean = false;
			var arr:Array = dungeon.split("_");
			if(arr[1] % 3 == 0){
				result = true;
			}
			return result;
		}
		
	}
}