package com.test.game.Manager
{
	import com.greensock.TweenLite;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.Map.GetItemIconEntity;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Modules.MainGame.Gift.GiftView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Configuration.GiftPackage;
	import com.test.game.Mvc.Configuration.Prop;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.Mvc.Vo.GiftVo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.geom.Point;
	
	public class GiftManager extends Singleton
	{
		public function GiftManager()
		{
			super();
		}
		
		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}

		
		public static function getIns():GiftManager{
			return Singleton.getIns(GiftManager);
		}
		
		public function addGift(giftId:int, isShow:Boolean = true):void{
			if(giftId>=NumberConst.getIns().levelGiftId_20 
				&& giftId<=NumberConst.getIns().openingGiftId){
				var gift:ItemVo = PackManager.getIns().creatItem(giftId);
				
				PackManager.getIns().addItemIntoPack(gift);
				GiftManager.getIns().addGiftVo(giftId);
				LogManager.getIns().addGiftLog(giftId,"gift");
				DeformTipManager.getIns().checkGiftDeform();
				if(ViewFactory.getIns().getView(GiftView) != null){
					EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.GIFTVIEW_UPDATE));	
					if(isShow){
						(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
							"恭喜获得"+gift.name+"\n\n已放入背包，请查收");
					}
				}
			}
		}
		
		
		/**
		 *发放VIP礼包给玩家 
		 * 
		 */		
		public function addVipDailyGift():void{
			var giftId:int;
			switch(ShopManager.getIns().vipLv){
				case NumberConst.getIns().one:
					giftId = NumberConst.getIns().vipGift1;
					break;
				case NumberConst.getIns().two:
					giftId = NumberConst.getIns().vipGift2;
					break;
				case NumberConst.getIns().three:
					giftId = NumberConst.getIns().vipGift3;
					break;
				case NumberConst.getIns().four:
					giftId = NumberConst.getIns().vipGift4;
					break;
				case NumberConst.getIns().five:
					giftId = NumberConst.getIns().vipGift5;
					break;
			}
			
			if(GiftManager.getIns().useGift(giftId,false)){
				player.vip.isVipGiftGet = true;
				player.vip.vipGiftGetTime = TimeManager.getIns().returnTimeNowStr();
			}
			
		}


		
		//添加已领取礼包信息进人物数据
		public function addGiftVo(id:int):void{
			var gift:GiftVo = new GiftVo();
			gift.id = id;
			gift.isGet = true;
			gift.getTime = TimeManager.getIns().returnTimeNowStr();
			var arr:Array = player.gift;
			arr.push(gift);
			player.gift = arr;
		}
		

		
		//检查人物数据中的礼包是否可以被领取
		public function checkGift(id:int):int{
			
			var nowDate:String = TimeManager.getIns().returnTimeNowStr().split(" ")[0];
			
			for(var i:int = 0; i < player.gift.length; i++)
			{
				if(player.gift[i].id == id && player.gift[i].isGet == true){
					return NumberConst.getIns().one;
					break;
				}
			}
			
			if(id == NumberConst.getIns().openingGiftId){
				if(!TimeManager.getIns().checkDate(NumberConst.getIns().openingGiftDate)){
					return NumberConst.getIns().negativeTwo;
				}
			}
			
			if(id == NumberConst.getIns().returnGiftId){
				if(!TimeManager.getIns().checkDate(NumberConst.getIns().returnGiftDate)){
					return NumberConst.getIns().negativeTwo;
				}
			}
			
			if(id == NumberConst.getIns().wuYiGiftId){

				var day:int = TimeManager.getIns().disDayNum(NumberConst.getIns().wuYiGiftDate,nowDate);
				if(day>0 || day<-7){
					return NumberConst.getIns().negativeTwo;
				}
			}
			
			if(id == NumberConst.getIns().duanwuGiftId){
				//var test:String = "2014-06-10 11:28:15";
				var duanwuDay:int = TimeManager.getIns().disDayNum(NumberConst.getIns().duanwuGiftDate,nowDate);
				if(duanwuDay>0 || duanwuDay<-12){
					return NumberConst.getIns().negativeTwo;
				}
			}
			
			if(id == NumberConst.getIns().tenYearsGiftId){
				var tenYears:int = TimeManager.getIns().disDayNum(NumberConst.getIns().tenYearsGiftDate,nowDate);
				if(tenYears>0 || tenYears<-13){
					return NumberConst.getIns().negativeTwo;
				}
			}
			
			if(id == NumberConst.getIns().fiveYearsGiftId){
				var fiveYears:int = TimeManager.getIns().disDayNum(NumberConst.getIns().fiveYearsGiftDate,nowDate);
				if(fiveYears>0 || fiveYears<-6){
					return NumberConst.getIns().negativeTwo;
				}
			}
			
			if(id == NumberConst.getIns().zhongQiuGiftId){
				var zhongQiu:int = TimeManager.getIns().disDayNum(NumberConst.getIns().zhongQiuGiftDate, nowDate);
				if(zhongQiu > 0 || zhongQiu < -NumberConst.getIns().zhongQiuDay){
					return NumberConst.getIns().negativeTwo;
				}
			}
			
			return NumberConst.getIns().zero;
		}
		
		
		
		/**
		 *使用礼包 
		 * @param itemVo
		 *  hasItem 是否清除背包里的对应物品
		 * 
		 */
		public function useGift(id:int,hasItem:Boolean = true):Boolean{
			var isGet:Boolean = false;
			var prop:Prop = ConfigurationManager.getIns().getObjectByID(AssetsConst.PROP,id) as Prop;
			var giftPackage:GiftPackage = ConfigurationManager.getIns().getObjectByID(AssetsConst.GIFT_PACKAGE,id) as GiftPackage;
			var items:Array = giftPackage.itemIds.split("|");
			var itemNums:Array = giftPackage.itemNums.split("|");
			var itemVos:Array = new Array();
			var baguaVos:Array = new Array();
			var hasBaGua:Boolean;
			if(items[0]!=0){
				for(var index:int = 0; index<items.length; index++){
					var item:ItemVo;
					if(int(items[index])>10000){
						item = PackManager.getIns().creatBossData(
							ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SPECIAL, "id", int(items[index])).bid
							,int((int(items[index]) - 10000) / 100) + 1);
						itemVos.push(item);
					}else if(int(items[index])>8000 && int(items[index])<9000){
						hasBaGua = true;
						var bagua:BaGuaPieceVo = BaGuaManager.getIns().creatLingQiBaGua(int(items[index]));
						baguaVos.push(bagua);
					}else{
						item = PackManager.getIns().creatItem(items[index]);
						item.num = itemNums[index];
						itemVos.push(item);
					}
					
				}	
			}
			
			if(PackManager.getIns().checkMaxRooM(itemVos,true) == false){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"背包空间不足！\n请留出空间后再使用");
				return false;
			}
			
			if(hasBaGua && BaGuaManager.getIns().checkFull() < 0){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"八卦背包空间不足！\n请留出空间后再使用");
				return false;
			}
			
			isGet = true;
			for each(var itemVo:ItemVo in itemVos){
				if((itemVo.id == NumberConst.getIns().gaoShouCard 
					|| itemVo.id == NumberConst.getIns().wanNengId
					|| itemVo.id == NumberConst.getIns().wanNengKeyId
					|| itemVo.id == NumberConst.getIns().refreshCouponId
					|| itemVo.id == NumberConst.getIns().lifeCoinId)){
					LogManager.getIns().addMissionLog(id+"gift_"+itemVo.id,itemVo.num);
				}
			}
			
			
			for(var j:int = 0; j<itemVos.length; j++){
				itemVos[j].mid = PackManager.getIns().firstEmptyMid;
				PackManager.getIns().addItemIntoPack(itemVos[j]);
				
				TweenLite.delayedCall(j * .1, addDropItem, [itemVos[j]]);
			}
			for(var k:int = 0; k<baguaVos.length; k++){
				BaGuaManager.getIns().addBaGuaIntoPack(baguaVos[k]);
				
				TweenLite.delayedCall(k * .1, addDropItem, [baguaVos[k]]);
			}
			var message:Array = prop.message.split("：");
			(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
				giftPackage.name+"获得"+message[1], function () : void{GuideManager.getIns().bagGuideSetting();});
			
			if(giftPackage.gold>0){
				PlayerManager.getIns().checkAdd("gift_money",giftPackage.gold,10000);
				PlayerManager.getIns().addMoney(giftPackage.gold);
				addDropItem({type:"Weather",id:"Money",num:giftPackage.gold});
			}
			if(giftPackage.soul>0){
				PlayerManager.getIns().checkAdd("gift_soul",giftPackage.soul,10000);
				PlayerManager.getIns().addSoul(giftPackage.soul);
				addDropItem({type:"Weather",id:"Soul",num:giftPackage.soul});
			}
			ViewFactory.getIns().getView(MainToolBar).update();
			
			if(hasBaGua && !HideMissionManager.getIns().returnHideMissionComplete(3012)){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"当前八卦盘尚未开启！灵气牌将在通关太虚观隐藏副本得到八卦盘之后进入八卦背包里");
			}
			
			if(hasItem){
				PackManager.getIns().reduceItem(id,NumberConst.getIns().one);
			}
			
			GuideManager.getIns().bagGuideSetting();
			DeformTipManager.getIns().allCheck();

			
			return isGet;
			
		}
		private var _endPos:Point;
		private var _direct:int = 1;
		private function addDropItem(item:*) : void{

			var fodder:String = item.type+item.id;
			var name:String = ""
			var num:int;
			if(item.hasOwnProperty("num")){
				num = Math.max(1,item.num/2);
				if(num>4){
					num=4;
				}
			}else{
				num = 1;
			}
			for(var i:int=0;i<num;i++){
				TweenLite.delayedCall(i * .3,
					function():void{
						var dropEntity:GetItemIconEntity = new GetItemIconEntity(fodder, _direct);
						LayerManager.getIns().gameTipLayer.addChild(dropEntity);
						_direct = -_direct;
					}
				);
			}
			
			
		}

		
	}
}