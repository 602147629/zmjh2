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
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class RoleDetailGuideView extends BaseView{
		public function RoleDetailGuideView(){
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
				_guideMC = GuideManager.getIns().getGuideMCByName("GuideRoleDetail", 0, 0);
			}
			var point:Point = (ViewFactory.getIns().getView(RoleDetailView) as RoleDetailView).position;
			_guideMC.x = point.x;
			_guideMC.y = point.y;
			layer.addChild(_guideMC);
		}
		
		public function tweenlitePosition() : void{
			if(_guideMC != null && !this.isClose){
				TweenMax.fromTo(_guideMC,0.3,{x:300},{x:100});
			}
		}
		
		private function hideGuide(e:MouseEvent) : void{
			this.hide();
			GuideManager.getIns().bagGuideSetting();
		}
	}
}