package com.test.game.net.sm.Game{
	import com.superkaka.mvc.Control.net.SMessage;
	
	public class LoadingComplete extends SMessage{
		public function LoadingComplete(){
			super("RMGame.LoadingComplete");
		}
		
		override protected function writeBody():void{
			
		}
	}
}