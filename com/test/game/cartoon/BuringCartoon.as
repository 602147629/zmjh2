package com.test.game.cartoon
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.test.game.Effect.BaseEffect;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.SceneManager;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class BuringCartoon extends BaseEffect
	{
		private var layer:Sprite;
		private var _type:String;
		private var _bne:BaseNativeEntity;
		private var _bg:BaseNativeEntity;
		public function BuringCartoon(type:String){
			_type = type;
			LoadManager.getIns().hideProgress();
			layer = new Sprite();
			container.addChild(layer);
			initUI();
			super();
		}
		
		private var _stepTime:int = 0;
		private var _stepJudge:Boolean = false;
		override public function step() : void{
			if(_stepJudge){
				_stepTime++;
				if(_stepTime == 12){
					_stepJudge = false;
					continueShow();
				}
			}
		}
		
		private function initUI():void{
			/*_bg = new BaseNativeEntity();
			_bg.data.bitmapData = AUtils.getNewObj("UIBg") as BitmapData;
			this.layer.addChild(_bg);*/
			
			_bne = new BaseNativeEntity();
			_bne.data.bitmapData = AUtils.getNewObj(_type + "Buring") as BitmapData;
			_bne.x = 940 + _bne.width;
			_bne.y = 590 - _bne.height;
			_bne.scaleX = -1;
			this.layer.addChild(_bne);
			
			start();
		}
		
		private function start():void{
			MapManager.getIns().addUIBg();
			TweenLite.to(_bne, .3, {x:940, ease:Expo.easeOut, onComplete:function () : void{_stepJudge = true;}});
		}
		
		private function continueShow() : void{
				TweenLite.to(_bne, .3, {x:940 + _bne.width, ease:Expo.easeIn, onComplete:
					function () : void{
						SceneManager.getIns().resetRenderSlow();
						MapManager.getIns().removeUIBg();
						destroy();
					}});
		}
		
		protected function get container():BaseLayer{
			return LayerManager.getIns().gameTipLayer;
		}
		
		override public function destroy() : void{
			TweenLite.killTweensOf(_bne, true);
			if(_bne){
				_bne.destroy();
				_bne = null;
			}
			if(_bg){
				_bg.destroy();
				_bg = null;
			}
			if(layer){
				if(layer.parent != null){
					layer.parent.removeChild(layer);
				}
				layer = null;
			}
			super.destroy();
		}
	}
}