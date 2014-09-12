package com.test.game.Modules.ChoosePlayer.view{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.superkaka.mvc.Control.net.SMessage;
	import com.test.game.Mvc.Vo.Player;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	import com.test.game.net.sm.Login.ChoosePlayer;
	import com.test.game.net.sm.Login.NewPlayer;
	
	public class ChoosePlayerView extends BaseView{
		public function ChoosePlayerView(){
			super();
		}
		
		override public function init():void{
			super.init();
			
		}
		
		
		public function getPlayerReturn(players:Vector.<Player>):void{
			this.newBtn(null,0);
			var i:uint=1;
			for each(var player:Player in players){
				this.newBtn(player,i);
				i++;
			}
		}
		
		
		private function newBtn(player:Player,i:uint):void{
			var sp:SinglePlayer = new SinglePlayer();
			sp.initWithPlayer(player);
			sp.x = 100+120*i;
			this.addChild(sp);
			sp.addEventListener(SinglePlayer.CHOOSE,__choosePlayer);
			sp.addEventListener(SinglePlayer.NEW,__choosePlayer);
			
		}
		
		protected function __choosePlayer(evt:CommonEvent):void{
			var sp:SinglePlayer = evt.currentTarget as SinglePlayer;
			var choosePlayer:Player = evt.data as Player;
			//发送选择结果
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			var sm:SMessage;
			if(evt.type == SinglePlayer.CHOOSE){
				//选择角色
				sm = new ChoosePlayer(choosePlayer);
			}else{
				//新建角色
				sm = new NewPlayer(choosePlayer);
			}
			ssc.send(sm);
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

