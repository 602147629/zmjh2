package com.test.game.net.sm.Room{
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class CreateRoom extends SMessage{
		public function CreateRoom(){
			super("RMRoom.CreateRoom");
		}
		
		override protected function writeBody():void{
			
		}
	}
}