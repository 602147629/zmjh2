package com.test.game.net.sm.Gate
{
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class GetServers extends SMessage{
		public function GetServers(){
			super("RMGate.GetServers");
		}
		
		override protected function writeBody():void{
			
		}
	}
}