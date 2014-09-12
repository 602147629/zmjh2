package com.test.game.Modules.MainGame.Market
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.BaGuaManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Modules.MainGame.BaGua.BaGuaPiece;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewForShopShortage;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Configuration.BlackMarket;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.Vo.VipVo;
	import com.test.game.UI.ItemIcon;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class BlackMarketItemIcon extends BaseSprite implements IGrid
	{
		private var _obj:Sprite;
		
		private var _isBagua:Boolean;
		
		private var _itemIcon:ItemIcon;
		
		private var _baguaPieceIcon:BaGuaPiece;
		
		public var layerName:String;
		
		private var _data:BlackMarket;
		
		private var _itemVo:ItemVo;
		
		private var _baguaPieceVo:BaGuaPieceVo;
		
		private var _recommandIcon:BaseNativeEntity;
		
		private var _index:int;
		
		private var _anti:Antiwear;
		
		private var isCoupon:Boolean;

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}
		
		
		public function get btnEnable():Boolean
		{
			return _anti["btnEnabe"];
		}
		
		public function set btnEnable(value:Boolean):void
		{
			_anti["btnEnabe"] = value;
		}
		
		
		
		public function BlackMarketItemIcon()
		{
			_anti = new Antiwear(new binaryEncrypt());
			this.buttonMode = true;
			
			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("blackMarketItemIcon") as Sprite;
				this.addChild(_obj);
			}
			
			if(!_itemIcon){
				_itemIcon = new ItemIcon();
				_itemIcon.x = 10;
				_itemIcon.y = 10;
				_itemIcon.selectable = false;
				_itemIcon.menuable = false;
				this.addChild(_itemIcon);
			}
			
			if(!_baguaPieceIcon){
				_baguaPieceIcon = new BaGuaPiece();
				_baguaPieceIcon.x = 10;
				_baguaPieceIcon.y = 10;
				_baguaPieceIcon.dragable = false;
				_baguaPieceIcon.menuable = false;
				this.addChild(_baguaPieceIcon);
			}
			
			//推荐标志
			if(!_recommandIcon){
				_recommandIcon  = new BaseNativeEntity();
				_recommandIcon.x=-10;
				_recommandIcon.y=-10;
				this.addChild(_recommandIcon);
				_recommandIcon.data.bitmapData = AUtils.getNewObj("recommandIcon") as BitmapData;
			}
			
			
			
			initEvent();
			super();
		}
		
		
		public function setData(data:*) : void{
			if(data == null){
				this.visible = false;
				return;
			}
			this.visible = true;
			_data = ConfigurationManager.getIns().getObjectByID(AssetsConst.BLACK_MARKET,int(data.id)) as BlackMarket
			
			if(_data.id>8000 && _data.id<9000){
				_isBagua = true;
				_baguaPieceVo = BaGuaManager.getIns().creatLingQiBaGua(_data.id);
				_baguaPieceIcon.setData(_baguaPieceVo);
			}else{
				_isBagua = false;
				_itemVo = PackManager.getIns().creatItem(_data.id);
				_itemVo.num = _data.number;
				_itemVo.isPriceShow = false;
				_itemIcon.setData(_itemVo);	
			}

			
			_recommandIcon.visible = _data.recommend==1?true:false;
			itemNameTxt.text = _data.name;
			
			if(data.coupon=="1"){
				isCoupon = true;
				originPriceTxt.text = NumberConst.numTranslate(_data.coupon_before)+"点券";
				priceTxt.text = NumberConst.numTranslate(_data.coupon)+"点券";
			}else{
				isCoupon = false;
				originPriceTxt.text = NumberConst.numTranslate(_data.gold_before);
				priceTxt.text = NumberConst.numTranslate(_data.gold);
			}
			
			
			
			checkBtn();
		}
		
		private function checkBtn():void
		{
			var arr:Array = player.blackMarket.itemsEnable;
			if(player.blackMarket.itemsEnable[index] == NumberConst.getIns().one.toString()){
				buyBtnEnable(true);
			}else{
				buyBtnEnable(false);
			}
		}
		
		private function initEvent():void{
			buyBtn.addEventListener(MouseEvent.CLICK,_onClick);
		}
		
		private function _onClick(event:MouseEvent):void
		{
			if(btnEnable){
				if(isCoupon ){
					if(vip.curCoupon<_data.coupon){
						(ViewFactory.getIns().initView(TipViewForShopShortage) as TipViewForShopShortage).setFun(
							"点券不足！\n请充值后再购买");
					}else{
						if(PackManager.getIns().checkMaxRooM([_itemVo])){
							(ViewFactory.getIns().getView(TipView) as TipView).setFun(
								"确定使用"+_data.coupon+"点券购买"+_itemVo.num+"件"+_itemVo.name+"?",buyCouponBlackItem);
						}else{
							(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
								"背包空间不足！\n请留出空间后再购买");
						}
					}
				}else{
					if(PlayerManager.getIns().checkNumber("money",_data.gold)){
						(ViewFactory.getIns().getView(TipView) as TipView).setFun(
							"花费"+_data.gold+"金币购买"+_data.name+"?",buyBlackItem);
						
					}else{
						(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
							"金钱不足！");
					}	
				}

			}

		}
		
		private function buyCouponBlackItem():void
		{
			(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
				"系统正在处理当中，请稍等...",null,null,true);
			SaveManager.getIns().onJudgeMulti(
				function () : void{
					var data:Object = {propId:_data.propId.toString(),count:_itemVo.num,price:_data.coupon,idx:PlayerManager.getIns().player.index,tag:"buy"+_itemVo.id};
					ShopManager.getIns().buyPropNd(data,buyItemCallBack);
				});
		}
		
		private function buyItemCallBack(data:Object):void{
			//DebugArea.getIns().showInfo(data.tag,DebugConst.NORMAL);
			PackManager.getIns().addItemIntoPack(_itemVo.copy());
			//该黑市物品已购买
			var arr:Array = player.blackMarket.itemsEnable;
			arr[index] = NumberConst.getIns().zero.toString();
			player.blackMarket.itemsEnable = arr;
			
			SaveManager.getIns().onlySave(function():void{
				vip.curCoupon = data.balance;
				EventManager.getIns().dispatchEvent(new Event(EventConst.BUY_SHOP_ITEM_SCUUESS));
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					_itemVo.name+"购买成功！");
				EventManager.getIns().dispatchEvent(
					new CommonEvent(EventConst.BLACK_MARKET_BUY,[_data,this]));
				//update();
			});
		}
		
		
		private function buyBlackItem():void{
			if(_isBagua){
				var bagState:int = BaGuaManager.getIns().checkFull();
				if(bagState>=0){
					BaGuaManager.getIns().addBaGuaIntoPack(_baguaPieceVo.copy());
					PlayerManager.getIns().reduceMoney(_data.gold);
					
					//该黑市物品已购买
					var arr:Array = player.blackMarket.itemsEnable;
					arr[index] = NumberConst.getIns().zero.toString();
					player.blackMarket.itemsEnable = arr;
					
					//SaveManager.getIns().onSaveGame();
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						_data.name+"×"+_data.number+" 购买成功！");
					EventManager.getIns().dispatchEvent(
						new CommonEvent(EventConst.BLACK_MARKET_BUY,[_data,this]));
				}else{
					(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"八卦牌背包已满！请整理，否则无法获得八卦牌");
				}
			}else{
				if(PackManager.getIns().checkMaxRooM([_itemVo])){
					PackManager.getIns().addItemIntoPack(_itemVo.copy());
					PlayerManager.getIns().reduceMoney(_data.gold);
					
					//该黑市物品已购买
					var arr:Array = player.blackMarket.itemsEnable;
					arr[index] = NumberConst.getIns().zero.toString();
					player.blackMarket.itemsEnable = arr;
					
					//SaveManager.getIns().onSaveGame();
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						_data.name+"×"+_data.number+" 购买成功！");
					EventManager.getIns().dispatchEvent(
						new CommonEvent(EventConst.BLACK_MARKET_BUY,[_data,this]));
				}else{
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"背包空间不足！\n请留出空间后再购买");
				}
			}
		}
		
		private function buyBtnEnable(enable:Boolean):void{
			if(enable){
				GreyEffect.reset(buyBtn);
			}else{
				GreyEffect.change(buyBtn);
			}
			btnEnable = enable;
		}


		private function get itemNameTxt():TextField
		{
			return _obj["itemNameTxt"];
		}
		
		private function get originPriceTxt():TextField
		{
			return _obj["originPriceTxt"];
		}
		
		private function get priceTxt():TextField
		{
			return _obj["priceTxt"];
		}

		private function get buyBtn():SimpleButton
		{
			return _obj["buyBtn"];
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		private function get vip():VipVo{
			return PlayerManager.getIns().player.vip;
		}
		
		
		public function setLocked() : void{
		}
		
		public function set menuable(value:Boolean) : void{
		}
		
		public function set selectable(value:Boolean) : void{
		}
		

		
		override public function destroy():void{
			removeComponent(_recommandIcon);
			removeComponent(_obj);
			_itemIcon.destroy();
			_data = null;
			super.destroy();
		}
	}
}