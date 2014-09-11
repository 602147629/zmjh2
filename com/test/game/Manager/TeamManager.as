package com.test.game.Manager
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.PiPeiConst;
	import com.test.game.Const.PlayerKillingEventConst;
	import com.test.game.Const.TeamConst;
	import com.test.game.Modules.MainGame.Load.GongGaoView;
	import com.test.game.Modules.MainGame.PlayerKilling.PlayerKillingWaitView;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	import com.test.game.net.sm.Game.LoadingComplete;
	import com.test.game.net.sm.Room.AutoPipei;
	
	import flash.events.Event;
	
	public class TeamManager extends Singleton
	{
		public var startAutoPipeiFun:Function;
		public var cancelAutoPipeiFun:Function;
		private var _stepPipeiCount:int = 0;
		private var _stepJoinRoomCount:int = 0;
		private var _stepFightCount:int = 0;
		private var _startPipei:Boolean = false;
		private var _startJoinRoom:Boolean = false;
		private var _startFight:Boolean = false;
		public var isCanFight:Boolean = true;
		public function TeamManager(){
			super();
			EventManager.getIns().EventDispather.addEventListener(TeamConst.VERSION_WRONG, versionWrong);
			EventManager.getIns().EventDispather.addEventListener(TeamConst.START_TEAM_PIPEI, startAutoPipeiSuccess);
			EventManager.getIns().EventDispather.addEventListener(TeamConst.CANCEL_TEAM_PIPEI, cancelAutoPipeiSuccess);
			EventManager.getIns().EventDispather.addEventListener(TeamConst.START_TEAM_FIGHT, startCoolDown);
			EventManager.getIns().EventDispather.addEventListener(TeamConst.START_TEAM_FIGHT_AFTER_LOADING, loadingComplete);
			EventManager.getIns().EventDispather.addEventListener(TeamConst.GET_NOTICE, onGetNotice);
			EventManager.getIns().EventDispather.addEventListener(TeamConst.GET_MESSAGE, onGetMessage);
			EventManager.getIns().EventDispather.addEventListener(TeamConst.JOIN_ROOM_SUCCESS, onJoinRoomSuccess);
			EventManager.getIns().EventDispather.addEventListener(TeamConst.JOIN_ROOM_FAILURE, onJoinRoomFailure);
			EventManager.getIns().EventDispather.addEventListener(TeamConst.LEAVE_ROOM_SUCCESS, onLeaveRoomSuccess);
		}
		
		public static function getIns():TeamManager{
			return Singleton.getIns(TeamManager);
		}
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		protected function versionWrong(event:Event):void{
			EventManager.getIns().EventDispather.dispatchEvent(new CommonEvent(PiPeiConst.GET_NOTICE, "经检测，您打开的页面游戏版本过低，请更新到最新版本进行游戏"));
			//(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun("经检测，您打开的页面游戏版本过低，请更新到最新版本进行游戏");
		}
		
		public function startTeamPipei(callback:Function = null) : void{
			DebugArea.getIns().showInfo("---发送开始匹配请求---");
			startAutoPipeiFun = callback;
			_startPipei = false;
			_startJoinRoom = false;
			_startFight = false;
			_stepPipeiCount = 0;
			_stepJoinRoomCount = 0;
			_stepFightCount = 0;
			var sm:AutoPipei = new AutoPipei(RoleManager.getIns().getPlayerProperty(), player.occupation,player.character.lv, player.pkInfo.pkLv, player.pkInfo.preResult, player.pack.equip.length);
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
		}
		
		public function startAutoPipeiSuccess(e:CommonEvent) : void{
			DebugArea.getIns().showInfo("---匹配成功---");
			_startPipei = true;
			if(startAutoPipeiFun != null){
				startAutoPipeiFun();
			}
		}
		
		public function cancelAutoPipeiSuccess(e:CommonEvent) : void{
			DebugArea.getIns().showInfo("---取消匹配成功---");
			if(cancelAutoPipeiFun != null){
				cancelAutoPipeiFun();
			}
		}
		
		public function startCoolDown(e:CommonEvent) : void{
			DebugArea.getIns().showInfo("---双方玩家准备完毕，开始5秒倒计时---");
			_startPipei = false;
			_startJoinRoom = false;
			_startFight = true;
		}
		
		protected function loadingComplete(event:Event):void{
			
		}
		
		public function loadComplete() : void{
			DebugArea.getIns().showInfo("---加载素材完成，发送加载完成请求---");
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			var sm2:LoadingComplete = new LoadingComplete();
			ssc.sendToFb(sm2);
		}
		
		protected function onGetMessage(e:CommonEvent):void{
			var id:int = e.data as int;
			var obj:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.FEEDBACK_MESSAGE, "id", id);
			(ViewFactory.getIns().initView(GongGaoView) as GongGaoView).setInfo(obj.info);
		}
		
		protected function onGetNotice(e:CommonEvent):void{
			var notice:String = e.data as String;
			DebugArea.getIns().showInfo(notice);
			if(notice == "服务器已关闭！"){
				isCanFight = false;
			}
			(ViewFactory.getIns().initView(GongGaoView) as GongGaoView).setInfo(notice);
		}
		
		protected function onJoinRoomSuccess(event:Event):void{
			DebugArea.getIns().showInfo("---加入房间成功，等待玩家加入---");
			_startPipei = false;
			_startJoinRoom = true;
			_startFight = false;
			(ViewFactory.getIns().initView(PlayerKillingWaitView) as PlayerKillingWaitView).joinRoomStart();
		}
		
		protected function onJoinRoomFailure(event:Event):void{
			DebugArea.getIns().showInfo("---加入房间失败，执行取消匹配请求---");
			_startJoinRoom = false;
			(ViewFactory.getIns().initView(PlayerKillingWaitView) as PlayerKillingWaitView).onCancelAutoPipei();
		}
		
		protected function onLeaveRoomSuccess(event:Event):void{
			DebugArea.getIns().showInfo("---离开房间成功---");
			if(!ViewFactory.getIns().initView(PlayerKillingWaitView).isClose){
				(ViewFactory.getIns().initView(PlayerKillingWaitView) as PlayerKillingWaitView).cancelAutoPipei();
			}
		}
	}
}