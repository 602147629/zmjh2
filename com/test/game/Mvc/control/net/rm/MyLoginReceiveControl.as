package com.test.game.Mvc.control.net.rm{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Control.net.SMessage;
	import com.superkaka.mvc.Control.net.rm.LoginReceiveControl;
	import com.test.game.Manager.MyUserManager;
	import com.test.game.Mvc.Vo.Line;
	import com.test.game.Mvc.Vo.Player;
	import com.test.game.Mvc.Vo.User;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	import com.test.game.net.sm.Line.ChooseLine;
	import com.test.game.net.sm.Login.ChoosePlayer;
	import com.test.game.net.sm.Login.NewPlayer;
	
	import flash.utils.ByteArray;
	
	public class MyLoginReceiveControl extends LoginReceiveControl{
		public function MyLoginReceiveControl(){
			super();
		}
		
		
		/**
		 * 登录成功 
		 * @param body
		 * 
		 */		
		public function LoginSuccess(body:ByteArray):void{
			trace("-------LoginSuccess----------");
//			var isNewPlayer:Boolean = body.readInt()==1;
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			
			if(jObj.err){
				trace("登录失败！jObj.err:"+jObj.err);
				return;
			}
			
			//帐号信息
			var userObj:Object = jObj.user;
			MyUserManager.getIns().user = new User();
			MyUserManager.getIns().user.buildFromObject(userObj);
			
			//角色信息
			var players:Vector.<Player> = new Vector.<Player>();
			for(var i:uint=0;i<jObj.players.length;i++){
				var p:Object = jObj.players[i];
				
				var player:Player = new Player();
				player.buildFromObject(p);
				players.push(player);
			}
			
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			var sm:SMessage;
			if(players.length == 0){
				//创建角色
				var choosePlayer:Player = new Player();
				if(GameConst.LOG_DATA){
					choosePlayer.name = GameConst.LOG_DATA.nickName; 
				}else{
					choosePlayer.name = "undefined"; 
				}
				sm = new NewPlayer(choosePlayer);
				ssc.send(sm);
			}else{
				//选择角色
				sm = new ChoosePlayer(players[0]);
				ssc.send(sm);
			}
			
		}
		
		
		/**
		 * 登录失败
		 * @param body
		 * 
		 */		
		public function LoginFail(body:ByteArray):void{
			trace("-------LoginFail----------");
			
			//SocketConnectManager.getIns().connectToGate();
		}
		
		
		public function ChoosePlayerReturn(body:ByteArray):void{
			trace("-------ChoosePlayerReturn----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var result:int = jObj.result;
			if(result == 1){
				//登录成功
				var p:Object = jObj.player;
				var player:Player = new Player();
				player.buildFromObject(p);
				
				MyUserManager.getIns().socketPlayer = player;
				
				var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
				var chooseLine:Line = new Line();
				chooseLine.id = 1;
				var sm:SMessage = new ChooseLine(chooseLine);
				ssc.send(sm);
			}else{
				//异地登录
				
			}
		}
		
		/**
		 * 玩家被异地登录，踢出游戏 
		 * @param body
		 * 
		 */		
		public function PlayerBeKicked(body:ByteArray):void{
			trace("帐号重复登录！请刷新页面！")
		}
		
		/**
		 * 服务器停止，维护 
		 * @param body
		 * 
		 */		
		public function ServerStop(body:ByteArray):void{
			trace("服务器维护中！")
		}
		
		
	}
}