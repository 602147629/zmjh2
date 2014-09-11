package com.test.game.Manager.Pipei
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.PiPeiConst;
	import com.test.game.Modules.MainGame.Load.GongGaoView;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	import com.test.game.net.sm.Game.LoadingComplete;
	import com.test.game.net.sm.Room.AutoPipei;
	import com.test.game.net.sm.Room.CancelPipei;
	import com.test.game.net.sm.Room.LeftRoom;
	
	import flash.events.Event;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.RoleManager;
	
	public class PipeiManager extends Singleton
	{
		public var pipeiType:uint;
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function PipeiManager()
		{
			super();
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.VERSION_WRONG, onVersionWrong);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.START_AUTO_PIPEI, onStartAutoPipeiSuccess);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.CANCEL_AUTO_PIPEI, onCancelAutoPipeiSuccess);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.PIPEI_COMPLETE, onPipeiComplete);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.LOADING_COMPLETE, onLoadingComplete);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.RESULT_FAILURE, onResultFailure);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.RESULT_VICTORY, onResultVictory);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.GET_NOTICE, onGetNotice);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.GET_MESSAGE, onGetMessage);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.JOIN_ROOM_SUCCESS, onJoinRoomSuccess);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.JOIN_ROOM_FAILURE, onJoinRoomFailure);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.LEAVE_ROOM_SUCCESS, onLeaveRoomSuccess);
		}
		
		
		public function startAutoPipeiPK() : void{
			DebugArea.getIns().showInfo("---PK发送开始匹配请求---");
			pipeiType = 1;
			var sm:AutoPipei = new AutoPipei(RoleManager.getIns().getPlayerProperty(), player.occupation,player.character.lv, player.pkInfo.pkLv, player.pkInfo.preResult, player.pack.equip.length);
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
		}
		
		public function startCancelAutoPipei() : void{
			DebugArea.getIns().showInfo("---发送取消匹配请求---");
			var sm:CancelPipei = new CancelPipei(RoleManager.getIns().getPlayerProperty());
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
		}
		
		public function startLeaveRoom() : void{
			DebugArea.getIns().showInfo("---发送离开房间请求---");
			var sm:LeftRoom = new LeftRoom();
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.sendToFb(sm);
		}
		
		public function loadingComplete() : void{
			DebugArea.getIns().showInfo("---加载素材完成，发送素材已经加载完成请求---");
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			var sm2:LoadingComplete = new LoadingComplete();
			ssc.sendToFb(sm2);
		}
		
		
		protected function onLeaveRoomSuccess(e:CommonEvent):void{
			DebugArea.getIns().showInfo("---离开房间成功---");
			switch(pipeiType){
				case 1:
					EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.LEAVE_ROOM_SUCCESS_PK));
					break;
			}
		}
		
		protected function onJoinRoomFailure(e:CommonEvent):void{
			DebugArea.getIns().showInfo("---加入房间失败，执行取消匹配请求---");
			switch(pipeiType){
				case 1:
					EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.JOIN_ROOM_FAILURE_PK));
					break;
			}
		}
		
		protected function onJoinRoomSuccess(e:CommonEvent):void{
			DebugArea.getIns().showInfo("---加入房间成功，等待玩家加入---");
			switch(pipeiType){
				case 1:
					EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.JOIN_ROOM_SUCCESS_PK));
					break;
			}
		}
		
		protected function onResultVictory(e:CommonEvent):void{
			DebugArea.getIns().showInfo("---战斗胜利---");
			switch(pipeiType){
				case 1:
					EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.RESULT_VICTORY_PK));
					break;
			}
		}
		
		protected function onResultFailure(e:CommonEvent):void{
			DebugArea.getIns().showInfo("---战斗失败---");
			switch(pipeiType){
				case 1:
					EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.RESULT_FAILURE_PK));
					break;
			}
		}
		
		protected function onLoadingComplete(e:CommonEvent):void{
			DebugArea.getIns().showInfo("---素材加载完成---");
			switch(pipeiType){
				case 1:
					EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.LOADING_COMPLETE_PK));
					break;
			}
		}
		
		protected function onPipeiComplete(e:CommonEvent):void{
			DebugArea.getIns().showInfo("---双方玩家都进入房间，匹配完成---");
			switch(pipeiType){
				case 1:
					EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.PIPEI_COMPLETE_PK));
					break;
			}
		}
		
		protected function onCancelAutoPipeiSuccess(e:Event):void{
			DebugArea.getIns().showInfo("---取消匹配成功---");
			switch(pipeiType){
				case 1:
					EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.CANCEL_AUTO_PIPEI_PK));
					break;
			}
		}
		
		protected function onStartAutoPipeiSuccess(e:CommonEvent):void{
			DebugArea.getIns().showInfo("---匹配成功---");
			switch(pipeiType){
				case 1:
					EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.START_AUTO_PIPEI_PK));
					break;
			}
		}
		
		protected function onGetMessage(e:CommonEvent):void{
			var id:int = e.data as int;
			var obj:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.FEEDBACK_MESSAGE, "id", id);
			DebugArea.getIns().showInfo(obj.info);
			(ViewFactory.getIns().initView(GongGaoView) as GongGaoView).setInfo(obj.info);
		}
		
		protected function onGetNotice(e:CommonEvent):void{
			var notice:String = e.data as String;
			DebugArea.getIns().showInfo(notice);
			(ViewFactory.getIns().initView(GongGaoView) as GongGaoView).setInfo(notice);
			switch(pipeiType){
				case 1:
					EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.GET_NOTICE_PK, notice));
					break;
			}
		}
		
		protected function onVersionWrong(e:Event):void{
			EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.GET_NOTICE_PK, "经检测，您打开的页面游戏版本过低，请等待游戏更新到最新版本再进行武斗"));
		}
		
		public static function getIns():PipeiManager{
			return Singleton.getIns(PipeiManager);
		}
	}
}