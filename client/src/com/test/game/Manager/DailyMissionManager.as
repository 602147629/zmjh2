package com.test.game.Manager
{
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.DailyMissionConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.DailyMissionFontEffect;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Modules.MainGame.Mission.MissionHint;
	import com.test.game.Modules.MainGame.Mission.MissionView;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.geom.Point;
	
	public class DailyMissionManager extends Singleton{
		public var startCreatNextDaily:Boolean;
		
		//随机5分钟
		private static const RATE:Number = 1 / 60;
		
		public function DailyMissionManager(){
			super();
		}
		
		public static function getIns():DailyMissionManager{
			return Singleton.getIns(DailyMissionManager);
		}
		
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		
		private var _stepCount:int = 0;
		private var _random:Number = 0;
		//获得下一个每日任务
		public function step():void{
			if(startCreatNextDaily){
				_stepCount++;
				if(_stepCount >= 30 * 5){
					_stepCount = 0;
					//trace(player.dailyMissionVo.missionCount);
					if(player.dailyMissionVo.missionCount <= NumberConst.getIns().five){
						getNextDailyMission();
					}else{
 						_random = Math.random();
						//DebugArea.getIns().showInfo("当前奇遇任务的概率为：" + 5 / ((player.dailyMissionVo.missionCount - 5) * 10 * 60));
						if(_random < NumberConst.getIns().five / ((player.dailyMissionVo.missionCount - NumberConst.getIns().five) * 10 * 60)){
							getNextDailyMission();
							_random = 0;
						}else{
							var time:int = (TimeManager.getIns().compareTime(player.dailyMissionVo.missionTime,TimeManager.getIns().returnTimeNowStr())) / (1000 * 60);
							if(time >= (player.dailyMissionVo.missionCount - NumberConst.getIns().five) * 10){
								getNextDailyMission();
								_random = 0;
							}
						}
					}
				}
			}
		}
		

		public function startGetNextDailyMission() : void{
			startCreatNextDaily = true;
			player.dailyMissionVo.missionTime = TimeManager.getIns().curTimeStr;	
			player.dailyMissionVo.missionDungeon = PlayerManager.getIns().getRandomDungeonName();
			player.dailyMissionVo.missionType = NumberConst.getIns().negativeOne;
		}
		
		private function getNextDailyMission():void{
			player.dailyMissionVo.getNextDailyMission();
			ViewFactory.getIns().getView(MissionHint).update();
			if(ViewFactory.getIns().getView(MissionView)!=null){
				ViewFactory.getIns().getView(MissionView).update();
			}
			startCreatNextDaily = false;
		}
		
		//判断是否是当前关卡的宝藏任务
		public function get isNowLevel() : Boolean{
			var result:Boolean = false;
			//if(player.dailyMissionVo.missionType == DailyMissionConst.TREASURE
			//	&& player.dailyMissionVo.isComplete == false){
				var arr:Array = player.dailyMissionVo.missionDungeon.split("_");
				if(LevelManager.getIns().nowIndex == arr[0] + "_" + arr[1]
					&& LevelManager.getIns().mapType == (arr.length==3?1:0)){
					result = true;
				}
			//}
			return result;
		}
		
		//判断当前关卡是否有障碍的任务
		public function obstacleJudge(index:int) : Boolean{
			var result:Boolean = false;
			if(index == 3){
				if(isDailyMissionStart){
					if(!judgeDailyComplete
						&& isNowLevel
						&& dailyMissionType == DailyMissionConst.OBSTACLE){
						result = true;
					}
				}
			}
			return result;
		}
		
		public function passLevelComplete(char:CharacterEntity) : void{
			if(passLevelJudge()){
				var fontFind:DailyMissionFontEffect = new DailyMissionFontEffect();
				fontFind.initOtherFontEffect(char, "PassComplete", new Point(10, 0));
			}
		}
		
		//判断当前关卡是否有悬赏的任务
		public function passLevelJudge() : Boolean{
			var result:Boolean = false;
			if(isDailyMissionStart){
				if(!judgeDailyComplete
					&& isNowLevel
					&& dailyMissionType == DailyMissionConst.PASSLEVEL){
					result = true;
				}
			}
			return result;
		}
		
		public function get judgeDailyComplete() : Boolean{
			return player.dailyMissionVo.isComplete;
		}
		
		public function setDailyComplete() : void{
			player.dailyMissionVo.isComplete = true;
		}
		
		public function get isDailyMissionComplete() : Boolean{
			return player.dailyMissionVo.isComplete;
		}
		
		public function get dailyMissionType() : int{
			return player.dailyMissionVo.missionType;
		}
		
		public function get checkDailyMission() : Boolean{
			if(player.mainMissionVo.id > 1012){
				return true;
			}else{
				return false;
			}
		}
		
		public function clear() : void{
			startCreatNextDaily = false;
		}
		
		public function get isDailyMissionStart() : Boolean{
			//return false;
			if(player.mainMissionVo.id > 1012){
				return true;
			}else{
				return false;
			}
		}
		
		
	}
}