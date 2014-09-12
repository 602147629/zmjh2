package com.test.game.Manager
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.gameServer.ShopFor4399;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.DebugConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.PublicNoticeType;
	import com.test.game.Event.ServerEvent;
	import com.test.game.Manager.Extra.DoubleDungeonManager;
	import com.test.game.Modules.MainGame.StartPageView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.Shop.ShopView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipViewForShopPay;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Modules.MainGame.Vip.VipView;
	import com.test.game.Mvc.Configuration.BossCardUp;
	import com.test.game.Mvc.Configuration.GiftPackage;
	import com.test.game.Mvc.Configuration.Prop;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.Vo.VipVo;
	
	import flash.events.Event;
	
	public class ShopManager extends Singleton
	{
		private var _getBalanceFun:Function;
		private var _getShopListFun:Function;
		private var _buyPropNdFun:Function;
		private var _getTotalPaiedFun:Function;
		private var _getTotalRechargedFun:Function;
		private var _anti:Antiwear;
		
		public var playerChange:Boolean;
		
		public function ShopManager()
		{
			_anti = new Antiwear(new binaryEncrypt());
			super();
		}
		
		public static function getIns():ShopManager{
			return Singleton.getIns(ShopManager);
		}
		
		public function initEvent():void{
			ShopFor4399.getIns().stage.addEventListener(EventConst.USE_PAY_API_SHOP, onUsePayAPI);
			ShopFor4399.getIns().stage.addEventListener(EventConst.GET_MONEY_SHOP, onGetMoney);
			ShopFor4399.getIns().stage.addEventListener(EventConst.PAY_MONEY_SHOP, onPayMoney);
			ShopFor4399.getIns().stage.addEventListener(EventConst.PAID_MONEY_SHOP, onPaiedMoney);
			ShopFor4399.getIns().stage.addEventListener(EventConst.RECHARGED_MONEY_SHOP, onRechargedMoney);
			ShopFor4399.getIns().stage.addEventListener(EventConst.PAY_ERROR_SHOP, onPayError);
			ShopFor4399.getIns().stage.addEventListener(EventConst.SHOP_ERROR_ND, onShopError);
			ShopFor4399.getIns().stage.addEventListener(EventConst.SHOP_BUY_ND, onShopBuy);
			ShopFor4399.getIns().stage.addEventListener(EventConst.SHOP_GET_LIST, onShopGetList);
			EventManager.getIns().addEventListener(EventConst.PAY_MONEY,moneyPaid);
			
		}
		

		
		protected function onUsePayAPI(e:ServerEvent):void{
			DebugArea.getIns().showInfo("---可以正常使用支付API---", DebugConst.NORMAL);
		}
		
		protected function onGetMoney(e:ServerEvent):void{
			DebugArea.getIns().showInfo("---当前余额为：" + e.targetData.balance + "---", DebugConst.NORMAL);
			vip.curCoupon = e.targetData.balance;
			if(_getBalanceFun != null){
				_getBalanceFun(e.targetData.balance);
			}
		}
		
		protected function onPayMoney(e:ServerEvent):void{
			DebugArea.getIns().showInfo("---充值游戏币失败---", DebugConst.ERROR);
		}
		
		protected function onPaiedMoney(e:ServerEvent):void{
			DebugArea.getIns().showInfo("---获取累积消费的游戏币为：" + e.targetData.balance + "---", DebugConst.NORMAL);
			if(_getTotalPaiedFun != null){
				_getTotalPaiedFun(e.targetData.balance);
			}
		}
		
		protected function onRechargedMoney(e:ServerEvent):void{
			DebugArea.getIns().showInfo("---获取累积充值的游戏币为：" + e.targetData.balance + "---", DebugConst.NORMAL);
			if(_getTotalRechargedFun != null){
				_getTotalRechargedFun(e.targetData.balance);
			}
		}
		
		protected function onPayError(e:ServerEvent):void{
			DebugArea.getIns().showInfo("---使用支付接口其他错误：" + e.targetData.info + "---", DebugConst.ERROR);
			(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun("系统出错，请重试");
		}
		
		protected function onShopError(e:ServerEvent):void{
			/*
			eId|message
			20000|该物品不存在
			20001|前后端价格不一致
			20002|该用户没有余额
			20003|用户余额不足
			20004|扣款出错
			20010|限量/限时/限量限时活动已结束
			20011|销售物品数量不足
			20012|活动未开始
			20013|限量折扣/限时折扣/限量限时折扣活动已结束
			30000|系统级出错
			80001|取物品列表出错了！
			90001|传的索引值有问题！
			90003|购买的物品数据不完善！
			90004|购买的物品数量须至少1个！
			90005|购买的物品数据类型有误！
			*/
			DebugArea.getIns().showInfo("---eId:" + e.targetData.eId + "  message:" + e.targetData.msg + "---", DebugConst.ERROR);
			var info:String;
			switch(int(e.targetData.eId)){
				case 20002:
					info = "余额不足，请充值";
					break;
				case 20001:
				case 20004:
				case 30000:
				case 80001:
				case 90001:
				case 90003:
				case 90004:
				case 90005:
					info = "系统出错，请重试"
					break;
				default:	
					info = e.targetData.msg;
					break;
			}				
			(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(info);
		}
		
		protected function onShopBuy(e:ServerEvent):void{
			DebugArea.getIns().showInfo("---购买成功：propId:" + e.targetData.propId + "  count:" + e.targetData.count + "   balance:" + e.targetData.balance + "   tag:" + e.targetData.tag + "---", DebugConst.NORMAL);
			if(_buyPropNdFun != null){
				_buyPropNdFun(e.targetData);
			}
		}
		
		protected function onShopGetList(e:ServerEvent):void{
			if(e.targetData == null){
				DebugArea.getIns().showInfo("---获取物品列表时，返回空值了---", DebugConst.ERROR);
				return;
			}
			if((e.targetData as Array).length == 0){
				DebugArea.getIns().showInfo("---无商品列表---", DebugConst.ERROR);
				return;
			}
			if(_getShopListFun != null){
				DebugArea.getIns().showInfo("---获取物品列表成功---", DebugConst.NORMAL);
				_getShopListFun(e.targetData as Array);
			}
		}
		
		//游戏充值
		public function payMoney(value:int = 10) : void{
			DebugArea.getIns().showInfo("---发送游戏充值请求---", DebugConst.NORMAL);
			(ViewFactory.getIns().initView(TipViewForShopPay) as TipViewForShopPay).setFun(
				"充值完成后，请点击确定来刷新点券",dispatchUpdate);
			
			ShopFor4399.getIns().payMoney(value);
		}
		
		private function dispatchUpdate():void{
			EventManager.getIns().dispatchEvent(new Event(EventConst.PAY_MONEY));
		}
		
		public function summerPayMoney(callback:Function, value:int = 10) : void{
			DebugArea.getIns().showInfo("---发送游戏充值请求---", DebugConst.NORMAL);
			(ViewFactory.getIns().initView(TipViewForShopPay) as TipViewForShopPay).setFun(
				"充值完成后，请点击确定来刷新点券", callback);
			
			ShopFor4399.getIns().payMoney(value);
		}
		
		
		public function getNewBalance():void{
			getBalance(function(balance:int):void{
				vip.curCoupon = balance;
			}
			);
		}
		
		//获取余额
		public function getBalance(callback:Function = null) : void{
			DebugArea.getIns().showInfo("---发送获取余额请求---", DebugConst.NORMAL);
			_getBalanceFun = callback;
			if(GameConst.localData){
				vip.curCoupon = 5000;
			}else{
				ShopFor4399.getIns().getBalance();
			}

		}
		
		//获取商城列表
		public function getShopList(callback:Function = null) : void{
			DebugArea.getIns().showInfo("---发送获取商城列表请求---", DebugConst.NORMAL);
			_getShopListFun = callback;
			ShopFor4399.getIns().getShopList();
		}
		
		//购买物品
		public function buyPropNd(data:Object, callback:Function = null) : void{
			DebugArea.getIns().showInfo("---发送购买物品请求---", DebugConst.NORMAL);
			_buyPropNdFun = callback;
			ShopFor4399.getIns().buyPropNd(data);
		}
		
		//获取累积消费的游戏币
		public function getTotalPaied(callback:Function = null, date:Object = null) : void{
			DebugArea.getIns().showInfo("---发送获取累计消费游戏币请求---", DebugConst.NORMAL);
			_getTotalPaiedFun = callback;
			ShopFor4399.getIns().getTotalPaiedFun(date);
		}
		
		//获取累积充值的游戏币
		public function getTotalRecharged(callback:Function = null, date:Object = null) : void{
			DebugArea.getIns().showInfo("---获取累积充值的游戏币请求！---", DebugConst.NORMAL);
			_getTotalRechargedFun = callback;
			ShopFor4399.getIns().getTotalRechargedFun(date);
		}
		
		
		private function get vip():VipVo{
			return PlayerManager.getIns().player.vip;
		}
		
		private function get gifts():Array{
			return PlayerManager.getIns().player.gift;
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		/**
		 * 
		 * vip等级
		 * 
		 */
		public function get vipLv():int
		{
			return _anti["vipLv"];
		}
		public function set vipLv(value:int):void
		{
			_anti["vipLv"] = value;
		}

		
		public function setTotalRechaged(callBack:Function = null):void{
			if(GameConst.localData){
				var showVipPublicNotice:Array = checkVipPublicNotice(1000000);
				var showFirstPublicNotice:Boolean = checkFirstPublicNotice(1000000);
                vip.totalRecharge = 1000000;
				checkVipLv();
				checkFirstCharge();
				setVipGet();
				if(ViewFactory.getIns().getView(RoleStateView)){
					(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).setVip();
				}
				DoubleDungeonManager.getIns().setDoubleDuration();
				player.escortInfo.judgeResetEscort();
				fashionJudge();
				cheatCheck();
				if(callBack){
					callBack();
				}
			}else{
				getTotalRecharged(
					function (total:int):void{
						var showVipPublicNotice:Array = checkVipPublicNotice(total);
						var showFirstPublicNotice:Boolean = checkFirstPublicNotice(total);
						vip.totalRecharge = total;
						checkVipLv();
						checkFirstCharge();
						if(!(ViewFactory.getIns().getView(StartPageView) as StartPageView).isNew){
							setVipGet();
						}
						if(ViewFactory.getIns().getView(RoleStateView)){
							(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).setVip();
						}
						DoubleDungeonManager.getIns().setDoubleDuration();
						player.escortInfo.judgeResetEscort();
						fashionJudge();
						cheatCheck();
						//DebugArea.getIns().showInfo("---vip等级公告数据---");
						if(showVipPublicNotice[0] || showFirstPublicNotice){
							if(showVipPublicNotice[0]){
								var arr:Array = showVipPublicNotice[1];
								for(var i:int = 0; i < arr.length; i++){
									PublicNoticeManager.getIns().sendPublicNotice(PublicNoticeType.VIP_CHANGE, "VIP" + arr[i]);
								}
							}
							if(showFirstPublicNotice){
								PublicNoticeManager.getIns().sendPublicNotice(PublicNoticeType.FIRST_CHARGE, "");
							}
							SaveManager.getIns().onSaveGame(null, null, 2);
						}
						if(callBack){
							callBack();
						}
					}
				);
			}
		}
		
		//判断是否可以领取首冲礼包的公告
		private function checkFirstPublicNotice(total:int) : Boolean{
			var result:Boolean = false;
			if(total != NumberConst.getIns().zero && vip.totalRecharge == NumberConst.getIns().zero){
				result = true;
			}
			return result;
		}
		
		//判断是否需要发送vip等级变更公告
		private function checkVipPublicNotice(total:int) : Array{
			var result:Boolean = false;
			var arr:Array = [];
			var vipData:Array = ConfigurationManager.getIns().getAllData(AssetsConst.VIPINFO);
			//当前充值的vip等级
			var nowVipLv:int;
			for(var i:int = 0; i < vipData.length; i++){
				if(total >= vipData[i].coupon){
					nowVipLv = vipData[i].id;
				}
			}
			//存档记录的vip等级
			var preVipLv:int;
			for(var j:int = 0; j < vipData.length; j++){
				if(vip.totalRecharge >= vipData[j].coupon){
					preVipLv = vipData[j].id;
				}
			}
			
			if(nowVipLv > preVipLv){
				for(var k:int = preVipLv + 1; k <= nowVipLv; k++){
					arr.push(k);
				}
				result = true;
			}
			
			DebugArea.getIns().showInfo("---充值vip等级" + nowVipLv + "---存档vip等级" + preVipLv + "---");
			return new Array(result, arr);
		}
		
		/**
		 *判断是否不充值作弊 
		 * 
		 */
		private function cheatCheck():void
		{
			if(vip.totalRecharge==0){
				for each(var fashion:ItemVo in player.pack.fashion){
					if(player.fashionInfo.fashionId == fashion.id){
						player.fashionInfo.fashionId = -1;
						fashion.mid = PackManager.getIns().firstEmptyMid;
					}
					PackManager.getIns().reduceItem(fashion.id,1);
				}
				
				for each(var prop:ItemVo in player.pack.prop){
					if((prop.id == NumberConst.getIns().gaoShouCard ||
						prop.id == NumberConst.getIns().changeNameCard ||
						prop.id == NumberConst.getIns().rpCard ||
						prop.id == NumberConst.getIns().doubleCard) && prop.num>1
					){
						PackManager.getIns().reduceItem(prop.id,prop.num);
					}
				}
			}
			
			if(vipLv<5){
				//判断是否有卡牌是否大于等级上限（大于则必然作弊）
				for each(var boss:ItemVo in player.pack.boss){
					if(boss.lv >= NumberConst.getIns().bossMaxLv){
						LogManager.getIns().addCheatLog("gold_boss",boss.id);
						boss.lv = NumberConst.getIns().one;
						boss.bossUp = ConfigurationManager.getIns().getObjectByID(AssetsConst.BOSS_UP,1) as BossCardUp;
					}
				}
			}
		}
		
		/**
		 *判断时装是否超时 
		 * 
		 */
		private function fashionJudge():void
		{
			for each(var fashion:ItemVo in player.pack.fashion){
				var day:int = TimeManager.getIns().disDayNum(fashion.time,TimeManager.getIns().curTimeStr);
				if(fashion.fashionConfig.time!=0 && day>= fashion.fashionConfig.time){
					if(player.fashionInfo.fashionId == fashion.id){
						player.fashionInfo.fashionId = -1;
						fashion.mid = PackManager.getIns().firstEmptyMid;
					}
					PackManager.getIns().reduceItem(fashion.id,1);
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"您的时装"+fashion.name+"已经过期，欢迎前往商城购买新时装");
				}
			}
		}
		
		private function checkVipLv():void{
			var vipData:Array = ConfigurationManager.getIns().getAllData(AssetsConst.VIPINFO);
			var totalRecharge:int = vip.totalRecharge;
			vipLv = NumberConst.getIns().zero;
			for(var i:int = 0;i<vipData.length;i++){
				if(totalRecharge>=vipData[i].coupon){
					vipLv = vipData[i].id;
				}
			}	
			TitleManager.getIns().checkVip6Title();
		}
		
		private function checkFirstCharge():void{
			if(vip.totalRecharge>0 && vip.firstCharge == NumberConst.getIns().negativeOne){
				vip.firstCharge = NumberConst.getIns().zero;
			}
		}
		
		public function setVipGet():void{
			checkVipReward();
		}
		
		private function checkVipReward() : void{
			for(var i:int = vipLv; i >= 1 ; i--){
				var giftId:int = NumberConst.getIns()["vipGet"+i];
				if(!checkVipGet(giftId)){
					PackManager.getIns().openBagRoomLock();
					getVipReward(giftId);
					LogManager.getIns().addGiftLog(giftId,"vipGet");
					GiftManager.getIns().addGiftVo(giftId);
					var prop:Prop = ConfigurationManager.getIns().getObjectByID(AssetsConst.PROP,giftId) as Prop;
					var message:Array = prop.message.split("：");
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						prop.name+",获得"+message[1]);
				}
				vipRepair(giftId);
			}
		}
		
		private function vipRepair(giftId:int) : void{
			if(giftId == NumberConst.getIns().vipGet4 && player.vipRepair != NumberConst.getIns().one){
				player.vipRepair = NumberConst.getIns().one;
				var giftPackage:GiftPackage = ConfigurationManager.getIns().getObjectByID(AssetsConst.GIFT_PACKAGE, NumberConst.getIns().vipGet4) as GiftPackage;
				if(giftPackage.gold > 0){
					PlayerManager.getIns().checkAdd("vip_money", giftPackage.gold, 10*10000);
					PlayerManager.getIns().addMoney(giftPackage.gold);
				}
				if(giftPackage.soul > 0){
					PlayerManager.getIns().checkAdd("vip_soul", giftPackage.gold, 10*10000);
					PlayerManager.getIns().addSoul(giftPackage.soul);
				}
				
				if(ViewFactory.getIns().getView(MainToolBar)){
					ViewFactory.getIns().getView(MainToolBar).update();
				}
				
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"VIP4奖励，金钱X320000、战魂X320000");
			}
		}
		
		private function checkVipGet(id:int):Boolean{
			var result:Boolean;
			for(var i:int = 0;i<gifts.length;i++){
				if(gifts[i].id == id){
					result = true;
					break;
				}
			}
			return result;
		}
		
		
		/**
		 *获得VIP奖励
		 * 
		 */
		private function getVipReward(id:int):void{
			var giftPackage:GiftPackage = ConfigurationManager.getIns().getObjectByID(AssetsConst.GIFT_PACKAGE,id) as GiftPackage;
			var items:Array = giftPackage.itemIds.split("|");
			var itemNums:Array = giftPackage.itemNums.split("|");
			var itemVos:Array = new Array();
			
			//VIP4获得2000成就，特殊处理
			if(id == NumberConst.getIns().vipGet4){
				player.signInVo.achievements += (NumberConst.getIns().oneThousand * NumberConst.getIns().two);
				player.vipRepair = NumberConst.getIns().one;
			}
			
			if(items[0] != 0){
				for(var index:int = 0; index<items.length; index++){
					var item:ItemVo = PackManager.getIns().creatItem(items[index]);
					item.num = itemNums[index];
					itemVos.push(item);
				}	
				for(var j:int = 0; j<itemVos.length; j++){
					itemVos[j].mid = PackManager.getIns().firstEmptyMid;
					PackManager.getIns().addItemIntoPack(itemVos[j]);
				}
			}
			
			if(giftPackage.gold > 0){
				PlayerManager.getIns().checkAdd("vip_money", giftPackage.gold, 10*10000);
				PlayerManager.getIns().addMoney(giftPackage.gold);
			}
			if(giftPackage.soul > 0){
				PlayerManager.getIns().checkAdd("vip_soul", giftPackage.gold, 10*10000);
				PlayerManager.getIns().addSoul(giftPackage.soul);
			}
			
			if(ViewFactory.getIns().getView(MainToolBar)){
				ViewFactory.getIns().getView(MainToolBar).update();
			}
		}
		
		protected function moneyPaid(event:Event):void
		{
			ShopManager.getIns().getBalance(getNewCoupon);
		}
		
		private function getNewCoupon(balance:int):void{
			PlayerManager.getIns().player.vip.curCoupon = balance;
			
			if(ViewFactory.getIns().getView(VipView) != null && !ViewFactory.getIns().getView(VipView).isClose){
				(ViewFactory.getIns().getView(VipView) as VipView).updateVip();
			}
			
			if(ViewFactory.getIns().getView(ShopView) != null && !ViewFactory.getIns().getView(ShopView).isClose){
				(ViewFactory.getIns().getView(ShopView) as ShopView).renderUI();
			}
		}
		

	}
}