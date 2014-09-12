package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.test.game.Mvc.Vo.LogGiftVo;
	import com.test.game.Mvc.Vo.LogMissionVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class LogManager extends Singleton
	{
		public function LogManager()
		{
			super();
		}
		
		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public static function getIns():LogManager{
			return Singleton.getIns(LogManager);
		}
		
		public function addGiftLog(id:int,type:String=""):void{
			var gift:LogGiftVo = new LogGiftVo();
			gift.type = type;
			gift.id = id;
			gift.time = TimeManager.getIns().returnTimeNowStr();
			player.logVo.giftLogs.push(gift);
		}
		
		public function addMissionLog(type:String,num:int):void{
			var mission:LogMissionVo = new LogMissionVo();
			mission.type = type;
			mission.num = num;
			mission.time = TimeManager.getIns().returnTimeNowStr();
			player.logVo.missionLogs.push(mission);
		}
		
		public function addCheatLog(type:String,num:int):void{
			var bol:Boolean;
			for each(var log:LogMissionVo in player.logVo.missionLogs){
				if(log.type == type){
					bol = true;
					log.num = num;
					log.time = TimeManager.getIns().returnTimeNowStr();	
					break;
				}
			}
			
			if(!bol){
				var mission:LogMissionVo = new LogMissionVo();
				mission.type = type;
				mission.num = num;
				mission.time = TimeManager.getIns().returnTimeNowStr();	
				player.logVo.missionLogs.push(mission);	
			}

		}
	}
}