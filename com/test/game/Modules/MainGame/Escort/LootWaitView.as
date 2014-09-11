package com.test.game.Modules.MainGame.Escort
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Effect.DigitalEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.EscortManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.Layer.AnimationLayerManager;
	import com.test.game.Mvc.BmdView.OtherEntityView;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class LootWaitView extends BaseView
	{
		private var _maxTime:int = 0;
		private var _startPipei:Boolean = false;
		private var _startLoot:Boolean = false;
		public function LootWaitView()
		{
			super();
			start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = AssetsManager.getIns().getAssetObject("LootWaitView") as Sprite;
				this.addChild(layer);
				
				initUI();
				initParams();
				setParams();
				setCenter();
				initBg();
			}
		}
		
		private var _myRolePowerDigital:Sprite;
		private var _otherRolePowerDigital:Sprite;
		private function initUI():void{
			cancelLootBtn.addEventListener(MouseEvent.CLICK, onCancelLoot);
		}
		
		private function onCancelLoot(e:MouseEvent = null) : void{
			EscortManager.getIns().cancelMatchEscort();
			hide();
			ViewFactory.getIns().getView(EscortView).show();
		}
		
		override public function hide() : void{
			super.hide();
			AnimationManager.getIns().removeEntity(this);
		}
		
		private function initParams():void{
			
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			AnimationManager.getIns().addEntity(this);
			
			updateStatus();
			updateMyRole();
		}
		
		private var _stepCount:int;
		override public function step():void{
			pipeiStep();
			lootStep();
		}
		
		private function lootStep():void{
			if(_startLoot){
				_stepCount++;
				if(_stepCount == 30){
					_stepCount = 0;
					_maxTime--;
					coolDownTF.text = "匹配成功\n（" + _maxTime + "）";
					if(_maxTime == 0){
						hide();
						EscortManager.getIns().lootReallyStart();
						completeLoot();
					}
				}
			}
		}
		
		private function completeLoot():void{
			AnimationLayerManager.getIns().removeFromParentByOther();
			if(BmdViewFactory.getIns().getView(OtherEntityView) != null){
				BmdViewFactory.getIns().destroyView(OtherEntityView);
			}
		}
		
		private function pipeiStep() : void{
			if(_startPipei){
				_stepCount++;
				if(_stepCount == 30){
					_stepCount = 0;
					_maxTime--;
					coolDownTF.text = "对手匹配中...\n（" + _maxTime + "）";
					if(_maxTime == 5){
						EscortManager.getIns().cancelMatchEscort();
						EscortManager.getIns().autoStartLoot();
					}
				}
			}
		}
		
		public function updatatLootStatus() : void{
			GreyEffect.change(cancelLootBtn);
			cancelLootBtn.mouseEnabled = false;
			_startPipei = false;
			_startLoot = true;
			_maxTime = 5;
			_stepCount = 0;
			coolDownTF.text = "匹配成功\n（" + _maxTime + "）";
			GreyEffect.reset(lootBg);
			updateOtherRole();
		}
		
		private function updateStatus() : void{
			GreyEffect.reset(cancelLootBtn);
			cancelLootBtn.mouseEnabled = true;
			_startPipei = true;
			_startLoot = false;
			_maxTime = 30;
			_stepCount = 0;
			coolDownTF.text = "对手匹配中...\n（" + _maxTime + "）";
			GreyEffect.change(lootBg);
		}
		
		private function updateMyRole() : void{
			myRole["RoleName"].text = PlayerManager.getIns().player.name;
			myRole["PlayerLevel"].text = "等级" + PlayerManager.getIns().player.character.lv + "级";
			if(_myRolePowerDigital != null){
				if(_myRolePowerDigital.parent != null){
					_myRolePowerDigital.parent.removeChild(_myRolePowerDigital);
				}
				_myRolePowerDigital = null;
			}
			_myRolePowerDigital = DigitalEffect.createDigital("AtkHp", PlayerManager.getIns().battlePower);
			_myRolePowerDigital.x = 55;
			_myRolePowerDigital.y = 193;
			_myRolePowerDigital.scaleX = .5;
			_myRolePowerDigital.scaleY = .5;
			myRole.addChild(_myRolePowerDigital);
			AnimationLayerManager.getIns().setRolePosition(-5, -20, myRole);
			AnimationLayerManager.getIns().removeFromParentByOther();
			otherRole["RoleName"].text = "";
			otherRole["PlayerLevel"].text = "";
			if(_otherRolePowerDigital != null){
				if(_otherRolePowerDigital.parent != null){
					_otherRolePowerDigital.parent.removeChild(_otherRolePowerDigital);
				}
			}
		}
		
		private function updateOtherRole() : void{
			var datas:Object = EscortManager.getIns().gainData;
			if(datas != null){
				otherRole["RoleName"].text = datas.otherPlayerData.name;
				otherRole["PlayerLevel"].text = "等级" + datas.otherPlayerData.lv + "级";
				_otherRolePowerDigital = DigitalEffect.createDigital("AtkHp", datas.otherPlayerData.fightNum);
				_otherRolePowerDigital.x = 55;
				_otherRolePowerDigital.y = 193;
				_otherRolePowerDigital.scaleX = .5;
				_otherRolePowerDigital.scaleY = .5;
				otherRole.addChild(_otherRolePowerDigital);
				
				(BmdViewFactory.getIns().initView(OtherEntityView) as OtherEntityView).setEntity(datas.otherPlayerData.occupation, datas.otherPlayerData.assetsArray);
				AnimationLayerManager.getIns().setOtherPosition(145, -10, -1);
				otherRole.addChild(AnimationLayerManager.getIns().otherEntityLayer);
			}
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function get coolDownTF() : TextField{
			return layer["CoolDownTF"];
		}
		private function get cancelLootBtn() : SimpleButton{
			return layer["CancelLootBtn"];
		}
		private function get myRole() : Sprite{
			return layer["MyRole"];
		}
		private function get otherRole() : Sprite{
			return layer["OtherRole"];
		}
		private function get lootBg() : Sprite{
			return layer["LootBg"];
		}
	}
}