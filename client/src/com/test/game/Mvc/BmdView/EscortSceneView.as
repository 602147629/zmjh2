package com.test.game.Mvc.BmdView
{
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.game.ResourceOperation.BitmapDataPool;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseBmdView;
	import com.test.game.Const.AutoFightConst;
	import com.test.game.Const.CharacterType;
	import com.test.game.Const.KeyOperationType;
	import com.test.game.Effect.WeatherShowEffect;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Effect.EffectEntity;
	import com.test.game.Entitys.Monsters.EscortEntity;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Manager.AssessManager;
	import com.test.game.Manager.BattleUIManager;
	import com.test.game.Manager.EscortManager;
	import com.test.game.Manager.GameProcessManager;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.MyUserManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.ServerControllor;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.Collision.PlayerKillingCollisionListener;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Modules.MainGame.Escort.EscortBar;
	import com.test.game.Modules.MainGame.Map.EscortMapView;
	import com.test.game.Mvc.control.character.LootAutoFightControl;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	public class EscortSceneView extends BaseBmdView
	{
		private var _monsterVec:Vector.<MonsterEntity> = new Vector.<MonsterEntity>();
		private var _players:Vector.<PlayerEntity> = new Vector.<PlayerEntity>();
		private var _convoys:Vector.<EscortEntity> = new Vector.<EscortEntity>();
		//玩家自己
		private var _myPlayer:PlayerEntity;
		private var _otherPlayer:PlayerEntity;
		private var _topList:Vector.<BaseNativeEntity> = new Vector.<BaseNativeEntity>();
		private var _gameStart:Boolean = false;
		//怪物素材资源数组
		private var _monsterResource:Vector.<String> = new Vector.<String>();
		//时间计数
		private var _timeStep:int;
		//重新请求护镖计数
		private var _restartTimeStep:int;
		private var _restartEscort:Boolean = false;
		private var _hasEnemyPlayer:Boolean = false;
		private var _infoShowEffect:WeatherShowEffect;
		private var _lootInfo:Sprite;
		public function EscortSceneView()
		{
			super();
		}
		
		override public function init():void{
			super.init();
			initParams();
		}
		
		private function initParams():void{
			GameConst.stage.addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			GameConst.stage.addEventListener(KeyboardEvent.KEY_UP,__keyUp);
			RenderEntityManager.getIns().addEntity(this);
			PhysicsWorld.getIns().clear();
			PhysicsWorld.getIns().collisionListener = new PlayerKillingCollisionListener();	
			GameProcessManager.getIns().init();
			EscortManager.getIns().init();
			initPlayer();
			initUI();
			RoleManager.getIns().fightType = 1;
			
			/*if(GameConst.localLogin){
				setTimeout(function(){
					EscortManager.getIns().escortResultShow(2);
				},8000);
			}*/
		}
		
		private function initUI() : void{
			_infoShowEffect = new WeatherShowEffect();
			_lootInfo = AssetsManager.getIns().getAssetObject("EscortInfo") as Sprite;
			_lootInfo.x = GameConst.stage.stageWidth * .5;
			_lootInfo.y = GameConst.stage.stageHeight * .5 - 100;
		}
		
		protected function __keyUp(evt:KeyboardEvent):void{
			ServerControllor.getIns().acceptOperation(MyUserManager.getIns().player.index,evt.keyCode,KeyOperationType.KEY_UP);
		}
		
		protected function __keyDown(evt:KeyboardEvent):void{
			clearMonsterTest(evt.keyCode);
			ServerControllor.getIns().acceptOperation(MyUserManager.getIns().player.index,evt.keyCode,KeyOperationType.KEY_DOWN);
		}
		
		private function clearMonsterTest(keyCode:uint) : void{
			if(keyCode == Keyboard.R && GameConst.useDebug){
				SceneManager.getIns().allMonsterDeath();
			}
		}
		
		public function initPlayer():void{
			var lv:int = PlayerManager.getIns().player.character.lv;
			var data:Object = new Object(); 
			data.uid = GameConst.UID;
			data.data = null;
			initMyPlayer(RoleManager.getIns().createPlayer(80, 400, data, 4));
			data.uid = "1234567890";
			var index:int = EscortManager.getIns().nowBiaoChe;
			var biaoCheName:String;
			var fodder:String;
			switch(index){
				case 1:
					initConvoy(RoleManager.getIns().createConvoy(5901, 240, 350, lv));
					initConvoy(RoleManager.getIns().createConvoy(5902, 290, 400, lv));
					biaoCheName = "木牛";
					fodder = "BiaoCheMuNiu";
					break;
				case 2:
					initConvoy(RoleManager.getIns().createConvoy(5911, 240, 350, lv));
					initConvoy(RoleManager.getIns().createConvoy(5912, 290, 400, lv));
					initConvoy(RoleManager.getIns().createConvoy(5913, 240, 450, lv));
					biaoCheName = "流马";
					fodder = "BiaoCheLiuMa";
					break;
				case 3:
					initConvoy(RoleManager.getIns().createConvoy(5921, 240, 350, lv));
					initConvoy(RoleManager.getIns().createConvoy(5922, 290, 400, lv));
					initConvoy(RoleManager.getIns().createConvoy(5923, 240, 450, lv));
					biaoCheName = "金车";
					fodder = "BiaoCheJinChe";
					break;
			}
			var allHp:int = 0;
			for(var i:int = 0; i < convoys.length; i++){
				allHp += convoys[i].charData.totalProperty.hp;
			}
			(ViewFactory.getIns().getView(EscortBar) as EscortBar).escortSetting(biaoCheName, lv, fodder, allHp, index);
			
			BattleUIManager.getIns().setMainBattleTool(myPlayer.player, myPlayer.charData.skillConfigurationVo);
		}
		
		public function gameStart() : void{
			_gameStart = true;
		}
		
		//创建镖车
		private function initConvoy(con:EscortEntity):void{
			_convoys.push(con);
			con.isLock = true;
			con.hideBloodBar();
			con.characterControl.limitLeftX = 0;
			con.characterControl.limitRightX = 4600;
			con.characterJudge.isUseAutoFight = true;
			con.collisionIndex = CollisionFilterIndexConst.PLAYER;
			con.collisionListeners = [CollisionFilterIndexConst.MONSTER_SKILL, CollisionFilterIndexConst.ALL_SKILL];
			var len:int = con.charData.assetsArray.length;
			for(var i:int = 0; i < len; i++){
				_monsterResource.push(con.charData.assetsArray[i]);
			}
		}
		
		//创建角色
		private function initMyPlayer(player:PlayerEntity):void{
			_myPlayer = player;
			_myPlayer.isLock = true;
			_myPlayer.charData.relive();
			_myPlayer.charData.angerCount = 100;
			_myPlayer.charData.bossCount = 100;
			_myPlayer.collisionIndex = CollisionFilterIndexConst.PLAYER;
			_myPlayer.collisionListeners = [CollisionFilterIndexConst.MONSTER_SKILL];
			if(_myPlayer.mainConjure != null){
				_myPlayer.mainConjure.collisionIndex = CollisionFilterIndexConst.PLAYER;
			}
			if(_myPlayer.minorConjure != null){
				_myPlayer.minorConjure.collisionIndex = CollisionFilterIndexConst.PLAYER;
			}
			this.addChild(player);
			_players.push(player);
		}
		
		private function enemyPlayerCallback() : void{
			DebugArea.getIns().showInfo("---护镖场景里开始创建劫镖角色---");
			_hasEnemyPlayer = true;
			var data:Object = new Object(); 
			data.uid = "1234567890";
			data.data = EscortManager.getIns().gainData.otherPlayerData;
			initEnemyPlayer(RoleManager.getIns().createPlayer(4000, 400, data));
		}
		
		private function initEnemyPlayer(otherPlayer:PlayerEntity) : void{
			_infoShowEffect.start(_lootInfo);
			LayerManager.getIns().gameTipLayer.addChild(_lootInfo);
			_otherPlayer = otherPlayer;
			_otherPlayer.autoFightControl = new LootAutoFightControl(_otherPlayer);
			_otherPlayer.autoFightControl.autoType = AutoFightConst.AUTO_TYPE_NORMAL;
			_otherPlayer.autoFightControl.startAutoFight = true;
			_otherPlayer.charData.characterType = CharacterType.OTHER_PLAYER;
			_otherPlayer.charData.relive();
			_otherPlayer.charData.angerCount = 100;
			_otherPlayer.charData.bossCount = 100;
			_otherPlayer.collisionIndex = CollisionFilterIndexConst.MONSTER;
			_otherPlayer.collisionListeners = [CollisionFilterIndexConst.PLAYER_SKILL];
			if(_otherPlayer.mainConjure != null){
				_otherPlayer.mainConjure.collisionIndex = CollisionFilterIndexConst.MONSTER;
			}
			if(_otherPlayer.minorConjure != null){
				_otherPlayer.minorConjure.collisionIndex = CollisionFilterIndexConst.MONSTER;
			}
			_otherPlayer.initPlayerName(_otherPlayer.player.name, 1);
			_otherPlayer.initBlood();
			this.addChild(_otherPlayer);
			_players.push(_otherPlayer);
			MyUserManager.getIns().player = myPlayer.player;
		}
		
		public function initMonster(mon:MonsterEntity) : void{
			//this.addChild(mon);
			_monsterVec.push(mon);
			mon.isLock = true;
			mon.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
			var len:int = mon.charData.assetsArray.length;
			for(var i:int = 0; i < len; i++){
				_monsterResource.push(mon.charData.assetsArray[i]);
			}
		}
		
		public function resetRenderSlow() : void{
			
		}
		
		private function allPlayerLock() : void{
			for(var i:int = 0; i < _players.length; i++){
				_players[i].isLock = true;
			}
		}
		
		private function allMonsterLock() : void{
			for(var i:int = 0; i < _monsterVec.length; i++){
				_monsterVec[i].isLock = true;
			}
		}
		
		public function playerDeath(player:PlayerEntity) : void{
			if(_myPlayer.charData.useProperty.hp <= 0){
				for(var i:int = 0; i < convoys.length; i++){
					convoys[i].charData.useProperty.hp = 0;
				}
				EscortManager.getIns().escortResultShow(2);
				allMonsterLock();
			}else{
				_restartTimeStep = 0;
				_restartEscort = true;
				_hasEnemyPlayer = false;
				EscortManager.getIns().killCount++;
			}
		}
		
		override public function step():void{
			super.step();
			resetPosition();
		}
		
		/**
		 * 重新排列怪物和角色的Y轴位置
		 * 
		 */		
		private function resetPosition():void{
			var len:int = this.childrens.length;
			for(var i:int = 0; i < len; i++){
				for(var j:int = 0; j < len; j++){
					if(childrens[i] == null || childrens[j] == null || childrens[i] is EffectEntity || childrens[j] is EffectEntity) continue;
					if(childrens[i] is SequenceActionEntity && childrens[j] is SequenceActionEntity){
						if(childrens[i].shadowPos.y > childrens[j].shadowPos.y && getChildIndex(childrens[i]) < getChildIndex(childrens[j])){
							this.swapChildren(childrens[i], childrens[j]);
							var start:SequenceActionEntity = childrens[i] as SequenceActionEntity;
							childrens[i] = childrens[j];
							childrens[j] = start;
						}
					}
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
		
		public function get playerAliveStatus() : Boolean{
			if(_myPlayer.charData.useProperty.hp > 0){
				return true;
			}else{
				return false;
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
		}
		
		public function isShowPassLevel(monster:MonsterEntity) : void{
			if(monster.charData.characterType == CharacterType.BOSS_MONSTER
				|| monster.charData.characterType == CharacterType.ELITE_BOSS_MONSTER){
				return
				/*if(!checkGameOver() && !_showPassLevel){
				_showPassLevel = true;
				PassLevelControl(ControlFactory.getIns().getControl(PassLevelControl)).showInfo(monster);
				}*/
			}
		}
		
		public function checkMonsterDeath(monster:MonsterEntity) : void{
			EscortManager.getIns().extraReward(monster.charData.characterType, monster.pos);
			_monsterVec.splice(_monsterVec.indexOf(monster), 1);
			monster.destroy();
		}
		
		public function gameRelive() : void{
			_myPlayer.relive();
		}
		
		/**
		 * 根据服务端返回命令，渲染游戏 
		 * @param command
		 * 
		 */	
		public function updateByCommand(command:ByteArray):void{
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
			
			for(var j:int = 0; j < _players.length; j++){
				GameSceneManager.getIns().singleScenePlayerControl(_players[j]);
			}
			
			/*var mapView:BaseMapView = ViewFactory.getIns().getView(BaseMapView) as BaseMapView;
			for each(var monster:MonsterEntity in _monsterVec)
			{
			monster.stationList = mapView.stationList;
			}*/
			
			
			//控制地图移动
			controlMap();
			topRender();
			characterLimit();
			convoyMove();
			timeJudge();
			RenderEntityManager.getIns().step();
			LayerManager.getIns().step();
			PhysicsWorld.getIns().step();
			EffectManager.getIns().step();
			GameProcessManager.getIns().step();
			AssessManager.getIns().step();
			SoundManager.getIns().step();
		}
		
		private function timeJudge():void{
			if(EscortManager.getIns().isGameOver){
				allMonsterLock();
				allPlayerLock();
				return;
			}
			_timeStep++;
			//开始10秒后出怪
			if(_timeStep >= 10 * 30){
				EscortManager.getIns().monsterStep();
			}
			//护镖开始30秒后劫镖匹配\护镖结束前1分钟劫镖匹配
			if(_timeStep == 30 * 30){
				EscortManager.getIns().startMatchEscort(1, enemyPlayerCallback);
			}else if(_timeStep == EscortManager.getIns().lastEscortTime){
				EscortManager.getIns().cancelMatchEscort();
			}
			
			//每2秒更新一次护镖玩家的数据
			if(_timeStep > 30 * 30 && _timeStep % 60 == 0 && !_hasEnemyPlayer && _timeStep < EscortManager.getIns().lastEscortTime && !EscortManager.getIns().matchComplete){
				updateConvoyData();
			}
			
			//遇到一次劫镖后，10秒后才能再次劫镖
			if(_restartEscort){
				_restartTimeStep++;
				if(_restartTimeStep >= 30 * 10 && _timeStep < 30 * (60 * 4 + 30)){
					EscortManager.getIns().startMatchEscort(1, enemyPlayerCallback);
					_restartEscort = false;
				}
			}
		}
		
		private function updateConvoyData():void{
			var useHp:int = 0;
			for(var i:int = 0; i < _convoys.length; i++){
				useHp += (_convoys[i].charData.useProperty.hp>0?_convoys[i].charData.useProperty.hp:0);
			}
			var obj:Object = new Object();
			obj.playerHp = _myPlayer.charData.useProperty.hp;
			obj.carTime = 0;
			obj.carHp = useHp;
			obj.carX = _convoys[0].x;
			obj.carY = _convoys[0].y;
			EscortManager.getIns().updateMatchEscort(obj);
		}
		
		private function convoyMove():void{
			if(EscortManager.getIns().isGameOver || !_gameStart)	return;
			var useHp:int = 0;
			var totalHp:int = 0;
			for(var i:int = 0; i < _convoys.length; i++){
				_convoys[i].x += EscortManager.getIns().biaoCheSpeed;
				useHp += (_convoys[i].charData.useProperty.hp>0?_convoys[i].charData.useProperty.hp:0);
				totalHp += _convoys[i].charData.totalProperty.hp;
			}
			var hpRate:Number = useHp/totalHp;
			if(ViewFactory.getIns().getView(EscortBar) != null){
				(ViewFactory.getIns().getView(EscortBar) as EscortBar).reduceMainHp(hpRate);
			}
			
			if(_convoys.length == 3){
				if(hpRate < .67){
					_convoys[0].setAction(ActionState.HIT1);
				}
				if(hpRate < .33){
					_convoys[1].setAction(ActionState.HIT1);
				}
				if(hpRate <= 0){
					_convoys[2].setAction(ActionState.HIT1);
				}
			}else{
				if(hpRate < .5){
					_convoys[0].setAction(ActionState.HIT1);
				}
				if(hpRate <= 0){
					_convoys[1].setAction(ActionState.HIT1);
				}
			}
			
			if(useHp == 0){
				EscortManager.getIns().escortResultShow(2);
				allMonsterLock();
			}
			if(_convoys[0].x > 4300){
				EscortManager.getIns().escortResultShow(1);
				allMonsterLock();
			}
			//trace(_convoys[0].x);
		}
		
		private function characterLimit():void{
			return;
			for(var i:int = 0; i < _monsterVec.length; i++){
				_monsterVec[i].characterControl.limitLeftX = 0;
				_monsterVec[i].characterControl.limitRightX = 4700;
			}
			for(var j:int = 0; j < _players.length; j++){
				_players[j].characterControl.limitLeftX = 0;
				_players[j].characterControl.limitRightX = 4700;
			}
			for(var k:int = 0; k < _convoys.length; k++){
				_convoys[k].characterControl.limitLeftX = 0;
				_convoys[k].characterControl.limitRightX = 4600;
			}
		}
		
		protected function controlMap():void{
			if(!this._myPlayer){
				return;
			}
			var map:EscortMapView = (ViewFactory.getIns().getView(EscortMapView) as EscortMapView);
			if(map != null){
				if(EscortManager.getIns().isGameOver){
					map.controlMap();
					showGo(false);
				}else if(_monsterVec.length == 0 && !LevelManager.getIns().isStart){
					map.controlMap(true);
					showGo(true);
				}else{
					map.controlMap();
					showGo(false);
				}
			}
		}
		
		private function showGo(isShow:Boolean):void{
			/*if(isShow && !_gameOver){
			GameProcessManager.getIns().showGo();
			}else{
			GameProcessManager.getIns().hideGo();
			}*/
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
		
		override public function destroy():void{
			GameConst.stage.removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			GameConst.stage.removeEventListener(KeyboardEvent.KEY_UP,__keyUp);
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
			RoleManager.getIns().clear();
			
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
			_players.length = 0;
			_players = null;
			
			for each(var con:EscortEntity in _convoys){
				RenderEntityManager.getIns().removeEntity(con);
				con.destroy();
			}
			_convoys.length = 0;
			_convoys = null;
			
			this._monsterVec = null;
			
			for each(var resource:String in _monsterResource){
				BitmapDataPool.removeData(resource);
			}
			
			super.destroy();
		}
		
		public function get players():Vector.<PlayerEntity>
		{
			return _players;
		}
		
		public function get myPlayer():PlayerEntity
		{
			return _myPlayer;
		}
		
		public function get otherPlayer() : PlayerEntity{
			return _otherPlayer;
		}
		
		public function get monsters() : Vector.<MonsterEntity>{
			return _monsterVec;
		}
		
		public function get convoys() : Vector.<EscortEntity>{
			return _convoys;
		}
		
		public function get convoysPos() : Point{
			return _convoys[0].pos;
		}
		
		public function get childrensNum() : int{
			return childrens.length;
		}
	}
}