package com.test.game.cartoon
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Effect.DialogEffect;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Mvc.control.key.NewGameControl;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class NewGameCartoon
	{
		public function NewGameCartoon(){
			
		}
		
		private var layer:Sprite;
		public var animation:MovieClip;
		public function init() : void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = new Sprite();
				container.addChild(layer);
				//initUI();
				initCartoon();
			}
		}
		
		public static var cartoon:MovieClip;
		public static var callback:Function;
		public static function showCartoon(type:int, xPos:int, yPos:int, call:Function) : void{
			callback = call;
			var obj:Object = AssetsManager.getIns().getAssetObject("Cartoon_" + type);
			cartoon = obj as MovieClip;
			cartoon.addEventListener(Event.ENTER_FRAME, onCartoonEnterFrame);
			cartoon.x = xPos;
			cartoon.y = yPos;
			LayerManager.getIns().gameTipLayer.addChild(cartoon);
		}
		
		protected static function onCartoonEnterFrame(event:Event):void
		{
			if(cartoon == null) return;
			if(cartoon.currentFrame == cartoon.totalFrames){
				cartoon.removeEventListener(Event.ENTER_FRAME, onCartoonEnterFrame);
				cartoon.stop();
				if(cartoon.parent != null){
					cartoon.parent.removeChild(cartoon);
				}
				cartoon = null;
				if(callback != null){
					callback();
				}
			}
		}
		
		private var _skip:Sprite;
		private function initCartoon():void
		{
			var obj:Object = AssetsManager.getIns().getAssetObject("NewGameCartoon");
			animation = obj as MovieClip;
			animation.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			layer.addChild(animation);
			_skip = AUtils.getNewObj("CartoonSkip") as Sprite;
			layer.addChild(_skip);
			(_skip["SkipBtn"] as SimpleButton).x = 865;
			(_skip["SkipBtn"] as SimpleButton).y = 545;
			(_skip["SkipBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onSkipAll);
		}
		
		public function onSkipAll(event:MouseEvent = null):void{
			(ControlFactory.getIns().getControl(NewGameControl) as NewGameControl).leaveNewGame();
			skipClear();
			animationClear();
			cartoonClear();
			DialogEffect.clear();
		}
		
		public function onClearAll() : void{
			(ControlFactory.getIns().getControl(NewGameControl) as NewGameControl).quitAll();
			skipClear();
			animationClear();
			cartoonClear();
			DialogEffect.clear();
		}
		
		private function skipClear() : void{
			if(_skip != null){
				(_skip["SkipBtn"] as SimpleButton).removeEventListener(MouseEvent.CLICK, onSkipAll);
				if(_skip.parent != null){
					_skip.parent.removeChild(_skip);
				}
				_skip = null;
			}
		}
		
		private function animationClear() : void{
			if(animation != null){
				animation.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				if(animation.parent != null){
					animation.parent.removeChild(animation);
				}
				animation.stop();
				animation = null;
			}
		}
		
		private function cartoonClear() : void{
			if(cartoon != null){
				cartoon.removeEventListener(Event.ENTER_FRAME, onCartoonEnterFrame);
				cartoon.stop();
				if(cartoon.parent != null){
					cartoon.parent.removeChild(cartoon);
				}
				cartoon = null;
			}
		}
		
		protected function onEnterFrame(event:Event):void{
			if(animation == null) return;
			if(animation.currentFrame == 2){
				SoundManager.getIns().bgSoundPlay(AssetsConst.NEWGAMECARTOONSOUND);
			}
			if (animation.currentFrame==animation.totalFrames) {
				animationClear();
				this.destroy();
				(ControlFactory.getIns().getControl(NewGameControl) as NewGameControl).gotoNewGame();
			}
		}
		
		protected function get container():BaseLayer{
			return LayerManager.getIns().gameTipLayer;
		}
		
		public function clear() : void{
			
		}
		
		public function destroy() : void{
			if(layer != null){
				layer = null;
			}
		}
	}
}