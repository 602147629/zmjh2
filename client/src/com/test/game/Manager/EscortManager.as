package com.test.game.Manager
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.CharacterType;
	import com.test.game.Const.EscortEventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.Map.ItemIconEntity;
	import com.test.game.Entitys.Monsters.EscortEntity;
	import com.test.game.Modules.MainGame.Escort.EscortResultView;
	import com.test.game.Modules.MainGame.Escort.EscortView;
	import com.test.game.Modules.MainGame.Escort.LootResultView;
	import com.test.game.Modules.MainGame.Escort.LootWaitView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.BmdView.EscortSceneView;
	import com.test.game.Mvc.BmdView.LootSceneView;
	import com.test.game.Mvc.Configuration.VehicleEscort;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.Escort.EscortControl;
	import com.test.game.Mvc.control.View.GameSceneControl;
	import com.test.game.Mvc.control.net.socket.SocketsSendControl;
	import com.test.game.net.sm.Escort.CancelMatchEscort;
	import com.test.game.net.sm.Escort.MatchEscort;
	import com.test.game.net.sm.Escort.MatchEscortUpdate;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	
	public class EscortManager extends Singleton
	{
		public var isGameOver:Boolean;
		public var gainData:Object;
		public var startMatchEscortFun:Function;
		public var cancelMatchEscortFun:Function;
		
		public var isEscort:uint = 1;
		
		public var matchComplete:Boolean;
		private var _anti:Antiwear;
		private var _escortDate:Date;
		private var _lootDate:Date;
		public var canEscort:Boolean = true;
		public var canLoot:Boolean = true;
		public var lastEscortTime:int = 0;
		public function get escortHpRate() : Number{
			return _anti["escortHpRate"];
		}
		public function set escortHpRate(value:Number) : void{
			_anti["escortHpRate"] = value;
		}
		public function get escortReduceHpRate() : Number{
			return _anti["escortReduceHpRate"];
		}
		public function set escortReduceHpRate(value:Number) : void{
			_anti["escortReduceHpRate"] = value;
		}
		public function get killCount() : int{
			return _anti["killCount"];
		}
		public function set killCount(value:int) : void{
			_anti["killCount"] = value;
		}
		public function get nowBiaoChe() : int{
			return _anti["nowBiaoChe"];
		}
		public function set nowBiaoChe(value:int) : void{
			_anti["nowBiaoChe"] = value;
		}
		public function get finalRate() : Number{
			return _anti["finalRate"];
		}
		public function set finalRate(value:Number) : void{
			_anti["finalRate"] = value;
		}
		public function get biaoCheSpeed() : Number{
			return _anti["biaoCheSpeed"];
		}
		public function set biaoCheSpeed(value:Number) : void{
			_anti["biaoCheSpeed"] = value;
		}
		public var biaoCheInfo:VehicleEscort;
		public var levelData:Object;
		public var nowIndex:String;
		public var mapType:int;
		public var extraMoney:int;
		public var extraSoul:int;
		public var extraMaterial:Vector.<ItemVo> = new Vector.<ItemVo>();
		private var _timeStep:int;
		private var _timeCount:int;
		private var _monsterCount:int;
		private var _prePos:Point = new Point();
		private var _monsters:Array = new Array();
		private var _monsterTimes:Array = new Array();
		private var _monsterLibrary:Array = new Array();
		private var _monsterEliteLibrary:Array = new Array();
		
		public function EscortManager(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["nowBiaoChe"] = 1;
			_anti["killCount"] = 0;
			_anti["escortHpRate"] = 0;
			_anti["finalRate"] = 0;
			_anti["escortReduceHpRate"] = 0;
			_anti["biaoCheSpeed"] = 0;
			EventManager.getIns().EventDispather.addEventListener(EscortEventConst.START_ESCORT, startMatchEscortSuccess);
			EventManager.getIns().EventDispather.addEventListener(EscortEventConst.CANCEL_MATCH_ESCORT, cancelMatchEscortSuccess);
		}

		public static function getIns():EscortManager{
			return Singleton.getIns(EscortManager);
		}
		
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function startLootBattle() : void{
			startMatchEscort(0, startLoot);
		}
		
		public function startLoot() : void{
			(ViewFactory.getIns().getView(LootWaitView) as LootWaitView).updatatLootStatus();
		}
		
		public function autoStartLoot() : void{
			var obj:Object = new Object();
			var escortData:Object = new Object();
			escortData.playerHp = NumberConst.getIns().zero;
			escortData.carTime = NumberConst.getIns().zero;
			escortData.carHp = NumberConst.getIns().zero;
			escortData.carX = NumberConst.getIns().zero;
			escortData.carY = NumberConst.getIns().zero;
			var otherPlayerData:Object = RoleManager.getIns().getEscortProperty();
			otherPlayerData.name = "龙门镖局";
			otherPlayerData.EscortType = NumberConst.getIns().one;
			obj.otherPlayerData = otherPlayerData;
			obj.escortType = 0;
			obj.escortData = escortData;
			gainData = obj;
			(ViewFactory.getIns().getView(LootWaitView) as LootWaitView).updatatLootStatus();
		}
		
		public function startMatchEscort(type:int,callback:Function = null) : void{
			DebugArea.getIns().showInfo("---发送开始匹配请求---");
			startMatchEscortFun = callback;
			isEscort = type;
			matchComplete = false;
			var sm:MatchEscort = new MatchEscort(RoleManager.getIns().getEscortProperty(), player.occupation,player.character.lv, isEscort, player.pack.equip.length);
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
		}
		
		public function startMatchEscortSuccess(e:CommonEvent) : void{
			if(matchComplete == true) return;
			DebugArea.getIns().showInfo("---匹配成功---");
			matchComplete = true;
			gainData = e.data.result;
			if(startMatchEscortFun != null){
				startMatchEscortFun();
			}
		}
		
		
		public function updateMatchEscort(escortData:Object,callback:Function = null) : void{
			DebugArea.getIns().showInfo("---发送更新护镖数据请求---");
			var sm:MatchEscortUpdate = new MatchEscortUpdate(escortData.playerHp,escortData.carTime,escortData.carHp,escortData.carX,escortData.carY);
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
		}
		
		
		public function cancelMatchEscort(callback:Function = null) : void{
			DebugArea.getIns().showInfo("---发送取消匹配请求---");
			cancelMatchEscortFun = callback;
			var sm:CancelMatchEscort = new CancelMatchEscort();
			var ssc:SocketsSendControl = ControlFactory.getIns().getControl(SocketsSendControl) as SocketsSendControl;
			ssc.send(sm);
		}
		
		public function cancelMatchEscortSuccess(e:CommonEvent) : void{
			DebugArea.getIns().showInfo("---取消匹配成功---");
			if(cancelMatchEscortFun != null){
				cancelMatchEscortFun();
			}
		}
		
		//开始护镖条件判断
		public function escortCondition() : void{
			if(player.escortInfo.escortCount <= NumberConst.getIns().zero){
				(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun("今日护镖次数不足，无法护镖");
				return;
			}
			switch(nowBiaoChe){
				case NumberConst.getIns().one:
					muNiuBiaoChe();
					break;
				case NumberConst.getIns().two:
					liuMaBiaoChe();
					break;
				case NumberConst.getIns().three:
					jinCheBiaoChe();
					break;
			}
		}
		
		//木牛镖车
		private function muNiuBiaoChe() : void{
			(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
				"请稍等...",null,null,true);
			SaveManager.getIns().onSaveGame(muNiuData, muNiuStart);
		}
		
		private function muNiuData() : void{
			lastEscortTime = 30 * (60 * 3 + 30);
			biaoCheSpeed = 0.5;
			if(player.mainMissionVo.id == 1007){
				player.mainMissionVo.isComplete = true;
			}
			player.escortInfo.escortCount--;
			player.escortInfo.escortTime = TimeManager.getIns().returnTimeNowStr();
		}
		
		private function muNiuStart() : void{
			ViewFactory.getIns().getView(TipViewWithoutCancel).hide();
			initColdTime();
			(ControlFactory.getIns().getControl(EscortControl) as EscortControl).gotoEscortBattle();
		}
		
		//流马镖车
		private function liuMaBiaoChe() : void{
			if(player.money >= biaoCheInfo.money){
				(ViewFactory.getIns().initView(TipView) as TipView).setFun("是否花费" + biaoCheInfo.money + "金币进行护镖？",
					function () : void{
						(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
							"请稍等...",null,null,true);
						SaveManager.getIns().onSaveGame(liuMaData, liuMaStart);
					});
			}else{
				(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun("金币不足，无法护镖");
			}
		}
		
		private function liuMaData() : void{
			lastEscortTime = 30 * (60 * 3);
			biaoCheSpeed = .56;
			player.money -= biaoCheInfo.money;
			if(player.mainMissionVo.id == 1007){
				player.mainMissionVo.isComplete = true;
			}
			player.escortInfo.escortCount--;
			player.escortInfo.escortTime = TimeManager.getIns().returnTimeNowStr();
		}
		
		private function liuMaStart() : void{
			ViewFactory.getIns().getView(TipViewWithoutCancel).hide();
			initColdTime();
			(ControlFactory.getIns().getControl(EscortControl) as EscortControl).gotoEscortBattle();
			ViewFactory.getIns().getView(MainToolBar).update();
		}
		
		//金车镖车
		private function jinCheBiaoChe() : void{
			if(player.vip.curCoupon >= NumberConst.getIns().haoHuaBiaoCheCoupon){
				(ViewFactory.getIns().initView(TipView) as TipView).setFun("是否花费" + NumberConst.getIns().haoHuaBiaoCheCoupon + "点券进行护镖？", startBuyBiaoChe);
			}else{
				(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun("点券不足，无法护镖");
			}
		}
		
		//点券购买护镖
		private function startBuyBiaoChe() : void{
			(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
				"系统正在处理当中，请稍等...",null,null,true);
			SaveManager.getIns().onJudgeMulti(
				function () : void{
					var data:Object = {propId:NumberConst.getIns().haoHuaBiaoCheID.toString(),count:1,price:NumberConst.getIns().haoHuaBiaoCheCoupon,idx:PlayerManager.getIns().player.index,tag:"buyBiaoChe"};
					ShopManager.getIns().buyPropNd(data,buyBiaoCheCallBack);
				});
		}
		
		//点卷购买护镖成功
		private function buyBiaoCheCallBack(data:Object):void{
			SaveManager.getIns().onlySave(function():void{
				lastEscortTime = 30 * (60 * 2 + 30);
				biaoCheSpeed = 0.64;
				player.vip.curCoupon = data.balance;
				player.escortInfo.escortCount--;
				player.escortInfo.escortTime = TimeManager.getIns().returnTimeNowStr();
				if(player.mainMissionVo.id == 1007){
					player.mainMissionVo.isComplete = true;
				}
				(ControlFactory.getIns().getControl(EscortControl) as EscortControl).gotoEscortBattle();
				initColdTime();
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).hide();
			});
		}
		
		//劫镖条件判断
		public function lootCondition() : void{
			if(player.escortInfo.lootCount <= NumberConst.getIns().zero){
				(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun("今日劫镖次数不足，无法劫镖");
				return;
			}else{
				(ViewFactory.getIns().getView(EscortView) as EscortView).reallyStartLoot();
			}
		}
		
		//劫镖开始
		public function lootReallyStart() : void{
			if(player.mainMissionVo.id == 1009){
				player.mainMissionVo.isComplete = true;
			}
			player.escortInfo.lootCount--;
			player.escortInfo.lootTime = TimeManager.getIns().returnTimeNowStr();
			(ControlFactory.getIns().getControl(EscortControl) as EscortControl).gotoLootBattle();
			SaveManager.getIns().onSaveGame();
			initColdTime();
		}
		
		//额外奖励
		public function extraReward(type:int, pos:Point) : void{
			var rate:Number = (type==CharacterType.NORMAL_MONSTER?NumberConst.getIns().percent20:NumberConst.getIns().one);
			if(Math.random() < rate){
				var iie:ItemIconEntity;
				var fodder:String;
				var itemName:String;
				var itemVo:ItemVo;
				var extraType:int = int(Math.random() * 3);
				switch(extraType){
					case NumberConst.getIns().zero:
						var moneys:Array = biaoCheInfo.extra_money.split("|");
						var money:int = int(moneys[1]) + Math.random() * (int(moneys[0]) - int(moneys[1]));
						fodder = "WeatherMoney";
						itemName = NumberConst.numTranslate(money);
						PlayerManager.getIns().addMoney(money);
						extraMoney += money;
						break;
					case NumberConst.getIns().one:
						var souls:Array = biaoCheInfo.extra_soul.split("|");
						var soul:int = int(souls[1]) + Math.random() * (int(souls[0]) - int(souls[1]));
						fodder = "WeatherSoul";
						itemName = NumberConst.numTranslate(soul);
						PlayerManager.getIns().addSoul(soul);
						extraSoul += soul;
						break;
					case NumberConst.getIns().two:
						var arr:Array = biaoCheInfo.extra_material.split("|");
						itemVo = PackManager.getIns().creatItem(arr[int(Math.random() * arr.length)]);
						itemVo.num = NumberConst.getIns().one;
						PackManager.getIns().addItemIntoPack(itemVo);
						fodder = itemVo.type + itemVo.id;
						itemName = itemVo.name;
						pushMaterialArr(itemVo);
						break;
				}
				if(itemVo != null){
					for(var i:int = 0; i < itemVo.num; i++){
						iie = new ItemIconEntity(fodder, itemName, pos, DigitalManager.getIns().getOneStauts());
						SceneManager.getIns().nowScene.addChild(iie);
					}
				}else{
					iie = new ItemIconEntity(fodder, itemName, pos, DigitalManager.getIns().getOneStauts());
					SceneManager.getIns().nowScene.addChild(iie);
				}
			}
		}
		
		//推进额外奖励材料数组
		private function pushMaterialArr(itemVo:ItemVo) : void{
			var result:Boolean = true;
			for(var i:int = 0; i < extraMaterial.length; i++){
				if(extraMaterial[i].id == itemVo.id){
					extraMaterial[i].num += itemVo.num;
					result = false;
					break;
				}
			}
			if(result){
				extraMaterial.push(itemVo);
			}
		}
		
		private function calculateConvoysHpRate() : void{
			var escortHp:int = 0;
			var totalHp:int = 0;
			var escorts:Vector.<EscortEntity>
			if(BmdViewFactory.getIns().getView(EscortSceneView) != null){
				escorts = (BmdViewFactory.getIns().getView(EscortSceneView) as EscortSceneView).convoys;
			}else{
				escorts = (BmdViewFactory.getIns().getView(LootSceneView) as LootSceneView).convoys;
			}
			for(var i:int = 0; i < escorts.length; i++){
				escortHp += escorts[i].charData.useProperty.hp;
				totalHp += escorts[i].charData.totalProperty.hp;
			}
			escortHpRate = escortHp/totalHp;
		}
		
		public function escortAccount() : void{
			calculateConvoysHpRate();
			var modulus:Number;
			switch(nowBiaoChe){
				case NumberConst.getIns().one:
					modulus = NumberConst.getIns().percent70;
					break;
				case NumberConst.getIns().two:
					modulus = NumberConst.getIns().one;
					break;
				case NumberConst.getIns().three:
					modulus = NumberConst.getIns().two;
					break;
			}
			finalRate = modulus * (escortHpRate + NumberConst.getIns().percent50 + killCount * NumberConst.getIns().percent20);
			
			PlayerManager.getIns().addExp(biaoCheInfo.escortexp * finalRate);
			PlayerManager.getIns().addMoney(biaoCheInfo.escortgold * finalRate);
			PlayerManager.getIns().addSoul(biaoCheInfo.escortsoul * finalRate);
			SaveManager.getIns().onSaveGame();
		}
		
		public function get finalExp() : int{
			return biaoCheInfo.escortexp * finalRate;
		}
		public function get finalMoney() : int{
			return biaoCheInfo.escortgold * finalRate;
		}
		public function get finalSoul() : int{
			return biaoCheInfo.escortsoul * finalRate;
		}
		
		private function calculateConvoysReduceHp() : void{
			var escortHp:int = 0;
			var totalHp:int = 0;
			var escorts:Vector.<EscortEntity>
			if(BmdViewFactory.getIns().getView(EscortSceneView) != null){
				escorts = (BmdViewFactory.getIns().getView(EscortSceneView) as EscortSceneView).convoys;
			}else{
				escorts = (BmdViewFactory.getIns().getView(LootSceneView) as LootSceneView).convoys;
			}
			for(var i:int = 0; i < escorts.length; i++){
				escortHp += escorts[i].charData.useProperty.hp;
				totalHp += escorts[i].charData.totalProperty.hp;
			}
			escortReduceHpRate = (int((gainData.escortData.carHp==0?totalHp:gainData.escortData.carHp)) - escortHp) / totalHp;
		}
		
		public function lootAccount() : void{
			calculateConvoysHpRate();
			calculateConvoysReduceHp();
			var modulus:Number;
			switch(nowBiaoChe){
				case NumberConst.getIns().one:
					modulus = NumberConst.getIns().percent70;
					break;
				case NumberConst.getIns().two:
					modulus = NumberConst.getIns().one;
					break;
				case NumberConst.getIns().three:
					modulus = NumberConst.getIns().two;
					break;
			}
			finalRate = escortReduceHpRate * modulus * (NumberConst.getIns().ten - (player.character.lv - gainData.otherPlayerData.lv)) * NumberConst.getIns().percent10;
			PlayerManager.getIns().addExp(biaoCheInfo.escortexp * finalRate);
			PlayerManager.getIns().addMoney(biaoCheInfo.escortgold * finalRate);
			PlayerManager.getIns().addSoul(biaoCheInfo.escortsoul * finalRate);
			
			DebugArea.getIns().showInfo("劫镖保存");
			SaveManager.getIns().onSaveGame();
		}
		
		//初始化
		public function init() : void{
			killCount = NumberConst.getIns().zero;
			extraMoney = NumberConst.getIns().zero;
			extraSoul = NumberConst.getIns().zero;
			isGameOver = false;
			extraMaterial.length = 0;
			_timeStep = 0;
			_timeCount = 0;
			_monsterCount = 0;
			_monsterTimes.length = 0;
			_monsters.length = 0;
			_monsterLibrary.length = 0;
			_monsterEliteLibrary.length = 0;
			var index:int = nowIndex.split("_")[0];
			var monsterID:int;
			for(var i:int = 1; i <= 7; i++){
				monsterID = 5000 + (index - 1) * 10 + i;
				if(monsterID != 5027){
					_monsterLibrary.push(monsterID);
				}
			}
			for(var j:int = 1; j <= 7; j++){
				monsterID = 5100 + (index - 1) * 10 + j;
				if(monsterID != 5127){
					_monsterEliteLibrary.push(monsterID);
				}
			}
		}
		
		public function initColdTime() : void{
			var differ:Number;
			if(player.escortInfo.escortTime != ""){
				differ = TimeManager.getIns().compareTime(player.escortInfo.escortTime, TimeManager.getIns().returnTimeNowStr());
				if(differ < NumberConst.getIns().ten * NumberConst.getIns().timeMinute * 1000){
					_escortDate = new Date(2000, 0, 1, 0, 0, 0);
					_escortDate.time += (NumberConst.getIns().ten * NumberConst.getIns().timeMinute * 1000 - differ);
					_preTime = getTimer();
					canEscort = false;
				}
			}
			if(player.escortInfo.lootTime != ""){
				differ = TimeManager.getIns().compareTime(player.escortInfo.lootTime, TimeManager.getIns().returnTimeNowStr());
				if(differ < NumberConst.getIns().ten * NumberConst.getIns().timeMinute * 1000){
					_lootDate = new Date(2000, 0, 1, 0, 0, 0);
					_lootDate.time += (NumberConst.getIns().ten * NumberConst.getIns().timeMinute * 1000 - differ);
					_preTime = getTimer();
					canLoot = false;
				}
			}
		}
		
		private var _preTime:Number;
		private var _calculateTime:Number;
		public function step() : void{
			_calculateTime = (getTimer() - _preTime);
			if(_calculateTime > 1000){
				_calculateTime = 0;
			}
			_preTime = getTimer();
			if(!canEscort){
				_escortDate.time -= _calculateTime;
				if(ViewFactory.getIns().getView(EscortView) != null){
					(ViewFactory.getIns().getView(EscortView) as EscortView).updateEscortTime(_escortDate.minutes, _escortDate.seconds);
				}
				if(_escortDate.hours == 0
					&& _escortDate.minutes == 0
					&& _escortDate.seconds == 0){
					canEscort = true;
					if(ViewFactory.getIns().getView(EscortView) != null){
						ViewFactory.getIns().getView(EscortView).update();
					}
				}
			}
			if(!canLoot){
				_lootDate.time -= _calculateTime;
				if(ViewFactory.getIns().getView(EscortView) != null){
					(ViewFactory.getIns().getView(EscortView) as EscortView).updateLootTime(_lootDate.minutes, _lootDate.seconds);
				}
				if(_lootDate.hours == 0
					&& _lootDate.minutes == 0
					&& _lootDate.seconds == 0){
					canLoot = true;
					if(ViewFactory.getIns().getView(EscortView) != null){
						ViewFactory.getIns().getView(EscortView).update();
					}
				}
			}
		}
		
		public function monsterStep() : void{
			if(_monsterCount > 10 || isGameOver) return;
			timeStep++;
			if(timeStep % 30 == 0 && timeStep <= 300){
				timeCount++;
			}
			if(timeStep > 1200){
				_timeStep = 0;
				_timeCount = 0;
			}
		}
		
		private function get timeStep() : int{
			return _timeStep;
		}
		private function set timeStep(value:int) : void{
			if(_timeStep == 0){
				randomMonster();
			}
			_timeStep = value;
		}
		
		private function get timeCount() : int{
			return _timeCount;
		}
		private function set timeCount(value:int) : void{
			judgeMonster(value);
			_timeCount = value;
		}
		
		//第几波怪
		private function randomMonster() : void{
			_monsterCount++;
			_monsterTimes.length = 0;
			_monsters.length = 0;
			for(var i:int = 0; i < 5; i++){
				_monsterTimes.push(int(Math.random() * 10) + 1);
				_monsters.push(_monsterLibrary[int(_monsterLibrary.length * Math.random())]);
			}
			var eliteCount:int = (_monsterCount - 1) / 2;
			for(var j:int = 1; j <= eliteCount; j++){
				_monsterTimes.push(int(Math.random() * 10) + 1);
				_monsters.push(_monsterEliteLibrary[int(_monsterEliteLibrary.length * Math.random())]);
			}
			DebugArea.getIns().showInfo("-----第" + _monsterCount + "波-----");
		}
		
		//这波怪出怪时间
		public function judgeMonster(count:int) : void{
			if(count == 0) return;
			for(var i:int = 0; i < _monsterTimes.length; i++){
				if(_monsterTimes[i] == count){
					DebugArea.getIns().showInfo("-----第" + count + "秒" + "-----怪物ID：" + _monsters[i] + "-----");
					createMonster(_monsters[i]);
				}
			}
		}
		
		//创建怪物
		private function createMonster(id:int):void{
			if(id == 0) return;
			_prePos = getRandomPos();
			var mon:MonsterEntity = RoleManager.getIns().createConvoyMonster(id, _prePos.x, _prePos.y, player.character.lv);
			mon.characterControl.limitLeftX = 0;
			mon.characterControl.limitRightX = 4600;
			SceneManager.getIns().initMonster(mon);
		}
		
		//获得随机出怪点
		private function getRandomPos() : Point{
			var result:Point = new Point();
			do{
				result.x = targetX + (Math.random()<.5?-1:1) * (300 + Math.random() * 300);
				result.y = 350 + Math.random() * 190;
				if(result.x < 0){
					result.x = 50;
				}
			}while(judgePos(result));
			
			return result;
		}
		
		//随机出怪点判断
		private function judgePos(point:Point) : Boolean{
			var result:Boolean = false;
			if(_prePos.x == 0 && _prePos.y == 0){
				result = false;
			}else{
				if(Math.abs(_prePos.x - point.x) < 175 && Math.abs(_prePos.y - point.y) < 125){
					result = true;
				}
			}
			return result;
		}
		
		private function get targetX() : int{
			return SceneManager.getIns().nowScene["convoysPos"].x;
		}
		
		public function escortResultShow(type:int) : void{
			EscortManager.getIns().cancelMatchEscort();
			isGameOver = true;
			(ViewFactory.getIns().initView(EscortResultView) as EscortResultView).showResult(type);
			(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).timeStop();
		}
		
		public function lootResultShow() : void{
			(ViewFactory.getIns().initView(LootResultView) as LootResultView).showResult();
		}
		
		public function lootTimeStop() : void{
			(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).timeStop();
			isGameOver = true;
		}
		
		public function clear() : void{
			canEscort = true;
			canLoot = true;
		}
	}
}