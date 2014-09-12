package com.test.game.Manager
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.Map.ItemIconEntity;
	import com.test.game.Modules.MainGame.Activity.FunnyBossView;
	import com.test.game.Modules.MainGame.HeroFight.HeroFightResultView;
	import com.test.game.Modules.MainGame.HeroFight.HeroGameOverView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Configuration.Boss;
	import com.test.game.Mvc.Configuration.Player;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.key.GotoFunnyBattleControl;
	
	public class FunnyBossManager extends Singleton
	{
		private var _anti:Antiwear;
		public function get funnyBossType() : int{
			return _anti["funnyBossType"];
		}
		public function set funnyBossType(value:int) : void{
			_anti["funnyBossType"] = value;
		}
		public function get exp() : int{
			return _anti["exp"];
		}
		public function set exp(value:int) : void{
			_anti["exp"] = value;
		}
		public function get soul() : int{
			return _anti["soul"];
		}
		public function set soul(value:int) : void{
			_anti["soul"] = value;
		}
		public function get money() : int{
			return _anti["money"];
		}
		public function set money(value:int) : void{
			_anti["money"] = value;
		}
		public function get reliveCount() : int{
			return _anti["reliveCount"];
		}
		public function set reliveCount(value:int) : void{
			_anti["reliveCount"] = value;
		}
		
		public var resultArr:Array = new Array();
		public function FunnyBossManager()
		{
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["funnyBossType"] = 0;
			_anti["exp"] = 0;
			_anti["soul"] = 0;
			_anti["money"] = 0;
			_anti["reliveCount"] = 0;
			_anti["hasTuZi"] = false;
		}
		
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public static function getIns():FunnyBossManager{
			return Singleton.getIns(FunnyBossManager);
		}
		
		public function init() : void{
			resultArr.length = NumberConst.getIns().zero;
			reliveCount = NumberConst.getIns().zero;
		}
		
		public function startFunnyBoss() : void{
			if(player.statisticsInfo.funnyBossCount < NumberConst.getIns().one){
				(ViewFactory.getIns().initView(TipView) as TipView).setFun("是否开始挑战？",
					function () : void{
						if(GameConst.localData){
							lastStartFunnyBoss();
						}else{
							SaveManager.getIns().onJudgeMulti(lastStartFunnyBoss);
						}
						
					});
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice("是否花费250点券开始挑战？", startBuyFunnyBoss);
			}
		}
		
		private function lastStartFunnyBoss() : void{
			ViewFactory.getIns().getView(FunnyBossView).hide();
			player.statisticsInfo.funnyBossCount++;
			(ControlFactory.getIns().getControl(GotoFunnyBattleControl) as GotoFunnyBattleControl).goToBattle();
			SaveManager.getIns().onSaveGame();
		}
		
		private function startBuyFunnyBoss() : void{
			if(GameConst.localData){
				buyFunnyBossFight({balance:1000000});
			}else{
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"系统正在处理当中，请稍等...",null,null,true);
				SaveManager.getIns().onJudgeMulti(
					function () : void{
						var data:Object = {propId:NumberConst.getIns().funnyBossID.toString(),count:1,price:NumberConst.getIns().funnyBossCoupon,idx:PlayerManager.getIns().player.index,tag:"buyFunnyBoss"};
						ShopManager.getIns().buyPropNd(data, buyFunnyBossFight);
					});
			}
		}
		
		private function buyFunnyBossFight(data:Object) : void{
			ViewFactory.getIns().getView(TipViewWithoutCancel).hide();
			PlayerManager.getIns().player.vip.curCoupon = data.balance;
			ViewFactory.getIns().getView(FunnyBossView).hide();
			(ControlFactory.getIns().getControl(GotoFunnyBattleControl) as GotoFunnyBattleControl).goToBattle();
			SaveManager.getIns().onSaveGame();
		}
		
		public function createMonster() : Vector.<MonsterEntity>{
			funnyBossType = int(Math.random() * 2);
			var result:Vector.<MonsterEntity> = new Vector.<MonsterEntity>();
			result.push(RoleManager.getIns().createMonster(1021 + funnyBossType, 700, 400, NumberConst.getIns().fifty));
			return result;
		}
		
		public function funnyPlayerDeath() : void{
			ViewFactory.getIns().initView(HeroGameOverView).show();
		}
		
		public function funyFailureOver() : void{
			ViewFactory.getIns().initView(HeroFightResultView).show();
			SaveManager.getIns().onSaveGame();
		}
		
		public function funnyBossOver() : void{
			calculateBossData();
			addBossCard();
			addMoonCake();
			addOtherData();
			ViewFactory.getIns().initView(HeroFightResultView).show();
			SaveManager.getIns().onSaveGame();
		}
		
		private function addMoonCake() : void{
			var itemVo:ItemVo = PackManager.getIns().creatItem(NumberConst.getIns().moonCakeId);
			itemVo.num = NumberConst.getIns().one;
			PackManager.getIns().addItemIntoPack(itemVo);
		}
		
		//计算奖励
		private function calculateBossData() : void{
			var boss:Boss;
			var random:Number = Math.random();
			var index:int = 0;
			var target:Number;
			for(var k:int = 6; k >= 0; k--){
				target = 1 / Math.pow(2, k);
				if(random < target){
					index = k + NumberConst.getIns().six;
					break;
				}
			}
			var last:int = 10073 + funnyBossType + index * NumberConst.getIns().oneHundred;
			resultArr.push(last);
		}
		 
		//添加卡牌
		private function addBossCard() : void{
			for(var i:int = 0; i < resultArr.length; i++){
				var itemVo:ItemVo = PackManager.getIns().creatBossDataBySpecial(resultArr[i]);
				itemVo.num = NumberConst.getIns().one;
				PackManager.getIns().addItemIntoPack(itemVo);
			}
		}
		
		private function addOtherData() : void{
			var obj:Player = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.PLAYER, "lv", player.character.lv) as Player;
			exp = obj.dailyexp;
			soul = obj.dailysoul;
			money = obj.dailygold;
			PlayerManager.getIns().addExp(exp);
			PlayerManager.getIns().addSoul(soul);
			PlayerManager.getIns().addMoney(money);
		}
		
	}
}