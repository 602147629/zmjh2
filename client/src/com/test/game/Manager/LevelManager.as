package com.test.game.Manager
{
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseBmdView;
	import com.test.game.Const.DebugConst;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	
	import flash.geom.Point;
	
	public class LevelManager extends Singleton
	{
		public var guideIndex:int;
		public var levelData:Object;
		public var nowIndex:String;
		//普通关卡还是精英关卡
		public var mapType:int;
		public var mainBossEntity:MonsterEntity;
		public var minorBossEntity:MonsterEntity;
		private var _isStart:Boolean;
		private var _stepTime:int;
		//当前场次战斗数据
		private var _data:Object;
		//当前怪物索引
		private var _nowMonsterIndex:int;
		public function get nowMonsterIndex() : int{
			return _nowMonsterIndex;
		}
		//当前场次怪物总共波数
		private var _totalWaveIndex:int;
		//当前场次怪物当前波数
		private var _nowWaveIndex:int;
		//当前场次怪物当前波数的当前次数
		private var _nowBoutIndex:int;
		//当前场次出怪数组
		private var _nowMonsterList:Array = new Array();
		//当前场次怪物当前波数已经出怪的次数
		private var _alreadyBout:Array = new Array();
		
		public var storyStop:Boolean = false;
		
		private var _prePosX:int = 0;
		private var _prePosY:int = 0;
		
		public function LevelManager(){
			super();
		}
		
		public static function getIns():LevelManager{
			return Singleton.getIns(LevelManager);
		}
		
		public function step() : void{
			if(!storyStop){
				createMonster();
				stepPlus();
			}
		}
		
		private function stepPlus() : void{
			if(_isStart){
				_stepTime++;
				if(_stepTime % 10 == 0 && _nowMonsterList[_nowWaveIndex] != null)
					_nowBoutIndex++;
			}else{
				_stepTime = 0;
			}
		}
		
		public function createSpecialMonster(monsterID:int, xPos:int, yPos:int) : void{
			var mon:MonsterEntity = RoleManager.getIns().createMonster(monsterID, xPos, yPos);
			if(MapManager.getIns().mapType == MapManager.HERO_MAP){
				mon.characterControl.limitLeftX = 0;
				mon.characterControl.limitRightX = 1200;
				SceneManager.getIns().nowScene["initSpecialMonster"](mon);
			}else{
				mon.characterControl.limitLeftX = MapManager.getIns().nowMap["mapEntity"]["limit" + _nowMonsterIndex + "_1"].x;
				mon.characterControl.limitRightX = MapManager.getIns().nowMap["mapEntity"]["limit" + _nowMonsterIndex + "_2"].x;
				SceneManager.getIns().initMonster(mon);
			}
		}
		
		private function createMonster():void{
			if(!_isStart || checkBout()) return;
			if(_nowMonsterList[_nowWaveIndex] == null || _nowBoutIndex >= _nowMonsterList[_nowWaveIndex].length)	return;
			
			for(var i:int = 0; i < _nowMonsterList[_nowWaveIndex][_nowBoutIndex].length; i++){
				var info:Array = _nowMonsterList[_nowWaveIndex][_nowBoutIndex][i].split("|");
				var xPos:int;
				var yPos:int;
				var level:int = nowIndex.split("_")[0];
				if(level < 3){
					xPos = MapManager.getIns().nowMap["mapEntity"]["monster" + _nowMonsterIndex + "_" + info[1]].x;
					yPos = MapManager.getIns().nowMap["mapEntity"]["monster" + _nowMonsterIndex + "_" + info[1]].y;
				}else{
					if(info[1] < 4){
						xPos = MapManager.getIns().nowMap["mapEntity"]["monster" + _nowMonsterIndex + "_" + info[1]].x;
						yPos = MapManager.getIns().nowMap["mapEntity"]["monster" + _nowMonsterIndex + "_" + info[1]].y;
					}else{
						var point:Point = getRandomPos();
						_prePosX = xPos = point.x;
						_prePosY = yPos = point.y;
					}
				}
				var mon:MonsterEntity = RoleManager.getIns().createMonster(info[0], xPos, yPos);
				mon.characterControl.limitLeftX = MapManager.getIns().nowMap["mapEntity"]["limit" + _nowMonsterIndex + "_1"].x;
				mon.characterControl.limitRightX = MapManager.getIns().nowMap["mapEntity"]["limit" + _nowMonsterIndex + "_2"].x;
				SceneManager.getIns().initMonster(mon);
			}
			_alreadyBout.push(_nowBoutIndex);
			
			if(ViewFactory.getIns().getView(BaseMapView) != null){
				if(nowIndex == "3_9"){
					if(_nowMonsterIndex == 3 && _nowBoutIndex == 1){
						StoryManager.getIns().judgeStartStory();
					}
				}else{
					if(_nowMonsterIndex == 3 && _nowBoutIndex == 0){
						StoryManager.getIns().judgeStartStory();
					}
				}
			}
		}
		
		private function getRandomPos() : Point{
			var result:Point = new Point();
			do{
				result.x = MapManager.getIns().nowMap["mapEntity"]["limit" + _nowMonsterIndex + "_1"].x + 100 + 
					Math.random() * (MapManager.getIns().nowMap["mapEntity"]["limit" + _nowMonsterIndex + "_2"].x - 100 - MapManager.getIns().nowMap["mapEntity"]["limit" + _nowMonsterIndex + "_1"].x);
				result.y = 350 + Math.random() * 190;
			}while(judgePos(result));
			
			return result;
		}
		
		private function judgePos(point:Point) : Boolean{
			var result:Boolean = false;
			if(_prePosX == 0 && _prePosY == 0){
				result = false;
			}else{
				if(Math.abs(_prePosX - point.x) < 175 && Math.abs(_prePosY - point.y) < 125){
					result = true;
				}
			}
			return result;
		}
		
		public function createQingMingMonster(monsterID:int) : void{
			if(_nowMonsterIndex != 0 && _isStart && _nowMonsterIndex < 3){
				var player:PlayerEntity = SceneManager.getIns().myPlayer;
				if(player.charData.lv >= 16){
					var mon:MonsterEntity = RoleManager.getIns().createQingMingMonster(monsterID, player.charData.lv);
					mon.characterControl.limitLeftX = MapManager.getIns().nowMap["mapEntity"]["limit" + _nowMonsterIndex + "_1"].x;
					mon.characterControl.limitRightX = MapManager.getIns().nowMap["mapEntity"]["limit" + _nowMonsterIndex + "_2"].x;
					mon.x = player.pos.x + Math.random() * (100 + Math.random() * 300);
					if(mon.x < mon.characterControl.limitLeftX){
						mon.x = mon.characterControl.limitLeftX;
					}
					if(mon.x > mon.characterControl.limitRightX){
						mon.x = mon.characterControl.limitRightX;
					}
					mon.y = player.pos.y + Math.random() * (80 + Math.random() * 70);
					if(mon.y < 300){
						mon.y = 300;
					}
					if(mon.y > GameConst.stage.stageHeight - 50){
						mon.y = GameConst.stage.stageHeight - 50
					}
					SceneManager.getIns().initMonster(mon);
				}
			}
		}
		
		public function createTuZi(monsterID:int) : Boolean{
			if(_nowMonsterIndex != 0 && _isStart && _nowMonsterIndex < 3){
				var player:PlayerEntity = SceneManager.getIns().myPlayer;
				var mon:MonsterEntity = RoleManager.getIns().createTuZiMonster(monsterID, player.charData.lv);
				mon.characterControl.limitLeftX = MapManager.getIns().nowMap["mapEntity"]["limit" + _nowMonsterIndex + "_1"].x;
				mon.characterControl.limitRightX = MapManager.getIns().nowMap["mapEntity"]["limit" + _nowMonsterIndex + "_2"].x;
				mon.x = player.pos.x + Math.random() * (100 + Math.random() * 300);
				if(mon.x < mon.characterControl.limitLeftX){
					mon.x = mon.characterControl.limitLeftX;
				}
				if(mon.x > mon.characterControl.limitRightX){
					mon.x = mon.characterControl.limitRightX;
				}
				mon.y = player.pos.y + Math.random() * (80 + Math.random() * 70);
				if(mon.y < 300){
					mon.y = 300;
				}
				if(mon.y > GameConst.stage.stageHeight - 50){
					mon.y = GameConst.stage.stageHeight - 50
				}
				SceneManager.getIns().initMonster(mon);
				return true;
			}else{
				return false;
			}
		}
		
		private function checkBout() : Boolean{
			var result:Boolean = false;
			for(var i:int = 0; i < _alreadyBout.length; i++){
				if(_alreadyBout[i] == _nowBoutIndex){
					result = true;
					break;
				}
			}
			return result;
		}
		
		public function initLevelData(data:Object, index:int) : void{
			_data = data;
			_nowMonsterIndex = index;
			_nowWaveIndex = 0;
			_nowBoutIndex = 0;
			_totalWaveIndex = 0;
			_alreadyBout.length = 0;
			_nowMonsterList.length = 0;
			_isStart = true;
			
			var len:int = 0;
			for(var i:int = 1; i < 7; i++){
				len = String(_data["monster" + i]).split("|").length
				_totalWaveIndex = (_totalWaveIndex > len?_totalWaveIndex:len);
			}
			
			for(var j:int = 0; j < _totalWaveIndex; j++){
				_nowMonsterList.push(analysisData(getSixData(j)));	
			}
		}
		
		private function analysisData(data:Array) : Array{
			var result:Array = [];
			var len:int;
			for(var k:int = 0; k < data.length; k++){
				len = (len > data[k].length?len:data[k].length)
			}
			
			for(var i:int = 0; i < len; i++){
				var info:Array = [];
				for(var j:int = 0; j < 6; j++){
					if(data[j] != null && data[j][i] != null && data[j][i] != ""){
						info.push(data[j][i] + "|" + (j + 1));
					}
				}
				if(info.length > 0){
					result.push(info);
				}
			}
			return result;
		}
		
		private function getSixData(index:int) : Array{
			var result:Array = new Array();
			for(var i:int = 1; i < 7; i++){
				var info:Array = String(_data["monster" + i]).split("|");
				if(info[index] != null){
					result.push(getMonsterData(info[index], i));
				}else{
					result.push([]);
				}
			}
			
			return result;
		}
		
		private function getMonsterData(str:String, index:int) : Array{
			var result:Array = new Array();
			if(str == "0"){
				result = [];
			}else{
				for(var j:int = 1; j < index; j++){
					result.push("");
				}
				var info:Array = str.split("*");
				if(info.length < 2){
					DebugArea.getIns().showInfo("配置信息错误！", DebugConst.ERROR);
					//throw new Error("配置信息错误！");
				}
				for(var i:int = 0; i < info[1]; i++){
					result.push(info[0]);
				}
			}
			return result;
		}
		
		public function get nowWaveIndex() : int
		{
			return _nowWaveIndex;
		}
		public function set nowWaveIndex(value:int) : void
		{
			_nowWaveIndex = value;
			if(_nowWaveIndex < _totalWaveIndex){
				_alreadyBout.length = 0;
				_nowBoutIndex = 0;
			}else{
				(ViewFactory.getIns().getView(BaseMapView) as BaseMapView).nowLimitIndex++;
				_isStart = false;
			}
		}
		
		public function get nowMonsterStart() : int{
			if(MapManager.getIns().nowMap != null && _nowMonsterIndex < 3){
				return MapManager.getIns().nowMap["mapEntity"]["start" + (_nowMonsterIndex + 1)].x;
			}else{
				return 0;
			}
		}
		
		public function get isStart() : Boolean
		{
			return _isStart;
		}
		
		public function clear() : void{
			_isStart = false;
			mainBossEntity = null;
			minorBossEntity = null;
		}
	}
}