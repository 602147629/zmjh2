package com.test.game.net.sm.Line{
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class GetLines extends SMessage{
		
		public function GetLines(){
			super("RMLine.GetLines");
		}
		
		override protected function writeBody():void{
			
		}
	}
}