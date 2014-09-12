package com.test.game.Manager
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Modules.MainGame.HeroFight.HeroFightResultView;
	import com.test.game.Modules.MainGame.HeroFight.HeroGameOverView;
	import com.test.game.Modules.MainGame.HeroScript.HeroScriptView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Configuration.Boss;
	import com.test.game.Mvc.Configuration.Player;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.key.GotoHeroBattleControl;
	
	public class HeroFightManager extends Singleton
	{
		private var _anti:Antiwear;
		private var _monsterArr:Array = new Array();
		public function get monsterArr() : Array{
			return _monsterArr;
		}
		public var resultArr:Array = new Array();
		public function get levelIndex() : int{
			return _anti["levelIndex"];
		}
		public function set levelIndex(value:int) : void{
			_anti["levelIndex"] = value;
		}
		public function get nowIndex() : int{
			return _anti["nowIndex"];
		}
		public function set nowIndex(value:int) : void{
			_anti["nowIndex"] = value;
		}
		public function get reliveCount() : int{
			return _anti["reliveCount"];
		}
		public function set reliveCount(value:int) : void{
			_anti["reliveCount"] = value;
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
		public function get heroFightType() : int{
			return _anti["heroFightType"];
		}
		public function set heroFightType(value:int) : void{
			_anti["heroFightType"] = value;
		}
		public function get heroFightMonsterID() : int{
			return _anti["heroFightMonsterID"];
		}
		public function set heroFightMonsterID(value:int) : void{
			_anti["heroFightMonsterID"] = value;
		}
		
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public function HeroFightManager(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["nowIndex"] = 0;
			_anti["reliveCount"] = 0;
			_anti["soul"] = 0;
			_anti["exp"] = 0;
			_anti["money"] = 0;
			_anti["heroFightType"] = 0;
			_anti["heroFightMonsterID"] = 0;
		}
		
		public static function getIns():HeroFightManager{
			return Singleton.getIns(HeroFightManager);
		}
		
		//初始化数据
		public function init() : void{
			reliveCount = NumberConst.getIns().zero;
			nowIndex = NumberConst.getIns().zero;
			resultArr.length = NumberConst.getIns().zero;
			_monsterArr.length = NumberConst.getIns().zero;
			initMonsterID();
		}
		
		public function startHeroFight(level:int) : void{
			if(player.heroScriptVo.heroFightNum < NumberConst.getIns().three){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice("是否开始挑战？",
					function () : void{
						heroFightType = NumberConst.getIns().zero;
						HeroFightManager.getIns().levelIndex = level;
						if(GameConst.localData){
							lastStartHeroFight();
						}else{
							SaveManager.getIns().onJudgeMulti(lastStartHeroFight);
						}
					});
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("挑战次数不足，无法挑战");
			}
		}
		
		private function lastStartHeroFight() : void{
			player.heroScriptVo.heroFightNum++;
			(ControlFactory.getIns().getControl(GotoHeroBattleControl) as GotoHeroBattleControl).goToBattle();
			ViewFactory.getIns().getView(HeroScriptView).hide();
			SaveManager.getIns().onSaveGame();
			DebugArea.getIns().showInfo("---当前列传挑战次数：" + player.heroScriptVo.heroFightNum + "---");
		}
		
		public function startHeroSpecailFight(monsterID:int) : void{
			heroFightMonsterID = monsterID;
			if(player.heroScriptVo.heroSpecialFightNum < NumberConst.getIns().one){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice("是否开始挑战？",
					function () : void{
						if(GameConst.localData){
							player.heroScriptVo.heroSpecialFightNum++;
							lastStartSpecialHeroFight();
						}else{
							(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
								"系统正在处理当中，请稍等...",null,null,true);
							SaveManager.getIns().onJudgeMulti(
								function () : void{
									player.heroScriptVo.heroSpecialFightNum++;
									lastStartSpecialHeroFight();
								});
						}
					});
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice("是否花费299点券开始挑战？", startBuyHeroFight);
			}
		}
		
		private function startBuyHeroFight() : void{
			if(GameConst.localData){
				buyHeroFight({balance:1000000});
			}else{
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"系统正在处理当中，请稍等...",null,null,true);
				SaveManager.getIns().onJudgeMulti(
					function () : void{
						var data:Object = {propId:NumberConst.getIns().heroFightID.toString(),count:1,price:NumberConst.getIns().heroFightCoupon,idx:PlayerManager.getIns().player.index,tag:"buyHeroFight"};
						ShopManager.getIns().buyPropNd(data, buyHeroFight);
					});
			}
		}
		
		private function buyHeroFight(data:Object) : void{
			PlayerManager.getIns().player.vip.curCoupon = data.balance;
			lastStartSpecialHeroFight();
			SaveManager.getIns().onSaveGame();
		}
		
		private function lastStartSpecialHeroFight() : void{
			ViewFactory.getIns().getView(TipViewWithoutCancel).hide();
			heroFightType = NumberConst.getIns().one;
			(ControlFactory.getIns().getControl(GotoHeroBattleControl) as GotoHeroBattleControl).goToBattle();
			ViewFactory.getIns().getView(HeroScriptView).hide();
			DebugArea.getIns().showInfo("---当前外传挑战次数：" + player.heroScriptVo.heroSpecialFightNum + "---");
		}
		
		//初始化Boss的ID
		private function initMonsterID() : void{
			if(heroFightType == NumberConst.getIns().zero){
				var result:Array = new Array();
				result.push(levelIndex);
				var index:int = result[int(Math.random() * result.length)];
				var arr:Array = new Array();
				for(var i:int = 1; i < 5; i++){
					arr.push(6000 + index * 10 + i);
				}
				for(var j:int = 0; j < 3; j++){
					var now:int = int(arr.length * Math.random());
					_monsterArr.push(arr[now]);
					arr.splice(now, 1);
				}
			}else if(heroFightType == NumberConst.getIns().one){
				_monsterArr.push(heroFightMonsterID);
			}
		}
		
		//根据Boss数组创建Boss
		public function createMonster() : Vector.<MonsterEntity>{
			var result:Vector.<MonsterEntity> = new Vector.<MonsterEntity>();
			result.push(RoleManager.getIns().createMonster(_monsterArr[nowIndex], 830, 400, player.character.lv));
			if(_monsterArr[nowIndex] == 6023){
				result.push(RoleManager.getIns().createMonster(6029, 830, 450, player.character.lv));
			}
			return result;
		}
		
		//怪物索引是否达到数组长度
		public function addIndex() : Boolean{
			nowIndex++;
			if(nowIndex >= _monsterArr.length){
				return true;
			}else{
				return false;
			}
		}
		
		//游戏结束
		public function heroPlayerDeath() : void{
			ViewFactory.getIns().initView(HeroGameOverView).show();
		}
		
		//战斗结束
		public function heroFightOver() : void{
			calculateBossData();
			addBossCard();
			addOtherData();
			ViewFactory.getIns().initView(HeroFightResultView).show();
			SaveManager.getIns().onSaveGame();
		}

		private function addOtherData() : void{
			var obj:Player = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.PLAYER, "lv", player.character.lv) as Player;
			if(heroFightType == NumberConst.getIns().zero){
				exp = obj.dailyexp / NumberConst.getIns().two * nowIndex;
				soul = obj.dailysoul / NumberConst.getIns().two * nowIndex;
				money = obj.dailygold / NumberConst.getIns().two * nowIndex;
			}else if(heroFightType == NumberConst.getIns().one){
				exp = obj.dailyexp;
				soul = obj.dailysoul;
				money = obj.dailygold;
			}
			PlayerManager.getIns().addExp(exp);
			PlayerManager.getIns().addSoul(soul);
			PlayerManager.getIns().addMoney(money);
		}
		
		//计算奖励
		private function calculateBossData() : void{
			var boss:Boss;
			for(var i:int = 0; i < nowIndex; i++){
				var random:Number = Math.random();
				var index:int = 0;
				var target:Number;
				if(heroFightType == NumberConst.getIns().zero){
					for(var j:int = 8; j >= 0; j--){
						target = 1 / Math.pow(2, j);
						if(random <= target){
							if(j == 8 || j == 0){
								index = Math.floor(Math.random() * NumberConst.getIns().three);
							}else{
								index = j + NumberConst.getIns().two;
							}
							break;
						}
					}
				}else if(heroFightType == NumberConst.getIns().one){
					player.heroScriptVo.heroSpecialFightCount++;
					if(player.heroScriptVo.heroSpecialFightCount >= NumberConst.getIns().six * NumberConst.getIns().ten){
						index = NumberConst.getIns().six * NumberConst.getIns().two;
						player.heroScriptVo.heroSpecialFightCount = NumberConst.getIns().zero;
					}else{
						for(var k:int = 6; k >= 0; k--){
							target = 1 / Math.pow(2, k);
							if(random < target){
								index = k + NumberConst.getIns().six;
								break;
							}
						}
					}
				}
				var last:int = _monsterArr[i] - NumberConst.getIns().oneThousand * NumberConst.getIns().six + index * NumberConst.getIns().oneHundred + NumberConst.getIns().tenThousand;
				resultArr.push(last);
			}
		}
		
		//添加卡牌
		private function addBossCard() : void{
			for(var i:int = 0; i < resultArr.length; i++){
				/*var itemVo:ItemVo = PackManager.getIns().creatBossData(ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SPECIAL, "id", int(resultArr[i])).bid
					,int((int(resultArr[i]) - 10000) / 100) + 1);*/
				var itemVo:ItemVo = PackManager.getIns().creatBossDataBySpecial(resultArr[i]);
				itemVo.num = NumberConst.getIns().one;
				PackManager.getIns().addItemIntoPack(itemVo);
			}
		}
	}
}