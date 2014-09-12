package com.test.game.Modules.MainGame.Activity
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class DevoteView extends BaseView
	{
		private var _anti:Antiwear;
		private function get nowCount() : int{
			return _anti["nowCount"];
		}
		private function set nowCount(value:int) : void{
			_anti["nowCount"] = value;
		}
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public function DevoteView()
		{
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["nowCount"] = 0;
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function init() : void{
			super.init();
			start();
		}
		
		private function start() : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("DevoteView") as Sprite;
				this.addChild(layer);
				
				initUI();
				setParams();
				initBg();
				setCenter();
			}
		}
		
		private function initUI() : void{
			upBtn.addEventListener(MouseEvent.CLICK, onUpClick);
			downBtn.addEventListener(MouseEvent.CLICK, onDownClick);
			devoteBtn.addEventListener(MouseEvent.CLICK, onDevote);
			numTxt.addEventListener(Event.CHANGE,numChange);
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
		}
		
		protected function onClose(e:MouseEvent) : void{
			this.hide();
			ViewFactory.getIns().getView(MidAutumnView).update();
		}
		
		protected function numChange(e:Event) : void{
			nowCount = int(numTxt.text);
			if(nowCount > PackManager.getIns().searchItemNum(NumberConst.getIns().moonCakeId)){
				nowCount = PackManager.getIns().searchItemNum(NumberConst.getIns().moonCakeId);
			}
			if(nowCount < NumberConst.getIns().one){
				nowCount = NumberConst.getIns().one;
			}
			update();
		}
		
		protected function onDevote(e:MouseEvent) : void{
			player.midAutumnInfo.moonCakeCount += nowCount;
			PackManager.getIns().reduceItem(NumberConst.getIns().moonCakeId, nowCount);
			ViewFactory.getIns().getView(MidAutumnView).update();
			nowCount = NumberConst.getIns().one;
			update();
		}
		
		protected function onDownClick(e:MouseEvent) : void{
			nowCount--;
			update();
		}
		
		protected function onUpClick(e:MouseEvent) : void{
			nowCount++;
			update();
		}
		
		override public function setParams():void{
			if(layer == null) return;
			nowCount = NumberConst.getIns().one;
			update();
		}
		
		override public function update():void{
			numTxt.text = nowCount.toString();
			if(nowCount == NumberConst.getIns().one){
				downBtn.mouseEnabled = false;
				GreyEffect.change(downBtn);
			}else{
				downBtn.mouseEnabled = true;
				GreyEffect.reset(downBtn);
			}
			if(nowCount >= PackManager.getIns().searchItemNum(NumberConst.getIns().moonCakeId)){
				upBtn.mouseEnabled = false;
				GreyEffect.change(upBtn);
			}else{
				upBtn.mouseEnabled = true;
				GreyEffect.reset(upBtn);
			}
			if(PackManager.getIns().searchItemNum(NumberConst.getIns().moonCakeId) < NumberConst.getIns().one){
				devoteBtn.mouseEnabled = false;
				GreyEffect.change(devoteBtn);
			}else{
				devoteBtn.mouseEnabled = true;
				GreyEffect.reset(devoteBtn);
			}
		}
		
		private function get upBtn() : SimpleButton{
			return layer["upBtn"];
		}
		private function get downBtn() : SimpleButton{
			return layer["downBtn"];
		}
		private function get devoteBtn() : SimpleButton{
			return layer["devoteBtn"];
		}
		private function get numTxt() : TextField{
			return layer["numTxt"];
		}
		private function get closeBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
	}
}