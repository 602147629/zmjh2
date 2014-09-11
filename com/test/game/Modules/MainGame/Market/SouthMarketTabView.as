package com.test.game.Modules.MainGame.Market
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.OccupationConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ChangePage;
	import com.test.game.UI.Grid.AutoGrid;
	
	import flash.display.Sprite;

	public class SouthMarketTabView extends BaseSprite
	{
		public var layerName:String;
		private var _obj:Sprite;
		
		private var _itemGrid:AutoGrid;
		
		private var _changePage:ChangePage;
		
		
		public function SouthMarketTabView()
		{
			_obj = AssetsManager.getIns().getAssetObject("southMarketTabView") as Sprite;
			_obj.x = 310;
			_obj.y = 45;
			this.addChild(_obj);
			update();
			initEvent();
		}
		
		private function initEvent():void
		{
			EventManager.getIns().addEventListener(EventConst.SOUTH_MARKET_ITEM_CLICK,onItemBuy);
		}		
		
		protected function onItemBuy(e:CommonEvent):void
		{
			ViewFactory.getIns().initView(SouthMarketBuyItemView).show();
			(ViewFactory.getIns().getView(SouthMarketBuyItemView) as SouthMarketBuyItemView).setData(
				e.data);
		}
		
		public function update():void{
			renderItems();
		}
		
		
		private function renderItems():void{

			
			if(!_changePage){
				_changePage = new ChangePage();
				_changePage.x = 498;
				_changePage.y = 390;
				this.addChild(_changePage);	
			}
			
			if (!_itemGrid)
			{
				_itemGrid = new AutoGrid(SouthMarketItemIcon,4, 3, 140, 70, 10, 10);
				_itemGrid.x = 310;
				_itemGrid.y = 65;
				this.addChild(_itemGrid);
			}
			_itemGrid.setData(southMarketDatas,_changePage);
		}
		
		private function get southMarketDatas():Array{
			var arr:Array = [];
			var dataArr:Array = ConfigurationManager.getIns().getAllData(AssetsConst.SOUTH_MARKET);
			for(var i:int = 0 ; i<dataArr.length;i++){
				if(dataArr[i].id>200){
					arr.push(dataArr[i]);	
				}
				
				if(dataArr[i].id>100 && dataArr[i].id<200 && 
					player.occupation == OccupationConst.XIAOYAO){
					arr.push(dataArr[i]);	
				}
				if(dataArr[i].id<100 && 
					player.occupation == OccupationConst.KUANGWU){
					arr.push(dataArr[i]);	
				}
				
			}	
			return sortByItemId(arr);
		}
		
		
		//按照物品id排序
		private function sortByItemId(arr:Array):Array{
			
			var newArr:Array = new Array();
			newArr=arr.sort(compare);
			
			return newArr;
			
			function compare(x:Object,y:Object):Number{
				var result:Number;
				if(x.id > y.id){
					result = 1;
				}else if(x.id < y.id){
					result = -1;
				}else{
					result = 0;
				}
				
				return result;
			}
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		override public function destroy() : void{
			EventManager.getIns().removeEventListener(EventConst.SOUTH_MARKET_ITEM_CLICK,onItemBuy);
			removeComponent(_obj);
			if(_itemGrid != null){
				_itemGrid.destroy();
				_itemGrid = null;
			}
			if(_changePage != null){
				_changePage.destroy();
				_changePage = null;
			}
			super.destroy();
		}
	}
}