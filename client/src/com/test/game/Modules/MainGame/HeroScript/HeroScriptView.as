package com.test.game.Modules.MainGame.HeroScript
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.TabBar;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class HeroScriptView extends BaseView
	{

		public static const TABS:Array = ["heroFight", "heroUpgrade","heroSpecialFight"];
		public static const HERO_FIGHT_TAB:String = "heroFight";		
		public static const HERO_UPGRADE_TAB:String = "heroUpgrade";	
		public static const HERO_SPECIAL_FIGHT_TAB:String = "heroSpecialFight";	
		private var _tabBar:TabBar;	
		
		// 当前标签
		private var _curTab:String;
		
		private var _uiLibrary:Array;
		
		private var _specialFightEnable:Boolean;
		
		
		private var _heroFightTabView:HeroFightTabView;
		private var _heroUpgradeTabView:HeroUpgradeTabView;
		private var _heroSpecialFightTabView:HeroSpecialFightTabView;
		

		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}

		
		public function HeroScriptView()
		{
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.HEROSCRIPTVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView,LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		

		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function renderView(...args):void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = AssetsManager.getIns().getAssetObject("HeroScriptView") as Sprite;
				layer.x = -30;
				layer.y = -10;
				this.addChild(layer);
				
				_uiLibrary = [];
				initBg();
				setCenter();
				
				update();
				initTabBar();
				initEvent();
			}

		}
		

		
		override public function show():void{
			if(layer == null) return;
			update();
			_tabBar.selectIndex = 0;
			super.show();
		}
		
		private function renderUi():void{
			renderHeroFight();
			renderHeroUpgrade();
			renderHeroSpecialFight();
		}
		
		
		override public function update():void{
			//ShopManager.getIns().vipLv = 5;
			renderUi();
			if(ShopManager.getIns().vipLv < NumberConst.getIns().five){
				GreyEffect.change(heroSpecialFightTab);
				TipsManager.getIns().addTips(heroSpecialFightTab,{title:"VIP5开启外传功能", tips:""});
				_specialFightEnable = false;
			}else{
				GreyEffect.reset(heroSpecialFightTab);
				TipsManager.getIns().removeTips(heroSpecialFightTab);
				_specialFightEnable = true;
			}
			
		}
		

		
		private function renderHeroFight():void{
			if(!_heroFightTabView){
				_heroFightTabView = new HeroFightTabView();
				_heroFightTabView["layerName"] = HERO_FIGHT_TAB;
				this.addChild(_heroFightTabView);
				_uiLibrary.push(_heroFightTabView);
			}
			_heroFightTabView.update();
		}
		
		
		private function renderHeroUpgrade():void{
			if(!_heroUpgradeTabView){
				_heroUpgradeTabView = new HeroUpgradeTabView();
				_heroUpgradeTabView["layerName"] = HERO_UPGRADE_TAB;
				this.addChild(_heroUpgradeTabView);
				_uiLibrary.push(_heroUpgradeTabView);
			}
			_heroUpgradeTabView.update();
		}
		
		
		private function renderHeroSpecialFight():void{
			if(!_heroSpecialFightTabView){
				_heroSpecialFightTabView = new HeroSpecialFightTabView();
				_heroSpecialFightTabView["layerName"] = HERO_SPECIAL_FIGHT_TAB;
				this.addChild(_heroSpecialFightTabView);
				_uiLibrary.push(_heroSpecialFightTabView);
			}
			_heroSpecialFightTabView.update();
		}

		
		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
		}

		
		private function initTabBar():void{
			var arr:Array = [heroFightTab,heroUpgradeTab,heroSpecialFightTab];
			_tabBar = new TabBar(arr);
			_tabBar.addEventListener(EventConst.TYPE_SELECT_CHANGE, onTabChange);
			_tabBar.selectIndex = 0;
		}
		
		private function onTabChange(e:CommonEvent) : void
		{
			_curTab = TABS[e.data as int];
			if(_curTab != HERO_SPECIAL_FIGHT_TAB || _specialFightEnable == true){
				for each(var item:* in _uiLibrary)
				{
					if (item["layerName"] == _curTab)
					{
						item.visible = true;
						item.update();
					}
					else
					{
						item.visible = false;
					}
				}
			}
		}
		
		
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		private function get heroFightTab():MovieClip
		{
			return layer["heroFightTab"];
		}
		
		private function get heroUpgradeTab():MovieClip
		{
			return layer["heroUpgradeTab"];
		}
		
		private function get heroSpecialFightTab():MovieClip
		{
			return layer["heroSpecialFightTab"];
		}
		
		
		private function close(e:MouseEvent):void{
			hide();
		}
		
		override public function hide():void{
			super.hide();
			if(_heroUpgradeTabView != null){
				_heroUpgradeTabView.hide();
			}
		}
		
		override public function destroy():void{
			closeBtn.removeEventListener(MouseEvent.CLICK,close);
			
			if(_heroFightTabView != null){
				_heroFightTabView.destroy();
				_heroFightTabView = null;
			}
			if(_heroUpgradeTabView != null){
				_heroUpgradeTabView.destroy();
				_heroUpgradeTabView = null;
			}

			if(_uiLibrary != null){
				_uiLibrary.length = 0;
				_uiLibrary = null
			}
			if(_tabBar != null){
				_tabBar.destroy();
				_tabBar = null;
			}

			super.destroy();
		}

	}
}