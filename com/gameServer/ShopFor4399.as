package com.gameServer
{
	import com.superkaka.Tools.DebugArea;
	import com.test.game.Const.DebugConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Event.ServerEvent;
	import com.test.game.Manager.ShopManager;
	
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import unit4399.events.PayEvent;
	import unit4399.events.ShopEvent;
	
	public class ShopFor4399 extends EventDispatcher
	{
		public var serviceHold:*;
		private var _stage:Stage;
		private static var _instance : ShopFor4399;
		
		public static function getIns():ShopFor4399
		{
			if(_instance == null){
				_instance = new ShopFor4399();
			}
			return _instance;
		}
		
		public function ShopFor4399(target:IEventDispatcher=null)
		{
			super();
		}
		
		
		public function get stage() : Stage
		{
			return _stage;
		}
		public function set stage(value:Stage) : void
		{
			_stage = value;
			
			serviceHold = Main.serviceHold;
			//initInfoTxt();
			initEvent();
		}
		
		private function initEvent() : void
		{
			stage.addEventListener("usePayApi",onPayEventHandler);
			stage.addEventListener(PayEvent.GET_MONEY,onPayEventHandler);
			stage.addEventListener(PayEvent.PAY_MONEY,onPayEventHandler);
			stage.addEventListener(PayEvent.PAIED_MONEY,onPayEventHandler);
			stage.addEventListener(PayEvent.RECHARGED_MONEY,onPayEventHandler);
			stage.addEventListener(PayEvent.PAY_ERROR,onPayEventHandler);
			　　
			stage.addEventListener(ShopEvent.SHOP_ERROR_ND,onShopEventHandler);
			stage.addEventListener(ShopEvent.SHOP_BUY_ND,onShopEventHandler);
			stage.addEventListener(ShopEvent.SHOP_GET_LIST,onShopEventHandler);
			
			ShopManager.getIns().initEvent();
		}
		
		private function onPayEventHandler(e:PayEvent):void{
			switch(e.type){
				case "usePayApi":
					//收到该事件，表明支付接口可以正常使用了
					trace("可以正常使用支付API");
					this.stage.dispatchEvent(new ServerEvent(EventConst.USE_PAY_API_SHOP, e.data));
					break;
				case "getMoney":
					if(e.data!==null&&!(e.data is Boolean)){
						trace("获取游戏币余额为："+e.data.balance);
						DebugArea.getIns().showInfo("---获取余额成功！---" + e.data.balance, DebugConst.NORMAL);
						this.stage.dispatchEvent(new ServerEvent(EventConst.GET_MONEY_SHOP, e.data));
						break;
					}
					DebugArea.getIns().showInfo("---获取余额错误！" + !(e.data is Boolean) + "---" + e.data + "---", DebugConst.ERROR);
					trace("获取游戏币余额错误！");
					break;
				case "payMoney":
					trace("充值游戏币失败");
					this.stage.dispatchEvent(new ServerEvent(EventConst.PAY_MONEY_SHOP, e.data));
					break;
				case "paiedMoney":
					if(e.data!==null&&!(e.data is Boolean)){
						trace("获取累积消费的游戏币为："+e.data.balance);
						this.stage.dispatchEvent(new ServerEvent(EventConst.PAID_MONEY_SHOP, e.data));
						break;
					}
					trace("获取累积消费的游戏币错误！");
					break;
				case "rechargedMoney":
					if(e.data!==null&&!(e.data is Boolean)){
						trace("获取累积充值的游戏币为："+e.data.balance);
						//DebugArea.getIns().showInfo("---获取累积充值的游戏币为：" + e.data.balance + "---", DebugConst.NORMAL);
						this.stage.dispatchEvent(new ServerEvent(EventConst.RECHARGED_MONEY_SHOP, e.data));
						break;
					}
					DebugArea.getIns().showInfo("---获取累积充值的游戏币错误！---", DebugConst.ERROR);
					trace("获取累积充值的游戏币错误！");
					break;
				case "payError":
					/*
					0|请重试!若还不行,请重新登录!!
					1|程序有问题，请联系技术人员100584399!!
					2|请检查,目前传进来的值等于0!!
					3|游戏不存在或者没有支付接口!!
					5|出错了,请重新登录!
					6|日期或者时间的格式出错了!!'
					*/
					if(e.data==null) break;
					trace("使用支付接口其他错误----->" + e.data.info);
					this.stage.dispatchEvent(new ServerEvent(EventConst.PAY_ERROR_SHOP, e.data));
					break;
			}
		}
		　　
		private function onShopEventHandler(evt:ShopEvent):void{
			switch(evt.type){
				case ShopEvent.SHOP_ERROR_ND:
					errorFun(evt.data);
					this.stage.dispatchEvent(new ServerEvent(EventConst.SHOP_ERROR_ND, evt.data));
					break;
				case ShopEvent.SHOP_BUY_ND:
					buySuccFun(evt.data);
					this.stage.dispatchEvent(new ServerEvent(EventConst.SHOP_BUY_ND, evt.data));
					break;
				case ShopEvent.SHOP_GET_LIST:
					getSuccFun(evt.data as Array);
					this.stage.dispatchEvent(new ServerEvent(EventConst.SHOP_GET_LIST, evt.data));
					break;
			}
		}
		　　
		private function errorFun(error:Object):void{
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
			
			trace("eId:" + error.eId + "  message:" + error.msg + "\n");
		}
		　　
		private function getSuccFun(data:Array):void{
			if(data == null){
				trace("获取物品列表时，返回空值了\n");
				return;
			}
			　　 
			if(data.length == 0){
				trace("无商品列表\n");
				return;
			}
			　　 
			for(var i in data){
				var propData:Object = data[i];
				trace("propNum:" + i + "  propId:" + propData.propId + "  price:" + propData.price + "   propType:" + propData.propType + "\n");
				//判断物品是否有活动
				if(propData.propAction != null)
				{
					//物品的活动信息
					var propAction:Object = propData.propAction;
					/*
					propAction.type //int类型,表示活动类型,参数(10:限量,20:限时,30:折扣,12:限量限时,13:限量折扣,23:限时折扣,40:限时限量折扣)
					propAction.state //int类型,表示活动状态,参数(1:进行,0:结束)
					propAction.count //int类型,表示限量活动的限量个数
					propAction.surplusCount //int类型,表示限量活动剩余购买数量
					propAction.startDate // int类型,表示限时活动开始时间戳(精确到天,以秒为单位)
					propAction.endDate //int类型,表示限时活动结束时间戳(精确到天,以秒为单位)
					propAction.discount //Number类型,表示活动折扣(区间为50-99)
					propAction.regularPrice //int类型,原价
					*/
				}
			}
		}
		　　
		private function buySuccFun(data:Object):void{
			trace("propId:" + data.propId + "  count:" + data.count + "   balance:" + data.balance + "   tag:" + data.tag+"\n");
		}
		
		private var payMoneyVar:PayMoneyVar = PayMoneyVar.getInstance();
		//游戏充值
		public function payMoney(value:int) : void{
			var payMoneyVar:PayMoneyVar = PayMoneyVar.getInstance();
			payMoneyVar.money = value;
			if(serviceHold){
				serviceHold.payMoney_As3(payMoneyVar);
			}
		}
		
		//获取余额
		public function getBalance() : void{
			if(serviceHold){
				DebugArea.getIns().showInfo("---发送获取余额请求---", DebugConst.NORMAL);
				serviceHold.getBalance();
			}
		}
		
		//获取商城列表
		public function getShopList() : void{
			if(serviceHold){
				serviceHold.getShopList();
			}
		}
		
		//购买物品
		public function buyPropNd(dataObj:Object) : void{
			if(serviceHold){
				serviceHold.buyPropNd(dataObj);
			}
		}
		
		//获取累积消费的游戏币
		public function getTotalPaiedFun(dateObj:Object = null) : void{
			if(serviceHold){
				serviceHold.getTotalPaiedFun(dateObj);
			}
		}
		
		//获取累积充值的游戏币
		public function getTotalRechargedFun(dateObj:Object = null) : void{
			if(serviceHold){
				if(dateObj == null){
					serviceHold.getTotalRechargedFun();
				}else{
					serviceHold.getTotalRechargedFun(dateObj);
				}
			}
		}
	}
}