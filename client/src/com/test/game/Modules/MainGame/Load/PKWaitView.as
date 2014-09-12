package com.test.game.Modules.MainGame.Load
{
	import com.test.game.Modules.MainGame.WaitView;
	
	import flash.text.TextField;
	
	public class PKWaitView extends WaitView
	{
		public function PKWaitView()
		{
			super();
		}
		
		override public function show():void{
			if(layer == null) return;
			loadShowTF.text = "等待玩家加入中...";
			super.show();
		}
		
		public function get loadShowTF() : TextField{
			return layer["LoadShowTF"];
		}
	}
}