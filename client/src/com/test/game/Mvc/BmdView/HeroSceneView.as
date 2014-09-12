package com.test.game.Mvc.BmdView
{
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
	import com.test.game.Const.EventConst;
	import com.test.game.Const.KeyOperationType;
	import com.test.game.Effect.SlowDownEffect;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Effect.EffectEntity;
	import com.test.game.Entitys.Monsters.ChiNanEntity;
	import com.test.game.Entitys.Monsters.YuanNvEntity;
	import com.test.game.Entitys.Roles.KuangWuEntity;
	import com.test.game.Entitys.Roles.XiaoYaoEntity;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Manager.AssessManager;
	import com.test.game.Manager.BattleUIManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GameProcessManager;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.HeroFightManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.MyUserManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.ServerControllor;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.Collision.CollisionListener;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Modules.MainGame.LevelInfoView;
	import com.test.game.Modules.MainGame.Map.HeroMapView;
	import com.test.game.Mvc.Vo.EnemyVo;
	import com.test.game.Mvc.control.View.GameSceneControl;
	import com.test.game.Mvc.control.View.PlayerUIControl;
	import com.test.game.Mvc.control.character.PartnerAutoFightControl;
	import com.test.game.Mvc.control.key.role.KuangWuActionControl;
	import com.test.game.Mvc.control.key.role.XiaoYaoActionControl;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	public class HeroSceneView extends BaseBmdView
	{
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
		
		public function HeroSceneView()
		{
			super();
		}
		
		override public function init():void{
			super.init();
			this.initParams();
			this.start();
			
			gameRelive();
			_myPlayer.isLock = true;
			(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameSceneInit();
			
			initMonster(HeroFightManager.getIns().createMonster(), false);
		}
		
		private function initParams() : void{
			GameConst.stage.addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			GameConst.stage.addEventListener(KeyboardEvent.KEY_UP,__keyUp);
			RenderEntityManager.getIns().addEntity(this);
			PhysicsWorld.getIns().clear();
			PhysicsWorld.getIns().collisionListener = new CollisionListener();
			GameProcessManager.getIns().init();
			HeroFightManager.getIns().init();
		}
		
		private function onDeactivate(e:Event) : void{
			(ControlFactory.getIns().getControl(PlayerUIControl) as PlayerUIControl).pauseGame();
		}
		
		protected function __keyUp(evt:KeyboardEvent):void{
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
		
		
		public function gameStart() : void{
			addDeactivete();
			for each(var item:MonsterEntity in _monsterVec){
				item.isLock = false;
			}
		}
		
		private function start():void{
			var data:Object = new Object(); 
			data.uid = GameConst.UID;
			data.data = null;
			initPlayer(RoleManager.getIns().createPlayer(350, 450, data));
			initPartnerPlayer(RoleManager.getIns().createPartnerPlayer(350, 350, data));
			
			BattleUIManager.getIns().setMainBattleTool(myPlayer.player, myPlayer.charData.skillConfigurationVo);
			if(GameSceneManager.getIns().partnerOperate){
				BattleUIManager.getIns().setPartnerBattleTool(partnerPlayer.player, partnerPlayer.charData.skillConfigurationVo);
			}
			
			RoleManager.getIns().fightType = 0;
		}
		
		private function initPlayer(player:PlayerEntity):void{
			_myPlayer = player;
			//_myPlayer.autoFightControl = new AceAutoFightControl(_myPlayer);
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
			var result:Boolean = true;
			for(var i:int = 0; i < _players.length; i++){
				if(_players[i].charData.useProperty.hp > 0){
					result = false;
					break;
				}
			}
			if(result == true){
				HeroFightManager.getIns().heroPlayerDeath();
				for each(var item:MonsterEntity in _monsterVec){
					item.isLock = true;
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
		}
		
		//检测主角复活后，boss是否已经死了
		public function checkReliveGameOver() : void{
			
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
		public function initMonster(mons:Vector.<MonsterEntity>, hasAppear:Boolean = true) : void{
			//this.addChild(mon);
			for(var i:int = 0; i < mons.length; i++){
				var mon:MonsterEntity = mons[i];
				_monsterVec.push(mon);
				mon.isLock = true;
				mon.hasAppearEffect = hasAppear;
				mon.characterControl.limitLeftX = 0;
				mon.characterControl.limitRightX = 1200;
				mon.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
				var len:int = mon.charData.assetsArray.length;
				for(var j:int = 0; j < len; j++){
					_monsterResource.push(mon.charData.assetsArray[j]);
				}
			}
		}
		
		public function initSpecialMonster(mon:MonsterEntity) : void{
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
		
		/**
		 * 检测怪物数量
		 * @param e
		 * 
		 */		
		public function checkMonsterDeath(monster:MonsterEntity) : void{
			if(monster.charData.characterType != CharacterType.SPECIAL_BOSS_MONSTER){
				if(!_gameOver && (monster.charData as EnemyVo).ID != 6029){
					if(HeroFightManager.getIns().addIndex()){
						HeroFightManager.getIns().heroFightOver();
						_gameOver = true;
					}else{
						initMonster(HeroFightManager.getIns().createMonster());
					}
				}
			}
			_monsterVec.splice(_monsterVec.indexOf(monster), 1);
			monster.destroy();
		}
		
		public function checkSpecialMonsterDeath() : void{
			var result:Boolean = true;
			for each(var item:MonsterEntity in _monsterVec){
				if(item.charData.useProperty.hp > 0){
					result = false;
					break;
				}
			}
			if(result){
				for each(var items:MonsterEntity in _monsterVec){
					if(items is ChiNanEntity){
						(items as ChiNanEntity).isAlreadyDead = true;
					}
					if(items is YuanNvEntity){
						(items as YuanNvEntity).isAlreadyDead = true;
					}
				}
			}
		}
		
		public function checkMonsterClear(monster:MonsterEntity) : void{
			_monsterVec.splice(_monsterVec.indexOf(monster), 1);
			monster.destroy();
			monster = null;
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
		
		public function isShowPassLevel(monster:MonsterEntity) : void{
			
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
			if(_slowDownEffect != null){
				_slowDownEffect.stop();
			}
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
			
			controlMap();
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
			var map:HeroMapView = (ViewFactory.getIns().getView(HeroMapView) as HeroMapView);
			if(map != null){
				map.moveMap();
			}
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
			SoundManager.getIns().clear();
			RoleManager.getIns().clear();
			LevelManager.getIns().clear();
			
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
			this._partnerPlayer = null;
			
			for each(var resource:String in _monsterResource){
				BitmapDataPool.removeData(resource);
			}
			
			if(_slowDownEffect != null){
				_slowDownEffect.destroy();
				_slowDownEffect = null;
			}
			
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