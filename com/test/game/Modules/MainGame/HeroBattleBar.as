package com.test.game.Modules.MainGame
{
	import com.test.game.Manager.HeroFightManager;

	public class HeroBattleBar extends BossBattleBar
	{
		public function HeroBattleBar()
		{
			super();
			HP_PERCENT = 9000;
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			if(HeroFightManager.getIns().monsterArr[HeroFightManager.getIns().nowIndex] == 6023){
				twoBossSetting();
			}else{
				oneBossSetting();
			}
		}
	}
}