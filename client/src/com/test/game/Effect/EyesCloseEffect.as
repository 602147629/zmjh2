package com.test.game.Effect
{
	import com.greensock.TweenLite;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Manager.AnimationManager;
	
	import flash.display.Sprite;

	public class EyesCloseEffect extends BaseEffect{
		
		public function EyesCloseEffect(){
			super();
			init();
		}
		
		private var rect:BaseSprite;
		private var _fuzzy:FuzzyEffect;
		public var closeCallback:Function;
		public var openCallback:Function;
		private function init() : void{
			rect = new BaseSprite();
			rect.graphics.beginFill(0x000000, 1);
			rect.graphics.drawRect(0,0,GameConst.stage.width,GameConst.stage.height);
			rect.graphics.endFill();
			
			_fuzzy = new FuzzyEffect();
		}
		
		public function addStartItem(sp:Sprite) : void{
			_fuzzy.addItem(sp, true);
		}
		public function addEndItem(sp:Sprite) : void{
			_fuzzy.addItem(sp, false);
		}
		
		public function closeEye() : void{
			addRect();
			rect.alpha = 0;
			TweenLite.to(rect, 1.5, {alpha:1, onComplete:isCloseCallback});
			_fuzzy.start();
		}
		
		private function isCloseCallback() : void{
			if(closeCallback != null){
				closeCallback();
			}
		}
		
		public function start() : void{
			addRect();
			rect.alpha = 0;
			TweenLite.to(rect, 1.5, {alpha:1, onComplete:openEye});
			_fuzzy.start();
		}
		
		public function openEye() : void{
			addRect();
			rect.alpha = 1;
			TweenLite.delayedCall(.5, 
				function () : void{
					TweenLite.to(rect, 1, {alpha:0, onComplete:openComplete});
				});
			if(closeCallback != null){
				closeCallback();
			}
			_fuzzy.resume();
		}
		
		private function addRect() : void{
			if(rect.parent == null){
				LayerManager.getIns().gameTipLayer.addChild(rect);
			}
			var index:int = LayerManager.getIns().gameTipLayer.numChildren - 1;
			LayerManager.getIns().gameTipLayer.setChildIndex(rect, index);
		}
		
		private function openComplete() : void{
			if(rect.parent != null){
				rect.parent.removeChild(rect);
			}
			if(openCallback != null){
				openCallback();
			}
			//this.destroy();
		}
		
		public function clear() : void{
			_fuzzy.clear();
		}
		
		override public function destroy():void{
			if(rect != null){
				if(rect.parent != null){
					rect.parent.removeChild(rect);
				}
				rect.destroy();
				rect = null;
			}
			super.destroy();
		}
	}
}