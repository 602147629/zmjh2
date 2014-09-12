package com.test.game.Modules.MainGame.Escort
{
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Effect.ExpBar;
	import com.test.game.Manager.EscortManager;
	import com.test.game.Mvc.control.Escort.EscortControl;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class LootResultView extends BaseView
	{
		private var _expBar:ExpBar = new ExpBar();
		public function LootResultView()
		{
			super();
			start();
		}
		
		private function start():void
		{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("LootResultView") as Sprite;
				layer.x = GameConst.stage.stageWidth * .5;
				layer.y = GameConst.stage.stageHeight * .5;
				this.addChild(layer);
				
				initParams();
				initUI();
				initBg();
			}
		}
		
		private function initParams():void{
			
		}
		
		private function initUI():void{
			quitLoot.addEventListener(MouseEvent.CLICK, onQuitLoot);
		}
		
		protected function onQuitLoot(event:MouseEvent):void{
			(ControlFactory.getIns().getControl(EscortControl) as EscortControl).leaveLoot();
			this.hide();
		}
		
		public function showResult() : void{
			updateInfo();
			show();
		}
		
		private function updateInfo():void{
			EscortManager.getIns().lootAccount();
			
			biaoCheHpRate.text = int(EscortManager.getIns().escortHpRate * 100) + "%";
			switch(EscortManager.getIns().gainData.otherPlayerData.EscortType){
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
			
			_expBar = new ExpBar();
			_expBar.createExpBar((layer["ExpShow"] as Sprite), EscortManager.getIns().finalExp);
			_expBar.start();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
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
		private function get quitLoot() : SimpleButton{
			return layer["QuitLoot"];
		}
	}
}