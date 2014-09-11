package com.test.game.Manager.Pipei
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ControlFactory;
	import com.test.game.Const.PiPeiConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.key.GoToBattleControl;
	
	public class LootManager extends Singleton
	{
		public function LootManager()
		{
			super();
			EventManager.getIns().EventDispather.addEventListener(PiPeiConst.PIPEI_COMPLETE_LOOT, startLoot);
		}
		
		public static function getIns():LootManager{
			return Singleton.getIns(LootManager);
		}
		
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function startLootBattle() : void{
			(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).gotoLoot();
		}
		
		private function startLoot(e:CommonEvent) : void{
			(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).gotoLoot();
		}
	}
}