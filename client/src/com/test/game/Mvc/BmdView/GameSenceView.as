package com.test.game.Mvc.BmdView{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.game.ResourceOperation.BitmapDataPool;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseBmdView;
	import com.test.game.Const.AutoFightConst;
	import com.test.game.Const.BuffType;
	import com.test.game.Const.CharacterType;
	import com.test.game.Const.DailyMissionConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.KeyOperationType;
	import com.test.game.Const.WeatherConst;
	import com.test.game.Effect.SlowDownEffect;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Daily.ClickThingEntity;
	import com.test.game.Entitys.Daily.MaterialClickEntity;
	import com.test.game.Entitys.Daily.ObstacleEntity;
	import com.test.game.Entitys.Daily.TreasureShowEntity;
	import com.test.game.Entitys.Effect.EffectEntity;
	import com.test.game.Entitys.Monsters.ChiNanEntity;
	import com.test.game.Entitys.Monsters.YuanNvEntity;
	import com.test.game.Entitys.Roles.KuangWuEntity;
	import com.test.game.Entitys.Roles.XiaoYaoEntity;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Manager.AssessManager;
	import com.test.game.Manager.AutoFightManager;
	import com.test.game.Manager.BattleUIManager;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.FunnyBossManager;
	import com.test.game.Manager.GameProcessManager;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.MyUserManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.ServerControllor;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.StageClickManager;
	import com.test.game.Manager.StoryManager;
	import com.test.game.Manager.WeatherManager;
	import com.test.game.Manager.Activity.MidAutumnManager;
	import com.test.game.Manager.Activity.QingMingManager;
	import com.test.game.Manager.Collision.CollisionListener;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Modules.MainGame.LevelInfoView;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	import com.test.game.Mvc.control.View.GameSceneControl;
	import com.test.game.Mvc.control.View.PassLevelControl;
	import com.test.game.Mvc.control.View.PlayerUIControl;
	import com.test.game.Mvc.control.character.AceAutoFightControl;
	import com.test.game.Mvc.control.character.PartnerAutoFightControl;
	import com.test.game.Mvc.control.key.role.KuangWuActionControl;
	import com.test.game.Mvc.control.key.role.XiaoYaoActionControl;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	public class GameSenceView extends BaseBmdView{
		private var _monsterVec:Vector.<MonsterEntity> = new Vector.<MonsterEntity>();
		private var _players:Vector.<PlayerEntity> = new Vector.<PlayerEntity>();
		//玩家自己
		private var _myPlayer:PlayerEntity;
		private var _partnerPlayer:PlayerEntity;
		//怪物素材资源数组
		private var _monsterResource:Vector.<String> = new Vector.<String>();
		private var _gameOver:Boolean;
		
		private var _slowDownEffect:SlowDownEffect;
		//正常暂停
		private var _isStopRender:Boolean = false; 
		override public function set isStopRender(value:Boolean) : void{
			_isStopRender = value;
		}
		override public function get isStopRender() : Boolean{
			return _isStopRender;
		}
		//防加速暂停
		private var _hackStopRender:Boolean = false;
		public function set hackStopRender(value:Boolean) : void{
			_hackStopRender = value;
		}
		public function get hackStopRender() : Boolean{
			return _hackStopRender;
		}

		private var _topList:Vector.<BaseNativeEntity> = new Vector.<BaseNativeEntity>();
		private var _showPassLevel:Boolean = false;
		
		private var _materialClickList:Array = new Array();
		
		private var _obstacleEntity:ObstacleEntity;
		private var _treasureEntity:TreasureShowEntity
		private var _clickThingEntity:ClickThingEntity;
		
		public function GameSenceView(){
			super();
		}
		
		override public function init():void{
			super.init();
			this.initParams();
			this.start();
			
			gameRelive();
			_myPlayer.isLock = true;
			(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameSceneInit();
			
		}
		
		private function showGo(isShow:Boolean):void{
			if(isShow && !_gameOver){
				GameProcessManager.getIns().showGo();
			}else{
				GameProcessManager.getIns().hideGo();
			}
		}
		
		private function initParams() : void{
			GameConst.stage.addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			GameConst.stage.addEventListener(KeyboardEvent.KEY_UP,__keyUp);
			RenderEntityManager.getIns().addEntity(this);
			PhysicsWorld.getIns().clear();
			PhysicsWorld.getIns().collisionListener = new CollisionListener();
			GameProcessManager.getIns().init();
			WeatherManager.getIns().init();
			MidAutumnManager.getIns().init();
		}
		
		private function onDeactivate(e:Event) : void{
			if(AutoFightManager.getIns().startAutoFight && AutoFightManager.getIns().autoType == AutoFightConst.AUTO_TYPE_ACE){
				
			}else{
				(ControlFactory.getIns().getControl(PlayerUIControl) as PlayerUIControl).pauseGame();
			}
		}
		
		protected function __keyUp(evt:KeyboardEvent):void{
			if(AutoFightManager.getIns().startAutoFight) return;
			ServerControllor.getIns().acceptOperation(MyUserManager.getIns().player.index,evt.keyCode,KeyOperationType.KEY_UP);
			if(GameSceneManager.getIns().partnerOperate){
				ServerControllor.getIns().acceptOperation(MyUserManager.getIns().partnerPlayer.index,evt.keyCode,KeyOperationType.KEY_UP);
			}
		}
		
		protected function __keyDown(evt:KeyboardEvent):void{
			gameStopControl(evt.keyCode);
			clearMonsterTest(evt.keyCode);
			reduceMonsterHp(evt.keyCode);
			partnerControl(evt.keyCode);
			storySkip();
			if(AutoFightManager.getIns().startAutoFight) return;
			ServerControllor.getIns().acceptOperation(MyUserManager.getIns().player.index,evt.keyCode,KeyOperationType.KEY_DOWN);
			if(GameSceneManager.getIns().partnerOperate){
				ServerControllor.getIns().acceptOperation(MyUserManager.getIns().partnerPlayer.index,evt.keyCode,KeyOperationType.KEY_DOWN);
			}
		}
		
		//E键伙伴
		private function partnerControl(keyCode:uint):void{
			if(!GameSceneManager.getIns().partnerOperate){
				if(!_gameOver && keyCode == Keyboard.E){
					partnerPress();
				}
			}
		}
		
		//跳过剧情
		private function storySkip():void{
			StoryManager.getIns().onSkip();
		}
		
		//游戏暂停
		private function gameStopControl(keyCode:uint) : void{
			if(!_gameOver && keyCode == Keyboard.P){
				if(_isStopRender){
					(ControlFactory.getIns().getControl(PlayerUIControl) as PlayerUIControl).startGame();
				}else{
					(ControlFactory.getIns().getControl(PlayerUIControl) as PlayerUIControl).pauseGame();
				}
			}
		}
		
		//R键清怪
		private function clearMonsterTest(keyCode:uint) : void{
			if(keyCode == Keyboard.R && GameConst.useDebug){
				SceneManager.getIns().allMonsterDeath();
			}
		}
		
		private function reduceMonsterHp(keyCode:uint) : void{
			if(keyCode == Keyboard.T && GameConst.useDebug){
				SceneManager.getIns().allMonsterReduceHp();
			}
		}
			
		
		private function start():void{
			var data:Object = new Object(); 
			data.uid = GameConst.UID;
			data.data = null;
			initPlayer(RoleManager.getIns().createPlayer(80, 400, data));
			initPartnerPlayer(RoleManager.getIns().createPartnerPlayer(80, 300, data));
			
			StageClickManager.getIns().init();
			initDaily();
			initMaterial();
			
			BattleUIManager.getIns().setMainBattleTool(myPlayer.player, myPlayer.charData.skillConfigurationVo);
			if(GameSceneManager.getIns().partnerOperate){
				BattleUIManager.getIns().setPartnerBattleTool(partnerPlayer.player, partnerPlayer.charData.skillConfigurationVo);
			}
			
			RoleManager.getIns().fightType = 0;
		}
		
		//采集
		private function initMaterial():void{
			var levelInfo:Object = LevelManager.getIns().levelData;
			var arr:Array = levelInfo.collection.split("|");
			var rate:Number = Number(levelInfo.collection_rate);
			for(var i:int = 0; i < arr.length; i++){
				var random:Number = Math.random();
				if(random < rate){
					var materialClickEntity:MaterialClickEntity = new MaterialClickEntity();
					materialClickEntity.init(arr[i]);
					ViewFactory.getIns().getView(BaseMapView).addChild(materialClickEntity);
					_materialClickList.push(materialClickEntity);
				}
			}
		}
		
		//每日任务
		private function initDaily() : void{
			if(DailyMissionManager.getIns().isDailyMissionStart 
				&& !DailyMissionManager.getIns().isDailyMissionComplete
				&& DailyMissionManager.getIns().isNowLevel){
				switch(DailyMissionManager.getIns().dailyMissionType){
					case DailyMissionConst.TREASURE:
						initTreasure();
						break;
					case DailyMissionConst.CLICK:
						initClickThing();
						break;
					case DailyMissionConst.OBSTACLE:
						initObstacle();
						break;
				}
			}
		}
		
		private function initObstacle():void{
			_obstacleEntity = new ObstacleEntity(_myPlayer.charData.totalProperty.hp);
			_obstacleEntity.y = 230;
			_obstacleEntity.x = 3400;
			this.addChildAt(_obstacleEntity, 0);
		}
		
		public function initTreasure():void{
			_treasureEntity = new TreasureShowEntity();
			_treasureEntity.x = 1430 + 3100 * Math.random();
			_treasureEntity.y = 250 + 200 * Math.random();
			this.addChild(_treasureEntity);
		}
		
		public function initClickThing() : void{
			_clickThingEntity = new ClickThingEntity();
			ViewFactory.getIns().getView(BaseMapView).addChild(_clickThingEntity);
		}
		
		/**
		 * 创建角色
		 * @param player
		 * 
		 */		
		private function initPlayer(player:PlayerEntity):void{
			_myPlayer = player;
			_myPlayer.autoFightControl = new AceAutoFightControl(_myPlayer);
			_myPlayer.isLock = true;
			_myPlayer.charData.angerCount = 100;
			_myPlayer.charData.bossCount = 100;
			this.addChild(_myPlayer);
			_players.push(_myPlayer);
		}
		
		private function initPartnerPlayer(player:PlayerEntity) : void{
			_partnerPlayer = player;
			_partnerPlayer.autoFightControl = new PartnerAutoFightControl(_partnerPlayer);
			if(!GameSceneManager.getIns().partnerOperate){
				_partnerPlayer.autoFightControl.autoType = AutoFightConst.AUTO_TYPE_NORMAL;
				_partnerPlayer.autoFightControl.startAutoFight = true;
			}
			_partnerPlayer.isLock = true;
			_partnerPlayer.charData.angerCount = 100;
			_partnerPlayer.charData.bossCount = 100;
			_partnerPlayer.charData.characterBarIndex = 1;
			_partnerPlayer.changeHp(0);
			_partnerPlayer.changeMp(0);
			this.addChild(_partnerPlayer);
			_players.push(_partnerPlayer);
			
			if(GameSceneManager.getIns().partnerOperate){
				EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.SHOW_PARTNER_ROLE));
				showPartner();
			}else{
				if(SceneManager.getIns().isShowPartner){
					EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.SHOW_PARTNER_ROLE));
					showPartner();
				}else{
					EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.HIDE_PARTNER_ROLE));	
					hidePartner();
				}
			}
		}
		
		private function partnerPress() : void{
			if(SceneManager.getIns().isShowPartner){
				EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.HIDE_PARTNER_ROLE));	
			}else{
				EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.SHOW_PARTNER_ROLE));
			}
		}
		
		public function hidePartner() : void{
			if(GameSceneManager.getIns().partnerOperate)  return;
			var index:int = _players.indexOf(_partnerPlayer);
			if(index != -1){
				_players.splice(index, 1);
				_partnerPlayer.isLock = true;
				_partnerPlayer.x = 0;
				_partnerPlayer.y = 1000;
				_partnerPlayer.visible = false;
				_partnerPlayer.autoFightControl.startAutoFight = false;
				_partnerPlayer.characterControl.limitLeftX = 0;
				_partnerPlayer.characterControl.limitRightX = 4700;
				if(_myPlayer.x < 2000){
					_partnerPlayer.x = 3300;
				}else{
					_partnerPlayer.x = 100;
				}
				PhysicsWorld.getIns().removeEntity(_partnerPlayer);
				if(_partnerPlayer.parent != null){
					_partnerPlayer.parent.removeChild(_partnerPlayer);
				}
			}
		}
		
		public function showPartner() : void{
			if(GameSceneManager.getIns().partnerOperate)  return;
			if(_partnerPlayer.charData.useProperty.hp <= 0) return;
			var index:int = _players.indexOf(_partnerPlayer);
			if(index == -1){
				_players.push(_partnerPlayer);
				_partnerPlayer.isLock = false;
				_partnerPlayer.visible = true;
				_partnerPlayer.x = _myPlayer.x;
				_partnerPlayer.y = _myPlayer.y;
				_partnerPlayer.autoFightControl.startAutoFight = true;
				PhysicsWorld.getIns().addEntity(_partnerPlayer);
				this.addChild(_partnerPlayer);
			}
		}
		
		//按百分比增加hp和mp
		public function playerAddHpAndMp(percent:int) : void{
			if(_myPlayer.charData.useProperty.hp > 0){
				var addHp:int = _myPlayer.charData.totalProperty.hp * percent * .01;
				_myPlayer.changeHp(-addHp);
				var addMp:int = _myPlayer.charData.totalProperty.mp * percent * .01;
				_myPlayer.changeMp(-addMp);
			}
			if(GameSceneManager.getIns().partnerOperate && _partnerPlayer.charData.useProperty.hp > 0){
				var addParHp:int = _partnerPlayer.charData.totalProperty.hp * percent * .01;
				_partnerPlayer.changeHp(-addParHp);
				var addParMp:int = _partnerPlayer.charData.totalProperty.mp * percent * .01;
				_partnerPlayer.changeMp(-addParMp);
			}
		}
		
		public function playerDeath(player:PlayerEntity) : void{
			if(GameSceneManager.getIns().partnerOperate){
				
			}else{
				if(player.charData.characterType == CharacterType.PARTNER_PLAYER){
					EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.HIDE_PARTNER_ROLE));	
				}
			}
		}
		
		public function gameOver() : void{
			if(checkGameOver()){
				GameProcessManager.getIns().clearAssess();
				slowDownWithTime(.5, 
					function () : void{
						(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameOver();
					});
				
				(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameOverStart();
				(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).allPlayersDeath();
				for each(var item:MonsterEntity in _monsterVec){
					item.isLock = true;
				}
			}
		}
		
		public function get playerAliveStatus() : Boolean{
			if(_myPlayer.charData.useProperty.hp > 0){
				return true;
			}else{
				return false;
			}
		}
		
		//主角复活
		public function gameRelive() : void{
			for each(var item:MonsterEntity in _monsterVec){
				item.isLock = false;
			}
			_myPlayer.relive();
			RoleManager.getIns().addPlayerDeathEvent(_myPlayer);
			if(_partnerPlayer != null && _partnerPlayer.charData.useProperty.hp <= 0){
				_partnerPlayer.relive();
				RoleManager.getIns().addPlayerDeathEvent(_partnerPlayer);
				EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.SHOW_PARTNER_ROLE));	
			}
			if(WeatherManager.getIns().weatherStatus == WeatherConst.WEATHER_RAIN){
				rainSlowDonwSpeed();
			}
		}
		
		//检测主角复活后，boss是否已经死了
		public function checkReliveGameOver() : void{
			if(LevelManager.getIns().nowMonsterIndex == 3){
				var result:Boolean = true;
				for(var i:int = 0; i < _monsterVec.length; i++){
					if(_monsterVec[i].charData.characterType == CharacterType.BOSS_MONSTER 
						|| _monsterVec[i].charData.characterType == CharacterType.ELITE_BOSS_MONSTER){
						if(_monsterVec[i].charData.useProperty.hp > 0){
							result = false;
						}
					}
				}
				if(result){
					(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).levelTimeEffect.stop();
					(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).unResponse();
					PassLevelControl(ControlFactory.getIns().getControl(PassLevelControl)).showInfo(_monsterVec[0]);
				}
			}
		}
		
		//检测是否所有玩家都死亡
		private function checkGameOver() : Boolean{
			var result:Boolean = true;
			for each(var role:PlayerEntity in _players){
				if(role.charData.useProperty.hp > 0){
					result = false;
					break;
				}
			}
			return result;
		}
		
		/**
		 * 创建怪物
		 * @param mon
		 * 
		 */		
		public function initMonster(mon:MonsterEntity) : void{
			//this.addChild(mon);
			_monsterVec.push(mon);
			mon.isLock = true;
			mon.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
			var len:int = mon.charData.assetsArray.length;
			for(var i:int = 0; i < len; i++){
				if(_monsterResource.indexOf(mon.charData.assetsArray[i]) == -1){
					_monsterResource.push(mon.charData.assetsArray[i]);
				}
			}
		}
		
		public function isShowPassLevel(monster:MonsterEntity) : void{
			if(monster.charData.characterType == CharacterType.BOSS_MONSTER
				|| monster.charData.characterType == CharacterType.ELITE_BOSS_MONSTER){
				if(!checkGameOver() && !_showPassLevel){
					_showPassLevel = true;
					PassLevelControl(ControlFactory.getIns().getControl(PassLevelControl)).showInfo(monster);
				}
			}
		}
		
		/**
		* 检测怪物数量
		* @param e
		* 
		*/		
		public function checkMonsterDeath(monster:MonsterEntity) : void{
			//是否是Boss死亡
			if(monster.charData.characterType == CharacterType.BOSS_MONSTER
				|| monster.charData.characterType == CharacterType.ELITE_BOSS_MONSTER){
				monster.charData.useProperty.hp = 0;
				monster.changeHp(0);
				for each(var item:MonsterEntity in _monsterVec){
					if(item.charData.useProperty.hp > 0 && item.curAction != ActionState.GROUNDDEAD && item.curAction != ActionState.DEAD){
						item.setAction(ActionState.GROUNDDEAD);
					}
				}
				_gameOver = true;
			}else{
				_monsterVec.splice(_monsterVec.indexOf(monster), 1);
				monster.destroy();
				
				if(_monsterVec.length == 0){
					LevelManager.getIns().nowWaveIndex++;
				}
			}
			SceneManager.getIns().getWeatherProp(monster.pos);
		}
		
		public function allMonsterDeath() : void{
			slowDownWithTime(.25);
			for each(var item:MonsterEntity in _monsterVec){
				if(item.charData.useProperty.hp > 0 && item.curAction != ActionState.GROUNDDEAD && item.curAction != ActionState.DEAD){
					item.charData.useProperty.hp = 0;
					item.setAction(ActionState.GROUNDDEAD);
				}
				if(item is ChiNanEntity){
					(item as ChiNanEntity).isAlreadyDead = true;
				}
				if(item is YuanNvEntity){
					(item as YuanNvEntity).isAlreadyDead = true;
				}
			}
		}
		
		//特殊怪死亡（绝秀娇俏）
		public function allSpecialMonsterDeath() : void{
			for each(var item:MonsterEntity in _monsterVec){
				if(item.charData.characterType == CharacterType.SPECIAL_BOSS_MONSTER){
					item.charData.useProperty.hp = 0;
					item.setAction(ActionState.GROUNDDEAD);
				}
			}
		}
		
		//特殊怪动作（绝秀娇俏）
		public function allSpecialMonsterAction(action:uint) : void{
			for each(var item:MonsterEntity in _monsterVec){
				if(item.charData.characterType == CharacterType.SPECIAL_BOSS_MONSTER
					|| item.charData.characterType == CharacterType.BOSS_MONSTER
					|| item.charData.characterType == CharacterType.ELITE_BOSS_MONSTER){
					item.setAction(action);
					item.isLock = false;
					if(item.x > _myPlayer.x){
						item.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
					}else{
						item.faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
					}
				}
			}
		}
		
		public function checkMonsterClear(monster:MonsterEntity) : void{
			_monsterVec.splice(_monsterVec.indexOf(monster), 1);
			monster.destroy();
			monster = null;
		}
		
		//时间暂停
		public function slowDownWithTime(percent:Number, callback:Function = null) : void{
			slowDown(percent, callback);
			(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).levelTimeEffect.stop();
		}
		
		public function slowDown(percent:Number, callback:Function = null) : void{
			_slowDownEffect = new SlowDownEffect();
			_slowDownEffect.percent = percent;
			_slowDownEffect.addObj(RenderEntityManager.getIns().childrensList);
			_slowDownEffect.addObj(childrens);
			_slowDownEffect.callback = callback;
			_slowDownEffect.start();
		}
		
		public function resetRenderSlow() : void{
			_slowDownEffect.stop();
		}
		
		override public function step():void{
			super.step();
			
			resetPosition();
		}
		
		private var unResetEntity:Array = [EffectEntity];
		private function unResetJudge(bne:BaseNativeEntity) : Boolean{
			var result:Boolean = false;
			for(var i:int = 0; i < unResetEntity.length; i++){
				if(bne is unResetEntity[i]){
					result = true;
					break;
				}
			}
			return result;
		}
		
		public function rainSlowDonwSpeed() : void{
			for(var i:int = 0; i < players.length; i++){
				players[i].charData.addBuff(BuffType.BUFF_SPEED, -.1);
			}
		}
		public function rainResetSpeed() : void{
			for(var i:int = 0; i < players.length; i++){
				players[i].charData.removeBuff(BuffType.BUFF_SPEED, -.1);
			}
		}
		
		/**
		 * 重新排列怪物和角色的Y轴位置
		 * 
		 */		
		private function resetPosition():void{
			var len:int = this.positionList.length;
			for(var i:int = 0; i < len; i++){
				if(positionList[i] == null || unResetJudge(positionList[i])) continue;
				for(var j:int = 0; j < len; j++){
					if(positionList[j] == null || unResetJudge(positionList[j])) continue;
					if(positionList[i] is SequenceActionEntity && positionList[j] is SequenceActionEntity){
						if(positionList[i].shadowPos.y > positionList[j].shadowPos.y && getChildIndex(positionList[i]) < getChildIndex(positionList[j])){
							var start:SequenceActionEntity = childrens[childrens.indexOf(positionList[j])] as SequenceActionEntity;
							childrens[childrens.indexOf(positionList[j])] = childrens[childrens.indexOf(positionList[i])];
							childrens[childrens.indexOf(positionList[i])] = start;
							this.swapChildren(positionList[i], positionList[j]);
						}
					}
				}
			}
		}
		
