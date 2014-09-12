package{
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ProxyFactory;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Mvc.Proxy.ProtocolProxy;
	import com.test.game.Mvc.control.data.ProtocalControl;
	import com.test.game.Mvc.control.net.rm.MyCommonReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyGameReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyGateReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyLineReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyLoginReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyPlayerReceiveControl;
	import com.test.game.Mvc.control.net.rm.MyRoomReceiveControl;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	
	public class PressureTest2 extends Sprite{
		private var total:int = 1;
		private var uid:int = 10000+Math.random()*10000;
		
		public function PressureTest2(){
			this.dodo();
		}
		
		private function start(...args):void{
			ConfigurationManager.getIns().init();
			ProxyFactory.getIns().initProxy(ProtocolProxy);
			
			ControlFactory.getIns().initControl(MyCommonReceiveControl);
			ControlFactory.getIns().initControl(MyGameReceiveControl);
			ControlFactory.getIns().initControl(MyGateReceiveControl);
			ControlFactory.getIns().initControl(MyLineReceiveControl);
			ControlFactory.getIns().initControl(MyLoginReceiveControl);
			ControlFactory.getIns().initControl(MyPlayerReceiveControl);
			ControlFactory.getIns().initControl(MyRoomReceiveControl);
			
			ControlFactory.getIns().initControl(SocketsSendControl);
			ControlFactory.getIns().initControl(ProtocalControl);
			
			connect();
		}
		
		
		private var arr:Array = [];
		private function connect():void{
			if(total > 0){
				uid++;
				total--;
			}else{
				return;
			}
			
			var scmt:SocketConnectManagerTest = new SocketConnectManagerTest(uid);
			arr.push(scmt);
			
			
			setTimeout(connect,100);
		}
		
		
		public function dodo():void{
			GameConst.GATE_IP = "192.168.54.107";
			GameConst.GATE_PORT = 4096;
			AssetsManager.getIns().addQueen([],[
				AssetsUrl.JSON_DATA
			], start, null);
			AssetsManager.getIns().start();
		}
	}
}