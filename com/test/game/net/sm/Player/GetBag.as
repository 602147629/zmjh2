package com.test.game.net.sm.Player{
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class GetBag extends SMessage{
		public function GetBag(){
			super("RMPlayer.GetBag");
		}
		
		override protected function writeBody():void{
			
		}
	}
}