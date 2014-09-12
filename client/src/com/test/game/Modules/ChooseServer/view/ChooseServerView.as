package com.test.game.Modules.ChooseServer.view{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Manager.SocketConnectManager;
	import com.test.game.Mvc.Vo.Server;
	
	public class ChooseServerView extends BaseView{
		public function ChooseServerView(){
			super();
		}
		
		override public function init():void{
			super.init();
			
		}
		
		
		public function getServerReturn(servers:Vector.<Server>):void{
			var i:uint=0;
			for each(var server:Server in servers){
				this.newBtn(server,i);
				i++;
			}
		}
		
		
		private function newBtn(server:Server,i:uint):void{
			var sl:SingleServer = new SingleServer();
			sl.initWithServer(server);
			sl.x = 100+120*i;
			this.addChild(sl);
			sl.addEventListener(SingleServer.CHOOSE,__chooseServer);
		}
		
		protected function __chooseServer(evt:CommonEvent):void{
			var sp:SingleServer = evt.currentTarget as SingleServer;
			var chooseServer:Server = evt.data as Server;
			//直接按照选择结果，连接相对应的服务器
//			SocketConnectManager.getIns().connectToGame(chooseServer.ip,chooseServer.port);
		}	
		
		
		
		override public function step():void{
			super.step();
			
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy():void{
			super.destroy();
			
		}
	}
}


