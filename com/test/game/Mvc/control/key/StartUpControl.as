package com.test.game.Mvc.control.key{
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ProxyFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.superkaka.mvc.View.Map.MemCpuView;
	import com.test.game.Mvc.Proxy.ProtocolProxy;
	import com.test.game.Mvc.control.data.ProtocalControl;
	import com.test.game.Mvc.control.net.rm.MyCommonReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyEscortReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyGameReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyGateReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyLineReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyLoginReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyPlayerReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyPublicNoticeReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyRoomReceiveControl;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	import com.test.game.Mvc.view.Loading.LoadingView;
	
	public class StartUpControl extends BaseControl{
		public function StartUpControl(){
			super();
		}
		
		/**
		 *开始游戏 
		 * 
		 */		
		public function startGame():void{
			//加载界面
			ViewFactory.getIns().initView(LoadingView).show();
			if(GameConst.localLogin){
				ViewFactory.getIns().initView(MemCpuView).show();
			}
			ControlFactory.getIns().initControl(InitLoadingCompleteControl);
			ControlFactory.getIns().initControl(SocketsSendControl);
			
			ControlFactory.getIns().initControl(MyLoginReceiveControl);
			ControlFactory.getIns().initControl(MyGameReceiveControl);
			ControlFactory.getIns().initControl(MyRoomReceiveControl);
			ControlFactory.getIns().initControl(MyLineReceiveControl);
			ControlFactory.getIns().initControl(MyPlayerReceiveControl);
			ControlFactory.getIns().initControl(MyGateReceiveControl);
			ControlFactory.getIns().initControl(MyCommonReceiveControl);
			ControlFactory.getIns().initControl(MyEscortReceiveControl);
			ControlFactory.getIns().initControl(MyPublicNoticeReceiveControl);
			
			ControlFactory.getIns().initControl(ProtocalControl);
			ProxyFactory.getIns().initProxy(ProtocolProxy);
		}
		
		
	}
}