package com.test.game.Mvc.BmdView{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Const.SequenceConst;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Keyboard.KeyboardInput;
	import com.superkaka.game.Manager.Keyboard.PlayerKeyboardControl;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseBmdView;
	import com.test.game.Const.KeyOperationType;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Roles.PlaneEntity;
	import com.test.game.Manager.MyUserManager;
	import com.test.game.Manager.RoomsManager;
	import com.test.game.Manager.ServerControllor;
	import com.test.game.Manager.Collision.CollisionListener;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.Room;
	import com.test.game.Mvc.Vo.Seat;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	public class PlaneGameSenceView extends BaseBmdView{
		private var _monsterVec:Vector.<MonsterEntity> = new Vector.<MonsterEntity>();
		private var _players:Vector.<PlaneEntity> = new Vector.<PlaneEntity>();
		private var _myPlayer:PlaneEntity;//玩家自己

		public function PlaneGameSenceView(){
			super();
		}
		
		override public function init():void{
			super.init();
			
			GameConst.stage.addEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			GameConst.stage.addEventListener(KeyboardEvent.KEY_UP,__keyUp);
			
			this.start();
		}
		
		protected function __keyUp(evt:KeyboardEvent):void{
			ServerControllor.getIns().acceptOperation(MyUserManager.getIns().player.uid,evt.keyCode,KeyOperationType.KEY_UP);
		}
		
		protected function __keyDown(evt:KeyboardEvent):void{
			ServerControllor.getIns().acceptOperation(MyUserManager.getIns().player.uid,evt.keyCode,KeyOperationType.KEY_DOWN);
		}	
		
		
		private function start():void{
			RenderEntityManager.getIns().addEntity(this);
			
			PhysicsWorld.getIns().clear();
			PhysicsWorld.getIns().collisionListener = new CollisionListener();
			
			var mVo:CharacterVo;
//			for(var i:uint=0;i<10;i++){
//				mVo = new CharacterVo();
//				mVo.assetsArray = ["Monster166"];
//				mVo.isDouble = true;
//				mVo.sequenceId = SequenceConst.MONSTER_ZGL;
//				
//				
//				var mon:Monster1Entity = new Monster1Entity(mVo);
////				mon.x = Math.random()*700;
////				mon.y = Math.random()*450;
//				mon.x = i*100;
//				mon.y = i*20;
//				mon.renderSpeed = 1;
//				this.addChild(mon);
//				
//				RenderEntityManager.getIns().addEntity(mon);
//				PhysicsWorld.getIns().addEntity(mon);
//				
//				_monsterVec.push(mon);
//			}
			
			//添加玩家实体
			var room:Room = RoomsManager.getIns().getRoomByUid(MyUserManager.getIns().player.uid);
			var seats:Vector.<Seat> = room.getSeatVec();
			for each(var seat:Seat in seats){
				if(seat.isEmpty()){
					continue;
				}
				var cvo:CharacterVo = new CharacterVo();
				cvo.assetsArray = ["plane1"];
				cvo.isDouble = true;
				cvo.sequenceId = SequenceConst.ROLE_PLANE;
				
				var player:PlaneEntity = new PlaneEntity(cvo);
				player.player = seat.player;
				player.keyBoard = new KeyboardInput();
				player.x = 100;
				if(seat.player.uid == MyUserManager.getIns().player.uid){
					_myPlayer = player;
					//赋值副本操作键盘
					ServerControllor.getIns().myKeyBoardInput = _myPlayer.keyBoard; 
				}
				if(seat.index == 0){
					player.y = 200;
				}else{
					player.y = 400;
				}
				_players.push(player);
				this.addChild(player);
				
				RenderEntityManager.getIns().addEntity(player);
				PhysicsWorld.getIns().addEntity(player);
			}
			
			
//			cvo = new CharacterVo();
//			cvo.assetsArray = ["ROLE2_11","ROLE2_EQUIP_9"];
//			cvo.isDouble = true;
//			cvo.sequenceId = SequenceConst.ROLE_TANGSENG;
//			var ts:TangsengEntity = new TangsengEntity(cvo);
//			ts.x = 500;
//			ts.y = 200;
//			this.addChild(ts);
			
			
			
			this.show();
		}
		
		override public function step():void{
			super.step();
		}
		
		/**
		 * 玩家退出(别的玩家)
		 * @param uid 玩家uid
		 * 
		 */		
		private function playerLeft(uid:int):void{
			var len:uint = this._players.length;
			for(var i:uint=0;i<len;i++){
				var pe:PlaneEntity = this._players[i];
				if(pe.player.uid == uid){
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
			var player:PlaneEntity;
			var curPlayer:PlaneEntity;
			
			while(command.bytesAvailable){
				var len:int = command.readInt();//单人命令长度
				var uid:int = command.readInt();
				len -= 4;
				
				for each(player in this._players){
					if(player.player.uid == uid){
						curPlayer = player;
						break;
					}
				}
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
						if(operation == KeyOperationType.PLAYER_LEFT){
							//玩家离开副本
							this.playerLeft(uid);
						}
					}
					
					len -= 8;
				}
			}
			for each(player in this._players){
				this.controlPlayer(player,GameConst.PLAYER_1);
				player.keyBoard.step();
			}
			
			//控制地图移动
			this.controlMap();
			
			RenderEntityManager.getIns().step();
		}
		
		protected function controlMap():void{
			if(!this._myPlayer){
				return;
			}
			var bmv:BaseMapView = ViewFactory.getIns().getView(BaseMapView) as BaseMapView;
			if(bmv){
				bmv.x -= 1;
			}
		}
		
		protected function controlPlayer(player:PlaneEntity,playerId:uint):void{
			var isAction:Boolean = false;
			
			var playerKeyboard:PlayerKeyboardControl = PlayerKeyboardControl.getIns();
			
			var isUp:Boolean = true;
			
			if(playerKeyboard.getPlayerKeyBoardByPlayer(player.keyBoard,PlayerKeyboardControl.LEFT,playerId,KeyboardInput.KEYDOWN)){
				player.moveHorizontalDirect = DirectConst.DIRECT_LEFT;
				player.x -= 8;
			}
			if(playerKeyboard.getPlayerKeyBoardByPlayer(player.keyBoard,PlayerKeyboardControl.RIGHT,playerId,KeyboardInput.KEYDOWN)){
				player.moveHorizontalDirect = DirectConst.DIRECT_RIGHT;
				player.x += 8;
			}
			if(playerKeyboard.getPlayerKeyBoardByPlayer(player.keyBoard,PlayerKeyboardControl.DOWN,playerId,KeyboardInput.KEYDOWN)){
				player.setAction(ActionState.PLANE_DOWN);
				player.y += 5;
				isUp = false;
			}
			if(playerKeyboard.getPlayerKeyBoardByPlayer(player.keyBoard,PlayerKeyboardControl.UP,playerId,KeyboardInput.KEYDOWN)){
				player.setAction(ActionState.PLANE_UP);
				player.y -= 5;
				isUp = false;
			}
			if(isUp){
				player.setAction(ActionState.WAIT);
			}
			
			
			if(playerKeyboard.getPlayerKeyBoardByPlayer(player.keyBoard,PlayerKeyboardControl.NORMAL_HIT,playerId,KeyboardInput.KEYDOWN)){
				player.doHit1();
			}
		}
		
		
		override public function destroy():void{
			GameConst.stage.removeEventListener(KeyboardEvent.KEY_DOWN,__keyDown);
			GameConst.stage.removeEventListener(KeyboardEvent.KEY_UP,__keyUp);
			
			ServerControllor.getIns().myKeyBoardInput = null;
			if(this._myPlayer){
				this._myPlayer = null;
			}
			for each(var player:PlaneEntity in _players){
				player.destroy();
			}
			for each(var mon:MonsterEntity in _monsterVec){
				mon.destroy();
			}
			this._monsterVec = null;
			this._players = null;
			
			PhysicsWorld.getIns().clear();
//			this._player2 = null;
//			BitmapDataPool.removeData("Monster166");
//			BitmapDataPool.removeData("ROLE1_11");
//			BitmapDataPool.removeData("ROLE1_EQUIP_9");
			
			super.destroy();
		}

		public function get players():Vector.<PlaneEntity>
		{
			return _players;
		}

		public function get myPlayer():PlaneEntity
		{
			return _myPlayer;
		}


	}
}