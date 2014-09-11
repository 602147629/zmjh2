package com.test.game.Mvc.BmdView
{
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseBmdView;
	import com.test.game.Const.CharacterType;
	import com.test.game.Const.KeyOperationType;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Effect.EffectEntity;
	import com.test.game.Entitys.Roles.KuangWuEntity;
	import com.test.game.Entitys.Roles.XiaoYaoEntity;
	import com.test.game.Manager.AssessManager;
	import com.test.game.Manager.BattleUIManager;
	import com.test.game.Manager.FbPlayersManager;
	import com.test.game.Manager.GameProcessManager;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.GameSettingManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.MyUserManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.ServerControllor;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.TeamManager;
	import com.test.game.Manager.Collision.PlayerKillingCollisionListener;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Modules.MainGame.MainUI.BattleToolBar;
	import com.test.game.Modules.MainGame.Map.TeamMapView;
	import com.test.game.Mvc.control.key.role.KuangWuActionControl;
	import com.test.game.Mvc.control.key.role.KuangWuSimpleActionControl;
	import com.test.game.Mvc.control.key.role.XiaoYaoActionControl;
	import com.test.game.Mvc.control.key.role.XiaoYaoSimpleActionControl;
	
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	
	public class TeamGameSceneView extends BaseBmdView
	{
		private var _monsterVec:Vector.<MonsterEntity> = new Vector.<MonsterEntity>();
		private var _players:Vector.<PlayerEntity> = new Vector.<PlayerEntity>();
		//玩家自己
		private var _myPlayer:PlayerEntity;
		private var _topList:Vector.<BaseNativeEntity> = new Vector.<BaseNativeEntity>();
		private var _gameOver:Boolean;
		//怪物素材资源数组
		private var _monsterResource:Vector.<String> = new Vector.<String>();
		public function TeamGameSceneView()
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
			initPlayer();
			GameProcessManager.getIns().init();
			TeamManager.getIns().loadComplete();
		}
		
		protected function __keyUp(evt:KeyboardEvent):void{
			ServerControllor.getIns().playerKillingAcceptOperation(MyUserManager.getIns().player.index,evt.keyCode,KeyOperationType.KEY_UP);
		}
		
		protected function __keyDown(evt:KeyboardEvent):void{
			ServerControllor.getIns().playerKillingAcceptOperation(MyUserManager.getIns().player.index,evt.keyCode,KeyOperationType.KEY_DOWN);
		}
		
		public function initPlayer():void{
			var datas:Array = FbPlayersManager.getIns().playerDatas;
			for(var i:int = 0; i < FbPlayersManager.getIns().playerDatas.length; i++){
				if(datas[i].gameKey == MyUserManager.getIns().socketPlayer.gameKey){
					initMyPlayer(RoleManager.getIns().createPlayer(80, 300 + i * 100, datas[i]));
				}else{
					otherPlayer(RoleManager.getIns().createPlayer(80, 300 + i * 100, datas[i]));
				}
			}
			BattleUIManager.getIns().setMainBattleTool(myPlayer.player, myPlayer.charData.skillConfigurationVo);
		}
		
		/**
		 * 创建角色
		 * @param player
		 * 
		 */		
		private function initMyPlayer(player:PlayerEntity):void{
			_myPlayer = player;
			_myPlayer.charData.relive();
			_myPlayer.charData.angerCount = 100;
			_myPlayer.charData.bossCount = 100;
			_myPlayer.collisionIndex = CollisionFilterIndexConst.PLAYER;
			_myPlayer.collisionListeners = [CollisionFilterIndexConst.MONSTER_SKILL];
			if(_myPlayer.mainConjure != null){
				_myPlayer.mainConjure.collisionIndex = CollisionFilterIndexConst.PLAYER;
			}
			
			this.addChild(player);
			_players.push(player);
		}
		
		private function otherPlayer(otherPlayer:PlayerEntity) : void{
			otherPlayer.charData.relive();
			otherPlayer.charData.angerCount = 100;
			otherPlayer.charData.bossCount = 100;
			otherPlayer.collisionIndex = CollisionFilterIndexConst.PLAYER;
			otherPlayer.collisionListeners = [CollisionFilterIndexConst.MONSTER_SKILL];
			if(otherPlayer.mainConjure != null){
				otherPlayer.mainConjure.collisionIndex = CollisionFilterIndexConst.PLAYER;
			}
			this.addChild(otherPlayer);
			_players.push(otherPlayer);
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
				_monsterResource.push(mon.charData.assetsArray[i]);
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
			for(var i:int = 0; i < _players.length; i++){
				var addHp:int = _players[i].charData.totalProperty.hp * percent * .01;
				_players[i].changeHp(-addHp);
				var addMp:int = _players[i].charData.totalProperty.mp * percent * .01;
				_players[i].changeMp(-addMp);
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
		
		/**
		 * 根据服务端返回命令，渲染游戏 
		 * @param command
		 * 
		 */	
		public function updateByCommand(command:ByteArray):void{
			
			ServerControllor.getIns().frameCount++;
			//			trace("FrameCount:"+ServerControllor.getIns().frameCount);
			
			//var player:PlayerEntity;
			var curPlayer:PlayerEntity;
			
			while(command.bytesAvailable){
				var len:int = command.readShort();//单人命令长度
				var index:int = command.readInt();
				len -= 4;
				
				for(var i:int = 0; i < _players.length; i++){
					if(_players[i].player.index == index){
						curPlayer = _players[i];
						break;
					}
				}
				
				if(curPlayer){
					while(len > 0){
						var keyCode:int = command.readShort();//按键码
						var operation:int = command.readShort();//操作符号(0:keydown,1:keyup)
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
		}
		
		protected function controlMap():void{
			if(!this._myPlayer){
				return;
			}
			var map:TeamMapView = (ViewFactory.getIns().getView(TeamMapView) as TeamMapView)
			if(map != null){
				if(_gameOver){
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
		
		public function get players():Vector.<PlayerEntity>
		{
			return _players;
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