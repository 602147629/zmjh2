package com.test.game.Mvc.control.net.rm{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.Control.net.rm.GameReceiveControl;
	import com.test.game.Const.PiPeiConst;
	import com.test.game.Manager.EventManager;
	
	import flash.utils.ByteArray;
	
	public class MyGameReceiveControl extends GameReceiveControl{
		public function MyGameReceiveControl(){
			super();
		}
		
		
		/**
		 * 退出副本 
		 * 
		 */		
		public function LeftFb(body:ByteArray):void{
			trace("-------LeftFb----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			var result:int = jObj.result;
			if(result == 1){
				//成功退出
//				if(!GameConst.isAutoTest){
//					GoToGameMenuControl(ControlFactory.getIns().getControl(GoToGameMenuControl)).goToGameMenu();
//				}else{
//					//延迟2秒退出房间
//					setTimeout(function(){
//						var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
//						var sm2:LeftRoom = new LeftRoom();
//						ssc.send(sm2);
//					},2000);
//				}
			}else{
				//退出失败
				
			}
		}
		
		/**
		 * 副本超时
		 * 
		 */		
		public function FbTimeout(body:ByteArray):void{
			trace("-------FbTimeout----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			
			if(!GameConst.isAutoTest){
//				GoToGameMenuControl(ControlFactory.getIns().getControl(GoToGameMenuControl)).goToGameMenu();
			}
		}
		
		
		/**
		 * 副本开始（真正的开始，玩家都加载完毕后）
		 * 
		 */		
		public function StartGameAfterLoading(body:ByteArray):void{
			trace("-------StartGameAfterLoading----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.LOADING_COMPLETE));
//			var players:Array = jObj.players;
//			
//			var playerVos:Vector.<Player> = new Vector.<Player>();
//			for each(var pObj:Object in players){
//				var player:Player = new Player();
//				player.buildFromObject(pObj);
//				playerVos.push(player);
//			}
//			
//			FbPlayersManager.getIns().updatePlayers(playerVos);
			
			//进入游戏
//			if(!GameConst.isAutoTest){
				//GoToBattleControl(ControlFactory.getIns().getControl(GoToBattleControl)).goToBattle();
//			}
		}
		
		/**
		 * 加载超时
		 * 
		 */		
		public function ByondLoading(body:ByteArray):void{
			trace("-------ByondLoading----------");
			var str:String = body.readUTFBytes(body.bytesAvailable);
			trace("str:"+str)
			var jObj:Object = com.adobe.serialization.json.JSON.decode(str);
			
			
		}
		
		
	}
}