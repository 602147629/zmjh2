package com.test.game.net.sm.Game{
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class StartGame extends SMessage{
		public function StartGame(){
			super("RMGame.StartGame");
		}
		
		override protected function writeBody():void{
			
		}
	}
}