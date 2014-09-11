package com.test.game.Manager.HideMission
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.WeatherConst;
	import com.test.game.Entitys.HideMission.TaiXuBaseHideMissionEntity;
	import com.test.game.Entitys.HideMission.WanEGuBaseHideMissionEntity;
	import com.test.game.Entitys.HideMission.WindMissionEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.WeatherManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class WanEGuMissionManager extends Singleton
	{
		private var _pointerIndex:String = "";
		private var _sceneObject:Array = new Array();
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public function WanEGuMissionManager()
		{
			super();
		}
		
		public static function getIns():WanEGuMissionManager{
			return Singleton.getIns(WanEGuMissionManager);
		}
		
		public function init() : void{
			switch(LevelManager.getIns().nowIndex){
				case "3_3":
					createMission3_3();
					_pointerIndex = "3_3";
					break;
				case "3_5":
					createMission3_5();
					_pointerIndex = "3_5";
					break;
				case "3_6":
					createMission3_6();
					_pointerIndex = "3_6";
					break;
				case "3_8":
					createMission3_8();
					_pointerIndex = "3_8";
					break;
				case "3_9":
					createMission3_9();
					_pointerIndex = "3_9";
					break;
			}
		}
		
		private function createMission3_3():void{
			var cowEyeEntity:WanEGuBaseHideMissionEntity = new WanEGuBaseHideMissionEntity(["HideMission3_3"], "SeZhongEGuiSkill1_1", 180, true);
			cowEyeEntity.x = 3502;
			cowEyeEntity.y = 130;
			_sceneObject.push(cowEyeEntity);
		}
		
		private function createMission3_5():void{
			var windEntity:WindMissionEntity = new WindMissionEntity(10028, ["HideMission3_5"], "JumpPressHit", 160);
			windEntity.x = 4200;
			windEntity.y = 200;
			_sceneObject.push(windEntity);
		}
		
		private function createMission3_6():void{
			var televisionEntity:WanEGuBaseHideMissionEntity = new WanEGuBaseHideMissionEntity(["HideMission3_6_1", "HideMission3_6_2"], "LeiChenDianNuSkill1_3", 210, true);
			televisionEntity.x = 2730;
			televisionEntity.y = 130;
			_sceneObject.push(televisionEntity);
			SceneManager.getIns().nowScene.addChildAt(televisionEntity, 0);
		}
		
		private function createMission3_8():void{
			var stoneEntity:WanEGuBaseHideMissionEntity = new WanEGuBaseHideMissionEntity(["HideMission3_8_1", "HideMission3_8_2"], "YinYangZhenRenSkill2", 0, false);
			stoneEntity.x = 3248;
			stoneEntity.y = -63;
			_sceneObject.push(stoneEntity);
		}
		
		private function createMission3_9():void{
			var steleEntity:WanEGuBaseHideMissionEntity = new WanEGuBaseHideMissionEntity(["HideMission3_9_1", "HideMission3_9_2"], "ChiNanSkill2", 250, false);
			steleEntity.x = 2740;
			steleEntity.y = 80;
			_sceneObject.push(steleEntity);
			SceneManager.getIns().nowScene.addChildAt(steleEntity, 0);
		}
		
		public function setHideMissionComplete(missionID:int = 3021) : void{
			var index:int = HideMissionManager.getIns().getHideMissionIndex(missionID);
			if(index != -1){
				var nowCount:int = -1;
				switch(_pointerIndex){
					case "3_3":
						nowCount = 0;
						break;
					case "3_5":
						nowCount = 1;
						break;
					case "3_6":
						nowCount = 2;
						break;
					case "3_8":
						nowCount = 3;
						break;
					case "3_9":
						nowCount = 4;
						break;
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
		
		public function sceneHurtBySkill(skill:SkillEntity) : void{
			if(_pointerIndex == "3_8" && skill != null && _sceneObject.length > 0 && WeatherManager.getIns().weatherStatus == WeatherConst.WEATHER_RAIN){
				_sceneObject[0].hurtBy(skill);
			}
		}
			
		public function step() : void{
			switch(WeatherManager.getIns().weatherStatus){
				case WeatherConst.WEATHER_BLACK:
					if(_pointerIndex == "3_3"){
						addSceneObject();
					}
					break;
				case WeatherConst.WEATHER_WIND:
					if(_pointerIndex == "3_5"){
						addSceneObject();
					}
					break;
				case WeatherConst.WEATHER_RAIN:
					if(_pointerIndex == "3_8"){
						addSceneObject();
					}
					break;
				default:
					if(_pointerIndex == "3_3" || _pointerIndex == "3_5" || _pointerIndex == "3_8" ){
						removeSceneObject();
					}
					break;
			}
		}
		
		private function addSceneObject() : void{
			if(_sceneObject.length > 0){
				if(_sceneObject[0].parent == null){
					SceneManager.getIns().nowScene.addChildAt(_sceneObject[0], 0);
					RenderEntityManager.getIns().addEntity(_sceneObject[0]);
					PhysicsWorld.getIns().addEntity(_sceneObject[0]);
				}
			}
		}
		
		private function removeSceneObject() : void{
			if(_sceneObject.length > 0){
				if(_sceneObject[0].parent != null){
					SceneManager.getIns().nowScene.removeChild(_sceneObject[0]);
					RenderEntityManager.getIns().removeEntity(_sceneObject[0]);
					PhysicsWorld.getIns().removeEntity(_sceneObject[0]);
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