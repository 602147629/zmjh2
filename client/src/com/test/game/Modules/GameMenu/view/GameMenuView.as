package com.test.game.Modules.GameMenu.view{
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Manager.MyUserManager;
	import com.test.game.Manager.PlayersManager;
	import com.test.game.Manager.RoomsManager;
	import com.test.game.Mvc.Vo.Item;
	import com.test.game.Mvc.Vo.Player;
	import com.test.game.Mvc.Vo.Room;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	import com.test.game.net.sm.Game.StartGame;
	import com.test.game.net.sm.Line.GetAllRooms;
	import com.test.game.net.sm.Player.AddExp;
	import com.test.game.net.sm.Player.AddItem;
	import com.test.game.net.sm.Player.GetBag;
	import com.test.game.net.sm.Player.RemoveItem;
	import com.test.game.net.sm.Room.ApplyJoinRoom;
	import com.test.game.net.sm.Room.CreateRoom;
	import com.test.game.net.sm.Room.LeftRoom;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import fl.controls.Button;
	
	public class GameMenuView extends BaseView{
		private var _userList:TextField;
		private var _playerHistroy:TextField;
		private var _roomList:TextField;
		private var _playerProperty:TextField;
		
		private var _joinBtn:Button;//加入房间
		private var _leftBtn:Button;//离开房间
		private var _startBtn:Button;//开始游戏
		private var _createBtn:Button;//创建房间
		
		private var _addExpBtn:Button;//增加经验
		
		private var _addItem:Button;//增加装备/道具
		private var _removeItem:Button;//删除装备/道具
		private var _itemInputTf:TextField;//道具输入框
		private var _itemTf:TextField;//道具信息框
		
		
		private var _roomInputTf:TextField;//加入房间输入框
		
		
		public function GameMenuView(){
			super();
		}
		
		override public function init():void{
			super.init();
			
//			//登录游戏
//			var sm:Login = new Login();
//			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
//			ssc.send(sm);
			
			_userList = new TextField();
			_userList.text = "正在获取用户列表";
			_userList.width = 200;
			_userList.height = 150;
			_userList.border = true;
			_userList.x = 500;
			_userList.y = 10;
			this.addChild(_userList);
			
			
			_playerProperty = new TextField();
			_playerProperty.multiline = true;
			_playerProperty.wordWrap = true;
			var player:Player = MyUserManager.getIns().socketPlayer;
			_playerProperty.text = player.toString();
			_playerProperty.width = 200;
			_playerProperty.height = 200;
			_playerProperty.border = true;
			_playerProperty.x = 275;
			_playerProperty.y = 200;
			this.addChild(_playerProperty);
			
			
			_playerHistroy = new TextField();
			_playerHistroy.width = 200;
			_playerHistroy.height = 150;
			_playerHistroy.border = true;
			_playerHistroy.x = 500;
			_playerHistroy.y = 170;
			this.addChild(_playerHistroy);
			
			
			_roomList = new TextField();
			_roomList.width = 200;
			_roomList.height = 150;
			_roomList.border = true;
			_roomList.text = "获取房间列表...";
			_roomList.x = 500;
			_roomList.y = 330;
			this.addChild(_roomList);
			
			
			_joinBtn = new Button();
			_joinBtn.label = "join";
			_joinBtn.x = 500;
			_joinBtn.y = 490;
			this.addChild(_joinBtn);
			_joinBtn.addEventListener(MouseEvent.CLICK,__joinRoom);
			
			_leftBtn = new Button();
			_leftBtn.label = "left";
			_leftBtn.x = 600;
			_leftBtn.y = 490;
//			_leftBtn.visible = false;
			this.addChild(_leftBtn);
			_leftBtn.addEventListener(MouseEvent.CLICK,__leftRoom);
			
			_startBtn = new Button();
			_startBtn.label = "start";
			_startBtn.x = 500;
			_startBtn.y = 540;
//			_startBtn.visible = false;
			this.addChild(_startBtn);
			_startBtn.addEventListener(MouseEvent.CLICK,__startGame);
			
			
			_createBtn = new Button();
			_createBtn.label = "create";
			_createBtn.x = 400;
			_createBtn.y = 490;
			this.addChild(_createBtn);
			_createBtn.addEventListener(MouseEvent.CLICK,__createRoom);
			
			
			_addExpBtn = new Button();
			_addExpBtn.setSize(50,20);
			_addExpBtn.label = "addExp";
			_addExpBtn.x = 50;
			_addExpBtn.y = 490;
			this.addChild(_addExpBtn);
			_addExpBtn.addEventListener(MouseEvent.CLICK,_addExp);
			
			_addItem = new Button();
			_addItem.label = "addItem";
			_addItem.setSize(50,20);
			_addItem.x = 100;
			_addItem.y = 490;
			this.addChild(_addItem);
			_addItem.addEventListener(MouseEvent.CLICK,_addItemBtn);
			
			_removeItem = new Button();
			_removeItem.label = "removeItem";
			_removeItem.setSize(50,20);
			_removeItem.x = 150;
			_removeItem.y = 490;
			this.addChild(_removeItem);
			_removeItem.addEventListener(MouseEvent.CLICK,_removeItemBtn);
			
			
			_itemInputTf = new TextField();
			_itemInputTf.type = TextFieldType.INPUT;
			_itemInputTf.width = 200;
			_itemInputTf.height = 50;
			_itemInputTf.border = true;
			_itemInputTf.x = 50;
			_itemInputTf.y = 50;
			this.addChild(_itemInputTf);
			
			
			_roomInputTf = new TextField();
			_roomInputTf.type = TextFieldType.INPUT;
			_roomInputTf.width = 50;
			_roomInputTf.height = 20;
			_roomInputTf.border = true;
			_roomInputTf.x = 400;
			_roomInputTf.y = 520;
			this.addChild(_roomInputTf);
			
			
			_itemTf = new TextField();
			_itemTf.type = TextFieldType.DYNAMIC;
			_itemTf.width = 200;
			_itemTf.height = 100;
			_itemTf.border = true;
			_itemTf.x = 50;
			_itemTf.y = 150;
			this.addChild(_itemTf);
			
			
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			
			//重新请求玩家数据
//			var sm:GetAllPlayers = new GetAllPlayers();
//			ssc.send(sm);
			
			//请求列表信息
			var sm2:GetAllRooms = new GetAllRooms();
			ssc.send(sm2);
			
			//请求背包信息
			var sm3:GetBag = new GetBag();
			ssc.send(sm3);
		}
		
		protected function _removeItemBtn(event:MouseEvent):void{
			var text:String = _itemInputTf.text;
			var arr:Array = text.split("|");
			if(arr.length != 2){
				trace("道具输入有误！text:"+text)
				return;
				
			}
			var item:Item = new Item();
			item.id = arr[0];
			item.num = arr[1];
			
			//删除道具
			var sm:RemoveItem = new RemoveItem(item);
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
		}
		
		protected function _addItemBtn(event:MouseEvent):void{
			var text:String = _itemInputTf.text;
			var arr:Array = text.split("|");
			if(arr.length != 2){
				trace("道具输入有误！text:"+text)
				return;
				
			}
			var item:Item = new Item();
			item.id = arr[0];
			item.num = arr[1];
			
			//新增道具
			var sm:AddItem = new AddItem(item);
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
		}
		
		protected function _addExp(evt:MouseEvent):void{
			var sm:AddExp = new AddExp();
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
		}
		
		protected function __leftRoom(evt:MouseEvent):void{
			var sm:LeftRoom = new LeftRoom();
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.sendToFb(sm);
			
			this.addHistroy("请求退出房间");
		}
		
		public function leftRoomSuccess():void{
			this.addHistroy("退出房间成功");
			
			this._joinBtn.visible = true;
			this._startBtn.visible = false;
//			this._leftBtn.visible = false;
		}
		
		public function updatePlayerInfo():void{
			var player:Player = MyUserManager.getIns().socketPlayer;
			_playerProperty.text = player.toString();
		}
		
		protected function __joinRoom(evt:MouseEvent):void{
			var text:String = _roomInputTf.text;
			var arr:Array = text.split("_");
			if(arr.length != 2){
				return;
			}
			
			var sm:ApplyJoinRoom = new ApplyJoinRoom(int(arr[1]),int(arr[0]));
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
			
			this.addHistroy("请求加入房间");
		}
		
		public function joinRoomSuccess():void{
			this.addHistroy("加入房间成功");
			
			this._joinBtn.visible = false;
			this._startBtn.visible = true;
//			this._leftBtn.visible = true;
			
		}
		
		
		public function startGame():void{
			this.__startGame(null);
		}
		
		protected function __createRoom(event:MouseEvent):void{
			var sm:CreateRoom = new CreateRoom();
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
		}	
		
		
		protected function __startGame(event:MouseEvent):void{
			if(!GameConst.isSingleGame){
				//发送开始消息
				var sm:StartGame = new StartGame();
				var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
				ssc.sendToFb(sm);
			}else{
				//单机模式，直接进入关卡
				//GoToBattleControl(ControlFactory.getIns().getControl(GoToBattleControl)).goToBattle();
			}
		}	
		
		/**
		 * 更新房间信息 
		 * 
		 */		
		public function updateRoomListReturn():void{
			_roomList.text = "";
			for each(var room:Room in RoomsManager.getIns().rooms){
				_roomList.appendText(room.getInfo() + "--------------\n");
			}
		}
		
		public function showAllPlayersReturn():void{
			_userList.text = "";
			for each(var player:Player in PlayersManager.getIns().players){
				_userList.appendText("玩家:"+player.name + "\n");
			}
		}
		
		
		public function playerJoinReturn(player:Player):void{
			this.addHistroy("玩家 " + player.name + " 加入了游戏");
			
			this.showAllPlayersReturn();
		}
		
		public function playerLeftReturn(player:Player):void{
			this.addHistroy("玩家 " + player.name + " 离开了游戏");
			
			this.showAllPlayersReturn();
		}
		
		//背包变化，刷新背包
//		public function itemChange():void{
//			var str:String = "";
//			for each(var item:Item in MyUserManager.getIns().player.items){
//				str += item.toString()+"\n";
//			}
//			this._itemTf.text = str;
//		}
		
		
		public function startGameReturn(result:int):void{
			if(result == 1){
				this.addHistroy("成功开始游戏！");
			}else{
				this.addHistroy("开始游戏失败！");
			}
		}
		
		
		private function addHistroy(content:String):void{
			_playerHistroy.appendText(content + "\n");
			_playerHistroy.scrollV = _playerHistroy.maxScrollV;
		}
		
		override public function step():void{
			super.step();
			
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		
	}
}