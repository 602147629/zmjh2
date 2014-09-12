package com.test.game.net.sm.Player{
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class AddExp extends SMessage{
		public function AddExp(){
			super("RMPlayer.AddExp");
		}
		
		override protected function writeBody():void{
			
		}
	}
}