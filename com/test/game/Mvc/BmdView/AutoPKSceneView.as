package com.test.game.Mvc.BmdView
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ProxyFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseBmdView;
	import com.test.game.Const.AutoFightConst;
	import com.test.game.Const.CharacterType;
	import com.test.game.Const.KeyOperationType;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Effect.EffectEntity;
	import com.test.game.Manager.BattleUIManager;
	import com.test.game.Manager.GameProcessManager;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.MyUserManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.ServerControllor;
	import com.test.game.Manager.Collision.PlayerKillingCollisionListener;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Manager.Pipei.PlayerKillingManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Modules.MainGame.MainUI.PlayerKillingRoleStateView;
	import com.test.game.Modules.MainGame.Map.PlayerKillingMapView;
	import com.test.game.Modules.MainGame.PlayerKilling.PlayerKillingTimeShow;
	import com.test.game.Mvc.Proxy.FbSocketProxy;
	import com.test.game.Mvc.control.character.PKAceAutoFightControl;
	import com.test.game.Mvc.control.character.PKAutoFightControl;
	import com.test.game.Mvc.control.key.LeaveGameControl;
	
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	
	public class AutoPKSceneView extends BaseBmdView
	{
		private var _players:Vector.<PlayerEntity> = new Vector.<PlayerEntity>();
		//玩家自己
		private var _myPlayer:PlayerEntity;
		private var _otherPlayer:PlayerEntity;
		private var _totalFrame:int;
		private var _timeShow:PlayerKillingTimeShow;
		private var _isGameOver:Boolean = false;
		
		public function AutoPKSceneView()
		{
			super();
		}
		override public function init():void{
			super.init();
			initParams();
		}
		
		private function initParams() : void{
			GameConst.stage.addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			GameConst.stage.addEventListener(KeyboardEvent.KEY_UP,__keyUp);
			RenderEntityManager.getIns().addEntity(this);
			PhysicsWorld.getIns().clear();
			PhysicsWorld.getIns().collisionListener = new PlayerKillingCollisionListener();	
			initPlayer();
			initTime();
			
			RoleManager.getIns().fightType = 1;
			
			_totalFrame = -90;
			coolDownComplete();
		}
		
		public function coolDownComplete() : void{
			GameProcessManager.getIns().pkColdDown(null);
		}
		
		protected function __keyUp(evt:KeyboardEvent):void{
			ServerControllor.getIns().acceptOperation(MyUserManager.getIns().player.index,evt.keyCode,KeyOperationType.KEY_UP);
		}
		
		protected function __keyDown(evt:KeyboardEvent):void{
			ServerControllor.getIns().acceptOperation(MyUserManager.getIns().player.index,evt.keyCode,KeyOperationType.KEY_DOWN);
		}
		
		public function initPlayer():void{
			var data:Object = new Object();
			data.uid = GameConst.UID;
			data.data = null;
			initMyPlayer(RoleManager.getIns().createPlayer(3690 + 80, 400, data, 2));
			data.uid = "1234567890";
			initAutoPlayer(RoleManager.getIns().createPlayer(3690 + 845, 400, data, 2));
			BattleUIManager.getIns().setMainBattleTool(myPlayer.player, myPlayer.charData.skillConfigurationVo);
		}
		
		private function initTime():void{
			_timeShow = ViewFactory.getIns().getView(PlayerKillingTimeShow) as PlayerKillingTimeShow;
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
			_myPlayer.initPlayerName(PlayerManager.getIns().player.name, 0);
			_myPlayer.collisionIndex = CollisionFilterIndexConst.CAMP_1;
			_myPlayer.collisionListeners = [CollisionFilterIndexConst.CAMP_SKILL_2];
			if(_myPlayer.mainConjure != null){
				_myPlayer.mainConjure.collisionIndex = CollisionFilterIndexConst.CAMP_1;
			}
			if(_myPlayer.minorConjure != null){
				_myPlayer.minorConjure.collisionIndex = CollisionFilterIndexConst.CAMP_1;
			}
			_myPlayer.initPlayerName(_myPlayer.player.name, 0);
			this.addChild(player);
			_players.push(player);
		}
		
		private function initAutoPlayer(inputPlayer:PlayerEntity) : void{
			_otherPlayer = inputPlayer;
			_otherPlayer.charData.characterType = CharacterType.OTHER_PLAYER;
			_otherPlayer.charData.relive();
			_otherPlayer.charData.angerCount = 100;
			_otherPlayer.charData.bossCount = 100;
			_otherPlayer.initPlayerName(PlayerManager.getIns().player.name, 1);
			_otherPlayer.collisionIndex = CollisionFilterIndexConst.CAMP_2;
			_otherPlayer.collisionListeners = [CollisionFilterIndexConst.CAMP_SKILL_1];
			if(PlayerKillingManager.getIns().pkType == 1){
				_otherPlayer.autoFightControl = new PKAutoFightControl(_otherPlayer);
			}else if(PlayerKillingManager.getIns().pkType == 2){
				_otherPlayer.autoFightControl = new PKAceAutoFightControl(_otherPlayer);
				_otherPlayer.autoFightControl.autoType = AutoFightConst.AUTO_TYPE_NORMAL;
			}
			_otherPlayer.autoFightControl.startAutoFight = true;
			if(_otherPlayer.mainConjure != null){
				_otherPlayer.mainConjure.collisionIndex = CollisionFilterIndexConst.CAMP_2;
			}
			if(_otherPlayer.minorConjure != null){
				_otherPlayer.minorConjure.collisionIndex = CollisionFilterIndexConst.CAMP_2;
			}
			_otherPlayer.initPlayerName(_otherPlayer.player.name, 1);
			this.addChild(_otherPlayer);
			_players.push(_otherPlayer);
			(ViewFactory.getIns().initView(PlayerKillingRoleStateView) as PlayerKillingRoleStateView).initPlayerData(_otherPlayer.player);
			ViewFactory.getIns().initView(PlayerKillingRoleStateView).show();
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
		
		public function slowDown(callback:Function = null) : void{
			
		}
		
		public function resetRenderSlow() : void{
			
		}
		
		public function playerDeath(player:PlayerEntity) : void{
			if(player.charData.characterType == CharacterType.PLAYER){
				PlayerKillingManager.getIns().updateData(0);
			}else{
				PlayerKillingManager.getIns().updateData(1);
			}
			_isGameOver = true;
		}
		
		
		//离开pk界面
		public function leavePlayerKilling() : void{
			_myPlayer.relive();
			(ControlFactory.getIns().getControl(LeaveGameControl) as LeaveGameControl).leaveAutoPK();
		}
		
		public function gameOver() : void{
			
		}
		
		public function playerSetGlowFilter() : void{
			for(var i:int = 0; i < _players.length; i++){
				if(_players[i].charData.startAngerDown == false){
					_players[i].setGlowFilter();
				}
			}
		}
		
		/**
		 * 玩家退出(别的玩家)
		 * @param uid 玩家uid
		 * 
		 */		
		private function playerLeft(index:int):void{
			var len:uint = this._players.length;
			for(var i:uint=0;i<len;i++){
				var pe:PlayerEntity = this._players[i];
				if(pe.player.index == index){
					this._players.splice(i,1);
					pe.destroy();
					return;
				}
			}
		}
		
		
		/**
		 * 根据服务端返回命令，渲染游戏 
		 * @param command
		 * 
		 */	
		public function updateByCommand(command:ByteArray):void{
			if(_isGameOver) return;
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
			if(_totalFrame >= 0){
				for each(player in this._players){
					GameSceneManager.getIns().singleScenePlayerControl(player);
				}
			}
			controlMap();
			RenderEntityManager.getIns().step();
			LayerManager.getIns().step();
			PhysicsWorld.getIns().step();
			EffectManager.getIns().step();
			timeStep();
			buffStep();
		}
		
		private function timeStep():void{
			if(_totalFrame < 2 * 60 * 30){
				_totalFrame++;
				_timeShow.setTime(_totalFrame / 30);
				if(_totalFrame == 30 * 30){
					createSpeedBuff();
				}else if(_totalFrame == 90 * 30){
					createAtkBuff();
				}
			}else if(_totalFrame == 2 * 60 * 30){
				_timeShow.setTime(_totalFrame / 30);
				compareResult();
			}
		}
		
		private function buffStep():void{
			var player:PlayerEntity;
			if(_atkBuff != null && _atkBuff.parent != null){
				for(var i:int = 0; i < _players.length; i++){
					if(Math.abs(_players[i].x - _atkBuff.x) < 80 && Math.abs(_players[i].y - _atkBuff.y) < 50){
						SkillManager.getIns().createSkill(_players[i], 62);
						destroyAtkBuff();
						break;
					}
				}
			}
			if(_speedBuff != null && _speedBuff.parent != null){
				for(var j:int = 0; j < _players.length; j++){
					if(Math.abs(_players[j].x - _speedBuff.x) < 80 && Math.abs(_players[j].y - _speedBuff.y) < 50){
						SkillManager.getIns().createSkill(_players[j], 63);
						destroySpeedBuff();
						break;
					}
				}
			}
		}
		
		
		private var _atkBuff:BaseSequenceActionBind;
		private var _speedBuff:BaseSequenceActionBind;
		private function createAtkBuff() : void{
			_atkBuff = AnimationEffect.createAnimation(10020, ["PKAtkBuff"], false);
			_atkBuff.x = 3660 + GameConst.stage.stageWidth * .5;
			_atkBuff.y = GameConst.stage.stageHeight * .5 + 100;
			this.addChildAt(_atkBuff, 0);
		}
		
		private function createSpeedBuff() : void{
			_speedBuff = AnimationEffect.createAnimation(10022, ["PKSpeedBuff"], false);
			_speedBuff.x = 3660 + GameConst.stage.stageWidth * .5;
			_speedBuff.y = GameConst.stage.stageHeight * .5 + 100;
			this.addChildAt(_speedBuff, 0);
		}
		
		private function destroyAtkBuff() : void{
			if(_atkBuff != null){
				_atkBuff.destroy();
				_atkBuff = null;
			}
		}
		
		private function destroySpeedBuff() : void{
			if(_speedBuff != null){
				_speedBuff.destroy();
				_speedBuff = null;
			}
		}
		
		private function compareResult() : void{
			var myRate:Number;
			var myHp:Number;
			var otherRate:Number;
			var otherHp:Number;
			var result:int;
			
			myHp = _myPlayer.player.character.useProperty.hp;
			myRate = myHp/_myPlayer.player.character.totalProperty.hp;
			otherHp = _otherPlayer.player.character.useProperty.hp;
			otherRate = otherHp/_otherPlayer.player.character.totalProperty.hp;
			
			//剩余hp百分比
			if(myRate == otherRate){
				if(myRate == 1){
					result = NumberConst.getIns().zero;
				}else{
					if(myHp >= otherHp){
						result = NumberConst.getIns().one;
					}else{
						result = NumberConst.getIns().zero;
					}
				}
			}else{
				if(myRate > otherRate){
					result = NumberConst.getIns().one;
				}else{
					result = NumberConst.getIns().zero;
				}
			}
			
			if(result == NumberConst.getIns().one){
				PlayerKillingManager.getIns().updateData(1);
			}else{
				PlayerKillingManager.getIns().updateData(0);
			}
			_isGameOver = true;
		}
		
		protected function controlMap():void{
			if(!this._myPlayer){
				return;
			}
			var map:PlayerKillingMapView = (ViewFactory.getIns().getView(PlayerKillingMapView) as PlayerKillingMapView)
			if(map != null){
				map.controlMap();
			}
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
			ServerControllor.getIns().clear();
			ProxyFactory.getIns().destroyProxy(FbSocketProxy);
			
			if(this._myPlayer){
				this._myPlayer = null;
			}
			
			for each(var player:PlayerEntity in _players){
				RenderEntityManager.getIns().removeEntity(player);
				player.destroy();
			}
			this._players = null;
			destroyAtkBuff();
			destroySpeedBuff();
			super.destroy();
		}
		
		public function get players():Vector.<PlayerEntity>{
			return _players;
		}
		
		public function get myPlayer():PlayerEntity{
			return _myPlayer;
		}
		
		public function get otherPlayer() : PlayerEntity{
			return _otherPlayer;
		}
	}
}