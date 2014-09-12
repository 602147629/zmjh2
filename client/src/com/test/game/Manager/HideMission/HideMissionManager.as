package com.test.game.Manager.HideMission
{
	import com.superkaka.Tools.Singleton;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.DailyMissionFontEffect;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Mvc.Configuration.HideMission;
	import com.test.game.Mvc.Vo.DungeonPassVo;
	import com.test.game.Mvc.Vo.HideMissionVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class HideMissionManager extends Singleton
	{
		public static const MOZHULIN_ID:int = 3001;
		public static const TAIXUGUAM_ID:int = 3011;
		public static const WANEGU_ID:int = 3021;
		private var _pointerIndex:String;
		private var _sceneObject:Array = new Array();
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public function HideMissionManager(){
			super();
		}
		
		public static function getIns():HideMissionManager{
			return Singleton.getIns(HideMissionManager);
		}
		
		//墨竹林异闻任务
		public function get checkMoZhuLinOpen() : Boolean{
			if(player.mainMissionVo.id > 1017){
				return true;
			}else{
				return false;
			}
		}
		
		public function get checkTaiXuGuanOpen() : Boolean{
			if(player.mainMissionVo.id > 1027){
				return true;
			}else{
				return false;
			}
		}
		
		public function get checkWanEGuOpen() : Boolean{
			if(player.mainMissionVo.id > 1037){
				return true;
			}else{
				return false;
			}
		}
		
		public function openNextHideMission(missionID:int) : int{
			var nowMissionID:int = missionID;
			for(var i:int = 0; i < player.hideMissionInfo.length; i++){
				if(player.hideMissionInfo[i].id == missionID){
					player.hideMissionInfo[i].isShow = false;
				}
			}
			var nextMissionID:int = nowMissionID + 1;
			var obj:HideMission = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.HIDE_MISSION, "id", nextMissionID) as HideMission;
			if(obj != null){
				addHideMission(nextMissionID);
			}else{
				nextMissionID = -1;
			}
			addHideDungeon(missionID);
			return nextMissionID;
		}
		
		private function addHideDungeon(missionID:int):void{
			var dungeon:String = "";
			switch(missionID){
				case MOZHULIN_ID:
					dungeon = "1_10";
					break;
				case TAIXUGUAM_ID:
					dungeon = "2_10";
					break;
				case WANEGU_ID:
					dungeon = "3_10";
					break;
			}
			if(dungeon != ""){
				if(!PlayerManager.getIns().hasDungeonInfo(dungeon)){
					var normalItem:DungeonPassVo = new DungeonPassVo();
					normalItem.lv = NumberConst.getIns().negativeOne;
					normalItem.name = dungeon;
					player.dungeonPass.push(normalItem);
				}
			}
		}
		
		public function addHideMission(missionID:int):void{
			if(!hasHideMission(missionID)){
				var obj:HideMission = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.HIDE_MISSION, "id", missionID) as HideMission;
				var hideMissioVo:HideMissionVo = new HideMissionVo();
				hideMissioVo.id = missionID;
				hideMissioVo.isComplete = false;
				hideMissioVo.isShow = true;
				var arr:Array = [];
				for(var i:int = 0; i < obj.rules_number; i++){
					arr.push(NumberConst.getIns().zero);
				}
				hideMissioVo.missionConfig = arr;
				player.hideMissionInfo.push(hideMissioVo);
			}
		}
		
		public function init() : void{
			if(LevelManager.getIns().mapType == 0){
				MoZhuHideMissionManager.getIns().init();
				TaiXuHideMissionManager.getIns().init();
				WanEGuMissionManager.getIns().init();
			}
		}
		
		//返回是否有该ID的异闻任务
		public function hasHideMission(missionID:int) : Boolean{
			var result:Boolean = false;
			for(var i:int = 0; i < player.hideMissionInfo.length; i++){
				if(player.hideMissionInfo[i].id == missionID){
					result = true;
					break;
				}
			}
			return result;
		}
		
		//获得当前异闻任务的索引
		public function getHideMissionIndex(missionID:int) : int{
			var result:int = -1;
			for(var i:int = 0; i < player.hideMissionInfo.length; i++){
				if(player.hideMissionInfo[i].id == missionID){
					result = i;
					break;
				}
			}
			return result;
		}
		
		public function setMissionCompleteByIndex(index:int, count:int) : void{
			var arr:Array = player.hideMissionInfo[index].missionConfig;
			arr[count] = NumberConst.getIns().one;
			player.hideMissionInfo[index].missionConfig = arr;
		}
		
		public function showWord(missionID:int, count:int) : void{
			var index:int;
			switch(missionID){
				case MOZHULIN_ID:
					index = 1;
					break;
				case TAIXUGUAM_ID:
					index = 2;
					break;
				case WANEGU_ID:
					index = 3;
					break;
			}
			var wordEffect:DailyMissionFontEffect = new DailyMissionFontEffect();
			wordEffect.initOtherFontEffect(SceneManager.getIns().nowScene,
				"HideMissionWord" + index + "_" + count,
				SceneManager.getIns().nowScene["myPlayer"].pos);
		}
		
		public function judgeMissionComplete(missionID:int) : void{
			var index:int = getHideMissionIndex(missionID);
			var result:Boolean = true;
			for(var i:int = 0; i < player.hideMissionInfo[index].missionConfig.length; i++){
				if(player.hideMissionInfo[index].missionConfig[i] == NumberConst.getIns().zero){
					result = false;
					break;
				}
			}
			if(result){
				player.hideMissionInfo[index].isComplete = true;
			}
		}
		
		public function step() : void{
			MoZhuHideMissionManager.getIns().step();
			TaiXuHideMissionManager.getIns().step();
			WanEGuMissionManager.getIns().step();
		}
		
		public function get returnHasHideMission() : Boolean{
			var result:Boolean = false;
			if((hasHideMission(MOZHULIN_ID) && !returnHideMissionStatus(MOZHULIN_ID))
				|| (hasHideMission(TAIXUGUAM_ID) && !returnHideMissionStatus(TAIXUGUAM_ID))
				|| (hasHideMission(WANEGU_ID) && !returnHideMissionStatus(WANEGU_ID))){
				result = true;
			}
			return result;
		}
		
		//异闻任务是否完成
		public function returnHideMissionStatus(missionID:int) : Boolean{
			var result:Boolean = false;
			if(hasHideMission(missionID)){
				var index:int = getHideMissionIndex(missionID);
				if(player.hideMissionInfo[index].isComplete == true){
					result = true;
				}
			}
			return result;
		}
		
		//异闻任务是否显示
		public function returnHideMissionShow(missionID:int) : Boolean{
			var result:Boolean = false;
			if(hasHideMission(missionID)){
				var index:int = getHideMissionIndex(missionID);
				if(player.hideMissionInfo[index].isShow == true){
					result = true;
				}
			}
			return result;
		}
		
		public function returnHideMissionComplete(missionID:int) : Boolean{
			var result:Boolean = false;
			if(HideMissionManager.getIns().returnHideMissionStatus(missionID) && !HideMissionManager.getIns().returnHideMissionShow(missionID)){
				result = true;
			}
			return result;
		}
		
		public function clear() : void{
			MoZhuHideMissionManager.getIns().clear();
			TaiXuHideMissionManager.getIns().clear();
			WanEGuMissionManager.getIns().clear();
		}
	}
}