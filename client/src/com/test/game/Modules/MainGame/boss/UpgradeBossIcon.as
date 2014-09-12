package com.test.game.Modules.MainGame.boss
{
	import com.superkaka.Tools.CommonEvent;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.UI.BaseBossIcon;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.events.MouseEvent;
	
	public class UpgradeBossIcon extends BaseBossIcon implements IGrid
	{
		public function UpgradeBossIcon()
		{
			super();
		}
		
		
	    override public function setData(data:*):void{
			super.setData(data);
			initClickEvent();
		}
		
		
		
		private function initClickEvent():void{
			this.addEventListener(MouseEvent.CLICK,onBossSelected);
		}
		
		protected function onBossSelected(e:MouseEvent):void
		{
			EventManager.getIns().dispatchEvent(
				new CommonEvent(EventConst.UPGRADE_BOSS_SELECT_CHANGE,[data,this]));
		}	
		
		override public function destroy():void{
			this.removeEventListener(MouseEvent.CLICK,onBossSelected);
			super.destroy();
		}
		

	}
}