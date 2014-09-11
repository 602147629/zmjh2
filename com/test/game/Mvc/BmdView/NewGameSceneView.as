package com.test.game.Mvc.BmdView
{
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
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
	import com.test.game.Const.CharacterType;
	import com.test.game.Const.KeyOperationType;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Effect.EffectEntity;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Manager.AssessManager;
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
	import com.test.game.Modules.MainGame.StartPageView;
	import com.test.game.Modules.MainGame.Map.NewGameMapView;
	import com.test.game.Mvc.control.key.NewGameControl;
	
	import flash.utils.ByteArray;
	
	public class NewGameSceneView extends BaseBmdView
	{
		private var _monsterVec:Vector.<MonsterEntity> = new Vector.<MonsterEntity>();
		private var _players:Vector.<PlayerEntity> = new Vector.<PlayerEntity>();
		//玩家自己
		private var _kuangWuPlayer:PlayerEntity;
		private var _xiaoYaoPlayer:PlayerEntity;
		private var _topList:Vector.<BaseNativeEntity> = new Vector.<BaseNativeEntity>();
		private var _gameOver:Boolean;
		//怪物素材资源数组
		private var _monsterResource:Vector.<String> = new Vector.<String>();
		public function NewGameSceneView()
		{
			super();
		}
		
		override public function init():void{
			super.init();
			initParams();
		}
		
		private function initParams():void{
			RenderEntityManager.getIns().addEntity(this);
			PhysicsWorld.getIns().clear();
			PhysicsWorld.getIns().collisionListener = new PlayerKillingCollisionListener();	
			initPlayer();
			RoleManager.getIns().fightType = 0;
			//GameProcessManager.getIns().init();
		}
		
		public function initPlayer():void{
			var data:Object = new Object(); 
			data.uid = GameConst.UID;
			data.data = null;
			if(PlayerManager.getIns().player.occupation == 1){
				initKuangWuPlayer(RoleManager.getIns().createPlayer(80, 360, data));
				initXiaoYaoPlayer(RoleManager.getIns().createPartnerPlayer(860, 400, data));
			}else{
				initKuangWuPlayer(RoleManager.getIns().createPartnerPlayer(80, 360, data));
				initXiaoYaoPlayer(RoleManager.getIns().createPlayer(860, 400, data));
			}
			
			initMonster(RoleManager.getIns().createConvoyMonster(1008, 200, 370, 50, false));
			initMonster(RoleManager.getIns().createConvoyMonster(1008, 250, 350, 50, false));
			initMonster(RoleManager.getIns().createConvoyMonster(1008, 290, 390, 50, false));
			initMonster(RoleManager.getIns().createConvoyMonster(1008, 350, 370, 50, false));
			
			initMonster(RoleManager.getIns().createConvoyMonster(1008, 750, 410, 50, false));
			initMonster(RoleManager.getIns().createConvoyMonster(1008, 660, 390, 50, false));
			initMonster(RoleManager.getIns().createConvoyMonster(1008, 680, 430, 50, false));
			initMonster(RoleManager.getIns().createConvoyMonster(1008, 620, 410, 50, false));
			
			//BattleUIManager.getIns().setMainBattleTool(_kuangWuPlayer.player, _kuangWuPlayer.charData.skillConfigurationVo);
		}
		
		//创建角色
		private function initXiaoYaoPlayer(player:PlayerEntity):void{
			_xiaoYaoPlayer = player;
			_xiaoYaoPlayer.charData.relive();
			_xiaoYaoPlayer.charData.angerCount = 100;
			_xiaoYaoPlayer.charData.bossCount = 100;
			_xiaoYaoPlayer.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
			_xiaoYaoPlayer.collisionIndex = CollisionFilterIndexConst.PLAYER;
			_xiaoYaoPlayer.collisionListeners = [CollisionFilterIndexConst.MONSTER_SKILL];
			if(_xiaoYaoPlayer.mainConjure != null){
				_xiaoYaoPlayer.mainConjure.collisionIndex = CollisionFilterIndexConst.PLAYER;
			}
			
			this.addChild(_xiaoYaoPlayer);
			_players.push(_xiaoYaoPlayer);
		}
		
		//创建角色
		private function initKuangWuPlayer(player:PlayerEntity):void{
			_kuangWuPlayer = player;
			_kuangWuPlayer.charData.relive();
			_kuangWuPlayer.charData.angerCount = 100;
			_kuangWuPlayer.charData.bossCount = 100;
			_kuangWuPlayer.collisionIndex = CollisionFilterIndexConst.PLAYER;
			_kuangWuPlayer.collisionListeners = [CollisionFilterIndexConst.MONSTER_SKILL];
			if(_kuangWuPlayer.mainConjure != null){
				_kuangWuPlayer.mainConjure.collisionIndex = CollisionFilterIndexConst.PLAYER;
			}
			
			this.addChild(_kuangWuPlayer);
			_players.push(_kuangWuPlayer);
		}
		
		public function initMonster(mon:MonsterEntity) : void{
			//this.addChild(mon);
			_monsterVec.push(mon);
			mon.isLock = true;
			if(mon.x > 500){
				mon.faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
			}else{
				mon.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
			}
			var len:int = mon.charData.assetsArray.length;
			for(var i:int = 0; i < len; i++){
				_monsterResource.push(mon.charData.assetsArray[i]);
			}
		}
		
		public function resetRenderSlow() : void{
			
		}
		
		public function playerDeath(player:PlayerEntity) : void{
			
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
			if(_kuangWuPlayer.charData.useProperty.hp > 0){
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
		
		public function checkMonsterDeath(monster:MonsterEntity) : void{
			//是否是Boss死亡
			_monsterVec.splice(_monsterVec.indexOf(monster), 1);
			monster.destroy();
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
			
			//控制地图移动
			controlMap();
			topRender();
			scriptRender();
			RenderEntityManager.getIns().step();
			LayerManager.getIns().step();
			PhysicsWorld.getIns().step();
			EffectManager.getIns().step();
			AssessManager.getIns().step();
			SoundManager.getIns().step();
		}
		
		private var _scriptControl:Boolean = true;
		private var _kuangWuActions:Array = [ActionState.RUNHIT, ActionState.HIT1, ActionState.HIT2, ActionState.SKILL2, ActionState.HIT1, ActionState.HIT2, ActionState.HIT3, ActionState.HIT4, ActionState.SKILL6, ActionState.RUNHIT, ActionState.SKILL8, ActionState.SKILL10];
		private var _kuangWuTimes:Array = [50, 60, 73, 86, 112, 125, 138, 149, 168, 187, 200, 230];
		private var _xiaoYaoActions:Array = [ActionState.SKILL1, ActionState.HIT1, ActionState.HIT2, ActionState.HIT3, ActionState.HIT4, ActionState.SKILL7, ActionState.RUNHIT, ActionState.SKILL6, ActionState.SKILL9, ActionState.SKILL9, ActionState.SKILL7, ActionState.SKILL5];
		private var _xiaoYaoTimes:Array = [50, 64, 80, 93, 108, 128, 143, 153, 159, 170, 230, 225];
		private var _scriptStep:int = 45;
		private var _scriptKuangWuCount:int;
		private var _scriptXiaoYaoCount:int;
		private function scriptRender() : void{
			if(!_scriptControl) return;
			_scriptStep++;
			kuangWuScript();
			xiaoYaoScript();
			dialogScript();
			cartoonScript();
		}
		
		private function kuangWuScript() : void{
			if(_scriptStep == 46){
				players[0].faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
				players[0].moveHorizontalDirect = DirectConst.DIRECT_RIGHT;
				players[0].commonHitFace = DirectConst.DIRECT_RIGHT;
			}else if(_scriptStep >= 200 && _scriptStep < 230){
				players[0].faceHorizontalDirect = DirectConst.DIRECT_LEFT;
				players[0].moveLeft();
			}else if(_scriptStep >= 230){
				players[0].faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
			}
			for(var i:int = 0; i < _kuangWuTimes.length; i++){
				if(_kuangWuTimes[i] == _scriptStep){
					players[0].setAction(_kuangWuActions[_scriptKuangWuCount]);
					_scriptKuangWuCount++;
				}
			}
			
			if(_scriptStep >= 300 && _scriptStep <= 312){
				players[0].setAction(ActionState.WALK);
				players[0].moveRight();
			}else if(_scriptStep == 313){
				players[0].setAction(ActionState.WAIT);
			}
		}
		
		private function xiaoYaoScript() : void{
			if(_scriptStep == 46){
				players[1].faceHorizontalDirect = DirectConst.DIRECT_LEFT;
				players[1].moveHorizontalDirect = DirectConst.DIRECT_LEFT;
				players[1].commonHitFace = DirectConst.DIRECT_LEFT;
			}else if(_scriptStep >= 108 && _scriptStep <= 115){
				players[1].moveLeft();
			}else if(_scriptStep >= 158 && _scriptStep < 219){
				players[1].faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
			}else if(_scriptStep == 219){
				players[1].faceHorizontalDirect = DirectConst.DIRECT_LEFT;
			}
			
			for(var j:int = 0; j < _xiaoYaoTimes.length; j++){
				if(_xiaoYaoTimes[j] == _scriptStep){
					players[1].setAction(_xiaoYaoActions[_scriptXiaoYaoCount]);
					_scriptXiaoYaoCount++;
				}
			}
			if(_scriptStep == 290){
				SceneManager.getIns().allMonsterDeath();
			}
			
			if(_scriptStep >= 300 && _scriptStep <= 305){
				players[1].setAction(ActionState.WALK);
				players[1].moveDown();
			}else if(_scriptStep == 306){
				players[1].setAction(ActionState.WAIT);
			}
			
		}
		
		private function dialogScript() : void{
			if(_scriptStep == 350){
				dialogue1();
			}
		}
		
		private function dialogue1() : void{
			(ControlFactory.getIns().getControl(NewGameControl) as NewGameControl).initDialog(1, cartoon1);
			_scriptControl = false;
		}
		private function dialogue2() : void{
			players[0].visible = true;
			players[1].visible = true;
			players[0].x -= 130;
			players[1].x -= 477;
			players[1].y += 20;
			players[1].faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
			(ControlFactory.getIns().getControl(NewGameControl) as NewGameControl).initDialog(2, cartoon2);
			_scriptControl = false;
		}
		private function dialogue3() : void{
			(ControlFactory.getIns().getControl(NewGameControl) as NewGameControl).initDialog(3, cartoon3);
			_scriptControl = false;
		}
		private function dialogue4() : void{
			players[0].visible = true;
			players[1].visible = true;
			(ControlFactory.getIns().getControl(NewGameControl) as NewGameControl).initDialog(4, cartoon4);
			_scriptControl = false;
		}
		
		private function cartoon1() : void{
			players[0].visible = false;
			players[1].visible = false;
			(ControlFactory.getIns().getControl(NewGameControl) as NewGameControl).initCartoon(1, dialogue2);
			_scriptControl = false;
		}
		private function cartoon2() : void{
			players[0].visible = false;
			players[1].visible = false;
			(ControlFactory.getIns().getControl(NewGameControl) as NewGameControl).initCartoon(2, dialogue3);
			_scriptControl = false;
		}
		private function cartoon3() : void{
			players[0].visible = false;
			players[1].visible = false;
			(ControlFactory.getIns().getControl(NewGameControl) as NewGameControl).initCartoon(3, dialogue4);
			_scriptControl = false;
		}
		private function cartoon4() : void{
			players[0].visible = false;
			players[1].visible = false;
			(ControlFactory.getIns().getControl(NewGameControl) as NewGameControl).initCartoon(4, newGameComplete);
			_scriptControl = false;
		}
		
		private function newGameComplete():void
		{
			(ViewFactory.getIns().getView(StartPageView) as StartPageView).clearGameCartoon();
		}
		
		private function cartoonScript():void{
			
		}
		
		private function dialogCallback() : void{
			_scriptControl = true;
		}
		
		protected function controlMap():void{
			if(!this._kuangWuPlayer){
				return;
			}
			var map:NewGameMapView = (ViewFactory.getIns().getView(NewGameMapView) as NewGameMapView);
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
		
		override public function destroy():void{
			SkillManager.getIns().unHurt();
			EffectManager.getIns().clear();
			PhysicsWorld.getIns().clear();
			PhysicsWorld.getIns().collisionListener = null;
			MyUserManager.getIns().player = null;
			LayerManager.getIns().gameLayer.reset();
			RenderEntityManager.getIns().removeEntity(this);
			RenderEntityManager.getIns().clear();
			LevelManager.getIns().clear();
			SoundManager.getIns().clear();
			RoleManager.getIns().clear();
			
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
			
			super.destroy();
		}
		
		public function get players():Vector.<PlayerEntity>
		{
			return _players;
		}
		
		public function get myPlayer():PlayerEntity
		{
			return _kuangWuPlayer;
		}
		
		public function get monsters() : Vector.<MonsterEntity>{
			return _monsterVec;
		}
		
		public function get childrensNum() : int{
			return childrens.length;
		}
	}
}