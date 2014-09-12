package com.test.game.Modules.MainGame.MainUI
{
	import com.test.game.Mvc.Vo.PlayerVo;

	public class ExtraBattleToolBar extends BattleToolBar
	{
		public function ExtraBattleToolBar(player:PlayerVo)
		{
			super(player);
			
			layer.scaleX = .8;
			layer.scaleY = .8;
			layer.x = 240;
			layer.y = 500;
		}
		
		override protected function updateScale() : void{
			
		}
		
		override protected function updateLetter() : void{
			skillLetter.gotoAndStop(2);
		}
	}
}