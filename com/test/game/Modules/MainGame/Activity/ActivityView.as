package com.test.game.Modules.MainGame.Activity
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Modules.MainGame.FirstCharge.FirstChargeView;
	import com.test.game.Modules.MainGame.Gift.GiftView;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	import com.test.game.Modules.MainGame.Summer.SummerGiftView;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ActivityView extends BaseView
	{
		private var _showBtn:Array = new Array();
		public function ActivityView(){
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.MAINUI)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("ActivityView") as Sprite;
				layer.y = 80;
				this.addChild(layer);
				
				initUI();
				setParams();
				update();
			}
		}
		
		private function initUI():void{
			initBg();
			GiftBtn.addEventListener(MouseEvent.CLICK, onShowGift);
			//SummerBtn.addEventListener(MouseEvent.CLICK, onShowSummer);
			FirstChargeBtn.addEventListener(MouseEvent.CLICK, onShowFirstCharge);
			
			this.bg.addEventListener(MouseEvent.CLICK, onClose);
		}
		
		override public function show():void{
			update();
			super.show();
		}
		
		protected function onClose(event:MouseEvent):void{
			this.hide();
		}
		
		private function onShowGift(e:MouseEvent) : void{
			ViewFactory.getIns().initView(GiftView).show();
			this.hide();
		}
		
		private function onShowSummer(e:MouseEvent) : void{
			ViewFactory.getIns().initView(SummerGiftView).show();
			this.hide();
		}
		
		private function onShowFirstCharge(e:MouseEvent) : void{
			ViewFactory.getIns().initView(FirstChargeView).show();
			this.hide();
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			update();
		}
		
		override public function update():void{
			_showBtn = [];
			_showBtn.push(Gift);
			//summerChargeJudge();
			firstChargeJudge();
			resetPosition();
			layer.x = (ViewFactory.getIns().getView(ExtraBar) as ExtraBar).layer["Activity"].x - 20 - (_showBtn.length - 1) * 40;
			ActivityBg.width = ((_showBtn.length - 1) * 80) + 90;
		}
		
		private function resetPosition() : void{
			for(var i:int = 0; i < _showBtn.length; i++){
				_showBtn[i].x = 10 + i * 110;
			}
		}
		
		private function summerChargeJudge() : void{
			if(TimeManager.getIns().disDayNum(NumberConst.getIns().summerEndDate, TimeManager.getIns().curTimeStr) <= 0){
				_showBtn.push(Summer);
				if(SummerBtn.parent == null){
					layer.addChild(Summer);
				}
			}else{
				if(Summer.parent != null){
					Summer.parent.removeChild(Summer);
				}
			}
		}
		
		private function firstChargeJudge() : void{
			if(PlayerManager.getIns().hasGetFirstCharge){
				_showBtn.push(FirstCharge);
				if(FirstCharge.parent == null){
					layer.addChild(FirstCharge);
				}
			}else{
				if(FirstCharge.parent != null){
					FirstCharge.parent.removeChild(FirstCharge);
				}
			}
		}
		
		public function get Gift() : Sprite{
			return layer["Gift"];
		}
		public function get Summer() : Sprite{
			return layer["Summer"];
		}
		public function get FirstCharge() : Sprite{
			return layer["FirstCharge"];
		}
		
		public function get GiftBtn() : SimpleButton{
			return layer["Gift"]["Gift"]["GiftBtn"];
		}
		public function get SummerBtn() : SimpleButton{
			return layer["Summer"]["Summer"]["SummerBtn"];;
		}
		public function get FirstChargeBtn() : SimpleButton{
			return layer["FirstCharge"]["chargeGiftBtn"];;
		}
		
		private function get ActivityBg() : Sprite{
			return layer["ActivityBg"];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy() : void{
			super.destroy();
		}
	}
}