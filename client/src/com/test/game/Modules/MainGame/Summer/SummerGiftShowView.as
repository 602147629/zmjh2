package com.test.game.Modules.MainGame.Summer
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.DigitalEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.BaGuaManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.Gift.SummerRechargeManager;
	import com.test.game.Modules.MainGame.BaGua.BaGuaPiece;
	import com.test.game.Modules.MainGame.Shop.ShopView;
	import com.test.game.Mvc.Configuration.SummerCarnival;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.DungeonTip;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SummerGiftShowView extends BaseView
	{
		private var _anti:Antiwear;
		private function get showType() : int{
			return _anti["showType"];
		}
		private function set showType(value:int) : void{
			_anti["showType"]  = value;
		}
		private function get nowIndex() : int{
			return _anti["nowIndex"];
		}
		private function set nowIndex(value:int) : void{
			_anti["nowIndex"]  = value;
		}
		private var _nowInfo:Array;
		private var _itemIcons:Array;
		private var _moneyTip:BaseNativeEntity;
		private var _soulTip:BaseNativeEntity;
		private var _moneyTitle:DungeonTip;
		private var _soulTitle:DungeonTip;
		private var _baGuaPiece:BaGuaPiece;
		private var _couponDigital:Sprite;
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function SummerGiftShowView()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
		}
		
		override protected function getContainer() : BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function init() : void{
			super.init();
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("SummerGiftShowView") as Sprite;
				this.addChild(layer);
				
				initUI();
				initBg();
				setCenter();
			}
		}
		
		private function initUI() : void{
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			getGiftBtn.addEventListener(MouseEvent.CLICK, onGetGift);
			rechargeBtn.addEventListener(MouseEvent.CLICK, onRecharge);
			shopBtn.addEventListener(MouseEvent.CLICK, onGotoShop);
			for(var i:int = 1; i < 8; i++){
				(layer["Coupon" + i] as MovieClip).gotoAndStop(1);
				(layer["Coupon" + i] as MovieClip).buttonMode = true;
				(layer["Coupon" + i] as MovieClip).addEventListener(MouseEvent.CLICK, onClick);
			}
			nowIndex = NumberConst.getIns().one;
			_nowInfo = ConfigurationManager.getIns().getAllData(AssetsConst.SUMMER_CARNIVAL);
			
			_itemIcons = new Array();
			for(var j:int = 0; j < 5; j++){
				var itemIcon:ItemIcon = new ItemIcon();
				itemIcon.x = 50 + j * 51;
				itemIcon.y = 247;
				itemIcon.menuable =  false;
				itemIcon.selectable = false;
				layer.addChild(itemIcon);
				_itemIcons.push(itemIcon);
			}
			_moneyTip = new BaseNativeEntity();
			_moneyTip.data.bitmapData = AUtils.getNewObj("WeatherMoney") as BitmapData;
			_moneyTip.y = 265;
			_soulTip = new BaseNativeEntity();
			_soulTip.data.bitmapData = AUtils.getNewObj("WeatherSoul") as BitmapData;
			_soulTip.y = 260;
			
			_baGuaPiece = new BaGuaPiece();
			_baGuaPiece.y = 247;
			_baGuaPiece.menuable =  false;
			_baGuaPiece.selectable = false;
			layer.addChild(_baGuaPiece);
			GreyEffect.change(alreadyGetBtn);
			alreadyGetBtn.mouseEnabled = false;
		}
		
		protected function onGotoShop(e:MouseEvent) : void{
			this.hide();
			ViewFactory.getIns().initView(ShopView).show()
		}
		
		protected function onRecharge(e:MouseEvent) : void{
			ShopManager.getIns().summerPayMoney(
				function () : void{
					SummerRechargeManager.getIns().sendData(showType);
				}
			);
		}
		
		protected function onGetGift(e:MouseEvent) : void{
			SummerRechargeManager.getIns().onGetReward(showType, _nowInfo[nowIndex - 1]);
			updateData();
			update();
			updateBtn();
		}
		
		protected function onClose(e:MouseEvent) : void{
			this.hide();
			ViewFactory.getIns().getView(SummerGiftView).show();
		}
		
		protected function onClick(e:MouseEvent) : void{
			nowIndex = e.currentTarget.name.charAt(6);
			updatePoint();
			updateItem();
			updateBtn();
			updateDigital();
		}
		
		public function showUIType(type:int) : void{
			layer.mouseEnabled = false;
			layer.mouseChildren = false;
			showType = type;
			summerTitle.gotoAndStop(showType);
			contents.gotoAndStop(showType);
			couponType.gotoAndStop(showType);
			SummerRechargeManager.getIns().sendData(showType);
			show();
		}
		
		override public function show() : void{
			super.show();
			//update();
		}
		
		public function updateAll(total:int) : void{
			layer.mouseEnabled = true;
			layer.mouseChildren = true;
			update();
			updateBar(total);
		}
		
		private function updateData() : void{
			var arr:Array = [];
			switch(showType){
				case NumberConst.getIns().one:
					arr = player.summerCarnivalInfo.summerRecharge;
					break;
				case NumberConst.getIns().two:
					arr = player.summerCarnivalInfo.summerConsume;
					break;
			}
			var count:int = 0;
			for(var i:int = 0; i < arr.length; i++){
				if(arr[i] != 1){
					nowIndex = i + 1;
					break;
				}else{
					count++;
				}
			}
			if(nowIndex > 7 || count == 7){
				nowIndex = 7;
			}
		}
		
		override public function update() : void{
			updateData();
			updatePoint();
			updateItem();
			updateBtn();
			updateDigital();
		}
		
		private function updatePoint() : void{
			for(var i:int = 1; i < 8; i++){
				(layer["Coupon" + i] as MovieClip).gotoAndStop(1);
			}
			(layer["Coupon" + nowIndex] as MovieClip).gotoAndStop(2);
			barPoint.x = 48 * nowIndex;
		}
		
		private function updateDigital() : void{
			var nowInfo:SummerCarnival = _nowInfo[nowIndex - 1];
			if(_couponDigital != null){
				if(_couponDigital.parent != null){
					_couponDigital.parent.removeChild(_couponDigital);
				}
				_couponDigital = null;
			}
			_couponDigital = DigitalEffect.createDigital("AtkHp", nowInfo.value);
			_couponDigital.x = 340;
			_couponDigital.y = 260;
			_couponDigital.scaleX = .5;
			_couponDigital.scaleY = .5;
			layer.addChild(_couponDigital);
		}
		
		private function updateBtn() : void{
			switch(showType){
				case NumberConst.getIns().one:
					if(SummerRechargeManager.getIns().rechargeLv >= nowIndex){
						GreyEffect.reset(getGiftBtn);
						getGiftBtn.mouseEnabled = true;
					}else{
						GreyEffect.change(getGiftBtn);
						getGiftBtn.mouseEnabled = false;
					}
					shopBtn.visible = false;
					rechargeBtn.visible = true;
					break;
				case NumberConst.getIns().two:
					if(SummerRechargeManager.getIns().paiedLv >= nowIndex){
						GreyEffect.reset(getGiftBtn);
						getGiftBtn.mouseEnabled = true;
					}else{
						GreyEffect.change(getGiftBtn);
						getGiftBtn.mouseEnabled = false;
					}
					shopBtn.visible = true;
					rechargeBtn.visible = false;
					break;
			}
			
			if(player.summerCarnivalInfo.checkIsGet(nowIndex - 1, showType)){
				getGiftBtn.visible = false;
				alreadyGetBtn.visible = true;
			}else{
				getGiftBtn.visible = true;
				alreadyGetBtn.visible = false;
			}
		}
		
		private function updateItem() : void{
			clearAll();
			var nowInfo:SummerCarnival = _nowInfo[nowIndex - 1];
			var propID:Array = new Array();
			var propNum:Array = new Array();
			switch(showType){
				case NumberConst.getIns().one:
					propID = nowInfo.recharge_prop_id.split("|");
					propNum = nowInfo.recharge_prop_number.split("|");
					if(nowInfo.recharge_gold != 0){
						_moneyTip.x = 60 + propID.length * 50;
						layer.addChild(_moneyTip);
						_moneyTitle = new DungeonTip(NumberConst.numTranslate(nowInfo.recharge_gold));
						_moneyTitle.x = 77 + propID.length * 50;
						_moneyTitle.y = 260;
						layer.addChild(_moneyTitle);
						//TipsManager.getIns().addTips(_moneyTip, {title:"金钱:" + nowInfo.recharge_gold, tips:""});
					}
					if(nowInfo.recharge_soul != 0){
						_soulTip.x = 60 + propID.length * 50;
						layer.addChild(_soulTip);
						_soulTitle = new DungeonTip(NumberConst.numTranslate(nowInfo.recharge_soul));
						_soulTitle.x = 77 + propID.length * 50;
						_soulTitle.y = 260;
						layer.addChild(_soulTitle);
						//TipsManager.getIns().addTips(_soulTip, {title:"战魂:" + nowInfo.recharge_soul, tips:""});
					}
					if(nowInfo.recharge_fashion != "0"){
						var rechargeIndex:int = int(nowInfo.recharge_fashion.split("|")[player.occupation - 1]);
						var rechargeFashionVo:ItemVo = PackManager.getIns().creatItem(rechargeIndex);
						(_itemIcons[4] as ItemIcon).setData(rechargeFashionVo);
					}
					break;
				case NumberConst.getIns().two:
					propID = nowInfo.consume_prop_id.split("|");
					propNum = nowInfo.consume_prop_number.split("|");
					if(nowInfo.consume_gold != 0){
						_moneyTip.x = 60 + propID.length * 50;
						layer.addChild(_moneyTip);
						_moneyTitle = new DungeonTip(NumberConst.numTranslate(nowInfo.consume_gold));
						_moneyTitle.x = 77 + propID.length * 50;
						_moneyTitle.y = 260;
						layer.addChild(_moneyTitle);
						//TipsManager.getIns().addTips(_moneyTip, {title:"金钱:" + nowInfo.consume_gold, tips:""});
					}
					if(nowInfo.consume_soul != 0){
						_soulTip.x = 60 + propID.length * 50;
						layer.addChild(_soulTip);
						_soulTitle = new DungeonTip(NumberConst.numTranslate(nowInfo.consume_soul));
						_soulTitle.x = 77 + propID.length * 50;
						_soulTitle.y = 260;
						layer.addChild(_soulTitle);
						//TipsManager.getIns().addTips(_soulTip, {title:"战魂:" + nowInfo.consume_soul, tips:""});
					}
					if(nowInfo.consume_fashion != "0"){
						var consumeIndex:int = int(nowInfo.consume_fashion.split("|")[player.occupation - 1]);
						var consumeFashionVo:ItemVo = PackManager.getIns().creatItem(consumeIndex);
						(_itemIcons[4] as ItemIcon).setData(consumeFashionVo);
					}
					break;
			}
			for(var k:int; k < propID.length; k++){
				if(int(propID[k]) > 8000 && int(propID[k]) < 9000){
					var bagua:BaGuaPieceVo = BaGuaManager.getIns().creatLingQiBaGua(int(propID[k]));
					_baGuaPiece.x = 50 + k * 51;
					_baGuaPiece.setData(bagua);
					_baGuaPiece.setNum(int(propNum[k]));
				}else if(int(propID[k]) >= 10000 && int(propID[k]) < 12000){
					var bossVo:ItemVo = PackManager.getIns().creatBossDataBySpecial(int(propID[k]));
					(_itemIcons[k] as ItemIcon).setData(bossVo);
				}else{
					var itemVo:ItemVo = PackManager.getIns().creatItem(int(propID[k]));
					itemVo.num = int(propNum[k]);
					(_itemIcons[k] as ItemIcon).setData(itemVo);
				}
			}
			
		}
		
		private function updateBar(total:int) : void{
			if(total == 0){
				nowCoupon.visible = false;
			}else{
				nowCoupon.visible = true;
				nowCoupon.text = total.toString();
			}
			TipsManager.getIns().removeTips(bar);
			TipsManager.getIns().addTips(bar, {title:total + "/100000", tips:""});
			if(total >= 100000){
				rechargeBar.width = 369;
				return;
			}
			var nowInfo:SummerCarnival;
			var preInfo:SummerCarnival;
			switch(showType){ 
				case NumberConst.getIns().one:
					if(SummerRechargeManager.getIns().rechargeLv < 7){
						nowInfo = _nowInfo[SummerRechargeManager.getIns().rechargeLv];
						if(SummerRechargeManager.getIns().rechargeLv > 0){
							preInfo = _nowInfo[SummerRechargeManager.getIns().rechargeLv - 1];
							rechargeBar.width = SummerRechargeManager.getIns().rechargeLv * 46 + (total - preInfo.coupon) / (nowInfo.coupon - preInfo.coupon) * 46;
						}else{
							rechargeBar.width = SummerRechargeManager.getIns().rechargeLv * 46 + total / nowInfo.coupon * 46;
						}
					}else{
						rechargeBar.width = 7 * 46 + (total - 50000) / 50000 * 46;
					}
					break;
				case NumberConst.getIns().two:
					if(SummerRechargeManager.getIns().paiedLv < 7){
						nowInfo = _nowInfo[SummerRechargeManager.getIns().paiedLv];
						if(SummerRechargeManager.getIns().paiedLv > 0){
							preInfo = _nowInfo[SummerRechargeManager.getIns().paiedLv - 1];
							rechargeBar.width = SummerRechargeManager.getIns().paiedLv * 46 + (total - preInfo.coupon) / (nowInfo.coupon - preInfo.coupon) * 46;
						}else{
							rechargeBar.width = SummerRechargeManager.getIns().paiedLv * 46 + total / nowInfo.coupon * 46;
						}
					}else{
						rechargeBar.width = 7 * 46 + (total - 50000) / 50000 * 46;
					}
					break;
			}
		}
		
		private function clearAll() : void{
			for(var j:int = 0; j < _itemIcons.length; j++){
				(_itemIcons[j] as ItemIcon).setData(null);
			}
			_baGuaPiece.setData(null);
			if(_moneyTip.parent != null){
				_moneyTip.parent.removeChild(_moneyTip);
			}
			if(_moneyTitle != null){
				if(_moneyTitle.parent != null){
					_moneyTitle.parent.removeChild(_moneyTitle);
				}
				_moneyTitle.destroy();
				_moneyTitle = null;
			}
			TipsManager.getIns().removeTips(_moneyTip);
			if(_soulTip.parent != null){
				_soulTip.parent.removeChild(_soulTip);
			}
			if(_soulTitle != null){
				if(_soulTitle.parent != null){
					_soulTitle.parent.removeChild(_soulTitle);
				}
				_soulTitle.destroy();
				_soulTitle = null;
			}
			TipsManager.getIns().removeTips(_soulTip);
		}
		
		private function get closeBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
		private function get summerTitle() : MovieClip{
			return layer["SummerTitle"];
		}
		private function get contents() : MovieClip{
			return layer["Contents"];
		}
		private function get barPoint() : Sprite{
			return layer["BarPoint"];
		}
		private function get getGiftBtn() : SimpleButton{
			return layer["GetGiftBtn"]
		}
		private function get rechargeBar() : Sprite{
			return layer["Bar"]["RechargeBar"];
		}
		private function get bar() : Sprite{
			return layer["Bar"];
		}
		private function get rechargeBtn() : SimpleButton{
			return layer["RechargeBtn"];
		}
		private function get couponType() : MovieClip{
			return layer["CouponType"];
		}
		private function get alreadyGetBtn() : SimpleButton{
			return layer["AlreadyGetBtn"];
		}
		private function get nowCoupon() : TextField{
			return layer["NowCoupon"]
		}
		private function get shopBtn() : SimpleButton{
			return layer["ShopBtn"];
		}
	}
}