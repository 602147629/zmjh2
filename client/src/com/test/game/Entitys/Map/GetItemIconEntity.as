package com.test.game.Entitys.Map
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class GetItemIconEntity extends BaseNativeEntity
	{
		private var _fodder:String;
		private var _direct:int;
		private var _speed:Number = 1;
		private var _itemIcon:BaseNativeEntity;
		private var _layer:BaseNativeEntity;
		public function GetItemIconEntity(fodder:String, direct:int = 1,x:int = 475,y:int = 290){
			super();
			


			_fodder = fodder;
			_direct = direct;
			
			initImage();
			initPos(x,y);
			initEvents();
			
			RenderEntityManager.getIns().addEntity(this);
			var randomX:int = Math.random() * 200;
			var randomY:int = Math.random() * 100;
			TweenMax.to(this, 2, {ease:Bounce.easeOut,bezierThrough:[{x:x + _direct * randomX, y:y - randomY}, {x:x + _direct * (25 + randomX), y:420}], onComplete:startMove});
		}
		
		private function initEvents():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,moveToBag);
		}
		
		private function initImage():void{
			_layer = new BaseNativeEntity();
			this.addChild(_layer);
			_itemIcon = new BaseNativeEntity();
			_itemIcon.data.bitmapData = AUtils.getNewObj(_fodder) as BitmapData;
			_itemIcon.x = -_itemIcon.width * .5;
			_layer.addChild(_itemIcon);
		}
		
		private function startMove() : void{
			TweenMax.delayedCall(5, moveToBag);
		}
		
		private function moveToBag(e:MouseEvent = null):void{
			TweenMax.to(this,1,{scaleX:0.2,scaleY:0.2,x:endPos.x,y:endPos.y,onComplete:destroy});	
		}
		
		private function get endPos():Point{
			var pos:Point = new Point(
				ViewFactory.getIns().getView(MainToolBar).layer["bag"].x  + 25,
				ViewFactory.getIns().getView(MainToolBar).layer["bag"].y  + 25);
			return pos;
		}
			
		
		private function initPos(x:int,y:int):void{
			this.x = x;
			this.y = y;
		}
		
		
		override public function destroy() : void{

			TweenLite.killTweensOf(this, false);
			if(_itemIcon != null){
				_itemIcon.destroy();
				_itemIcon = null;
			}
			RenderEntityManager.getIns().removeEntity(this);
			super.destroy();
		}
	}
}