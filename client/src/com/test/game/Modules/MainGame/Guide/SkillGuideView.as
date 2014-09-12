package com.test.game.Modules.MainGame.Guide
{
	import com.greensock.TweenMax;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Manager.GuideManager;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SkillGuideView extends BaseView
	{
		public function SkillGuideView()
		{
			super();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
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
				_guideMC = GuideManager.getIns().getGuideMCByName("GuideSkillDetail", 0, 0);
				layer.addChild(_guideMC);
			}
		}
		
		private function hideGuide(e:MouseEvent) : void{
			this.hide();
			GuideManager.getIns().skillGuideSetting();
		}
	}
}