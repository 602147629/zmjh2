package com.test.game.Modules.MainGame
{
	import com.greensock.TweenLite;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Mvc.Vo.EnemyVo;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class BossBattleBar extends BaseView
	{
		protected var HP_PERCENT:int = 3000;
		private static const HP_SOURCE:Array = ["RedHp", "YellowHp", "BlueHp"];
		
		private var lv:String;
		private var mainBar:Sprite;
		private var minorBar:Sprite;
		
		private var _mainHpTotal:int;
		private var _mainHpList:Array;
		private var _mainHpLen:int;
		
		private var _minorHpTotal:int;
		private var _minorHpList:Array;
		private var _minorHpLen:int;
		public function BossBattleBar(){
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.BOSSBATTLEBAR)], start, null);
			AssetsManager.getIns().start();
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
		
		private function initParams():void{
			
		}
		
		private function initUI():void{
			mainBar = AssetsManager.getIns().getAssetObject("BossBattleBar") as Sprite;
			mainBar.x = 390;
			mainBar.y = 500;
			var bne1:BaseNativeEntity = new BaseNativeEntity();
			mainBar["BossHead"].addChild(bne1);
			//layer.addChild(mainBar);
			
			minorBar = AssetsManager.getIns().getAssetObject("BossBattleBar") as Sprite;
			minorBar.x = 450;
			minorBar.y = 530;
			var bne2:BaseNativeEntity = new BaseNativeEntity();
			minorBar["BossHead"].addChild(bne2);
			//layer.addChild(minorBar);
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			if(LevelManager.getIns().nowIndex == "3_9"
				|| (LevelManager.getIns().nowIndex == "3_3" && LevelManager.getIns().mapType == 1)){
				twoBossSetting();
			}else{
				oneBossSetting();
			}
		}
		
		protected function oneBossSetting() : void{
			if(GameSceneManager.getIns().partnerOperate){
				mainBar.scaleX = .85;
				mainBar.scaleY = .85;
				mainBar.x = 480;
				mainBar.y = 510;
			}else{
				mainBar.scaleX = 1;
				mainBar.scaleY = 1;
				mainBar.x = 390;
				mainBar.y = 500;
			}
			bossSetting(LevelManager.getIns().mainBossEntity, mainBar, 1);
			
			if(mainBar.parent == null){
				layer.addChild(mainBar);
			}
		}
		
		protected function twoBossSetting():void{
			if(GameSceneManager.getIns().partnerOperate){
				mainBar.scaleX = .75;
				mainBar.scaleY = .75;
				mainBar.x = 470;
				mainBar.y = 515;
				minorBar.scaleX = .75;
				minorBar.scaleY = .75;
				minorBar.x = 530;
				minorBar.y = 455;
			}else{
				mainBar.scaleX = .9;
				mainBar.scaleY = .9;
				mainBar.x = 370;
				mainBar.y = 515;
				minorBar.scaleX = .9;
				minorBar.scaleY = .9;
				minorBar.x = 440;
				minorBar.y = 455;
			}
			bossSetting(LevelManager.getIns().mainBossEntity, mainBar, 1);
			bossSetting(LevelManager.getIns().minorBossEntity, minorBar, 2);
			if(mainBar.parent == null){
				layer.addChild(mainBar);
			}
			if(minorBar.parent == null){
				layer.addChildAt(minorBar, 0);
			}
		}
		
		private function bossSetting(monster:MonsterEntity, sp:Sprite, type:int) : void{
			if(monster == null) return;
			(sp["BossName"] as TextField).text = monster.charData.name;
			(sp["BossLv"] as TextField).text = monster.charData.lv.toString();
			(sp["Hp_1"] as MovieClip).gotoAndStop(1);
			(sp["Hp_2"] as MovieClip).gotoAndStop(1);
			((sp["BossHead"] as Sprite).getChildAt(0) as BaseNativeEntity).data.bitmapData
				= AUtils.getNewObj((monster.charData as EnemyVo).fodder.split("_")[0] + "_LittleHead") as BitmapData;
			
			if(type == 1){
				_mainHpTotal = LevelManager.getIns().mainBossEntity.charData.totalProperty.hp;
				createMainHp();
				setMainHpNumber();
			}else{
				_minorHpTotal = monster.charData.totalProperty.hp;
				createMinorHp();
				setMinorHpNumber();
			}
		}
		
		public function resetMainHp(inputHp:int) : void{
			destroyMainHp();
			_mainHpList = new Array();
			var calculateHp:int = _mainHpTotal;
			var index:int = 0;
			var interval:int;
			var hpCount:int = _mainHpTotal / (HP_PERCENT + int(LevelManager.getIns().mainBossEntity.charData.lv / 10) * 1000);
			if(hpCount > 15){
				interval = Math.ceil(_mainHpTotal / 15);
			}else{
				interval = (HP_PERCENT + int(LevelManager.getIns().mainBossEntity.charData.lv / 10) * 1000); 
			}
			
			while(calculateHp > 0){
				_mainHpList.push(createHpMask(HP_SOURCE[index], mainBar));
				index++;
				calculateHp -= interval;
				if(index >= 3){
					index = 0;
				}
			}
			_mainHpLen = _mainHpList.length;
			reduceMainHp(inputHp/_mainHpTotal);
			setMainHpNumber();
		}
		
		public function resetMinorHp(inputHp:int) : void{
			destroyMinorHp();
			_minorHpList = new Array();
			var calculateHp:int = _minorHpTotal;
			var index:int = 0;
			var interval:int;
			var hpCount:int = _minorHpTotal / (HP_PERCENT + int(LevelManager.getIns().minorBossEntity.charData.lv / 10) * 1000);
			if(hpCount > 15){
				interval = Math.ceil(_minorHpTotal / 15);
			}else{
				interval = (HP_PERCENT + int(LevelManager.getIns().minorBossEntity.charData.lv / 10) * 1000);
			}
			
			while(calculateHp > 0){
				_minorHpList.push(createHpMask(HP_SOURCE[index], minorBar));
				index++;
				calculateHp -= interval;
				if(index >= 3){
					index = 0;
				}
			}
			_minorHpLen = _minorHpList.length;
			reduceMinorHp(inputHp/_minorHpTotal);
			setMinorHpNumber();
		}
		
		private function createMainHp():void{
			if(_mainHpList != null) return;
			_mainHpList = new Array();
			var calculateHp:int = _mainHpTotal;
			var index:int = 0;
			var interval:int;
			var hpCount:int = _mainHpTotal / (HP_PERCENT + int(LevelManager.getIns().mainBossEntity.charData.lv / 10) * 1000);
			if(hpCount > 15){
				interval = Math.ceil(_mainHpTotal / 15);
			}else{
				interval = (HP_PERCENT + int(LevelManager.getIns().mainBossEntity.charData.lv / 10) * 1000); 
			}
			
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
		
		private function createMinorHp():void{
			if(_minorHpList != null) return;
			_minorHpList = new Array();
			var calculateHp:int = _minorHpTotal;
			var index:int = 0;
			var interval:int;
			var hpCount:int = _minorHpTotal / (HP_PERCENT + int(LevelManager.getIns().minorBossEntity.charData.lv / 10) * 1000);
			if(hpCount > 15){
				interval = Math.ceil(_minorHpTotal / 15);
			}else{
				interval = (HP_PERCENT + int(LevelManager.getIns().minorBossEntity.charData.lv / 10) * 1000);
			}
			
			while(calculateHp > 0){
				_minorHpList.push(createHpMask(HP_SOURCE[index], minorBar));
				index++;
				calculateHp -= interval;
				if(index >= 3){
					index = 0;
				}
			}
			_minorHpLen = _minorHpList.length;
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
		
		public function reduceHp() : void{
			
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
		
		public function reduceMinorHp(rate:Number) : void{
			if(_minorHpList == null || _minorHpList.length == 0) return;
			if(rate < 0){
				rate = 0;
			}else if(rate > 1){
				rate = 1;
			}
			var nowRate:Number = Number(((rate - (1 / _minorHpLen * (_minorHpList.length - 1)))/(1 / _minorHpLen)).toFixed(2));
			nowRate = nowRate <= 0?0:nowRate;
			TweenLite.to((_minorHpList[_minorHpList.length - 1] as BaseNativeEntity).data.mask, .5, {width: nowRate * 435});
			if(nowRate <= 0){
				(_minorHpList[_minorHpList.length - 1] as BaseNativeEntity).destroy();
				_minorHpList[_minorHpList.length - 1] = null;
				_minorHpList.splice(_minorHpList.length - 1, 1);
				if(_minorHpList.length >= 1){
					var nextRate:Number = (rate - (1 / _mainHpLen * (_minorHpList.length - 1)))/(1 / _minorHpLen);
					TweenLite.to((_minorHpList[_minorHpList.length - 1] as BaseNativeEntity).data.mask, .5, {width: nextRate * 435});
				}
				setMinorHpNumber();
			}
			if(nowRate > 1){
				_minorHpList.push(createHpMask(HP_SOURCE[_mainHpList.length % 3], minorBar));
				nowRate = (rate - (1 / _minorHpLen * (_mainHpList.length - 1)))/(1 / _minorHpLen);
				(_minorHpList[_minorHpList.length - 1] as BaseNativeEntity).data.mask.width = 0;
				TweenLite.to((_minorHpList[_minorHpList.length - 1] as BaseNativeEntity).data.mask, .5, {width: nowRate * 435});
				setMinorHpNumber();
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
		
		private function setMinorHpNumber() : void{
			if(_minorHpList.length < 10){
				(minorBar["Hp_1"] as MovieClip).gotoAndStop(_minorHpList.length + 1);
				(minorBar["Hp_2"] as MovieClip).visible = false;
			}else{
				(minorBar["Hp_1"] as MovieClip).gotoAndStop(int(_minorHpList.length / 10) + 1);
				(minorBar["Hp_2"] as MovieClip).visible = true;
				(minorBar["Hp_2"] as MovieClip).gotoAndStop((_minorHpList.length % 10) + 1);
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
		
		private function destroyMinorHp() : void{
			if(_minorHpList != null){
				while(_minorHpList.length > 0){
					(_minorHpList[_minorHpList.length - 1] as BaseNativeEntity).data.mask = null;
					(_minorHpList[_minorHpList.length - 1] as BaseNativeEntity).destroy();
					_minorHpList[_minorHpList.length - 1] = null;
					_minorHpList.splice(_minorHpList.length - 1, 1);
				}
				_minorHpList.length = 0;
				_minorHpList = null;
			}
		}
		
		override public function destroy() : void{
			destroyMainHp();
			destroyMinorHp();
			super.destroy();
		}
	}
}