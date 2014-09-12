package com.test.game.Manager
{
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Base.BaseBmdView;
	import com.test.game.Const.BuffType;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.WeatherConst;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Conjure.ConjureEntity;
	import com.test.game.Entitys.Map.ItemIconEntity;
	import com.test.game.Mvc.BmdView.AutoPKSceneView;
	import com.test.game.Mvc.BmdView.EscortSceneView;
	import com.test.game.Mvc.BmdView.FunnyBossSceneView;
	import com.test.game.Mvc.BmdView.GameSenceView;
	import com.test.game.Mvc.BmdView.HeroSceneView;
	import com.test.game.Mvc.BmdView.LootSceneView;
	import com.test.game.Mvc.BmdView.NewGameSceneView;
	import com.test.game.Mvc.BmdView.PlayerKillingSceneView;
	import com.test.game.Mvc.BmdView.TeamGameSceneView;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.View.GameSceneControl;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	public class SceneManager extends Singleton
	{
		public static const NONE_SCENE:uint = 0;
		public static const NORMAL_SCENE:uint = 1;
		public static const PK_SCENE:uint = 2;
		public static const AUTO_PK_SCENE:uint = 3;
		public static const ESCORT_SCENE:uint = 4;
		public static const LOOT_SCENE:uint = 5;
		public static const TEAM_SCENE:uint = 6;
		public static const HERO_SCENE:uint = 7;
		public static const FUNNY_SCENE:uint = 8;
		
		public var isShowPartner:Boolean = true;
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function SceneManager()
		{
			super();
		}
		
		public static function getIns():SceneManager{
			return Singleton.getIns(SceneManager);
		}
		
		public function get nowScene() : BaseBmdView{
			if(BmdViewFactory.getIns().getView(GameSenceView) != null){
				return BmdViewFactory.getIns().getView(GameSenceView);
			}else if(BmdViewFactory.getIns().getView(PlayerKillingSceneView) != null){
				return BmdViewFactory.getIns().getView(PlayerKillingSceneView);
			}else if(BmdViewFactory.getIns().getView(AutoPKSceneView) != null){
				return BmdViewFactory.getIns().getView(AutoPKSceneView);
			}else if(BmdViewFactory.getIns().getView(TeamGameSceneView) != null){
				return BmdViewFactory.getIns().getView(TeamGameSceneView);
			}else if(BmdViewFactory.getIns().getView(EscortSceneView) != null){
				return BmdViewFactory.getIns().getView(EscortSceneView);
			}else if(BmdViewFactory.getIns().getView(LootSceneView) != null){
				return BmdViewFactory.getIns().getView(LootSceneView);
			}else if(BmdViewFactory.getIns().getView(NewGameSceneView)){
				return BmdViewFactory.getIns().getView(NewGameSceneView);
			}else if(BmdViewFactory.getIns().getView(HeroSceneView)) {
				return BmdViewFactory.getIns().getView(HeroSceneView);
			}else if(BmdViewFactory.getIns().getView(FunnyBossSceneView)){
				return BmdViewFactory.getIns().getView(FunnyBossSceneView);
			}else {
				return null;
			}
		}
		
		public function get sceneType() : uint{
			var result:uint = NONE_SCENE;
			if(BmdViewFactory.getIns().getView(GameSenceView) != null){
				result = NORMAL_SCENE;
			}else if(BmdViewFactory.getIns().getView(PlayerKillingSceneView) != null){
				result = PK_SCENE;
			}else if(BmdViewFactory.getIns().getView(AutoPKSceneView) != null){
				result = AUTO_PK_SCENE;
			}else if(BmdViewFactory.getIns().getView(EscortSceneView) != null){
				result = ESCORT_SCENE;
			}else if(BmdViewFactory.getIns().getView(LootSceneView) != null){
				result = LOOT_SCENE;
			}else if(BmdViewFactory.getIns().getView(TeamGameSceneView) != null){
				result = TEAM_SCENE;
			}else if(BmdViewFactory.getIns().getView(HeroSceneView) != null){
				result = HERO_SCENE;
			}else if(BmdViewFactory.getIns().getView(FunnyBossSceneView) != null){
				result = FUNNY_SCENE;
			}
			return result;
		}
		
		public function get myPlayer() : PlayerEntity{
			if(nowScene != null){
				return nowScene["myPlayer"];
			}else{
				return null;
			}
		}
		
		public function get players() : Vector.<PlayerEntity>{
			if(nowScene != null){
				return nowScene["players"];
			}else{
				return null;
			}
		}
		
		public function get monsters() : Vector.<MonsterEntity>{
			if(nowScene != null){
				return nowScene["monsters"];
			}else{
				return null;
			}
		}
		
		public function get partnerPlayer() : PlayerEntity{
			if(isTwoPlayerScene){
				return nowScene["partnerPlayer"];
			}else{
				return null;
			}
		}
		
		public function updateByCommand(command:ByteArray) : void{
			if(nowScene != null){
				nowScene["updateByCommand"](command);
			}
		}
		
		public function initMonster(mon:MonsterEntity) : void{
			if(nowScene != null){
				nowScene["initMonster"](mon);
			}
		}
		
		public function slowDown() : void{
			if(BmdViewFactory.getIns().getView(GameSenceView) != null){
				(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).slowDown(.25);
			}else if(BmdViewFactory.getIns().getView(PlayerKillingSceneView) != null){
				(BmdViewFactory.getIns().getView(PlayerKillingSceneView) as PlayerKillingSceneView).slowDown();
			}else if(BmdViewFactory.getIns().getView(AutoPKSceneView) != null){
				(BmdViewFactory.getIns().getView(AutoPKSceneView) as AutoPKSceneView).slowDown();
			}
		}
		
		public function resetRenderSlow() : void{
			if(nowScene != null){
				nowScene["resetRenderSlow"]();
			}
		}
		
		public function playerDeath(player:PlayerEntity) : void{
			if(nowScene != null){
				nowScene["playerDeath"](player);
			}
		}
		
		public function checkMonsterDeath(monster:MonsterEntity) : void{
			if(nowScene != null){
				nowScene["checkMonsterDeath"](monster);
			}
		}
		
		public function checkMonsterClear(monster:MonsterEntity) : void{
			if(BmdViewFactory.getIns().getView(GameSenceView) != null){
				(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).checkMonsterClear(monster);
			}
		}
		
		public function addConBuff(con:ConjureEntity, buffType:int, buffValue:Number) : void{
			if(con.belong != null){
				if(buffType == BuffType.BUFF_REGAIN_HP){
					con.belong.isLock = true;
				}
				con.belong.charData.addBuff(buffType, buffValue);
			}
		}
		
		public function removeConBuff(con:ConjureEntity, buffType:int, buffValue:Number) : void{
			if(con.belong != null){
				if(buffType == BuffType.BUFF_REGAIN_HP){
					con.belong.isLock = false;
				}
				con.belong.charData.removeBuff(buffType, buffValue);
			}
		}
		
		private var _nowCount:int;
		private var _stepCount:int = 0;
		public function shakeLayer() : void{
			/*if((_stepCount - _nowCount) > 2){
				_nowCount = _stepCount;*/
				(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).shakeLayer(5, .2);
			//}
		}
		
		public function allMonsterDeath() : void{
			if(nowScene != null){
				var monster:Vector.<MonsterEntity> = monsters;
				for(var i:int = 0; i < monsters.length; i++){
					monster[i].charData.useProperty.hp = 0;
					monster[i].setAction(ActionState.GROUNDDEAD);
					monster[i].isLock = true;
				}
			}
		}
		
		public function allMonsterReduceHp() : void{
			if(nowScene != null){
				var monsters:Vector.<MonsterEntity> = nowScene["monsters"];
				for(var i:int = 0; i < monsters.length; i++){
					monsters[i].changeHp(3000);
				}
			}
		}
		
		//天气模式下获得令牌碎片
		public function getWeatherProp(pos:Point) : void{
			//return;
			if(WeatherManager.getIns().weatherStatus != WeatherConst.WEATHER_NONE
				&& WeatherManager.getIns().weatherStatus != 0){
				var random:Number = Math.random();
				var last:Number = NumberConst.getIns().percent7 * Math.pow(NumberConst.getIns().percent93, player.statisticsInfo.weatherPropCount);
				if(random < last){
					var propID:int = 4499 + WeatherManager.getIns().weatherStatus;
					var itemVo:ItemVo = PackManager.getIns().creatItem(propID);
					itemVo.num = NumberConst.getIns().one;
					PackManager.getIns().addItemIntoPack(itemVo);
					var iie:ItemIconEntity = new ItemIconEntity(itemVo.type + itemVo.id, itemVo.name, pos, DigitalManager.getIns().getOneStauts());
					SceneManager.getIns().nowScene.addChild(iie);
					player.statisticsInfo.weatherPropCount++;
					DebugArea.getIns().showInfo("---random:" + random.toFixed(5) + "---last:" + last.toFixed(5) + "---propID:" + propID + "---count:" + player.statisticsInfo.weatherPropCount + "---");
				}
			}
		}
		
		//有连击数的场景
		public function get hasComboScene() : Boolean{
			var result:Boolean = false;
			if(sceneType == NORMAL_SCENE
				|| sceneType == LOOT_SCENE
				|| sceneType == ESCORT_SCENE
				|| sceneType == HERO_SCENE
				|| sceneType == FUNNY_SCENE){
				result = true;
			}
			return result;
		}
		
		//是否pk场景
		public function get isPkScene() : Boolean{
			var result:Boolean = false;
			if(sceneType == PK_SCENE
				|| sceneType == AUTO_PK_SCENE){
				result = true;
			}
			return result;
		}
		
		//有两个玩家的场景
		public function get isTwoPlayerScene() : Boolean{
			var result:Boolean = false;
			if(sceneType == NORMAL_SCENE
				|| sceneType == HERO_SCENE
				|| sceneType == FUNNY_SCENE){
				result = true;
			}
			return result;
		}
		
		//有怪物的场景
		public function get hasMonsterScene() : Boolean{
			var result:Boolean = false;
			if(sceneType == NORMAL_SCENE
				|| sceneType == HERO_SCENE
				|| sceneType == ESCORT_SCENE
				|| sceneType == FUNNY_SCENE){
				result = true;
			}
			return result;
		}
		
		public function step() : void{
			_stepCount++;
			if(_stepCount > 10000000){
				_stepCount = 0;
			}
		}
		
		public function clear() : void{
			_stepCount = 0;
			_nowCount = 0;
			isShowPartner = true;
		}
		
	}
}