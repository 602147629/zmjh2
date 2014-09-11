package com.test.game.Modules.MainGame.Market
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.TabBar;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class MarketView extends BaseView
	{

		public static const TABS:Array = ["southMarket", "blackMarket"];
		public static const SOUTH_MARKET_TAB:String = "southMarket";		
		public static const BLACK_MARKET_TAB:String = "blackMarket";		
		private var _tabBar:TabBar;	
		
		// 当前标签
		private var _curTab:String;
		
		private var _uiLibrary:Array;
		
		
		private var _southMarketTabView:SouthMarketTabView;
		
		private var _blackMarketTabView:BlackMarketTabView;

		
		public function get southMarketTabView() : SouthMarketTabView{
			return _southMarketTabView;
		}
		public function get blackMarketTabView() : BlackMarketTabView{
			return _blackMarketTabView;
		}

		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}

		
		public function MarketView()
		{
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.MARKETVIEW)				
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
				layer = AssetsManager.getIns().getAssetObject("marketView") as Sprite;
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
			renderSouthMarket();
			renderBlackMarket();
		}
		
		
		override public function update():void{
			renderUi();
			if(player.mainMissionVo.id>1014){
				blackMarketTab.visible = true;
			}else{
				blackMarketTab.visible = false;
			}
		}
		

		
		public function renderSouthMarket():void{
			if(!_southMarketTabView){
				_southMarketTabView = new SouthMarketTabView();
				_southMarketTabView["layerName"] = SOUTH_MARKET_TAB;
				_southMarketTabView.x = 30;
				_southMarketTabView.y = 58;
				this.addChild(_southMarketTabView);
				_uiLibrary.push(_southMarketTabView);
			}
			_southMarketTabView.update();
		}
		
		
		
		private function renderBlackMarket():void{
			if(!_blackMarketTabView){
				_blackMarketTabView = new BlackMarketTabView();
				_blackMarketTabView["layerName"] = BLACK_MARKET_TAB;
				_blackMarketTabView.x = 52;
				_blackMarketTabView.y = 96;
				this.addChild(_blackMarketTabView);
				_uiLibrary.push(_blackMarketTabView);
			}
			_blackMarketTabView.update();
		}
		

		
		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
		}

		
		private function initTabBar():void{
			var arr:Array = [southMarketTab,blackMarketTab];
			_tabBar = new TabBar(arr);
			_tabBar.addEventListener(EventConst.TYPE_SELECT_CHANGE, onTabChange);
			_tabBar.selectIndex = 0;
		}
		
		private function onTabChange(e:CommonEvent) : void
		{
			_curTab = TABS[e.data as int];
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
		
		

		public function get moveBar():MovieClip
		{
			return layer["moveBar"];
		}
		
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		private function get southMarketTab():MovieClip
		{
			return layer["southMarketTab"];
		}
		
		private function get blackMarketTab():MovieClip
		{
			return layer["blackMarketTab"];
		}
		
		
		private function close(e:MouseEvent):void{
			hide();
			GuideManager.getIns().bossGuideSetting("", true);
		}
		
		
		override public function destroy():void{
			closeBtn.removeEventListener(MouseEvent.CLICK,close);
			
			if(_southMarketTabView != null){
				_southMarketTabView.destroy();
				_southMarketTabView = null;
			}
			if(_blackMarketTabView != null){
				_blackMarketTabView.destroy();
				_blackMarketTabView = null;
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