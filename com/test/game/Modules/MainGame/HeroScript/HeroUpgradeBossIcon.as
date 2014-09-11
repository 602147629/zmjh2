package com.test.game.Modules.MainGame.HeroScript
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.UI.BaseBossIcon;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	public class HeroUpgradeBossIcon extends BaseBossIcon implements IGrid
	{
		public function HeroUpgradeBossIcon()
		{
			super();

		}
		
		private var gouBg:BaseNativeEntity;
		
	    override public function setData(data:*):void{
			
			super.setData(data);
			initClickEvent();
			if(!gouBg){
				gouBg = new BaseNativeEntity();
				gouBg.x = 18;
				gouBg.data.bitmapData = AUtils.getNewObj("gouBg") as BitmapData;
				this.addChild(gouBg);
			}
			gouBg.visible = false;
		}
		
		override public function showSelected():void{
			gouBg.visible = true;
			super.showSelected();
		}
		
		override public function hideSelected():void{
			gouBg.visible = false;
			super.hideSelected();
		}
		
		
		
		private function initClickEvent():void{
			this.addEventListener(MouseEvent.CLICK,onBossSelected);
		}
		
		protected function onBossSelected(e:MouseEvent):void
		{
			EventManager.getIns().dispatchEvent(
				new CommonEvent(EventConst.HERO_UPGRADE_BOSS_SELECT,[data,this]));
		}	
		
		override public function destroy():void{
			this.removeEventListener(MouseEvent.CLICK,onBossSelected);
			super.destroy();
		}
		

	}
}