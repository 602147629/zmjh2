package com.test.game.Modules.MainGame.HeroScript
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.HeroFightManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.UI.Grid.IGrid;
	import com.test.game.Utils.AllUtils;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class HeroFightDungeonIcon extends BaseSprite implements IGrid
	{
		public function HeroFightDungeonIcon()
		{
			this.buttonMode = true;
			initClickEvent();
			super();

		}
		
		private var dungeonImage:Sprite;
		
		private var _data:*;
		
		public function set menuable(value:Boolean):void{
		}
		public function set selectable(value:Boolean):void{
		}
		public function set index(value:int):void{
		}
		public function setLocked():void{
		}
		
		
		public function setData(data:*):void{
			_data = data;
			//物品图标
			if(!dungeonImage){
				dungeonImage = AssetsManager.getIns().getAssetObject(data.id) as Sprite;
				this.addChild(dungeonImage);
			}

			if(data.isOpen){
				GreyEffect.reset(this);
			}else{
				GreyEffect.change(this);
			}
		}
		
		private function initClickEvent():void{
			this.addEventListener(MouseEvent.CLICK,onEnterDungeon);
		}
		
		protected function onEnterDungeon(event:MouseEvent):void{
			if(PackManager.getIns().checkMaxRoomByNum(3)){
				HeroFightManager.getIns().startHeroFight(AllUtils.getNumFromString(_data.id) - 1);
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"请将背包至少留出三个空位后再进入");
			}
			
		}
		
		override public function destroy():void{
			removeComponent(dungeonImage);
			this.removeEventListener(MouseEvent.CLICK,onEnterDungeon);
			super.destroy();
		}
		

	}
}