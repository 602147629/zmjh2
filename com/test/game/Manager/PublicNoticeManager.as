package com.test.game.Manager
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.NumberConst;
	import com.test.game.Modules.MainGame.Tip.PublicNoticeView;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	import com.test.game.net.sm.PublicNotice.PublicNoticeMsg;
	
	public class PublicNoticeManager extends Singleton
	{

		public var sendPublicNoticeFun:Function;
		private var countStep:int;
		
		public function PublicNoticeManager(){
			super();
			//EventManager.getIns().EventDispather.addEventListener(EscortEventConst.START_ESCORT, startMatchEscortSuccess);
			//EventManager.getIns().EventDispather.addEventListener(EscortEventConst.CANCEL_MATCH_ESCORT, cancelMatchEscortSuccess);
		}
		
		public static function getIns():PublicNoticeManager{
			return Singleton.getIns(PublicNoticeManager);
		}
		
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		private function get publicNotice() : PublicNoticeView{
			if(ViewFactory.getIns().getView(PublicNoticeView) != null){
				return ViewFactory.getIns().getView(PublicNoticeView) as PublicNoticeView;
			}else{
				return null;
			}
		}
		
		public function sendPublicNotice(type:int,info:String,callback:Function = null) : void{
			if(GameConst.localData)	return;
			DebugArea.getIns().showInfo("---发送开始公告---");
			sendPublicNoticeFun = callback;
			var sm:PublicNoticeMsg = new PublicNoticeMsg(type,info);
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
		}
		
		public function startMatchEscortSuccess(e:CommonEvent) : void{
			DebugArea.getIns().showInfo("---公告发送成功---");
			if(sendPublicNoticeFun != null){
				sendPublicNoticeFun();
			}
		}
		
		//祝福次数加1
		public function addPublicNoticeCount() : void{
			if(player != null){
				player.statisticsInfo.publicNoticeCount++;
				DebugArea.getIns().showInfo("---祝福次数：" + player.statisticsInfo.publicNoticeCount + "---");
			}
		}
		
		//刚刚好到达200次的祝福次数
		public function get justPublicNoticeCount() : Boolean{
			var result:Boolean = false;
			if(player.statisticsInfo.publicNoticeCount == NumberConst.getIns().two * NumberConst.getIns().oneHundred){
				result = true;
			}
			return result;
		}
		
		//超过200次的祝福次数
		public function get checkPublicNoticeCount() : Boolean{
			var result:Boolean = false;
			if(player.statisticsInfo.publicNoticeCount > NumberConst.getIns().two * NumberConst.getIns().oneHundred){
				result = true;
			}
			return result;
		}
		
		//每秒执行
		public function step() : void{
			countStep++;
			if(countStep % 30 == 0){
				if(publicNotice != null){
					publicNotice.update();
				}
				countStep = 0;
			}
		}
		
		public function clear() : void{
			if(publicNotice != null){
				publicNotice.clear();
			}
		}
	}
}