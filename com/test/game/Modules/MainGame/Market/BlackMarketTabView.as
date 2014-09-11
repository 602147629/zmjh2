package com.test.game.Modules.MainGame.Market
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ItemIcon;
	import com.test.game.UI.Grid.AutoGrid;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class BlackMarketTabView extends BaseSprite
	{
		private var _anti:Antiwear;
		public var layerName:String;
		private var _obj:Sprite;
		
		private var _recommendItenArr:Array;
		
		private var _itemGrid:AutoGrid;
		
		private function get curBlackItems() : Array{
			return _anti["curBlackItems"];
		}
		private function set curBlackItems(value:Array) : void{
			_anti["curBlackItems"] = value;
		}
		
		public function BlackMarketTabView()
		{
			_anti = new Antiwear(new binaryEncrypt());
			_anti["curBlackItems"] = new Array();
			_obj = AssetsManager.getIns().getAssetObject("blackMarketTabView") as Sprite;
			_obj.x = 280;
			_obj.y = 15;
			this.addChild(_obj);
			
			initEvent();
			
		}
		
		private function initEvent():void
		{
			freeRefreshBtn.addEventListener(MouseEvent.CLICK,onFreeRefresh);
			continueRefreshBtn.addEventListener(MouseEvent.CLICK,onRefresh);
			EventManager.getIns().addEventListener(EventConst.BLACK_MARKET_BUY,onItemBuy);
			EventManager.getIns().addEventListener(EventConst.BUY_SHOP_ITEM_SCUUESS,updateCoupon);
		}
		
		protected function onItemBuy(event:Event):void
		{
			update();
		}
		
		protected function onRefresh(event:MouseEvent):void
		{
			if(PackManager.getIns().searchItemNum(NumberConst.getIns().refreshCouponId)>NumberConst.getIns().zero){
				(ViewFactory.getIns().getView(TipView) as TipView).setFun(
					"是否使用一张刷新券刷新黑市物品?",useRefreshCoupon);

			}else{
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"刷新券不足！");
			}
		}
		
		private function useRefreshCoupon():void{
			mouseChildren = false;
			SaveManager.getIns().onSaveGame(
				function () : void{
					PackManager.getIns().reduceItem(NumberConst.getIns().refreshCouponId,NumberConst.getIns().one);
					resetBlackMarket();
				},
				function () : void{
					mouseChildren = true;
					update();
				});
		}
		
		protected function onFreeRefresh(event:MouseEvent):void
		{
			mouseChildren = false;
			SaveManager.getIns().onSaveGame(
				function () : void{
					player.blackMarket.freeRefresh=NumberConst.getIns().one;
					resetBlackMarket();
				},
				function () : void{
					mouseChildren = true;
					update();
				});
		}
		
		public function update():void{
			if(player.blackMarket.items.length < 6){
				resetBlackMarket();
			}
			else if(player.blackMarket.items[0].id == "[object Object]" || player.blackMarket.items[0].id == "0"){
				resetBlackMarket();
			}
			else{
				curBlackItems = player.blackMarket.items;
			}
			renderUi();	
		}
		
		private function updateCoupon(e:Event):void{
			couponTxt.text = player.vip.curCoupon.toString();
		}
		
	
		private function renderUi():void
		{
			if (!_itemGrid)
			{
				_itemGrid = new AutoGrid(BlackMarketItemIcon,2, 3, 145, 95, 10, 10);
				_itemGrid.x = 285;
				_itemGrid.y = 135;
				this.addChild(_itemGrid);
			}
			_itemGrid.setData(curBlackItems);
			
			if(!_recommendItenArr){
				_recommendItenArr = NumberConst.getIns().blackMarketRecommend;
				for(var i:int =0;i<5;i++){
					var item:ItemIcon = new ItemIcon();
					var itemVo:ItemVo = PackManager.getIns().creatItem(_recommendItenArr[i]);
					item.selectable = false;
					item.menuable = false;
					item.num = false;
					item.setData(itemVo);
					item.x = 355+i*70;
					item.y = 30;
					this.addChild(item);
				}
			}
			
			if(player.blackMarket.freeRefresh==NumberConst.getIns().zero){
				freeRefreshBtn.visible = true;
				continueRefreshBtn.visible = false;
			}else{
				freeRefreshBtn.visible = false;
				continueRefreshBtn.visible = true;
			}
			updateCoupon(null);
			refreshNumTxt.text = PackManager.getIns().searchItemNum(NumberConst.getIns().refreshCouponId).toString();
		}
		

		
