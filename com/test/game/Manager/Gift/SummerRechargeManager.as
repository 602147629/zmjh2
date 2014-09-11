package com.test.game.Manager.Gift
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.BaGuaManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Summer.SummerGiftShowView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Configuration.SummerCarnival;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class SummerRechargeManager extends Singleton
	{
		private var _anti:Antiwear;
		public function get rechargeLv() : int{
			return _anti["rechargeLv"];
		}
		public function set rechargeLv(value:int) : void{
			_anti["rechargeLv"] = value;
		}
		public function get paiedLv() : int{
			return _anti["paiedLv"];
		}
		public function set paiedLv(value:int) : void{
			_anti["paiedLv"] = value;
		}
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public var testRecharge:int;
		
		public function SummerRechargeManager(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["rechargeLv"] = 0;
			_anti["paiedLv"] = 0;
		}
		
		public static function getIns():SummerRechargeManager{
			return Singleton.getIns(SummerRechargeManager);
		}
		
		public function sendData(type:int) : void{
			if(type == NumberConst.getIns().one){
				sendRecharge();
			}else{
				sendPaied();
			}
		}
		
		//获得暑假期间累计充值金额
		public function sendRecharge() : void{
			if(GameConst.localData){
				updateRecharge(1000000);
			}else{
				var dataObj:Object = new Object();
				dataObj.sDate = NumberConst.getIns().summerStartDate;
				dataObj.eDate = NumberConst.getIns().summerEndDate;
				ShopManager.getIns().getTotalRecharged(updateRecharge, dataObj);
			}
		}
		
		//更新暑假期间累计充值金额
		private function updateRecharge(total:int) : void{
			rechargeLv = getlv(total);
			DebugArea.getIns().showInfo("---累计充值等级为" + rechargeLv + "---"); 
			(ViewFactory.getIns().initView(SummerGiftShowView) as SummerGiftShowView).updateAll(total);
		}
		
		//获得暑假期间累计消费金额
		public function sendPaied() : void{
			if(GameConst.localData){
				updatePaied(1000000);
			}else{
				var dataObj:Object = new Object();
				dataObj.sDate = NumberConst.getIns().summerStartDate;
				dataObj.eDate = NumberConst.getIns().summerEndDate;
				ShopManager.getIns().getTotalPaied(updatePaied, dataObj);
			}
		}
		
		//更新暑假期间累计消费金额
		private function updatePaied(total:int) : void{
			paiedLv = getlv(total);
			DebugArea.getIns().showInfo("---累计消费等级为" + paiedLv + "---");
			(ViewFactory.getIns().initView(SummerGiftShowView) as SummerGiftShowView).updateAll(total);
		}
		
		private function getlv(total:int) : int{
			var result:int = NumberConst.getIns().zero;
			if(total >= NumberConst.getIns().oneHundred && total < NumberConst.getIns().fiveHundred){
				result = NumberConst.getIns().one;
			}else if(total >= NumberConst.getIns().fiveHundred && total < NumberConst.getIns().oneThousand){ 
				result = NumberConst.getIns().two;
			}else if(total >= NumberConst.getIns().oneThousand && total < NumberConst.getIns().fiveThousand){ 
				result = NumberConst.getIns().three;
			}else if(total >= NumberConst.getIns().fiveThousand && total < NumberConst.getIns().tenThousand){ 
				result = NumberConst.getIns().four;
			}else if(total >= NumberConst.getIns().tenThousand && total < NumberConst.getIns().twentyThousand){ 
				result = NumberConst.getIns().five;
			}else if(total >= NumberConst.getIns().twentyThousand && total < NumberConst.getIns().fiftyThousand){ 
				result = NumberConst.getIns().six;
			}else if(total >= NumberConst.getIns().fiftyThousand && total < NumberConst.getIns().oneHundredThousand){ 
				result = NumberConst.getIns().seven;
			}else if(total >= NumberConst.getIns().oneHundredThousand){
				result = NumberConst.getIns().eight;
			}
			return result;
		}
		
		public function onGetReward(showType:int, nowInfo:SummerCarnival) : void{
			var items:Array = new Array();
			items = checkRoom(showType, nowInfo);
			var message:String = "";
			if(items != null){
				var arr:Array = new Array();
				switch(showType){
					case NumberConst.getIns().one:
						arr = player.summerCarnivalInfo.summerRecharge;
						arr[nowInfo.id - 1] = NumberConst.getIns().one;
						player.summerCarnivalInfo.summerRecharge = arr;
						if(nowInfo.recharge_gold != NumberConst.getIns().zero){
							PlayerManager.getIns().addMoney(nowInfo.recharge_gold);
							message += "\n金钱X" + nowInfo.recharge_gold;
						}
						if(nowInfo.recharge_soul != NumberConst.getIns().zero){
							PlayerManager.getIns().addSoul(nowInfo.recharge_soul);
							message += "\n战魂X" + nowInfo.recharge_soul;
						}
						break;
					case NumberConst.getIns().two:
						arr = player.summerCarnivalInfo.summerConsume;
						arr[nowInfo.id - 1] = NumberConst.getIns().one;
						player.summerCarnivalInfo.summerConsume = arr;
						if(nowInfo.consume_gold != NumberConst.getIns().zero){
							PlayerManager.getIns().addMoney(nowInfo.consume_gold);
							message += "\n金钱X" + nowInfo.consume_gold;
						}
						if(nowInfo.consume_soul != NumberConst.getIns().zero){
							PlayerManager.getIns().addSoul(nowInfo.consume_soul);
							message += "\n战魂X" + nowInfo.consume_soul;
						}
						break;
				}
				for(var i:int = 0; i < items[0].length; i++){
					PackManager.getIns().addItemIntoPack(items[0][i]);
					message += "\n" + (items[0][i] as ItemVo).name + "X" + (items[0][i] as ItemVo).num;
				}
				if(items[1].length > 0){
					for(var j:int = 0; j < items[1].length; j++){
						BaGuaManager.getIns().addBaGuaIntoPack(items[1][j]);
					}
					message += "\n" + items[1][0].name + "X" + items[1].length;
				}
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("恭喜您获得"+ message);
				ViewFactory.getIns().getView(MainToolBar).update();
				SaveManager.getIns().onSaveGame();
			}
		}
		
		private function checkRoom(showType:int, nowInfo:SummerCarnival) : Array{
			var propID:Array = new Array();
			var propNum:Array = new Array();
			var items:Array = new Array();
			var baguaItems:Array = new Array();
			switch(showType){
				case NumberConst.getIns().one:
					propID = nowInfo.recharge_prop_id.split("|");
					propNum = nowInfo.recharge_prop_number.split("|");
					if(nowInfo.recharge_fashion != "0"){
						var rechargeIndex:int = int(nowInfo.recharge_fashion.split("|")[player.occupation - 1]);
						var rechargeFashionVo:ItemVo = PackManager.getIns().creatItem(rechargeIndex);
						items.push(rechargeFashionVo);
					}
					break;
				case NumberConst.getIns().two:
					propID = nowInfo.consume_prop_id.split("|");
					propNum = nowInfo.consume_prop_number.split("|");
					if(nowInfo.consume_fashion != "0"){
						var consumeIndex:int = int(nowInfo.consume_fashion.split("|")[player.occupation - 1]);
						var consumeFashionVo:ItemVo = PackManager.getIns().creatItem(consumeIndex);
						items.push(consumeFashionVo);
					}
					break;
			}
			for(var i:int; i < propID.length; i++){
				if(int(propID[i]) > 8000 && int(propID[i]) < 9000){
					var bagua:BaGuaPieceVo = BaGuaManager.getIns().creatLingQiBaGua(int(propID[i]));
					for(var j:int = 0; j < int(propNum[i]); j++){
						baguaItems.push(bagua.copy());
					}
					if(BaGuaManager.getIns().checkFull(int(propNum[i])) == -1){
						(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
							"八卦牌背包已满！请整理，否则无法获得八卦牌");
						return null;
					}
				}else if(int(propID[i]) >= 10000 && int(propID[i]) < 12000){
					var bossVo:ItemVo = PackManager.getIns().creatBossData(ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SPECIAL, "id", int(propID[i])).bid
						,int((int(propID[i]) - 10000) / 100) + 1);
					items.push(bossVo);
				}else{
					var itemVo:ItemVo = PackManager.getIns().creatItem(int(propID[i]));
					itemVo.num = int(propNum[i]);
					items.push(itemVo);
				}
			}
			if(!PackManager.getIns().checkMaxRooM(items)){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"背包空间不足！\n请留出空间后再使用");
				return null;
			}else{
				return new Array(items, baguaItems);
			}
		}
	}
}