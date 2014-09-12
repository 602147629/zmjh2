package com.test.game.Manager.HideMission
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.WeatherConst;
	import com.test.game.Effect.DailyMissionFontEffect;
	import com.test.game.Entitys.HideMission.ActionMissionEntity;
	import com.test.game.Entitys.HideMission.BaseHideMissionEntity;
	import com.test.game.Entitys.HideMission.TimeMissionEntity;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.WeatherManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class MoZhuHideMissionManager extends Singleton
	{
		private var _pointerIndex:String;
		private var _sceneObject:Array = new Array();
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public function MoZhuHideMissionManager()
		{
			super();
		}
		
		public static function getIns():MoZhuHideMissionManager{
			return Singleton.getIns(MoZhuHideMissionManager);
		}
		
		public function init() : void{
			switch(LevelManager.getIns().nowIndex){
				case "1_2":
					createMission1_2();
					_pointerIndex = "1_2";
					break;
				case "1_3":
					createMission1_3();
					_pointerIndex = "1_3";
					break;
				case "1_6":
					createMission1_6();
					_pointerIndex = "1_6";
					break;
				case "1_8":
					createMission1_8();
					_pointerIndex = "1_8";
					break;
				case "1_9":
					createMission1_9();
					_pointerIndex = "1_9";
					break;
			}
		}
		
		private function createMission1_2() : void{
			var ArrowEntity:TimeMissionEntity = new TimeMissionEntity(["HideMission1_3"]);
			ArrowEntity.x = 4481;
			ArrowEntity.y = 142;
			SceneManager.getIns().nowScene.addChild(ArrowEntity);
			_sceneObject.push(ArrowEntity);
		}
		
		private function createMission1_3() : void{
			var RopeEntity:BaseHideMissionEntity = new BaseHideMissionEntity(["HideMission1_2_1"]);
			RopeEntity.x = 2120;
			RopeEntity.y = 65;
			SceneManager.getIns().nowScene.addChild(RopeEntity);
			_sceneObject.push(RopeEntity);
			var boxEntity:BaseHideMissionEntity = new BaseHideMissionEntity(["HideMission1_2_2", "HideMission1_2_3"], "ShiFangXiuCaiSkill1", 80, true);
			boxEntity.x = 2075;
			boxEntity.y = 248;
			SceneManager.getIns().nowScene.addChild(boxEntity);
			_sceneObject.push(boxEntity);
		}
		
		private function createMission1_6() : void{
			var LightEntity:BaseHideMissionEntity = new BaseHideMissionEntity(["HideMission1_6"], "BiChiFuRenSkill1", 120);
			LightEntity.x = 3726;
			LightEntity.y = 203;
			_sceneObject.push(LightEntity);
		}
		
		private function createMission1_8() : void{
			var doorEntity:BaseHideMissionEntity = new BaseHideMissionEntity(["HideMission1_8_1", "HideMission1_8_2"], "BuTongLaoRenSkill1", 120);
			doorEntity.x = 4108;
			doorEntity.y = 30;
			doorEntity.shadow.y = 300;
			_sceneObject.push(doorEntity);
		}
		
		private function createMission1_9() : void{
			var vo:CharacterVo = new CharacterVo();
			vo.id = 10019;
			vo.assetsArray = ["HideMission1_9"];
			vo.isDouble = false;
			var actionEntity:ActionMissionEntity = new ActionMissionEntity(
				SceneManager.getIns().myPlayer.charData.totalProperty.hp,
				vo);
			//actionEntity.y = 400;
			actionEntity.x = 500;
			_sceneObject.push(actionEntity);
		}
		
		public function setHideMissionComplete(missionID:int = 3001) : void{
			var index:int = HideMissionManager.getIns().getHideMissionIndex(missionID);
			if(index != -1){
				var nowCount:int = -1;
				switch(_pointerIndex){
					case "1_2":
						nowCount = 0;
						break;
					case "1_3":
						nowCount = 1;
						break;
					case "1_6":
						nowCount = 2;
						break;
					case "1_8":
						nowCount = 3;
						break;
					case "1_9":
						nowCount = 4;
				}
				if(nowCount != -1){
					if(player.hideMissionInfo[index].missionConfig[nowCount] == NumberConst.getIns().zero){
						HideMissionManager.getIns().showWord(missionID, nowCount + 1);
					}
					HideMissionManager.getIns().setMissionCompleteByIndex(index, nowCount);
					HideMissionManager.getIns().judgeMissionComplete(missionID);
				}
			}
		}
		
		public function step() : void{
			if(WeatherManager.getIns().weatherStatus == WeatherConst.WEATHER_BLACK){
				if(_pointerIndex == "1_6" || _pointerIndex == "1_9"){
					if(_sceneObject.length > 0){
						if(_sceneObject[0].parent == null){
							SceneManager.getIns().nowScene.addChild(_sceneObject[0]);
							RenderEntityManager.getIns().addEntity(_sceneObject[0]);
							PhysicsWorld.getIns().addEntity(_sceneObject[0]);
						}
					}
				}
			}else if(WeatherManager.getIns().weatherStatus == WeatherConst.WEATHER_RAIN){
				if(_pointerIndex == "1_8"){
					if(_sceneObject.length > 0){
						if(_sceneObject[0].parent == null){
							SceneManager.getIns().nowScene.addChild(_sceneObject[0]);
							RenderEntityManager.getIns().addEntity(_sceneObject[0]);
							PhysicsWorld.getIns().addEntity(_sceneObject[0]);
						}
					}
				}
			}else{
				if(_pointerIndex == "1_6" || _pointerIndex == "1_8" || _pointerIndex == "1_9"){
					if(_sceneObject.length > 0){
						if(_sceneObject[0].parent != null){
							SceneManager.getIns().nowScene.removeChild(_sceneObject[0]);
							RenderEntityManager.getIns().removeEntity(_sceneObject[0]);
							PhysicsWorld.getIns().removeEntity(_sceneObject[0]);
						}
					}
				}
			}
		}
		
		public function clear() : void{
			for(var i:int = 0; i < _sceneObject.length; i++){
				_sceneObject[i].destroy();
				_sceneObject[i] = null;
			}
			_sceneObject.length = 0;
		}
	}
}