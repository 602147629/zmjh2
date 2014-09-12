package com.test.game.Modules.MainGame
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SoundManager;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class LevelUpView extends BaseView
	{
		public var callback:Function;
		public function LevelUpView(){
			super();
		}
		
		override public function init() : void{
			super.init();
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.LEVELUPVIEW),
				AssetsUrl.getAssetObject(AssetsConst.LEVELUPSOUND)
			];
			AssetsManager.getIns().addQueen([], arr, start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = new Sprite();
				this.addChild(layer);
				
				initUI();
				initParams();
				setParams();
				setCenter();
			}
		}
		
		private var _playMC:MovieClip;
		private function initParams():void{
			var obj:Object = AssetsManager.getIns().getAssetObject("LevelUpView");
			_playMC = obj as MovieClip;
			_playMC.stop();
			_playMC.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function onEnterFrameHandler(e:Event) : void{
			if(_playMC["LevelUpTF"] != null && _playMC["LevelUpTF"]["LevelTF"] != null){
				(_playMC["LevelUpTF"]["LevelTF"] as TextField).text = PlayerManager.getIns().player.character.lv.toString();
			}
			if(e.target.currentFrame == e.target.totalFrames){
				e.target.stop();
				e.target.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
				ViewFactory.getIns().destroyView(LevelUpView);
				if(callback != null){
					callback();
				}
			}
		}
		
		override public function step():void{
			
		}
		
		private function initUI():void{
			initBg();
			//this.addEventListener(MouseEvent.CLICK, onSkip);
		}
		
		/*private var _tweenDelayCount:int;
		private function onSkip(e:MouseEvent) : void{
			if(_tweenDelayCount == 1){
				TweenLite.killTweensOf((layer["LevelUpShow"] as Sprite), true);
			}else if(_tweenDelayCount == 2){
				TweenLite.killTweensOf(layer, false);
				TweenLite.killDelayedCallsTo(clearAll);
				ViewFactory.getIns().destroyView(LevelUpView);
				if(callback != null){
					callback();
				}
			}
		}*/
		
		override public function setParams():void{
			if(layer == null) return;
			
			SoundManager.getIns().fightSoundPlayer("LevelUpSound");
			if(_playMC != null){
				_playMC.gotoAndPlay(1);
				if(_playMC.parent == null){
					_playMC.x = 60;
					layer.addChild(_playMC);
				}
			}
			
			/*_tweenDelayCount = 1;
			layer.alpha = 1;
			(layer["LevelUpTF"] as Sprite).visible = false;
			(layer["LevelUpTF"]["LevelTF"] as TextField).text = PlayerManager.getIns().player.character.lv.toString();
			(layer["LevelUpShow"] as Sprite).scaleX = .3;
			(layer["LevelUpShow"] as Sprite).scaleY = .3;
			TweenLite.to((layer["LevelUpShow"] as Sprite), .2, {scaleX:5, scaleY:5, onComplete:showLimit});*/
		}
		
		/*private function showLimit() : void{
			TweenLite.to((layer["LevelUpShow"] as Sprite), .3, {scaleX:1.5, scaleY:1.5, onComplete:showText, ease:Elastic.easeOut});
		}
		
		private function showText() : void{
			(layer["LevelUpTF"] as Sprite).visible = true;
			_tweenDelayCount = 2;
			TweenLite.delayedCall(2, clearAll);
		}
		
		private function clearAll() : void{
			TweenLite.to(layer, 1, {alpha:0,
				onComplete:function () : void{
					ViewFactory.getIns().destroyView(LevelUpView);
					if(callback != null){
						callback();
					}
				}
			});
		}*/
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy() : void{
			_playMC = null;
			super.destroy();
		}
	}
}