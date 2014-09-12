package com.test.game.Modules.MainGame.Map
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GlowAnimationEffect;
	import com.test.game.Entitys.Map.FireEntity;
	import com.test.game.Entitys.Map.SheepEntity;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.FunnyBossManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Modules.MainGame.BagView;
	import com.test.game.Modules.MainGame.Activity.FunnyBossView;
	import com.test.game.Modules.MainGame.DungeonMenu.DungeonMenu;
	import com.test.game.Modules.MainGame.Market.MarketView;
	import com.test.game.Modules.MainGame.Role.RoleDetailView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Mvc.control.key.GotoFunnyBattleControl;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class MainMapView extends BaseView
	{
		private var _glow_1:GlowAnimationEffect;
		private var _glow_2:GlowAnimationEffect;
		private var _glow_3:GlowAnimationEffect;
		private var _glow_4:GlowAnimationEffect;
		private var _glowMarket:GlowAnimationEffect;
		private var _glowFunny:GlowAnimationEffect;
		
		private var _sheep1:SheepEntity;
		private var _sheep2:SheepEntity;
		private var _sheep3:SheepEntity;
		private var _fire1:FireEntity;
		private var _fire2:FireEntity;
		private var _fire3:FireEntity;
		private var _fire4:FireEntity;
		private var _fire5:FireEntity;
		private var _fire6:FireEntity;
		private var _cloud:MovieClip;
		public function MainMapView(){
			super();
		}
		
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[
				AssetsUrl.getAssetObject(AssetsConst.MAINMAPVIEW),
				AssetsUrl.getAssetObject(AssetsConst.MAINMAPSOUND)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("MainMapView") as Sprite;
				this.addChild(layer);
				LoadManager.getIns().hideProgress();
				initUI();
				initParams();
				setParams();
			}
		}
		
		private function initParams():void{
			
		}
		
		private function initUI():void{
			LevelBtn_1.addEventListener(MouseEvent.CLICK, selectLevel);
			LevelBtn_2.addEventListener(MouseEvent.CLICK, selectLevel);
			LevelBtn_3.addEventListener(MouseEvent.CLICK, selectLevel);
			LevelBtn_4.addEventListener(MouseEvent.CLICK, selectLevel);
			marketBtn.addEventListener(MouseEvent.CLICK, showMarketView);
			funnyBossBtn.addEventListener(MouseEvent.CLICK, onStartFunnyBoss);
			//(layer["EliteBtn"] as SimpleButton).visible = false;
			
			_glowFunny = new GlowAnimationEffect();
			_glowFunny.init(funnyBossBtn);
			_glowMarket = new GlowAnimationEffect();
			_glowMarket.init(marketBtn);
			_glow_1 = new GlowAnimationEffect();
			_glow_1.init(LevelBtn_1);
			_glow_2 = new GlowAnimationEffect();
			_glow_2.init(LevelBtn_2);
			_glow_3 = new GlowAnimationEffect();
			_glow_3.init(LevelBtn_3);
			_glow_4 = new GlowAnimationEffect();
			_glow_4.init(LevelBtn_4);
			
			_sheep1 = new SheepEntity(layer, 340, 343);
			_sheep2 = new SheepEntity(layer, 290, 420);
			_sheep3 = new SheepEntity(layer, 325, 435, -1);
			
			_fire1 = new FireEntity(layer, 416, 421);
			_fire2 = new FireEntity(layer, 499, 404);
			_fire3 = new FireEntity(layer, 481, 477);
			_fire4 = new FireEntity(layer, 537, 433);
			_fire5 = new FireEntity(layer, 524, 478);
			_fire6 = new FireEntity(layer, 450, 381);
			
			for(var i:int = 1; i <= 3; i++){
				layer["Cloud" + i].mouseEnabled = false;
				layer["Cloud" + i].mouseChildren = false;
			}
			
			update();
		}
		
		protected function onStartFunnyBoss(e:MouseEvent) : void{
			//FunnyBossManager.getIns().startFunnyBoss();
			ViewFactory.getIns().initView(FunnyBossView).show();
			if(ViewFactory.getIns().getView(BagView) != null){
				ViewFactory.getIns().getView(BagView).hide();
			}
			if(ViewFactory.getIns().getView(RoleDetailView) != null){
				ViewFactory.getIns().getView(RoleDetailView).hide();
			}
		}
		
		protected function showMarketView(event:MouseEvent):void{
			(ViewFactory.getIns().initView(MarketView) as MarketView).show();
			
			if(ViewFactory.getIns().getView(BagView) != null){
				ViewFactory.getIns().getView(BagView).hide();
			}
			if(ViewFactory.getIns().getView(RoleDetailView) != null){
				ViewFactory.getIns().getView(RoleDetailView).hide();
			}
		}
		
		private function selectLevel(e:MouseEvent) : void{
			var level:int = e.target.name.split("_")[1];
			var arr:Array = PlayerManager.getIns().getDungeonInfo(level);
			(ViewFactory.getIns().initView(DungeonMenu) as DungeonMenu).nowIndex = getIndex(arr);
			(ViewFactory.getIns().initView(DungeonMenu) as DungeonMenu).nowLevel = level;
			(ViewFactory.getIns().initView(DungeonMenu) as DungeonMenu).show();
			
			if(ViewFactory.getIns().getView(BagView) != null){
				ViewFactory.getIns().getView(BagView).hide();
			}
			if(ViewFactory.getIns().getView(RoleDetailView) != null){
				ViewFactory.getIns().getView(RoleDetailView).hide();
			}
			GuideManager.getIns().mainMapGuideSetting();
		}
		
		private function getIndex(arr:Array) : int{
			var result:int = 0;
			for(var i:int = arr.length - 1; i >= 0; i--){
				if(arr[i] > 0){
					result = i / 3;
					break;
				}
			}
			return result;
		}
		
		override public function setParams():void{
			if(layer == null) return;
			super.setParams();
			SoundManager.getIns().bgSoundPlay(AssetsConst.MAINMAPSOUND);
			update();
		}
		
		override public function update():void{
			_glow_1.start();
			_glowMarket.start();
			_glowFunny.start();
			//太虚观
			levelTaiXuGuan();
			levelWanEGu();
			levelFengBoDu();
			DeformTipManager.getIns().setDeformTip();
			
			updateSheep();
			updateFire();
			updateCloud();
			updateFunnyBoss();
			//funnyBossBtn.visible = false;
		}
		
		private function updateFunnyBoss() : void{
			var zhongQiu:int = TimeManager.getIns().disDayNum(NumberConst.getIns().moonCakeGiftDate, TimeManager.getIns().returnTimeNowStr().split(" ")[0]);
			if(zhongQiu <= 0 && zhongQiu >= -NumberConst.getIns().moonCakeDay){
				funnyBossBtn.visible = true;
			}else{
				funnyBossBtn.visible = false;
			}
		}
		
		private function updateCloud():void{
			for(var i:int = 1; i <= 3; i++){
				if(layer["Cloud" + i].parent == null){
					layer.addChild(layer["Cloud" + i]);
				}else{
					layer["Cloud" + i].parent.setChildIndex(layer["Cloud" + i], layer["Cloud" + i].parent.numChildren - 1);
				}
			}
		}
		
		private function updateFire():void{
			_fire1.update();
			_fire2.update();
			_fire3.update();
			_fire4.update();
			_fire5.update();
			_fire6.update();
		}
		
		private function updateSheep():void{
			_sheep1.update();
			_sheep2.update();
			_sheep3.update();
		}
		
		private function levelFengBoDu() : void{
			if(PlayerManager.getIns().hasPassDungeonInfo("3_9")){
				LevelBtn_4.visible = true;
				_glow_4.start();
			}else{
				LevelBtn_4.visible = false;
				_glow_4.stop();
			}
		}
		
		private function levelWanEGu():void{
			if(PlayerManager.getIns().hasPassDungeonInfo("2_9")){
				LevelBtn_3.visible = true;
				_glow_3.start();
			}else{
				LevelBtn_3.visible = false;
				_glow_3.stop();
			}
		}
		
		private function levelTaiXuGuan() : void{
			if(PlayerManager.getIns().hasPassDungeonInfo("1_9")){
				LevelBtn_2.visible = true;
				_glow_2.start();
			}else{
				LevelBtn_2.visible = false;
				_glow_2.stop();
			}
		}
		
		override public function hide():void{
			super.hide();
			_glow_1.stop();
			_glow_2.stop();
			_glow_3.stop();
			_glow_4.stop();
			_glowMarket.stop();
			_glowFunny.stop();
			_sheep1.stop();
			_sheep2.stop();
			_sheep3.stop();
			DeformTipManager.getIns().allClose();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().bgLayer;
		}
		
		private function get LevelBtn_1():SimpleButton{
			return layer["LevelBtn_1"] as SimpleButton;
		}
		private function get LevelBtn_2():SimpleButton{
			return layer["LevelBtn_2"] as SimpleButton;
		}
		private function get LevelBtn_3():SimpleButton{
			return layer["LevelBtn_3"] as SimpleButton;
		}
		private function get LevelBtn_4():SimpleButton{
			return layer["LevelBtn_4"] as SimpleButton;
		}
		
		private function get marketBtn():SimpleButton{
			return layer["marketBtn"] as SimpleButton;
		}
		
		private function get funnyBossBtn() : SimpleButton{
			return layer["FunnyBossBtn"];
		}
		
		private function get cloud1() : MovieClip{
			return layer["Cloud1"];
		}
		private function get cloud2() : MovieClip{
			return layer["Cloud2"];
		}
		private function get cloud3() : MovieClip{
			return layer["Cloud3"];
		}
		
		override public function destroy() : void{
			LevelBtn_1.removeEventListener(MouseEvent.CLICK, selectLevel);
			LevelBtn_2.removeEventListener(MouseEvent.CLICK, selectLevel);
			super.destroy();
		}
	}
}