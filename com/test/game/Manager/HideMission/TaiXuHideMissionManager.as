package com.test.game.Manager.HideMission
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.WeatherConst;
	import com.test.game.Entitys.HideMission.LetterHideMissionEntity;
	import com.test.game.Entitys.HideMission.StarHideMissionEntity;
	import com.test.game.Entitys.HideMission.TaiXuBaseHideMissionEntity;
	import com.test.game.Entitys.HideMission.XuShuiHideMissionEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.WeatherManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class TaiXuHideMissionManager extends Singleton
	{
		private var _pointerIndex:String = "";
		private var _sceneObject:Array = new Array();
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public function TaiXuHideMissionManager()
		{
			super();
		}
		
		public static function getIns():TaiXuHideMissionManager{
			return Singleton.getIns(TaiXuHideMissionManager);
		}
		
		public function init() : void{
			switch(LevelManager.getIns().nowIndex){
				case "2_3":
					createMission2_3();
					_pointerIndex = "2_3";
					break;
				case "2_4":
					createMission2_4();
					_pointerIndex = "2_4";
					break;
				case "2_6":
					createMission2_6();
					_pointerIndex = "2_6";
					break;
				case "2_7":
					createMission2_7();
					_pointerIndex = "2_7";
					break;
				case "2_9":
					createMission2_9();
					_pointerIndex = "2_9";
					break;
			}
		}
		
		private function createMission2_3():void{
			var firewoodEntity:TaiXuBaseHideMissionEntity = new TaiXuBaseHideMissionEntity(["HideMission2_3_1", "HideMission2_3_2"], "HongLianSanRenSkill1", 110, true);
			firewoodEntity.x = 2790;
			firewoodEntity.y = 240;
			_sceneObject.push(firewoodEntity);
		}
		
		private function createMission2_4():void{
			var lanternEntity:LetterHideMissionEntity = new LetterHideMissionEntity(["HideMission2_4_1"], player.fodder + "JumpPressHit", 370, true);
			lanternEntity.x = 3050;
			lanternEntity.y = 10;
			_sceneObject.push(lanternEntity);
			SceneManager.getIns().nowScene.addChild(lanternEntity);
		}
		
		private function createMission2_6():void{
			var waterEntity:XuShuiHideMissionEntity = new XuShuiHideMissionEntity(["HideMission2_6_1", "HideMission2_6_2", "HideMission2_6_3"], "FengLiuDaoRenSkill1", 80, true);
			waterEntity.x = 1870;
			waterEntity.y = 280;
			_sceneObject.push(waterEntity);
			SceneManager.getIns().nowScene.addChild(waterEntity);
		}
		
		private function createMission2_7():void{
			var pelletEntity:TaiXuBaseHideMissionEntity = new TaiXuBaseHideMissionEntity(["HideMission2_7_1", "HideMission2_7_2"], "YinYangZhenRenSkill2", 80, true);
			pelletEntity.x = 4070;
			pelletEntity.y = 20;
			_sceneObject.push(pelletEntity);
			SceneManager.getIns().nowScene.addChild(pelletEntity);
		}
		
		private function createMission2_9():void{
			var lanternEntity:StarHideMissionEntity = new StarHideMissionEntity(["HideMission2_9_1"], player.fodder + "JumpHit", 300, true);
			lanternEntity.setHp(SceneManager.getIns().myPlayer.charData.totalProperty.hp);
			lanternEntity.x = 2215;
			lanternEntity.y = 42;
			_sceneObject.push(lanternEntity);
		}
		
		public function setHideMissionComplete(missionID:int = 3011) : void{
			var index:int = HideMissionManager.getIns().getHideMissionIndex(missionID);
			if(index != -1){
				var nowCount:int = -1;
				switch(_pointerIndex){
					case "2_3":
						nowCount = 0;
						break;
					case "2_4":
						nowCount = 1;
						break;
					case "2_6":
						nowCount = 2;
						break;
					case "2_7":
						nowCount = 3;
						break;
					case "2_9":
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
		
		public function step() : void{
			switch(WeatherManager.getIns().weatherStatus){
				case WeatherConst.WEATHER_BLACK:
					if(_pointerIndex == "2_9"){
						addSceneObject();
					}
					break;
				case WeatherConst.WEATHER_RAIN:
					if(_pointerIndex == "2_3" || _pointerIndex == "2_6"){
						addSceneObject();
						if(_pointerIndex == "2_6"){
							setSceneObject(1);
						}
					}
					break;
				default:
					if(_pointerIndex == "2_3" || _pointerIndex == "2_6" || _pointerIndex == "2_9"){
						if(_pointerIndex == "2_6"){
							setSceneObject(0);
						}else{
							removeSceneObject();
						}
					}
					break;
			}
		}
		
		public function sceneHurtBySkill(skill:SkillEntity) : void{
			if(_pointerIndex == "2_7" && skill != null && skill.x > 3500 && _sceneObject.length > 0){
				_sceneObject[0].hurtBy(skill);
			}
		}
		
		private function setSceneObject(index:int) : void{
			if(_sceneObject.length > 0){
				_sceneObject[0].setImageIndex(index);
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