/*		private function renderBlackMarket():void{
			if(player.blackMarket.items.length < 6){
				refreshBlackMarketItems();
			}else{
				
				update();
			}
			
		}*/

		private function refreshBlackMarketItems():void{
			SaveManager.getIns().onSaveGame(
				function () : void{
					resetBlackMarket();
				},
				function () : void{
					update();
				}, 2);
		}
		
		private function resetBlackMarket() : void{
			var dataArr:Array = ConfigurationManager.getIns().getAllData(AssetsConst.BLACK_MARKET);
			var newDataArr:Array = [];
			if(!HideMissionManager.getIns().returnHideMissionComplete(3012)){
				for(var i:int=0;i<dataArr.length;i++){
					if(dataArr[i].id<8000 || dataArr[i].id>=9000){
						newDataArr.push(dataArr[i]);
					}
				}	
			}else{
				newDataArr = dataArr;
			}
			curBlackItems = getRandomArray(newDataArr,6);
			player.blackMarket.items = itemArr;
			player.blackMarket.itemsEnable = [1,1,1,1,1,1];
		}
		
		private function get itemArr():Array{
			var result:Array = [];
			for(var i:int = 0; i<curBlackItems.length;i++){
				result.push(curBlackItems[i]);
			}
			return result;
		}
		

		
		//从一个给定的数组arr中,随机返回num个不重复项
		private function getRandomArray(arr:Array, num:Number):Array {
			//新建一个数组,将传入的数组复制过来,用于运算,而不要直接操作传入的数组;
			var temp_special_array:Array = new Array();
			var temp_normal_array:Array = new Array();
			for (var i:int = 0; i<arr.length; i++) {
				if(arr[i].coupon!=0){
					temp_special_array.push(arr[i]);
				}
			}
			for (var j:int = 0; j<arr.length; j++) {
				if(arr[j].coupon==0){
					temp_normal_array.push(arr[j]);
				}
			}
			//取出的数值项,保存在此数组
			var return_array:Array = new Array();
			for (var k:int = 0; k<num; k++) {
					//在数组中产生一个随机索引
				if(Math.floor(Math.random()*10)<=3 && temp_special_array.length>0){
					var spIndex:Number = Math.floor(Math.random()*temp_special_array.length);
					//将此随机索引的对应的数组元素值复制出来
					return_array[k] = {id:temp_special_array[spIndex].id,coupon:Math.floor(Math.random()*2).toString()};
					//然后删掉此索引的数组元素,这时候temp_array变为新的数组
					temp_special_array.splice(spIndex, 1);
				}else{
					var nIndex:Number = Math.floor(Math.random()*temp_normal_array.length);
					//将此随机索引的对应的数组元素值复制出来
					return_array[k] = {id:temp_normal_array[nIndex].id,coupon:"0"};
					//然后删掉此索引的数组元素,这时候temp_array变为新的数组
					temp_normal_array.splice(nIndex, 1);
				}
			}
			return return_array;
		}
		
		
		private function get freeRefreshBtn():SimpleButton{
			return _obj["freeRefreshBtn"];
		}
		
		private function get continueRefreshBtn():SimpleButton{
			return _obj["continueRefreshBtn"];
		}
		
		private function get refreshNumTxt():TextField{
			return _obj["refreshNumTxt"];
		}
		
		private function get couponTxt():TextField{
			return _obj["couponTxt"];
		}
		
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		override public function destroy() : void{
			freeRefreshBtn.removeEventListener(MouseEvent.CLICK,onFreeRefresh);
			continueRefreshBtn.removeEventListener(MouseEvent.CLICK,onRefresh);
			EventManager.getIns().removeEventListener(EventConst.BLACK_MARKET_BUY,onItemBuy);
			
			removeComponent(_obj);
			if(_itemGrid != null){
				_itemGrid.destroy();
				_itemGrid = null;
			}
			super.destroy();
		}
	}
}