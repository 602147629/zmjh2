package com.test.game.Modules.MainGame.PlayerKilling
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Effect.DigitalEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.FbPlayersManager;
	import com.test.game.Manager.MyUserManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.Layer.AnimationLayerManager;
	import com.test.game.Manager.Pipei.PlayerKillingManager;
	import com.test.game.Mvc.BmdView.OtherEntityView;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class PlayerKillingWaitView extends BaseView
	{
		private var _maxTime:int = 0;
		private var _startPipei:Boolean = false;
		private var _joinRoomStart:Boolean = false;
		private var _coolDownStart:Boolean = false;
		private var _coolDown:int = 0;
		public function PlayerKillingWaitView()
		{
			super();
			start();
		}
		
		private function start() : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("PlayerKillingWaitView") as Sprite;
				this.addChild(layer);
				
				initParams();
				initUI();
				setParams();
				setCenter();
			}
		}
		
		private var _myRolePowerDigital:Sprite;
		private var _otherRolePowerDigital:Sprite;
		private function initUI():void{
			cancelAutoPipeiBtn.addEventListener(MouseEvent.CLICK, onCancelAutoPipei);
			initBg();
		}
		
		public function onCancelAutoPipei(event:MouseEvent = null):void{
			PlayerKillingManager.getIns().cancelAutoPipei(cancelAutoPipei);
		}
		
		private function onLeaveRoom() : void{
			_joinRoomStart = false;
			PlayerKillingManager.getIns().leaveRoom();
		}
		
		public function leaveRoomSuccess() : void{
			_maxTime = 31;
			update();
			coolDownUpdate();
			_startPipei = false;
			this.hide();
		}
		
		public function cancelAutoPipei() : void{
			leaveRoomSuccess()
			ViewFactory.getIns().getView(PlayerKillingFightView).show();
		}
		
		private function initParams():void{
			
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			GreyEffect.reset(cancelAutoPipeiBtn);
			cancelAutoPipeiBtn.mouseEnabled = true;
			_startPipei = true;
			_maxTime = 30;
			coolDownTF.text = "对手匹配中...\n（" + _maxTime + "）";
			GreyEffect.change(vs);
			
			myRole["RoleName"].text = PlayerManager.getIns().player.name;
			myRole["PKLevel"].text = "武斗" + PlayerManager.getIns().player.pkInfo.pkLv + "级";
			myRole["PKDetail"].text = "战绩：" + PlayerManager.getIns().player.pkInfo.pkWin + "胜" + PlayerManager.getIns().player.pkInfo.pkLose + "负";
			
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
			otherRole["PKLevel"].text = "";
			otherRole["PKDetail"].text = "";
			if(_otherRolePowerDigital != null){
				if(_otherRolePowerDigital.parent != null){
					_otherRolePowerDigital.parent.removeChild(_otherRolePowerDigital);
				}
			}
		}
		
		override public function update() : void{
			if(_startPipei){
				_maxTime--;
				coolDownTF.text = "对手匹配中...\n（" + _maxTime + "）";
				if(_maxTime < 5){
					PlayerKillingManager.getIns().autoPKStart();
					if(_maxTime == 0){
						onCancelAutoPipei();
					}
				}
			}
		}
		
		public function joinRoomUpdate() : void{
			if(_joinRoomStart){
				_maxTime--;
				coolDownTF.text = "等待玩家加入\n（" + _maxTime + "）";
				if(_maxTime == 0){
					onLeaveRoom();
				}
			}
		}
		
		public function coolDownUpdate() : void{
			if(_coolDownStart){
				_maxTime--;
				coolDownTF.text = "匹配成功\n（" + _maxTime + "）";
				if(_maxTime == 0){
					startPlayerKilling();
				}
			}
		}
		
		//加入房间成功，等待其他玩家加入房间
		public function joinRoomStart() : void{
			_startPipei = false;
			_joinRoomStart = true;
			_coolDownStart = false;
			_maxTime = 10;
			coolDownTF.text = "等待玩家加入...\n（" + _maxTime + "）";
			GreyEffect.change(cancelAutoPipeiBtn);
			GreyEffect.reset(vs);
			cancelAutoPipeiBtn.mouseEnabled = false;
		}
		
		//匹配成功开始倒计时
		public function coolDownStart() : void{
			_startPipei = false;
			_joinRoomStart = false;
			_coolDownStart = true;
			_maxTime = 5;
			coolDownTF.text = "匹配成功\n（" + _maxTime + "）";
			GreyEffect.change(cancelAutoPipeiBtn);
			GreyEffect.reset(vs);
			cancelAutoPipeiBtn.mouseEnabled = false;
			var datas:Array = FbPlayersManager.getIns().playerDatas;
			if(datas != null){
				for(var i:int = 0; i < datas.length; i++){
					if(datas[i].gameKey != MyUserManager.getIns().socketPlayer.gameKey){
						otherRole["RoleName"].text = datas[i].data.name;
						otherRole["PKLevel"].text = "武斗" + datas[i].data.pkInfo.pkLv + "级";
						otherRole["PKDetail"].text = "战绩：" + datas[i].data.pkInfo.pkWin + "胜" + datas[i].data.pkInfo.pkLose + "负";
						_otherRolePowerDigital = DigitalEffect.createDigital("AtkHp", datas[i].data.fightNum);
						_otherRolePowerDigital.x = 55;
						_otherRolePowerDigital.y = 193;
						_otherRolePowerDigital.scaleX = .5;
						_otherRolePowerDigital.scaleY = .5;
						otherRole.addChild(_otherRolePowerDigital);
						(BmdViewFactory.getIns().initView(OtherEntityView) as OtherEntityView).setEntity(datas[i].data.occupation, datas[i].data.assetsArray);
						AnimationLayerManager.getIns().setOtherPosition(145, -10, -1);
						otherRole.addChild(AnimationLayerManager.getIns().otherEntityLayer);
					}
				}
			}else{
				otherRole["RoleName"].text = PlayerManager.getIns().player.name;
				otherRole["PKLevel"].text = "武斗" + PlayerManager.getIns().player.pkInfo.pkLv + "级";
				otherRole["PKDetail"].text = "战绩：" + PlayerManager.getIns().player.pkInfo.pkWin + "胜" + PlayerManager.getIns().player.pkInfo.pkLose + "负";
				_otherRolePowerDigital = DigitalEffect.createDigital("AtkHp", PlayerManager.getIns().battlePower);
				_otherRolePowerDigital.x = 55;
				_otherRolePowerDigital.y = 193;
				_otherRolePowerDigital.scaleX = .5;
				_otherRolePowerDigital.scaleY = .5;
				otherRole.addChild(_otherRolePowerDigital);
				(BmdViewFactory.getIns().initView(OtherEntityView) as OtherEntityView).setEntity(PlayerManager.getIns().player.occupation, PlayerManager.getIns().getEquipped());
				AnimationLayerManager.getIns().setOtherPosition(145, -10, -1);
				otherRole.addChild(AnimationLayerManager.getIns().otherEntityLayer);
			}
		}
		
		//倒计时结束开始战斗
		public function startPlayerKilling() : void{
			_maxTime = 31;
			update();
			coolDownUpdate();
			_coolDownStart = false;
			this.hide();
			PlayerKillingManager.getIns().startPlayerKilling();
			AnimationLayerManager.getIns().removeFromParentByOther();
			if(BmdViewFactory.getIns().getView(OtherEntityView) != null){
				BmdViewFactory.getIns().destroyView(OtherEntityView);
			}
		}
		
		public function clearPlayerKilling() : void{
			_startPipei = false;
			_coolDownStart = false;
			this.hide();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function get cancelAutoPipeiBtn() : SimpleButton{
			return layer["CancelAutoPipeiBtn"];
		}
		private function get coolDownTF() : TextField{
			return layer["CoolDownTF"];
		}
		private function get myRole() : Sprite{
			return layer["MyRole"];
		}
		private function get otherRole() : Sprite{
			return layer["OtherRole"];
		}
		private function get vs() : Sprite{
			return layer["VS"];
		}
	}
}