//		/**
//		 * 玩家退出(别的玩家)
//		 * @param uid 玩家uid
//		 * 
//		 */		
//		private function playerLeft(uid:int):void{
//			var len:uint = this._players.length;
//			for(var i:uint=0;i<len;i++){
//				var pe:PlayerEntity = this._players[i];
//				if(pe.player.uid == uid){
//					this._players.splice(i,1);
//					pe.destroy();
//					return;
//				}
//			}
//		}
		
		
		/**
		 * 根据服务端返回命令，渲染游戏 
		 * @param command
		 * 
		 */	
		public function updateByCommand(command:ByteArray):void{
			if(_isStopRender || _hackStopRender){
				for each(player in this._players){
					if(player is KuangWuEntity){
						KuangWuActionControl.getIns().controlKeyUp(player);
					}else if(player is XiaoYaoEntity){
						XiaoYaoActionControl.getIns().controlKeyUp(player);
					}
					player.keyBoard.step();
				}
				return;
			}
			
			ServerControllor.getIns().frameCount++;
//			trace("FrameCount:"+ServerControllor.getIns().frameCount);
			
			var player:PlayerEntity;
			var curPlayer:PlayerEntity;
			
			while(command.bytesAvailable){
				var len:int = command.readInt();//单人命令长度
				var index:int = command.readInt();
				len -= 4;
				
				for each(player in this._players){
					if(player.player.index == index){
						curPlayer = player;
						break;
					}
				}
				if(curPlayer){
					while(len > 0){
						var keyCode:int = command.readInt();//按键码
						var operation:int = command.readInt();//操作符号(0:keydown,1:keyup)
						if(keyCode > 0){
							if(operation == KeyOperationType.KEY_DOWN){
								curPlayer.keyBoard.keyDown(keyCode);
							}else if(operation == KeyOperationType.KEY_UP){
								curPlayer.keyBoard.keyUp(keyCode);
							}
						}else{
							//特殊操作
//							if(operation == KeyOperationType.PLAYER_LEFT){
//								//玩家离开副本
////								this.playerLeft(uid);
//							}
						}
						
						len -= 8;
					}
					curPlayer = null;
				}else{
					break;
				}
			}
			for each(player in this._players){
				GameSceneManager.getIns().gameScenePlayerControl(player);
			}
			
			//控制地图移动
			controlMap();
			topRender();
			RenderEntityManager.getIns().step();
			LayerManager.getIns().step();
			PhysicsWorld.getIns().step();
			EffectManager.getIns().step();
			GameProcessManager.getIns().step();
			AssessManager.getIns().step();
			SoundManager.getIns().step();
			StageClickManager.getIns().step();
			WeatherManager.getIns().step();
			HideMissionManager.getIns().step();
			QingMingManager.getIns().step();
			StoryManager.getIns().step();
			MidAutumnManager.getIns().step();
		}
		
		protected function controlMap():void{
			if(!this._myPlayer){
				return;
			}
			var map:BaseMapView = (ViewFactory.getIns().getView(BaseMapView) as BaseMapView);
			if(map != null){
				if(_gameOver){
					map.controlMap();
					showGo(false);
				}else if(_monsterVec.length == 0 && !LevelManager.getIns().isStart){
					map.controlMap(true);
					showGo(true);
					partnerPlayerPosition(true);
				}else{
					map.controlMap();
					showGo(false);
					partnerPlayerPosition(false);
				}
			}
		}
		
		private function partnerPlayerPosition(limit:Boolean) : void{
			if(_partnerPlayer == null)	return;
			if(!_partnerPlayer.visible)  return;
			if(_partnerPlayer.charData.useProperty.hp <= 0){
				_partnerPlayer.characterControl.limitLeftX = 0;
				_partnerPlayer.characterControl.limitRightX = 4700;
				return;
			}
			var map:BaseMapView = (ViewFactory.getIns().getView(BaseMapView) as BaseMapView);
			if(_myPlayer.charData.useProperty.hp > 0){
				if(limit){
					_partnerPlayer.characterControl.limitLeftX = (_myPlayer.x - 900<0?0:_myPlayer.x - 900);
					_partnerPlayer.characterControl.limitRightX = (_myPlayer.x + 900>4700?4700:_myPlayer.x + 900);
				}else{
					_partnerPlayer.characterControl.limitLeftX = (_myPlayer.x - 900<map.mapEntity["limit" + map.nowLimitIndex + "_1"].x?map.mapEntity["limit" + map.nowLimitIndex + "_1"].x:_myPlayer.x - 900);
					_partnerPlayer.characterControl.limitRightX = (_myPlayer.x + 900>map.mapEntity["limit" + map.nowLimitIndex + "_2"].x?map.mapEntity["limit" + map.nowLimitIndex + "_2"].x:_myPlayer.x + 900);
				}
			}else{
				if(!limit){
					_partnerPlayer.characterControl.limitLeftX = map.mapEntity["limit" + map.nowLimitIndex + "_1"].x;
					_partnerPlayer.characterControl.limitRightX = map.mapEntity["limit" + map.nowLimitIndex + "_2"].x;
				}
			}
		}
		
		//检测是否有玩家到达出怪点
		public function checkPlayerCross(xPos:int) : Boolean{
			var result:Boolean = false;
			for each(var item:PlayerEntity in players){
				if(item.x > xPos){
					result = true;
					break;
				}
			}
			return result;
		}
		
		/**
		 * 移动地图 
		 * @param p
		 * 
		 */		
		public function offsetPoints(p:Point):void{
			this.x += p.x;
			this.y += p.y;
		}
		
		private function topRender():void{
			var xPos:int = MapManager.getIns().nowMap.x;
			for(var i:int = 0; i < _topList.length; i++){
				if(_topList[i].parent != null){
					 childrens.splice(childrens.indexOf(_topList[i]), 1);
					 childrens.push(_topList[i]);
				}
			}
		}
		
		public function pushTop(bne:BaseNativeEntity) : void{
			if(checkUI(bne) == -1){
				_topList.push(bne);
				this.addChildAt(bne, this.numChildren - 1);
			}
		}
		
		public function popTop(bne:BaseNativeEntity) : void{
			var index:int = checkUI(bne);
			if(index != -1){
				_topList.splice(index, 1);
				if(bne.parent != null){
					bne.parent.removeChild(bne);
				}
			}
		}
		
		public function checkUI(bne:BaseNativeEntity) : int{
			var result:int = _topList.indexOf(bne);
			return result;
		}
		
		private var unResetList:Array = ["HurtEffect", "HitEffect", "Obstacle", "BlackEffect", "RainLayer"];
		private var positionList:Array = new Array();
		private function unResetName(name:String) : Boolean{
			var result:Boolean = false;
			for(var i:int = 0; i < unResetList.length; i++){
				if(name == unResetList[i]){
					result = true;
					break;
				}
			}
			return result;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject{
			var dio:DisplayObject = super.addChild(child);
			if(!unResetName(child.name)){
				var idx:int = this.positionList.indexOf((child as BaseNativeEntity));
				if(idx == -1){
					this.positionList.push((child as BaseNativeEntity));
				}
			}
			return dio;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject{
			var dio:DisplayObject = super.addChildAt(child,index);
			if(!unResetName(child.name)){
				var idx:int = this.positionList.indexOf((child as BaseNativeEntity));
				if(idx == -1){
					this.positionList.splice(index, 0, (child as BaseNativeEntity));
				}
			}
			return dio;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject{
			var dio:DisplayObject = super.removeChild(child);
			var idx:int = this.positionList.indexOf((child as BaseNativeEntity));
			if(idx != -1){
				this.positionList.splice(idx,1);
			}
			return dio;
		}
		
		public function gameStart() : void{
			addDeactivete();
		}
		
		public function addDeactivete() : void{
			if(!GameConst.localLogin){
				GameConst.stage.addEventListener(Event.DEACTIVATE, onDeactivate);
			}
		}
		
		public function clearDeactivate() : void{
			if(!GameConst.localLogin){
				GameConst.stage.removeEventListener(Event.DEACTIVATE, onDeactivate);
			}
		}
		
		override public function destroy():void{
			GameConst.stage.removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			GameConst.stage.removeEventListener(KeyboardEvent.KEY_UP,__keyUp);
			GameConst.stage.removeEventListener(Event.DEACTIVATE, onDeactivate);
			SkillManager.getIns().unHurt();
			EffectManager.getIns().clear();
			PhysicsWorld.getIns().clear();
			PhysicsWorld.getIns().collisionListener = null;
			MyUserManager.getIns().player = null;
			LayerManager.getIns().gameLayer.reset();
			RenderEntityManager.getIns().removeEntity(this);
			RenderEntityManager.getIns().clear();
			AssessManager.getIns().clear();
			GameProcessManager.getIns().clear();
			LevelManager.getIns().clear();
			SoundManager.getIns().clear();
			StageClickManager.getIns().clear();
			WeatherManager.getIns().destroy();
			HideMissionManager.getIns().clear();
			RoleManager.getIns().clear();
			StoryManager.getIns().clear();
			//SceneManager.getIns().clear();
			
			if(this._myPlayer){
				this._myPlayer = null;
			}
			var monsters:Vector.<MonsterEntity> = _monsterVec.concat();
			for each(var mon:MonsterEntity in monsters){
				mon.dispatchEvent(new CharacterEvent(CharacterEvent.MONSTER_CLEAR_EVENT));
			}
			monsters.length = 0;
			monsters = null;
			
			for each(var player:PlayerEntity in _players){
				RenderEntityManager.getIns().removeEntity(player);
				player.destroy();
			}
			this._monsterVec = null;
			this._players = null;
			
			for each(var resource:String in _monsterResource){
				BitmapDataPool.removeData(resource);
			}
			
			if(_slowDownEffect != null){
				_slowDownEffect.destroy();
				_slowDownEffect = null;
			}
			if(_treasureEntity != null){
				_treasureEntity.destroy();
				_treasureEntity = null;
			}
			if(_clickThingEntity != null){
				_clickThingEntity.destroy();
				_clickThingEntity = null;
			}
			if(_obstacleEntity != null){
				_obstacleEntity.destroy();
				_obstacleEntity = null;
			}
			for(var i:int = 0; i < _materialClickList.length; i++){
				if(_materialClickList[i] != null){
					_materialClickList[i].destroy();
					_materialClickList[i] = null;
				}
			}
			_materialClickList.length = 0;
			
			super.destroy();
		}

		public function get players():Vector.<PlayerEntity>
		{
			return _players;
		}
		
		public function get partnerPlayer() : PlayerEntity{
			return _partnerPlayer;
		}

		public function get myPlayer():PlayerEntity
		{
			return _myPlayer;
		}
		
		public function get monsters() : Vector.<MonsterEntity>{
			return _monsterVec;
		}
		
		public function get childrensNum() : int{
			return childrens.length;
		}

	}
}