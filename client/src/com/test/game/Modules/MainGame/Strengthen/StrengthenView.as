package com.test.game.Modules.MainGame.Strengthen
{
	import com.greensock.TweenMax;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.EquipedManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Modules.MainGame.Guide.EquipForgeView;
	import com.test.game.Modules.MainGame.Guide.EquipStrengthenView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.TabBar;
	import com.test.game.UI.Grid.EquipedGrid;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class StrengthenView extends BaseView
	{
		public static const TABS:Array = ["strengthen", "forge","charge"];
		public static const STRENGTHEN_TAB:String = "strengthen";		
		public static const FORGE_TAB:String = "forge";	
		public static const CHARGE_TAB:String = "charge";
		private var _tabBar:TabBar;	
		
		// 当前标签
		private var _curTab:String;
		
		private var _uiLibrary:Array;
		private var _strengthenTabView:StrengthenTabView;
		private var _forgeTabView:ForgeTabView;
		private var _chargeTabView:ChargeTabView;

		
		private var _equips:Vector.<ItemVo>;
		private var _equippedEquipGrid:EquipedGrid;
		
		private var selectIndex:int;

		public function StrengthenView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.STRENGTHENVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function renderView(...args):void{
			if(layer == null){
				LoadManager.getIns().hideProgress();

				
				layer = AssetsManager.getIns().getAssetObject("strengthenView") as Sprite;
				_uiLibrary = [];
				this.addChild(layer);
				layer.visible = false;
				
				update();
				initTabBar();
				initEvent();
				selectFirstEquip();
				
				initBg();
				setCenter();
				openTween();
			}
		}
		
		private function initData():void
		{
			_equips = EquipedManager.getIns().EquipedVos;
		}		

		
		override public function show():void{
			if(layer == null) return;
			openTween();
			update();
			selectFirstEquip();
			_tabBar.selectIndex = 0;
			super.show();
		}
		
		private function renderUi():void{
			renderEquips();
			renderStrengthen();
			renderForge();
			renderCharge();
		}
		
		
		private function renderEquips():void{
			
			if (!_equippedEquipGrid)
			{
				_equippedEquipGrid = new EquipedGrid(StrengthenItemIcon,6, 1, 45, 45, 0, 14);
				_equippedEquipGrid.x = 55;
				_equippedEquipGrid.y = 110;
				layer.addChild(_equippedEquipGrid);
			}
			
			_equippedEquipGrid.setData(EquipedManager.getIns().EquipedVos);
			_equippedEquipGrid.showItemArrSelected(selectIndex);
			_equippedEquipGrid.checkEnableMc(_curTab);
			
		}
		
		
		override public function update():void{
			initData();
			renderUi();
			GuideManager.getIns().strengthenGuideSetting();
		}


		
		private function renderStrengthen():void{
			if(!_strengthenTabView){
				_strengthenTabView = new StrengthenTabView();
				_strengthenTabView["layerName"] = STRENGTHEN_TAB;
				_strengthenTabView.x = 203;
				_strengthenTabView.y = 107;
				layer.addChild(_strengthenTabView);
				_uiLibrary.push(_strengthenTabView);
			}
			
		}
		
		private function renderForge():void{
			if(!_forgeTabView){
				_forgeTabView = new ForgeTabView();
				_forgeTabView["layerName"] = FORGE_TAB;
				_forgeTabView.x = 209;
				_forgeTabView.y = 107;
				layer.addChild(_forgeTabView);
				_uiLibrary.push(_forgeTabView);
			}
		}
		
		
		private function renderCharge():void{
			if(!_chargeTabView){
				_chargeTabView = new ChargeTabView();
				_chargeTabView["layerName"] = CHARGE_TAB;
				_chargeTabView.x = 205;
				_chargeTabView.y = 95;
				layer.addChild(_chargeTabView);
				_uiLibrary.push(_chargeTabView);
			}
		}
		
		
		private function initEvent():void{
			EventManager.getIns().addEventListener(EventConst.STRENGTHEN_SELECT_CHANGE,onEquipSelect);
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			moveBar.addEventListener(MouseEvent.MOUSE_DOWN,moveView);
			moveBar.addEventListener(MouseEvent.MOUSE_UP,putView);
			(layer["helpBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onShowHelp);
		}
		
		private function onShowHelp(e:MouseEvent) : void{
			if(_curTab == TABS[0]){
				ViewFactory.getIns().initView(EquipStrengthenView).show();
			}else if(_curTab == TABS[1]){
				ViewFactory.getIns().initView(EquipForgeView).show();
			}

		}
		
		
		private function onEquipSelect(e:CommonEvent):void{
			if(GuideManager.getIns().guideIndex == 74){
				GuideManager.getIns().strengthenGuideSetting();
			}
			_strengthenTabView.setItemData(e.data[0] as ItemVo);
			_forgeTabView.setItemData(e.data[0] as ItemVo );
			_chargeTabView.setItemData(e.data[0] as ItemVo );
			_equippedEquipGrid.clearItemArrSelected();
			e.data[1].showSelected();
			selectIndex = e.data[1].index;
		}
		
		private function selectFirstEquip():void{
			_equippedEquipGrid.clearItemArrSelected();
			if(EquipedManager.getIns().checkEquipVos() == false){
				_strengthenTabView.setItemData(null);
				_forgeTabView.setItemData(null);
				_chargeTabView.setItemData(null);
				selectIndex = -1;
			}else{
				for (var i:int = 0;i<6;i++){
					if(_equips[i] != null){
						_strengthenTabView.setItemData(_equips[i]);
						_forgeTabView.setItemData(_equips[i]);
						_chargeTabView.setItemData(_equips[i]);
						_equippedEquipGrid.showItemArrSelected(i);
						selectIndex = i;
						break;
					}
				}
			}
		}
		
		
		private function initTabBar():void{
			var arr:Array = [strengthenTab,forgeTab,chargeTab];
			_tabBar = new TabBar(arr);
			_tabBar.addEventListener(EventConst.TYPE_SELECT_CHANGE, onTabChange);
			_tabBar.selectIndex = 0;
		}

		private function onTabChange(e:CommonEvent) : void
		{
			_curTab = TABS[e.data as int];
			if(_curTab == TABS[1]){
				GuideManager.getIns().strengthenGuideSetting();
			}
			if(_curTab == TABS[2]){
				(layer["helpBtn"] as SimpleButton).visible = false;
			}else{
				(layer["helpBtn"] as SimpleButton).visible = true;
			}
			for each(var item:* in _uiLibrary)
			{
				if (item["layerName"] == _curTab)
				{
					item.visible = true;
				}
				else
				{
					item.visible = false;
				}
			}
			_equippedEquipGrid.checkEnableMc(_curTab);
			guideVisible();
		}
		
		private function guideVisible():void{
			var index:int = PlayerManager.getIns().player.mainMissionVo.id;
			if(index > 1007){
				forgeTab.visible = true;
			}else{
				forgeTab.visible = false;
			}
		}
		
		private function get moveBar():Sprite
		{
			return layer["moveBar"];
		}
		
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		private function get forgeTab():MovieClip
		{
			return layer["forgeTab"];
		}
		
		private function get strengthenTab():MovieClip
		{
			return layer["strengthenTab"];
		}
		
		private function get chargeTab():MovieClip
		{
			return layer["chargeTab"];
		}
		
		
		private function moveView(e:MouseEvent):void{
			layer.startDrag();
		}
		
		private function putView(e:MouseEvent):void{
			layer.stopDrag();
		}
		
		
		private function openTween():void{
			layer.scaleX = layer.scaleY = 0;
			layer.visible = true;
			TweenMax.fromTo(layer,0.4,{scaleX:0,scaleY:0,x:pos.x,y:pos.y},{scaleX:1,scaleY:1,x:this.centerX,y:this.centerY});			
		}
		
		private function closeTween():void{
			TweenMax.to(layer,0.4,{scaleX:0,scaleY:0,x:pos.x,y:pos.y,onComplete:hide});			
		}
		
		private function get pos():Point{
			var p:Point = new Point();
			p.x = ViewFactory.getIns().getView(MainToolBar).layer["strengthen"].x  + 25 - this.x;
			p.y = ViewFactory.getIns().getView(MainToolBar).layer["strengthen"].y  + 25 - this.y;
			return p;
		}
		
		
		private function close(e:MouseEvent):void{
			closeTween();
			GuideManager.getIns().strengthenGuideSetting(true);
		}
		
		public function get position() : Point{
			return new Point(layer.x, layer.y);
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		override public function destroy():void{
			if(_strengthenTabView != null){
				_strengthenTabView.destroy();
				_strengthenTabView = null;
			}
			if(_forgeTabView != null){
				_forgeTabView.destroy();
				_forgeTabView = null;
			}
			if(_equippedEquipGrid != null){
				_equippedEquipGrid.destroy();
				_equippedEquipGrid = null;
			}
			if(_equips != null){
				_equips.length = 0;
				_equips = null;
			}
			if(_equippedEquipGrid != null){
				_equippedEquipGrid.destroy();
				_equippedEquipGrid = null;
			}
			layer = null;
			super.destroy();
		}
		
	}
}