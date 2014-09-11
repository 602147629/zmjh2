package com.test.game.net.sm.Line{
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class GetAllRooms extends SMessage{
		public function GetAllRooms(){
			super("RMLine.GetAllRooms");
		}
		
		override protected function writeBody():void{
			
		}
	}
}