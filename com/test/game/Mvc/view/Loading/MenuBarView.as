package com.test.game.Mvc.view.Loading{
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	import com.test.game.net.sm.Game.LeftFb;
	
	import flash.events.MouseEvent;
	import flash.system.System;
	
	import fl.controls.Button;
	
	public class MenuBarView extends BaseView{
		private var btn:Button;
		
		
		public function MenuBarView(){
			super();
			
			this.x = 500;
			this.y = 500;
		}
		
		override public function init():void{
			super.init();
			
			btn = new Button();
			btn.label = "返回";
			this.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK,__click);
			
			
		}
		
		
		public function showProgress(...args):void{
			var currentFileIdx:uint = args[0];
			var totalFileIdx:uint = args[1];
			var currentLoadedBytes:uint = args[2];
			var totalLoadedBytes:uint = args[3];
			
		}
		
		protected function __click(evt:MouseEvent):void{
			var sm:LeftFb = new LeftFb();
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
			System.gc();
			return;
		}
		
		private function callback():void{
			//this.show();
			this.destroy();
		}
		
		override public function step():void{
			super.step();
			
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameInfoLayer;
		}
		
	}
}