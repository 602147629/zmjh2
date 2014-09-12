package com.test.game.net.sm.Game{
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class LeftFb extends SMessage{
		public function LeftFb(){
			super("RMGame.LeftFb");
		}
		
		override protected function writeBody():void{
			
		}
	}
}