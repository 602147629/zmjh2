package com.test.game.Modules.MainGame.Escort
{
	import com.greensock.TweenLite;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class EscortBar extends BaseView
	{
		private static const HP_PERCENT:int = 50000;
		private static const HP_SOURCE:Array = ["RedHp", "YellowHp", "BlueHp"];
		private var lv:int;
		private var mainBar:Sprite;
		
		private var _mainHpTotal:int;
		private var _mainHpList:Array;
		private var _mainHpLen:int;
		private var _nowType:int;
		public function EscortBar()
		{
			super();
			start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = new Sprite();
				layer.x = 0;
				layer.y = 0;
				this.addChild(layer);
				
				initUI();
				initParams();
				setParams();
			}
		}
		
		private function initUI():void{
			mainBar = AssetsManager.getIns().getAssetObject("BossBattleBar") as Sprite;
			mainBar.x = 390;
			mainBar.y = 500;
			var bne1:BaseNativeEntity = new BaseNativeEntity();
			mainBar["BossHead"].addChild(bne1);
		}
		
		private function initParams():void
		{
			// TODO Auto Generated method stub
			
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
		}
		
		public function escortSetting(name:String, inputlv:int, fodder:String, hp:int, type:int) : void{
			lv = inputlv;
			_nowType = type;
			if(layer == null) return;
			mainBar.scaleX = 1;
			mainBar.scaleY = 1;
			mainBar.x = 390;
			mainBar.y = 500;
			(mainBar["BossName"] as TextField).text = name;
			(mainBar["BossLv"] as TextField).text = lv.toString();
			(mainBar["Hp_1"] as MovieClip).gotoAndStop(1);
			(mainBar["Hp_2"] as MovieClip).gotoAndStop(1);
			((mainBar["BossHead"] as Sprite).getChildAt(0) as BaseNativeEntity).data.bitmapData
				= AUtils.getNewObj(fodder + "_LittleHead") as BitmapData;
			
			_mainHpTotal = hp;
			createMainHp();
			setMainHpNumber();
			if(mainBar.parent == null){
				layer.addChild(mainBar);
			}
			show();
		}
		
		private function createMainHp():void{
			if(_mainHpList != null) return;
			_mainHpList = new Array();
			var calculateHp:int = _mainHpTotal;
			var index:int = 0;
			var interval:int = Math.ceil(_mainHpTotal / (_nowType * 5));
			
			while(calculateHp > 0){
				_mainHpList.push(createHpMask(HP_SOURCE[index], mainBar));
				index++;
				calculateHp -= interval;
				if(index >= 3){
					index = 0;
				}
			}
			_mainHpLen = _mainHpList.length;
		}
		
		private function createHpMask(str:String, sp:Sprite) : BaseNativeEntity{
			var hpMask:Sprite = new Sprite();
			hpMask.graphics.beginFill(0xFF0000);
			hpMask.graphics.drawRect(-435, 0, 435, 30);
			hpMask.graphics.endFill();
			hpMask.x = 450;
			hpMask.y = 42;
			sp.addChild(hpMask);
			var hpBar:BaseNativeEntity = new BaseNativeEntity();
			hpBar.data.bitmapData = AUtils.getNewObj(str) as BitmapData;
			hpBar.data.mask = hpMask;
			sp["BossHpBar"].addChild(hpBar);
			
			return hpBar;
		}
		
		public function reduceMainHp(rate:Number) : void{
			if(_mainHpList == null || _mainHpList.length == 0) return;
			if(rate < 0){
				rate = 0;
			}else if(rate > 1){
				rate = 1;
			}
			var nowRate:Number = Number(((rate - (1 / _mainHpLen * (_mainHpList.length - 1)))/(1 / _mainHpLen)).toFixed(2));
			nowRate = nowRate <= 0?0:nowRate;
			TweenLite.to((_mainHpList[_mainHpList.length - 1] as BaseNativeEntity).data.mask, .5, {width: nowRate * 435});
			if(nowRate <= 0){
				(_mainHpList[_mainHpList.length - 1] as BaseNativeEntity).destroy();
				_mainHpList[_mainHpList.length - 1] = null;
				_mainHpList.splice(_mainHpList.length - 1, 1);
				if(_mainHpList.length >= 1){
					var nextRate:Number = (rate - (1 / _mainHpLen * (_mainHpList.length - 1)))/(1 / _mainHpLen);
					TweenLite.to((_mainHpList[_mainHpList.length - 1] as BaseNativeEntity).data.mask, .5, {width: nextRate * 435});
				}
				setMainHpNumber();
			}
			if(nowRate > 1){
				_mainHpList.push(createHpMask(HP_SOURCE[_mainHpList.length % 3], mainBar));
				nowRate = (rate - (1 / _mainHpLen * (_mainHpList.length - 1)))/(1 / _mainHpLen);
				(_mainHpList[_mainHpList.length - 1] as BaseNativeEntity).data.mask.width = 0;
				TweenLite.to((_mainHpList[_mainHpList.length - 1] as BaseNativeEntity).data.mask, .5, {width: nowRate * 435});
				setMainHpNumber();
			}
		}
		
		private function setMainHpNumber() : void{
			if(_mainHpList.length < 10){
				(mainBar["Hp_1"] as MovieClip).gotoAndStop(_mainHpList.length + 1);
				(mainBar["Hp_2"] as MovieClip).visible = false;
			}else{
				(mainBar["Hp_1"] as MovieClip).gotoAndStop(int(_mainHpList.length / 10) + 1);
				(mainBar["Hp_2"] as MovieClip).visible = true;
				(mainBar["Hp_2"] as MovieClip).gotoAndStop((_mainHpList.length % 10) + 1);
			}
		}
		
		public function setLastNumber() : void{
			(mainBar["Hp_1"] as MovieClip).gotoAndStop(1);
			(mainBar["Hp_2"] as MovieClip).visible = false;
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		private function destroyMainHp() : void{
			if(_mainHpList != null){
				while(_mainHpList.length > 0){
					(_mainHpList[_mainHpList.length - 1] as BaseNativeEntity).data.mask = null;
					(_mainHpList[_mainHpList.length - 1] as BaseNativeEntity).destroy();
					_mainHpList[_mainHpList.length - 1] = null;
					_mainHpList.splice(_mainHpList.length - 1, 1);
				}
				_mainHpList.length = 0;
				_mainHpList = null;
			}
		}
		
		override public function destroy() : void{
			destroyMainHp();
			super.destroy();
		}
	}
}