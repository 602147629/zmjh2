package com.test.game.Modules.MainGame.Gift
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.ViewTweenEffect;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.ExtraBarManager;
	import com.test.game.Manager.GiftManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class GiftView extends BaseView
	{
		
		private var _giftComponents:Vector.<GiftComponent>;
		public function GiftView()
		{
			super();
		}
		
		
		override public function init() : void{
			super.init();
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.GIFTVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function renderView(...args):void{
			LoadManager.getIns().hideProgress();
			layer = AssetsManager.getIns().getAssetObject("GiftView") as Sprite;
			this.addChild(layer);
			this.isClose = true;
			layer.visible = false;
			
			renderGiftComponents();
			initEvent();
			initBg();
			setCenter();
			openTween();
			//LandIntegralManager.getIns().sendData("login");
		}
		


		
		private function renderGiftComponents():void{
			_giftComponents = new Vector.<GiftComponent>;
			var index:int = 0;
			for(var j:int = 0;j<2;j++){
				for(var i:int = 0;i<3;i++){
					var giftComponent:GiftComponent = new GiftComponent();
					if(index<NumberConst.getIns().giftIdArray.length){
						giftComponent.setId(NumberConst.getIns().giftIdArray[index]);
						giftComponent.setData(
							GiftManager.getIns().checkGift(
								NumberConst.getIns().giftIdArray[index]));
					}else{
						giftComponent.setId(NumberConst.getIns().zero);
						giftComponent.setData(NumberConst.getIns().negativeOne);
					}
					giftComponent.x= 35+i*134;
					giftComponent.y= 65+j*92;
					layer.addChild(giftComponent);
					_giftComponents.push(giftComponent);
					index++;
				}
			}
			trace(player.gift.length);
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		override public function show() : void{
			if(layer == null) return;
			openTween();
			update();
			super.show();
			
			//LandIntegralManager.getIns().sendData("30min");
		}
		
		override public function update() : void{
			renderGiftComponents();
		}
		
		private function initEvent():void{
			EventManager.getIns().addEventListener(EventConst.SCORE_GIFT_CLICK,onShowScoreGift);
			EventManager.getIns().addEventListener(EventConst.TEN_YEARS_CLICK, onTenYearsGift);
			EventManager.getIns().addEventListener(EventConst.GIFTVIEW_UPDATE,onGiftViewUpdate);
			closeBtn.addEventListener(MouseEvent.CLICK,close);
		}
		
		protected function onTenYearsGift(event:Event):void{
			ViewFactory.getIns().initView(TenYearsView).show();
		}
		
		protected function onGiftViewUpdate(e:CommonEvent):void
		{
			update();
		}
		
		protected function onShowScoreGift(e:CommonEvent):void
		{
			ViewFactory.getIns().initView(ScoreGiftView).show();
			(ViewFactory.getIns().getView(ScoreGiftView) as ScoreGiftView).setData(
				e.data[0]);
		}		
		
		private function openTween():void{
			var pos:Point = ExtraBarManager.getIns().getBtnPos("Activity");
			ViewTweenEffect.openTween(layer, pos.x, pos.y, centerX, centerY);
		}
		
		private function closeTween():void{
			var pos:Point = ExtraBarManager.getIns().getBtnPos("Activity");
			ViewTweenEffect.closeTween(layer, pos.x, pos.y, hide);
		}
		
		private function close(e:MouseEvent):void{
			closeTween();
		}
		
		private function moveView(e:MouseEvent):void{
			this.startDrag();
		}
		
		private function putView(e:MouseEvent):void{
			this.stopDrag();
		}
		
		public function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		

		override public function destroy():void{
			closeBtn.removeEventListener(MouseEvent.CLICK,close);
			for(var i:int=0;i<_giftComponents.length;i++){
				_giftComponents[i].destroy();
			}
			_giftComponents = null;
			super.destroy();
		}
	}
}