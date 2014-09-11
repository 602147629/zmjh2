package com.test.game.Modules.MainGame.Guide
{
	import com.greensock.TweenLite;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class OneKeyEquipView extends BaseView
	{
		public function OneKeyEquipView()
		{
			super();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private var _oneKeyMC:MovieClip;
		private var _itemIcon:ItemIcon
		override public function setParams():void{
			var point:Point = (ViewFactory.getIns().getView(MainToolBar) as MainToolBar).getBtnPosition("bag");
			if(layer == null){
				var index:int = LayerManager.getIns().gameLayer.getChildIndex(ViewFactory.getIns().getView(MainToolBar));
				LayerManager.getIns().gameLayer.setChildIndex(this, index - 1);
				layer = new Sprite();
				this.addChild(layer);
				_oneKeyMC = GuideManager.getIns().getGuideMCByName("OneKeyEquip", point.x - 150, 415 + point.y);
				layer.addChild(_oneKeyMC);
				(_oneKeyMC["EquipBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onOneKeyEquip);
				
				_itemIcon = new ItemIcon();
				_itemIcon.x = 165;
				_itemIcon.y = 25;
				_itemIcon.menuable = false;
				_oneKeyMC.addChild(_itemIcon);
			}
			
			var itemVo:ItemVo = PackManager.getIns().getUnEquipItem();
			if(itemVo == null){
				this.hide();
			}else if(PlayerManager.getIns().player.mainMissionVo.id < 1003 || PlayerManager.getIns().player.mainMissionVo.id > 1009){
				this.hide();
			}else{
				_itemIcon.setData(itemVo);
			}
			_oneKeyMC.x = point.x - 160;
			_oneKeyMC.y = 400;
		}
		
		public function tweenlitePosition(xPos:int) : void{
			TweenLite.to(_oneKeyMC, 1, {x:xPos});
		}
		
		private function onOneKeyEquip(e:MouseEvent) : void{
			this.hide();
			PackManager.getIns().oneKeyEquip();
		}
	}
}