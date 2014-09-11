package com.test.game.net.sm.Room{
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class LeftRoom extends SMessage{
		public function LeftRoom(){
			super("RMRoom.LeftRoom");
		}
		
		override protected function writeBody():void{
			
		}
	}
}