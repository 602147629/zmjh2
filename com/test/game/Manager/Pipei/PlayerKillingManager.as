package com.test.game.Manager.Pipei
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.PiPeiConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Manager.TitleManager;
	import com.test.game.Modules.MainGame.Load.PKWaitView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.PlayerKilling.PlayerKillingFightView;
	import com.test.game.Modules.MainGame.PlayerKilling.PlayerKillingOverView;
	import com.test.game.Modules.MainGame.PlayerKilling.PlayerKillingWaitView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.BmdView.AutoPKSceneView;
	import com.test.game.Mvc.BmdView.PlayerKillingSceneView;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.key.GoToBattleControl;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	import com.test.game.net.sm.Room.CancelPipei;
	
	import flash.utils.getTimer;
	
	public class PlayerKillingManager extends Singleton
	{
		public var startAutoPipeiFun:Function;
		public var cancelAutoPipeiFun:Function;
		public var pkType:uint = 0;
		private var _stepPipeiCount:int = 0;
		private var _stepJoinRoomCount:int = 0;
		private var _stepFightCount:int = 0;
		private var _startPipei:Boolean = false;
		private var _startJoinRoom:Boolean = false;
		private var _startFight:Boolean = false;
		//pk冷却计时
		private var _pkTimeDate:Date;
		public function get pkMinute() : int{
			return _pkTimeDate.minutes + _pkTimeDate.hours * 60;
		}
		//pk冷却计时开始
		public var pkTimeStart:Boolean = false;
		private var _preTime:Number;
		private var _calculateTime:Number;
		public var isGameOver:Boolean;
		public var isCanPK:Boolean = true;
		private function get pkFightView() : PlayerKillingFightView{
			if(ViewFactory.getIns().getView(PlayerKillingFightView) != null){
				return ViewFactory.getIns().getView(PlayerKillingFightView) as PlayerKillingFightView;
			}
			return null;
		}
		
		private function get pkOverView() : PlayerKillingOverView{
			if(ViewFactory.getIns().getView(PlayerKillingOverView) != null){
				return ViewFactory.getIns().getView(PlayerKillingOverView) as PlayerKillingOverView;
			}
			return null;
		}
		
		public function PlayerKillingManager(){
			super();
			
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.START_AUTO_PIPEI_PK, startAutoPipeiSuccess);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.CANCEL_AUTO_PIPEI_PK, cancelAutoPipeiSuccess);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.PIPEI_COMPLETE_PK, startCoolDown);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.LOADING_COMPLETE_PK, onLoadingComplete);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.RESULT_FAILURE_PK, PKFailure);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.RESULT_VICTORY_PK, PKVictory);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.GET_NOTICE_PK, onGetNotice);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.JOIN_ROOM_SUCCESS_PK, onJoinRoomSuccess);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.JOIN_ROOM_FAILURE_PK, onJoinRoomFailure);
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.LEAVE_ROOM_SUCCESS_PK, onLeaveRoomSuccess);
		}
		
		
		public static function getIns():PlayerKillingManager{
			return Singleton.getIns(PlayerKillingManager);
		}
		
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function startAutoPipei(callback:Function = null) : void{
			startAutoPipeiFun = callback;
			_startPipei = false;
			_startJoinRoom = false;
			_startFight = false;
			_stepPipeiCount = 0;
			_stepJoinRoomCount = 0;
			_stepFightCount = 0;
			PipeiManager.getIns().startAutoPipeiPK();
		}
		
		public function startAutoPipeiSuccess(e:CommonEvent) : void{
			_startPipei = true;
			if(startAutoPipeiFun != null){
				startAutoPipeiFun();
			}
		}
		
		public function cancelAutoPipei(callback:Function) : void{
			cancelAutoPipeiFun = callback;
			_startPipei = false;
			PipeiManager.getIns().startCancelAutoPipei();
		}
		
		public function cancelAutoPipeiSuccess(e:CommonEvent) : void{
			if(cancelAutoPipeiFun != null){
				cancelAutoPipeiFun();
			}
		}
		
		protected function onJoinRoomFailure(e:CommonEvent):void{
			_startJoinRoom = false;
			(ViewFactory.getIns().initView(PlayerKillingWaitView) as PlayerKillingWaitView).onCancelAutoPipei();
		}
		
		protected function onJoinRoomSuccess(e:CommonEvent):void{
			_startPipei = false;
			_startJoinRoom = true;
			_startFight = false;
			(ViewFactory.getIns().initView(PlayerKillingWaitView) as PlayerKillingWaitView).joinRoomStart();
		}
		
		public function leaveRoom() : void{
			_startJoinRoom = false;
			PipeiManager.getIns().startLeaveRoom();
		}
		
		protected function onLeaveRoomSuccess(e:CommonEvent):void{
			if(!ViewFactory.getIns().initView(PlayerKillingWaitView).isClose){
				(ViewFactory.getIns().initView(PlayerKillingWaitView) as PlayerKillingWaitView).cancelAutoPipei();
			}
		}
		
		protected function onGetNotice(e:CommonEvent):void{
			var notice:String = e.data as String;
			if(notice == "服务器已关闭！"){
				isCanPK = false;
			}
		}
		
		public function startCoolDown(e:CommonEvent) : void{
			DebugArea.getIns().showInfo("---双方玩家准备完毕，开始5秒倒计时---");
			pkType = 0;
			_startPipei = false;
			_startJoinRoom = false;
			_startFight = true;
			isGameOver = false;
			
			SaveManager.getIns().onSaveGame(
				function () : void{
					player.pkInfo.pkCount++;
					player.pkInfo.pkStatus = 0;
					if(player.pkInfo.pkTime == ""){
						player.pkInfo.pkTime = TimeManager.getIns().returnTimeNowStr();
					}
					startUpdateDate();
				},
				function () : void{
					(ViewFactory.getIns().initView(PlayerKillingWaitView) as PlayerKillingWaitView).coolDownStart();
				});
		}
		
		public function startPlayerKilling() : void{
			DebugArea.getIns().showInfo("---倒计时结束，开始进入场景---");
			_startFight = false;
			/*var nowInfo:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.LEVEL, "level_id", "1_1");
			(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).gotoTeamBattle(nowInfo);*/
			if(pkType == 0){
				(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).gotoPlayerKilling();
			}else{
				(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).gotoAutoPK();
			}
		}
		
		public function loadingComplete() : void{
			PipeiManager.getIns().loadingComplete();
		}
		
		protected function onLoadingComplete(e:CommonEvent):void{
			if(ViewFactory.getIns().getView(PKWaitView) != null){
				ViewFactory.getIns().getView(PKWaitView).hide();
			}
			if(BmdViewFactory.getIns().getView(PlayerKillingSceneView) != null){
				(BmdViewFactory.getIns().getView(PlayerKillingSceneView) as PlayerKillingSceneView).coolDownComplete();
			}
		}
		
		public function autoPKStart() : void{
			var pkLevel:int = PlayerManager.getIns().player.pkInfo.pkLv;
			if(pkLevel < 4){
				pkType = 1;
			}else if(pkLevel < 10){
				pkType = 2;
			}else{
				return;
			}
			
			cancelAutoPipeiFun = null;
			_startPipei = false;
			var sm:CancelPipei = new CancelPipei(RoleManager.getIns().getPlayerProperty());
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
			DebugArea.getIns().showInfo("---双方玩家准备完毕，开始5秒倒计时---");
			_startPipei = false;
			_startJoinRoom = false;
			_startFight = true;
			isGameOver = false;
			
			SaveManager.getIns().onSaveGame(
				function () : void{
					player.pkInfo.pkCount++;
					player.pkInfo.pkStatus = 0;
					if(player.pkInfo.pkTime == ""){
						player.pkInfo.pkTime = TimeManager.getIns().returnTimeNowStr();
					}
					startUpdateDate();
				},
				function () : void{
					(ViewFactory.getIns().initView(PlayerKillingWaitView) as PlayerKillingWaitView).coolDownStart();
				});
		}
		
		
		
		//判断pk时间
		public function startUpdateDate() : void{
			if(player.pkInfo.pkTime != "0" && player.pkInfo.pkTime != ""){
				_pkTimeDate = TimeManager.getIns().getAnalysisDate(player.pkInfo.pkTime);
				var nowDate:Date = TimeManager.getIns().returnTimeNow();
				var intervalTime:int = player.pkInfo.pkCount * 5 * 60 - (nowDate.time - _pkTimeDate.time) * .001;
				if(intervalTime > 0){
					_pkTimeDate = new Date(2000, 0, 1, 0, 0, 0);
					_pkTimeDate.time += (intervalTime * 1000);
					_preTime = getTimer();
					if(intervalTime >= 60 * 60){
						player.pkInfo.pkCanStart = 0;
					}
					pkTimeStart = true;
				}else{
					pkTimeStart = false;
					player.pkInfo.pkTime = "";
					player.pkInfo.pkCount = 0;
					player.pkInfo.pkCanStart = 1;
				}
			}else{
				pkTimeStart = false;
				player.pkInfo.pkTime = "";
				player.pkInfo.pkCount = 0;
				player.pkInfo.pkCanStart = 1;
			}
			if(pkFightView != null){
				pkFightView.update();
			}
		}
		
		public function clearPKTime(balance:int) : void{
			(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("购买成功！");
			pkTimeStart = false;
			player.pkInfo.pkTime = "";
			player.pkInfo.pkCount = 0;
			player.pkInfo.pkCanStart = 1;
			if(GameConst.localLogin){
				pkFightView.update();
			}else{
				SaveManager.getIns().onlySave(startUpdateDate);
			}
		}
		
		private function PKVictory(e:CommonEvent) : void{
			updateData(1);
		}
		
		private function PKFailure(e:CommonEvent) : void{
			updateData(0);
		}
		
		public function updateData(result:int) : void{
			isGameOver = true;
			var obj:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.PK_EXP, "lv", player.pkInfo.pkLv);
			player.pkInfo.preResult = result;
			player.pkInfo.pkStatus = 1;
			if(result == 0){
				(ViewFactory.getIns().initView(PlayerKillingOverView) as PlayerKillingOverView).setAllData(0);
				player.pkInfo.pkLose++;
				player.pkInfo.addPKExp(obj.loserexp);
				player.soul += obj.losersoul;
			}else if(result == 1){
				(ViewFactory.getIns().initView(PlayerKillingOverView) as PlayerKillingOverView).setAllData(1);
				player.pkInfo.pkWin++;
				player.pkInfo.addPKExp(obj.winnerexp);
				player.soul += obj.winnersoul;
			}
			TitleManager.getIns().checkPkKingTitle();
			
			if(BmdViewFactory.getIns().getView(PlayerKillingSceneView) != null){
				(ViewFactory.getIns().initView(PlayerKillingOverView) as PlayerKillingOverView).showType = 0;
			}else{
				(ViewFactory.getIns().initView(PlayerKillingOverView) as PlayerKillingOverView).showType = 1;
			}
			
			if(ViewFactory.getIns().getView(PlayerKillingWaitView) != null){
				(ViewFactory.getIns().getView(PlayerKillingWaitView) as PlayerKillingWaitView).clearPlayerKilling();
			}
			if(ViewFactory.getIns().getView(PKWaitView) != null){
				ViewFactory.getIns().getView(PKWaitView).hide();
			}
			ViewFactory.getIns().initView(PlayerKillingOverView).show();
		}
		
		//返回主界面
		public function playerKillingOver() : void{
			if(BmdViewFactory.getIns().getView(PlayerKillingSceneView) != null){
				(BmdViewFactory.getIns().getView(PlayerKillingSceneView) as PlayerKillingSceneView).leavePlayerKilling();
			}
			if(BmdViewFactory.getIns().getView(AutoPKSceneView) != null){
				(BmdViewFactory.getIns().getView(AutoPKSceneView) as AutoPKSceneView).leavePlayerKilling();
			}
			ViewFactory.getIns().getView(PlayerKillingFightView).show();
			ViewFactory.getIns().getView(MainToolBar).update();
		}
		
		//重新匹配
		public function restartPlayerKilling() : void{
			if(BmdViewFactory.getIns().getView(PlayerKillingSceneView) != null){
				(BmdViewFactory.getIns().getView(PlayerKillingSceneView) as PlayerKillingSceneView).leavePlayerKilling();
			}
			if(BmdViewFactory.getIns().getView(AutoPKSceneView) != null){
				(BmdViewFactory.getIns().getView(AutoPKSceneView) as AutoPKSceneView).leavePlayerKilling();
			}
			(ViewFactory.getIns().getView(PlayerKillingFightView) as PlayerKillingFightView).onAutoPipei();
			ViewFactory.getIns().getView(MainToolBar).update();
		}
		
		public function step() : void{
			if(pkTimeStart && _pkTimeDate != null){
				_calculateTime = (getTimer() - _preTime);
				if(_calculateTime > 1000){
					_calculateTime = 0;
				}
				_pkTimeDate.time -= _calculateTime;
				_preTime = getTimer();
				if(pkFightView != null && !pkFightView.isClose){
					pkFightView.updateTF(_pkTimeDate.hours, _pkTimeDate.minutes, _pkTimeDate.seconds);
				}
				if(pkOverView != null && !pkOverView.isClose){
					pkOverView.updateTF(_pkTimeDate.hours, _pkTimeDate.minutes, _pkTimeDate.seconds);
				}
				if(_pkTimeDate.hours == 0
					&& _pkTimeDate.minutes == 0
					&& _pkTimeDate.seconds == 0){
					player.pkInfo.pkCount = 0;
					player.pkInfo.pkCanStart = 1;
					player.pkInfo.pkTime = "";
					pkTimeStart = false;
					if(pkFightView != null){
						pkFightView.update();
					}
				}
			}
			
			if(ViewFactory.getIns().getView(PlayerKillingWaitView) != null){
				if(_startPipei){
					_stepPipeiCount++;
					if(_stepPipeiCount == 30){
						ViewFactory.getIns().getView(PlayerKillingWaitView).update();
						_stepPipeiCount = 0;
					}
				}
				if(_startFight){
					_stepFightCount++;
					if(_stepFightCount == 30){
						(ViewFactory.getIns().getView(PlayerKillingWaitView) as PlayerKillingWaitView).coolDownUpdate();
						_stepFightCount = 0;
					}
				}
				if(_startJoinRoom){
					_stepJoinRoomCount++;
					if(_stepJoinRoomCount == 30){
						(ViewFactory.getIns().getView(PlayerKillingWaitView) as PlayerKillingWaitView).joinRoomUpdate();
						_stepJoinRoomCount = 0;
					}
				}
			}
		}
		
		public function clear() : void{
			isCanPK = true;
		}
	}
}