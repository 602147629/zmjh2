package com.test.game.Modules.MainGame.HeroScript
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Manager.HeroFightManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.Grid.IGrid;
	import com.test.game.Utils.AllUtils;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class HeroSpecialFightIcon extends BaseSprite implements IGrid
	{
		private var _obj:Sprite;
		
		private var  bossHeadIcon:BaseNativeEntity
		
		private var _data:ItemVo;

		public function set menuable(value:Boolean):void{
		}
		public function set selectable(value:Boolean):void{
		}
		public function set index(value:int):void{
		}
		public function setLocked():void{
		}
		
		public function HeroSpecialFightIcon()
		{
			
			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("HeroSpecialFightIcon") as Sprite;
				this.addChild(_obj);
			}
			
			bossHeadIcon = new BaseNativeEntity();
			bossHeadIcon.x = 15;
			bossHeadIcon.y = -26;
			bossHead.addChild(bossHeadIcon);

			this.buttonMode = true;
			initEvent();
			super();
		}
		
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.CLICK,onEnterSpecialFight);
		}		
		
		protected function onEnterSpecialFight(event:MouseEvent):void
		{
			if(PackManager.getIns().checkMaxRoomByNum(1)){
				HeroFightManager.getIns().startHeroSpecailFight(_data.bossConfig.id + 5000);
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"请将背包至少留出一个空位后再进入");
			}
		}
		
		public function setData(data:*) : void{
			_data = data as ItemVo;
			bossHeadIcon.data.bitmapData = AUtils.getNewObj(_data.bossConfig.fodder + "_LittleHead") as BitmapData;
			bossName.text = _data.name;
		}
		
		private function get bossHead():MovieClip{
			return _obj["bossHead"];	
		}
		
		private function get bossName():TextField{
			return _obj["bossName"];	
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		

		override public function destroy():void{
			
			removeComponent(bossHead);
			removeComponent(_obj);
			super.destroy();
		}
	}
}