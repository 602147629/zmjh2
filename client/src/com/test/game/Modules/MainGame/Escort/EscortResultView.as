package com.test.game.Modules.MainGame.Escort
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Effect.ExpBar;
	import com.test.game.Manager.EscortManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.control.Escort.EscortControl;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class EscortResultView extends BaseView
	{
		private var _itemIcons:Vector.<ItemIcon> = new Vector.<ItemIcon>();
		private var _expBar:ExpBar = new ExpBar();
		private var _moneyTip:BaseNativeEntity;
		private var _soulTip:BaseNativeEntity;
		public function EscortResultView()
		{
			super();
			start();
		}
		
		private function start():void
		{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("EscortResultView") as Sprite;
				layer.x = GameConst.stage.stageWidth * .5;
				layer.y = GameConst.stage.stageHeight * .5;
				this.addChild(layer);
				
				initParams();
				initUI();
				initBg();
			}
		}
		
		private function initParams():void{
			for(var i:int = 0; i < 6; i++){
				var itemIcon:ItemIcon = new ItemIcon();
				itemIcon.x = i * 50 - 155;
				itemIcon.y = 18;
				itemIcon.selectable = false;
				itemIcon.menuable = false;
				layer.addChild(itemIcon);
				_itemIcons.push(itemIcon);
			}
			_moneyTip = new BaseNativeEntity();
			_moneyTip.data.bitmapData = AUtils.getNewObj("WeatherMoney") as BitmapData;
			_moneyTip.y = 28;
			_soulTip = new BaseNativeEntity();
			_soulTip.data.bitmapData = AUtils.getNewObj("WeatherSoul") as BitmapData;
			_soulTip.y = 28;
		}
		
		private function initUI():void{
			resultTitle.gotoAndStop(1);
			quitEscort.addEventListener(MouseEvent.CLICK, onQuitEscort);
		}
		
		protected function onQuitEscort(event:MouseEvent):void{
			(ControlFactory.getIns().getControl(EscortControl) as EscortControl).leaveEscort();
			this.hide();
		}
		
		public function showResult(type:int) : void{
			//resultTitle.gotoAndStop(type);
			updateInfo();
			show();
		}
		
		private function updateInfo():void{
			EscortManager.getIns().escortAccount();
			
			biaoCheHpRate.text = int(EscortManager.getIns().escortHpRate * 100) + "%";
			switch(EscortManager.getIns().nowBiaoChe){
				case 1:
					biaoCheType.text = "木牛";
					break;
				case 2:
					biaoCheType.text = "流马";
					break;
				case 3:
					biaoCheType.text = "金车";
					break;
			}
			expTF.text = EscortManager.getIns().finalExp.toString();
			moneyTF.text = EscortManager.getIns().finalMoney.toString();
			soulTF.text = EscortManager.getIns().finalSoul.toString();
			var items:Vector.<ItemVo> = EscortManager.getIns().extraMaterial;
			for(var i:int = 0; i < 6; i++){
				_itemIcons[i].setData(null);
			}
			for(var j:int = 0; j < items.length; j++){
				_itemIcons[j].setData(items[j]);
			}
			
			if(_moneyTip.parent != null){
				_moneyTip.parent.removeChild(_moneyTip);
			}
			TipsManager.getIns().removeTips(_moneyTip);
			
			if(_soulTip.parent != null){
				_soulTip.parent.removeChild(_soulTip);
			}
			TipsManager.getIns().removeTips(_soulTip);
			
			var len:int = items.length;
			if(EscortManager.getIns().extraMoney != 0){
				_moneyTip.x = len * 50 - 145;
				layer.addChild(_moneyTip);
				TipsManager.getIns().addTips(_moneyTip, {title:"金钱:" + EscortManager.getIns().extraMoney, tips:""});
				len++;
			}
			if(EscortManager.getIns().extraSoul != 0){
				_soulTip.x = len * 50 - 145;
				layer.addChild(_soulTip);
				TipsManager.getIns().addTips(_soulTip, {title:"战魂:" + EscortManager.getIns().extraSoul, tips:""});
			}
			
			_expBar = new ExpBar();
			_expBar.createExpBar((layer["ExpShow"] as Sprite), EscortManager.getIns().finalExp);
			_expBar.start();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		private function get resultTitle() : MovieClip{
			return layer["ResultTitle"];
		}
		private function get quitEscort() : SimpleButton{
			return layer["QuitEscort"];
		}
		private function get biaoCheHpRate() : TextField{
			return layer["BiaoCheHpRate"];
		}
		private function get biaoCheType() : TextField{
			return layer["BiaoCheType"];
		}
		private function get expTF() : TextField{
			return layer["ExpTF"];
		}
		private function get moneyTF() : TextField{
			return layer["MoneyTF"];
		}
		private function get soulTF() : TextField{
			return layer["SoulTF"];
		}
	}
}