package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.NumberConst;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.utils.getTimer;
	
	public class WuYiManager extends Singleton
	{
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		private function get roleState() : RoleStateView{
			return (ViewFactory.getIns().getView(RoleStateView) as RoleStateView);
		}
		private var _wuyiDate:Date;
		private var _startWuyiCount:Boolean;
		public function get startWuyiCount() : Boolean{
			return _startWuyiCount;
		}
		public function WuYiManager()
		{
			super();
		}
		
		public static function getIns():WuYiManager{
			return Singleton.getIns(WuYiManager);
		}
		
		private var _preTime:Number;
		private var _calculateTime:Number;
		public function step() : void{
			if(player == null || !_startWuyiCount) return;
			_calculateTime = (getTimer() - _preTime);
			if(_calculateTime > 1000){
				_calculateTime = 0;
			}
			_wuyiDate.time -= _calculateTime;
			_preTime = getTimer();
			if(roleState != null){
				roleState.renderWuyiTime(_wuyiDate.minutes, _wuyiDate.seconds);
			}
			if(_wuyiDate.hours == 0
				&& _wuyiDate.minutes == 0
				&& _wuyiDate.seconds == 0){
				_startWuyiCount = false;
				roleState.renderWuyiBtn();
			}
		}
		
		public function setWuyiStart(status:Boolean = false) : void{
			_startWuyiCount = status;
			if(_startWuyiCount){
				var differ:Number = TimeManager.getIns().compareTime(player.wuyiInfo.time, TimeManager.getIns().returnTimeNowStr());
				if(differ < NumberConst.getIns().timeMinute * NumberConst.getIns().timeMinute * 1000 * .5){
					_wuyiDate = new Date(2000, 0, 1, 0, 0, 0);
					_wuyiDate.time += (NumberConst.getIns().timeMinute * NumberConst.getIns().timeMinute * 1000 * .5 - differ);
					_preTime = getTimer();
				}else{
					_startWuyiCount = false;
				}
			}
		}
	}
}