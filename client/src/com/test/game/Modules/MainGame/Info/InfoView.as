package com.test.game.Modules.MainGame.Info
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class InfoView extends BaseView
	{
		private var _maskLayer:Sprite;
		public function InfoView(){
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.INFOVIEW)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				_maskLayer = new Sprite();
				_maskLayer.y = 180;
				this.addChild(_maskLayer);
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.INFOVIEW.split("/")[1]) as Sprite;
				_maskLayer.addChild(layer);
				
				//setCenter();
				initParams();
				initUI();
				setParams();
			}
		}
		
		private var _mask:Sprite;
		private function initUI():void{
			infoMC.stop();
			_mask = new Sprite();
			_mask.graphics.beginFill(0xFFFFFF, 1);
			_mask.graphics.drawRect(0, 0, layer.width, layer.height + 50);
			_mask.graphics.endFill();
			layer.mask = _mask;
			_mask.x = layer.x;
			_mask.y = layer.y;
			_maskLayer.addChild(_mask);
			
			initBg();
			this.addEventListener(MouseEvent.CLICK, onSkip);
		}
		
		private var _tweenDelayCount:int;
		private function onSkip(e:MouseEvent) : void{
			if(infoMC != null){
				if(_tweenDelayCount == 1){
					TweenLite.killTweensOf(_maskLayer, false);
					TweenLite.killTweensOf(_mask, true);
				}else if(_tweenDelayCount == 2){
					TweenLite.killDelayedCallsTo(callbackFun);
					callbackFun();
				}else if(_tweenDelayCount == 3){
					callbackFun();
				}
			}
		}
		
		private function initParams():void{
			
		}
		
		private var _stepTime:int;
		private var _callback:Function;
		public function setType(type:int, obj:Object, callback:Function = null) : void{
			this.show();
			infoMC.gotoAndStop(type);
			_stepTime = 45;
			_callback = callback;
			_mask.width = 0;
			_maskLayer.x = 0;
			if(type == 7){
				bg.visible = false
			}else{
				bg.visible = true;
			}
			_tweenDelayCount = 1;
			TweenLite.to(_maskLayer, .3, {x:250});
			TweenLite.to(_mask, .6, {width:layer.width, ease:Back.easeInOut,
				onComplete:function () : void{
					_tweenDelayCount = 2;
					if(type == 7){
						TweenLite.delayedCall(.2, callbackFun);
					}else{
						TweenLite.delayedCall(1.5, callbackFun);
					}
				}
			});
			if((type == 4 || type == 9) && obj != null){
				(infoMC["InfoTitle"] as TextField).text = obj.title;
				(infoMC["InfoDetail"] as TextField).text = obj.detail;
			}
		}
		
		private var _clickFunction:Function;
		public function setInfo(obj:Object, clickFunction:Function = null) : void{
			this.show();
			if(obj != null && layer != null){
				_tweenDelayCount = 3;
				_callback = clickFunction;
				infoMC.gotoAndStop(8);
				bg.visible = true;
				_maskLayer.x = 250;
				(infoMC["InfoTitle"] as TextField).text = obj.title;
				(infoMC["InfoDetail"] as TextField).text = obj.detail;
				this.parent.setChildIndex(this, this.parent.numChildren - 1);
			}
		}
		
		private function callbackFun() : void{
			this.hide();
			if(_callback != null){
				_callback();
			}
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameTipLayer;	
		}
		
		private function get infoMC() : MovieClip{
			return layer["Info"];
		}
	}
}