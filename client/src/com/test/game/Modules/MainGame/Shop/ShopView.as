package com.test.game.Modules.MainGame.Shop
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.Vo.ShopVo;
	import com.test.game.UI.ChangePage;
	import com.test.game.UI.TabBar;
	import com.test.game.UI.Grid.AutoGrid;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ShopView extends BaseView
	{
		public function ShopView()
		{
			super();
		}

		
		public static const TABS:Array = ["allTab", "fashionTab","itemTab","materialTab"];
		public static const ALL_TAB:String = "allTab";		
		public static const FASHION_TAB:String = "fashionTab";	
		public static const ITEM_TAB:String = "itemTab";
		public static const MATERIAL_TAB:String = "materialTab";
		private var _tabBar:TabBar;	
		
		// 当前标签
		private var _curTab:String;
		
		private var _uiLibrary:Array;
		
		private var _allGrid:AutoGrid;
		private var _fashionGrid:AutoGrid;
		private var _itemGrid:AutoGrid;
		private var _materialGrid:AutoGrid;
		
		private var _allChangePage:ChangePage;
		private var _fashionChangePage:ChangePage;
		private var _itemChangePage:ChangePage;
		private var _materialChangePage:ChangePage;
		
		
		private var _shopAllData:Vector.<ShopVo>;
		private var _shopFashionData:Vector.<ShopVo>;
		private var _shopItemData:Vector.<ShopVo>;
		private var _shopMaterialData:Vector.<ShopVo>;
		
		

		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.SHOPVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = AssetsManager.getIns().getAssetObject("ShopView") as Sprite;
				layer.x = -25;
				layer.y = -10;
				this.addChild(layer);
				
				_uiLibrary = [];
				
				if(GameConst.localData){
					/*var arr:Array = [
						{propId:1659,price:50,propType:1}
						,{propId:1660,price:50,propType:1}
						,{propId:1672,price:50,propType:1}
						,{propId:1673,price:50,propType:1}
						,{propId:1525,price:50,propType:1}
						,{propId:1526,price:50,propType:1}
						,{propId:1527,price:50,propType:1}
						,{propId:1528,price:50,propType:1}
						,{propId:1660,price:50,propType:1}
						,{propId:1659,price:50,propType:1}
						,{propId:1672,price:50,propType:1}
						,{propId:1673,price:50,propType:1}
						,{propId:1732,price:50,propType:3}
					]
					renderShopListData(arr);*/
					renderShopListLocateData();
				}else{
					ShopManager.getIns().getShopList(renderShopListData);
				}
				initTabBar();
				initEvents();
				
			}
		}
		
		private function renderShopListLocateData() : void{
			_shopAllData = new Vector.<ShopVo>;
			_shopFashionData = new Vector.<ShopVo>;
			_shopItemData = new Vector.<ShopVo>;
			_shopMaterialData = new Vector.<ShopVo>;
			var arr:Array = ConfigurationManager.getIns().getAllData(AssetsConst.SHOP);
			for(var i:int = arr.length - 1; i >= 0; i--){
				var shopVo:ShopVo = new ShopVo();
				shopVo.propId = arr[i].propId;
				shopVo.price = 100;
				shopVo.propType = 0;
				shopVo.type = arr[i].type;
				_shopAllData.push(shopVo);
			}
			for(var j:int =_shopAllData.length-1;j>=0;j--){
				var item:ShopVo = _shopAllData[j];
				if(item.type=="2"){
					_shopFashionData.push(item);
				}else if(item.type=="1"){
					_shopItemData.push(item);
				}else if(item.type=="3"){
					_shopMaterialData.push(item);
				}
				
			}
			renderUI();
		}
		
		private function renderShopListData(arr:Array):void{
			initShopItemData(arr);
			renderUI();
			_tabBar.selectIndex = 0;
		}
		
		private function initShopItemData(arr:Array):void{
			_shopAllData = new Vector.<ShopVo>;
			_shopFashionData = new Vector.<ShopVo>;
			_shopItemData = new Vector.<ShopVo>;
			_shopMaterialData = new Vector.<ShopVo>;
			
			for(var i:int =arr.length-1;i>=0;i--){
				var obj:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SHOP, "propId", arr[i].propId);
				if(obj != null){
					var shopVo:ShopVo = new ShopVo();
					shopVo.propId = arr[i].propId;
					//shopVo.propAction = arr[i].propAction;
					shopVo.price = arr[i].price;
					shopVo.propType = arr[i].propType;
					shopVo.type = obj.type;
					_shopAllData.push(shopVo);
				}
			}

			
			for(var j:int = 0 ; j<_shopAllData.length;j++){
				var item:ShopVo = _shopAllData[j];
				if(item.type=="2"){
					_shopFashionData.push(item);
				}else if(item.type=="1"){
					_shopItemData.push(item);
				}else if(item.type=="3"){
					_shopMaterialData.push(item);
				}
			}
			
		}
		
		public function renderUI(balance:int=1):void
		{
			couponTxt.text = player.vip.curCoupon.toString();
			renderAll();
			renderFashion();
			renderItem();
			renderMaterial();
			
		}	
		
		private function renderAll():void{
			if(!_allChangePage){
				_allChangePage = new ChangePage();
				_allChangePage.x = 458;
				_allChangePage.y = 495;
				_allChangePage["layerName"] = ALL_TAB;
				layer.addChild(_allChangePage);	
				_uiLibrary.push(_allChangePage);
			}
			
			if (!_allGrid)
			{
				_allGrid = new AutoGrid(ShopItem,3, 3, 207, 108, 30, 10);
				_allGrid.x = 160;
				_allGrid.y = 145;
				_allGrid["layerName"] = ALL_TAB;
				layer.addChild(_allGrid);
				_uiLibrary.push(_allGrid);
			}
			
			_allGrid.setData(_shopAllData,_allChangePage);
		}
		
		private function renderFashion():void{
			if(!_fashionChangePage){
				_fashionChangePage = new ChangePage();
				_fashionChangePage.x = 458;
				_fashionChangePage.y = 495;
				_fashionChangePage["layerName"] = FASHION_TAB;
				layer.addChild(_fashionChangePage);	
				_uiLibrary.push(_fashionChangePage);
			}
			
			if (!_fashionGrid)
			{
				_fashionGrid = new AutoGrid(ShopItem,3, 3, 207, 108, 30, 10);
				_fashionGrid.x = 160;
				_fashionGrid.y = 145;
				_fashionGrid["layerName"] = FASHION_TAB;
				layer.addChild(_fashionGrid);
				_uiLibrary.push(_fashionGrid);
			}
			
			_fashionGrid.setData(_shopFashionData,_fashionChangePage);
		}
		
		private function renderItem():void{
			if(!_itemChangePage){
				_itemChangePage = new ChangePage();
				_itemChangePage.x = 458;
				_itemChangePage.y = 495;
				_itemChangePage["layerName"] = ITEM_TAB;
				layer.addChild(_itemChangePage);	
				_uiLibrary.push(_itemChangePage);
			}
			
			if (!_itemGrid)
			{
				_itemGrid = new AutoGrid(ShopItem,3, 3, 207, 108, 30, 10);
				_itemGrid.x = 160;
				_itemGrid.y = 145;
				_itemGrid["layerName"] = ITEM_TAB;
				layer.addChild(_itemGrid);
				_uiLibrary.push(_itemGrid);
			}
			
			_itemGrid.setData(_shopItemData,_itemChangePage);
		}
		
		private function renderMaterial():void{
			if(!_materialChangePage){
				_materialChangePage = new ChangePage();
				_materialChangePage.x = 458;
				_materialChangePage.y = 495;
				_materialChangePage["layerName"] = MATERIAL_TAB;
				layer.addChild(_materialChangePage);	
				_uiLibrary.push(_materialChangePage);
			}
			
			if (!_materialGrid)
			{
				_materialGrid = new AutoGrid(ShopItem,3, 3, 207, 108, 30, 10);
				_materialGrid.x = 160;
				_materialGrid.y = 145;
				_materialGrid["layerName"] = MATERIAL_TAB;
				layer.addChild(_materialGrid);
				_uiLibrary.push(_materialGrid);
			}
			
			_materialGrid.setData(_shopMaterialData,_materialChangePage);
		}
		
		
		private function initEvents():void
		{
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			payMoneyBtn.addEventListener(MouseEvent.CLICK, onPayMoney);
			EventManager.getIns().addEventListener(EventConst.BUY_SHOP_ITEM_SCUUESS,renderUI);
		}
		
		protected function onPayMoney(event:MouseEvent):void
		{

			ShopManager.getIns().payMoney();
		}		
		

		
		override public function show():void{
			if(layer == null) return;
			renderUI();
			_tabBar.selectIndex = 0;
			super.show();
		}
		
		private function onClose(e:MouseEvent) : void{
			this.hide();
		}
		
		
		private function initTabBar():void{
			var arr:Array = [allTab,fashionTab,itemTab,materialTab];
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
				}
				else
				{
					item.visible = false;
				}
			}
			
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		override public function destroy() : void{
			super.destroy();
			
		}
		
		public function get closeBtn() : SimpleButton{
			return layer["closeBtn"];
		}
		public function get payMoneyBtn() : SimpleButton{
			return layer["payMoneyBtn"];
		}
		
		private function get allTab():MovieClip
		{
			return layer["allTab"];
		}
		private function get fashionTab():MovieClip
		{
			return layer["fashionTab"];
		}
		private function get itemTab():MovieClip
		{
			return layer["itemTab"];
		}
		private function get materialTab():MovieClip
		{
			return layer["materialTab"];
		}


		private function get couponTxt():TextField
		{
			return layer["couponTxt"];
		}
		
		
		
	}
}