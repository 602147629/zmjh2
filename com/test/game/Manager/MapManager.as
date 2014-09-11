package com.test.game.Manager
{
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	import com.test.game.Modules.MainGame.Map.EscortMapView;
	import com.test.game.Modules.MainGame.Map.FunnyMapView;
	import com.test.game.Modules.MainGame.Map.HeroMapView;
	import com.test.game.Modules.MainGame.Map.NewGameMapView;
	import com.test.game.Modules.MainGame.Map.PlayerKillingMapView;
	import com.test.game.Modules.MainGame.Map.TeamMapView;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Utils.AllUtils;
	
	import flash.display.Sprite;
	
	public class MapManager extends Singleton{
		public static const NONE_MAP:uint = 0;
		public static const NORMAL_MAP:uint = 1;
		public static const PK_MAP:uint = 2;
		public static const ESCORT_MAP:uint = 3;
		public static const TEAM_MAP:uint = 5;
		public static const NEW_GAME_MAP:uint = 6;
		public static const HERO_MAP:uint = 7;
		public static const FUNNY_MAP:uint = 8;
		public function MapManager(){
			super();
		}
		
		public static function getIns():MapManager{
			return Singleton.getIns(MapManager);
		}
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function get nowMap() : BaseView{
			if(ViewFactory.getIns().getView(BaseMapView) != null){
				return ViewFactory.getIns().getView(BaseMapView);
			}else if(ViewFactory.getIns().getView(PlayerKillingMapView) != null){
				return ViewFactory.getIns().getView(PlayerKillingMapView);
			}else if(ViewFactory.getIns().getView(TeamMapView) != null){
				return ViewFactory.getIns().getView(TeamMapView);
			}else if(ViewFactory.getIns().getView(EscortMapView) != null){
				return ViewFactory.getIns().getView(EscortMapView);
			}else if(ViewFactory.getIns().getView(NewGameMapView) != null){
				return ViewFactory.getIns().getView(NewGameMapView);
			}else if(ViewFactory.getIns().getView(HeroMapView) != null){
				return ViewFactory.getIns().getView(HeroMapView);
			}else if(ViewFactory.getIns().getView(FunnyMapView) != null){
				return ViewFactory.getIns().getView(FunnyMapView);
			}{
				return null;
			}
		}
		
		public function get mapType() : uint{
			var result:uint = NONE_MAP;
			if(ViewFactory.getIns().getView(BaseMapView) != null){
				result = NORMAL_MAP;
			}else if(ViewFactory.getIns().getView(PlayerKillingMapView) != null){
				result = PK_MAP;
			}else if(ViewFactory.getIns().getView(TeamMapView) != null){
				result = TEAM_MAP;
			}else if(ViewFactory.getIns().getView(EscortMapView) != null){
				result = ESCORT_MAP;
			}else if(ViewFactory.getIns().getView(NewGameMapView) != null){
				result = NEW_GAME_MAP;
			}else if(ViewFactory.getIns().getView(HeroMapView) != null){
				result = HERO_MAP;
			}else if(ViewFactory.getIns().getView(FunnyMapView) != null){
				result = FUNNY_MAP;
			}
			return result;
		}
		
		public function get mapEntity() : Sprite{
			if(nowMap != null){
				return nowMap["mapEntity"];
			}else{
				return null;
			}
		}
		
		public function removeUIBg() : void{
			if(nowMap != null){
				nowMap["removeUIBg"]();
			}
		}
		
		public function addUIBg() : void{
			if(nowMap != null){
				nowMap["addUIBg"]();
			}
		}
		
		//是否有是可以有两个玩家的关卡
		public function get isTwoPlayerMap() : Boolean{
			var result:Boolean = false;
			if(mapType == NORMAL_MAP || mapType == HERO_MAP || mapType == FUNNY_MAP){
				result = true;
			}
			return result;
		}
		
		public function preLoadingFodder(level:String, type:int) : Array{
			var result:Array = new Array;
			var fodder:Object;
			if(type == 0){
				fodder = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.LEVEL, "level_id", level);
			}else if(type == 1){
				fodder = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.ELITE, "level_id", level);
			}
			result = fodder.loading_fodder.split("|");
			return result;
		}
		
		public function getMapStr(level:String) : String{
			var result:String;
			var arr:Array = level.split("_");
			var index:int = arr[1];
			if(index <= 3){
				result = arr[0] + "_1";
			}else if(index > 3 && index <= 6){
				result = arr[0] + "_2";
			}else if(index > 6 && index <= 9){
				result = arr[0] + "_3";
			}else if(index > 9 && index <= 12){
				result = arr[0] + "_4";
			}
			return result;
		}
		
		public function mapResource(level:String, type:int) : String{
			var result:String;
			if(type == 0){
				result = "Map/Map" + getMapStr(level);
			}else if(type == 1){
				result = "Map/Map" + level;
			}
			return result;
		}
		
		//地图背景数组
		public function mapBgResource(level:String, type:int) : Array{
			var result:Array = [];
			var arr:Array = level.split("_");
			//普通关卡
			if(type == 0){
				//前9关普通关卡
				if(arr[1] < 10){
					//风波渡
					/*if(arr[0] == 4){
						result.push(AssetsUrl.getAssetObject("Map/MapBg" + arr[0] + "_" + Math.ceil(arr[1] / 3)));
					}else{*/
						result.push(AssetsUrl.getAssetObject("Map/MapBg" + arr[0]));
					//}
				}
				//后3关隐藏关卡
				else{
					if(arr[0] != 2){
						result.push(AssetsUrl.getAssetObject("Map/MapHideBg" + arr[0]));
					}
				}
			}
			//精英关卡
			else if(LevelManager.getIns().mapType == 1){
				//前3关普通精英关卡
				if(arr[1] < 4){
					/*if(arr[0] == 4){
						result.push(AssetsUrl.getAssetObject("Map/MapBg" + level));
					}else{*/
						result.push(AssetsUrl.getAssetObject("Map/MapBg" + arr[0]));
					//}
				}
				//后1关隐藏精英关卡
				else{
					if(arr[0] != 2){
						result.push(AssetsUrl.getAssetObject("Map/MapHideBg" + arr[0]));
					}
				}
			}
			
			return result;
		}
		
		public function getPKPlayerFodder() : Array{
			var arr:Array = new Array();
			var datas:Array = FbPlayersManager.getIns().playerDatas;
			if(datas != null){
				for(var i:int = 0; i < datas.length; i++){
					arr = arr.concat(getPlayerFodder(datas[i].data.occupation));
				}
				arr = AllUtils.getUnique(arr);
			}else{
				arr = getPlayerFodder(PlayerManager.getIns().player.occupation);
			}
			return arr;
		}
		
		//角色素材数组
		public function getPlayerFodder(occ:int) : Array{
			var result:Array = [];
			result.push("Relive", "BuringFront", "NoSkill", "HitEffect", "MonsterAppear");
			result.push("KuangWuCommon");
			result.push("KuangWuSkill");
			result.push("KuangWuJump");
			result.push("KuangWuRun");
			result.push("XiaoYaoCommon");
			result.push("XiaoYaoSkill");
			result.push("XiaoYaoJump");
			result.push("XiaoYaoRun");
			result.push("Sword");
			
			return result;
		}
		
		public function getMapFodder(level:String, type:int) : Array{
			var result:String = "";
			var levelInfo:Array = level.split("_");
			var index:int = (int(levelInfo[1]) - 1) / 3 + 1;
			var mapStr:String;
			switch(type){
				case 0:
					result = "Map" + level;
					mapStr = "MapImg" + levelInfo[0] + "_" + index;
					break;
				case 1:
					if(int(levelInfo[0]) <= 2){
						result = "MapElite";
					}else{
						result = "MapElite" + level;
					}
					mapStr = "MapImg" + level;
					break;
			}
			return new Array(result, mapStr);
		}
		
		public function getRandomMap() : Array{
			var result:Array = new Array();
			var mapIndex:String = int(DigitalManager.getIns().getRandom() * 2 + 1) + "_" + int(DigitalManager.getIns().getRandom() * 12 + 1);
			var mapType:int = 0;
			result.push(mapIndex);
			result.push(mapType);
			DebugArea.getIns().showInfo("当前pk地图为：" + mapIndex);
			return result;
		}
	}
}