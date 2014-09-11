package com.test.game.Modules.MainGame.Guide
{
	import com.greensock.TweenMax;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.GuideConst;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Modules.MainGame.Role.RoleDetailView;
	import com.test.game.Modules.MainGame.Strengthen.StrengthenView;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class EquipStrengthenView extends BaseView
	{
		public function EquipStrengthenView()
		{
			super();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameInfoLayer;	
		}
		
		private var _guideMC:MovieClip;
		private var _clickScene:MovieClip;
		override public function setParams():void{
			if(layer == null){
				layer = new Sprite();
				this.addChild(layer);
				initBg();
				bg.addEventListener(MouseEvent.CLICK, hideGuide);
				_clickScene = GuideManager.getIns().getGuideMCByName("GuideClickScene", 840, 500);
				this.addChild(_clickScene);
				_guideMC = GuideManager.getIns().getGuideMCByName("GuideEquipStrength", 0, 0);
			}
			var point:Point = (ViewFactory.getIns().getView(StrengthenView) as StrengthenView).position;
			_guideMC.x = (point.x == 0?263:point.x) + 5;
			_guideMC.y = (point.y == 0?28:point.y) + 20;
			layer.addChild(_guideMC);
		}
		
		private function hideGuide(e:MouseEvent) : void{
			this.hide();
			GuideManager.getIns().strengthenGuideSetting();
		}
	}
}