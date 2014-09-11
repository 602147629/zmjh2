package com.test.game.Mvc.control.View
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.greensock.TweenLite;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.DailyMissionConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.Map.ItemIconEntity;
	import com.test.game.Manager.AssessManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.PublicNoticeManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.TitleManager;
	import com.test.game.Manager.Extra.DoubleDungeonManager;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Modules.MainGame.BossBattleBar;
	import com.test.game.Modules.MainGame.BuffShowView;
	import com.test.game.Modules.MainGame.Info.CongratulationView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Map.MainMapView;
	import com.test.game.Modules.MainGame.Mission.MissionHint;
	import com.test.game.Modules.MainGame.PassLevel.PassLevelView;
	import com.test.game.Modules.MainGame.Tip.GetSkillBookView;
	import com.test.game.Mvc.Configuration.MainMission;
	import com.test.game.Mvc.Vo.DungeonPassVo;
	import com.test.game.Mvc.Vo.EliteDungeonPassVo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.geom.Point;
	
	public class PassLevelControl extends BaseControl{
		private var _anti:Antiwear;
		//是否显示任务界面
		public var showMission:Boolean;
		//特殊材料数据
		public var specialList:Vector.<ItemVo>;
		//万能碎片
		public var specialItem:ItemVo;
		//是否获得极碎片
		private var _hasSpecial:Boolean;
		//材料数组
		public var materialList:Vector.<ItemVo>;
		//是否有制作书
		private var _hasBook:Boolean;
		//制作书
		private var _bookItem:ItemVo;
		//第一次进入关卡
		public var isFirstEnterLevel:Boolean;
		//评价
		public function get add() : int{
			return _anti["add"];
		}
		public function set add(value:int) : void{
			_anti["add"] = value;
		}
		private var hasSkillBook:Boolean;
		private var _skillBookItem:ItemVo;
		
		public var showMoneyNum:int;
		public var showSoulNum:int;
		public var showExpNum:int;
		public var showRateNum:int;
		
		public var continueAutoFight:Boolean = false;
		
		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function PassLevelControl(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["add"] = 0;
		}
		
		public function showInfo(monster:MonsterEntity):void{
			specialList = new Vector.<ItemVo>();
			materialList = new Vector.<ItemVo>();
			_hasSpecial = false;
			_hasBook = false;
			hasSkillBook = false;
			add = ((AssessManager.getIns().assessLevel() - NumberConst.getIns().one) * NumberConst.getIns().percent10 + NumberConst.getIns().percent80) * NumberConst.getIns().ten;
			addDailyMissionData();
			addMissionData();
			addJiPublicNotice();
			if(LevelManager.getIns().mapType == 0){
				addNormalItem();
				addBook();
				updateLevelInfo();
				addSkillBook();
			}else{
				addEliteItem();
				updateEliteLevelInfo();
				addSkillBook();
				DeformTipManager.getIns().checkEliteDeform();
			}
			addALLData();
			ViewFactory.getIns().destroyView(BossBattleBar);
			ViewFactory.getIns().getView(MainToolBar).update();
			ViewFactory.getIns().getView(MainMapView).update();
			ViewFactory.getIns().getView(MissionHint).update();
			ViewFactory.getIns().getView(BuffShowView).update();
			DeformTipManager.getIns().allCheck();
			PlayerManager.getIns().checkAllAchieves();
			TitleManager.getIns().checkDungeonPassTitles();
			(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).saveGAME();
			showDropItem(monster);
		}
		
		private function addJiPublicNotice():void
		{
			if(add == NumberConst.getIns().assessJi){
				PublicNoticeManager.getIns().sendPublicNotice(1, LevelManager.getIns().levelData.level_name);
			}else if(add == NumberConst.getIns().assessDing){
				PublicNoticeManager.getIns().sendPublicNotice(6, LevelManager.getIns().levelData.level_name);
			}
		}
		
		private var _dropItemList:Array = new Array();
		private function showDropItem(monster:MonsterEntity):void{
			_dropItemList.length = 0;
			_dropItemList.push("WeatherMoney", NumberConst.numTranslate(passLevelMoney));
			_dropItemList.push("WeatherSoul", NumberConst.numTranslate(passLevelSoul));
			if(_hasBook){
				_dropItemList.push(_bookItem.type + _bookItem.id, _bookItem.name);
			}
			if(_hasSpecial){
				_dropItemList.push(specialItem.type + specialItem.id, specialItem.name);
			}
			/*if(hasSkillBook){
				_dropItemList.push(_skillBookItem.type + _skillBookItem.itemId, _skillBookItem.name);
			}*/
			if(materialList != null){
				for(var i:int = 0; i < materialList.length; i++){
					for(var ii:int = 0; ii < materialList[i].num; ii++){
						_dropItemList.push(materialList[i].type + materialList[i].id, materialList[i].name);
					}
				}
			}
			if(specialList != null){
				for(var j:int = 0; j < specialList.length; j++){
					for(var jj:int = 0; jj < specialList[j].num; jj++){
						_dropItemList.push(specialList[j].type + specialList[j].id, specialList[j].name);
					}
				}
			}
			for(var k:int = 0; k < _dropItemList.length; k++){
				var show:Boolean = (k==_dropItemList.length-2?true:false)
				TweenLite.delayedCall(k * .1, addDropItem, [k, monster.bodyPos, show]);
				k++;
			}
		}
		
		private var _direct:int = 1;
		private function addDropItem(index:int, pos:Point, show:Boolean) : void{
			var dropEntity:ItemIconEntity = new ItemIconEntity(_dropItemList[index], _dropItemList[index+1], pos, _direct);
			SceneManager.getIns().nowScene.addChild(dropEntity);
			_direct = -_direct;
			if(show == true){
				TweenLite.delayedCall(2,
					function () : void{
						ViewFactory.getIns().initView(PassLevelView).show();
					});
			}
		}
		
		private function addSkillBook():void{
			var arr:Array = LevelManager.getIns().nowIndex.split("_");
			var skillBookID:int;
			var list:Array;
			if(LevelManager.getIns().mapType == 0){
				if(LevelManager.getIns().levelData.skill_rate != 0){
					var random:Number = Math.random();
					var lastRate:Number = getSkillBookRate;
					if(random <= lastRate){
						list = PlayerManager.getIns().normalSkillUpInfo(arr[0]);
						if(list.length > 0){
							hasSkillBook = true;
							skillBookID = 500 + (player.occupation - 1) * 100 + (int(arr[0]) - 1) * 10 + list[int(Math.random() * list.length)];
							PlayerManager.getIns().addSkillUp(skillBookID);
							_skillBookItem = PackManager.getIns().creatItem(skillBookID);
						}else{
							hasSkillBook = false;
						}
					}else{
						hasSkillBook = false;
					}
				}else{
					hasSkillBook = false;
				}
			}else{
				if(int(arr[1]) == 4){
					list = PlayerManager.getIns().specialSkillUpInfo(arr[0]);
					if(list.length > 0){
						hasSkillBook = true;
						skillBookID = 500 + (player.occupation - 1) * 100 + (arr[0] - 1) * 10 + list[int(Math.random() * list.length)];
						PlayerManager.getIns().addSkillUp(skillBookID);
						_skillBookItem = PackManager.getIns().creatItem(skillBookID);
					}else{
						hasSkillBook = false;
					}
				}else{
					hasSkillBook = false;
				}
			}
		}
		
		//技能残券概率
		private function get getSkillBookRate() : Number{
			var result:Number = 0;
			result = LevelManager.getIns().levelData.skill_rate;
			//评价
			result += LevelManager.getIns().levelData.skill_rate * (AssessManager.getIns().assessLevel() - NumberConst.getIns().one) * NumberConst.getIns().percent25;
			//双倍副本
			if(DoubleDungeonManager.getIns().isInDoubleDungeon){
				//vip双倍副本
				if(ShopManager.getIns().vipLv >= NumberConst.getIns().three){
					result += LevelManager.getIns().levelData.skill_rate * NumberConst.getIns().three;
				}else{
					result += LevelManager.getIns().levelData.skill_rate * NumberConst.getIns().one;
				}
			}
			//vip等级
			if(ShopManager.getIns().vipLv >= NumberConst.getIns().one){
				result += NumberConst.getIns().vipLuckyRate;
			}
			//人品卡
			if(PlayerManager.getIns().player.autoFightInfo.rpCardCount > NumberConst.getIns().zero){
				result += NumberConst.getIns().rpRate;
			}
			return result;
		}
		
		//制作书概率
		private function get passLevelBook() : Number{
			var result:Number;
			result = LevelManager.getIns().levelData.book_rate;
			//评价
			result += LevelManager.getIns().levelData.book_rate * (AssessManager.getIns().assessLevel() - 1) * .25;
			//双倍副本
			if(DoubleDungeonManager.getIns().isInDoubleDungeon){
				//vip双倍副本
				if(ShopManager.getIns().vipLv >= NumberConst.getIns().three){
					result += LevelManager.getIns().levelData.book_rate * NumberConst.getIns().three;
				}else{
					result += LevelManager.getIns().levelData.book_rate * NumberConst.getIns().one;
				}
			}
			//vip等级
			if(ShopManager.getIns().vipLv >= NumberConst.getIns().one){
				result += NumberConst.getIns().vipLuckyRate;
			}
			//人品卡
			if(PlayerManager.getIns().player.autoFightInfo.rpCardCount > NumberConst.getIns().zero){
				result += NumberConst.getIns().rpRate;
			}
			return result;
		}
		
		
		private function addDailyMissionData():void{
			if(DailyMissionManager.getIns().isDailyMissionStart){
				if(DailyMissionManager.getIns().dailyMissionType == DailyMissionConst.PASSLEVEL
					&&!DailyMissionManager.getIns().isDailyMissionComplete 
					&& DailyMissionManager.getIns().isNowLevel){
					DailyMissionManager.getIns().setDailyComplete();
				}
			}
		}
		
		//添加任务相关数据
		private function addMissionData():void{
			var nowMission:MainMission = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.MAIN_MISSION, "id", player.mainMissionVo.id) as MainMission;
			var assessLevel:int = AssessManager.getIns().assessLevel();
			if(nowMission.evaluation == 0
				|| (nowMission.evaluation == 1 && assessLevel >= 3)
				|| (nowMission.evaluation == 2 && assessLevel >= 4)){
				if(LevelManager.getIns().mapType == 0){
					if(nowMission.mission_rules_level == LevelManager.getIns().nowIndex
						&& player.character.lv >= nowMission.lv
						&& player.mainMissionVo.isComplete == false){
						PlayerManager.getIns().completeMainMission();
						showMission = true;
					}else{
						showMission = false;
					}
				}else{
					if(nowMission.mission_rules_level == LevelManager.getIns().nowIndex + "_1"
						&& player.character.lv >= nowMission.lv
						&& player.mainMissionVo.isComplete == false){
						PlayerManager.getIns().completeMainMission();
						showMission = true;
					}else{
						showMission = false;
					}
				}
			}
		}
		
		//添加经验，金钱，战魂
		public function addALLData() : void{
			PlayerManager.getIns().checkAdd("pass_exp",passLevelExp,10*10000);
			PlayerManager.getIns().addExp(passLevelExp);
			player.money += passLevelMoney;
			player.soul += passLevelSoul;
			
			showExpNum = passLevelExp;
			showMoneyNum = passLevelMoney;
			showSoulNum = passLevelSoul;
			showRateNum = passLevelRate;
			
			if(player.autoFightInfo.autoFightCount > NumberConst.getIns().zero && !GameSceneManager.getIns().partnerOperate){
				player.autoFightInfo.autoFightCount--;
			}
			if(player.autoFightInfo.rpCardCount > NumberConst.getIns().zero){
				player.autoFightInfo.rpCardCount--;
			}
			if(player.autoFightInfo.doubleCardCount > NumberConst.getIns().zero){
				player.autoFightInfo.doubleCardCount--;
			}
			continueAutoFight = false;
		}
		
		//过关奖励加成
		private function get passLevelRate() : int{
			var result:int;
			var rate:Number;
			var start:Number;
			var end:Number = 0;
			end = start = rate = ((AssessManager.getIns().assessLevel() - NumberConst.getIns().one) * NumberConst.getIns().percent10 + NumberConst.getIns().percent80);
			//双倍副本
			if(DoubleDungeonManager.getIns().isInDoubleDungeon){
				end += (rate * NumberConst.getIns().one);
			}
			//双倍卡
			if(player.autoFightInfo.doubleCardCount > NumberConst.getIns().zero){
				end += (end * NumberConst.getIns().one);
			}
			//vip下双倍副本
			if(DoubleDungeonManager.getIns().isInDoubleDungeon){
				if(ShopManager.getIns().vipLv >= NumberConst.getIns().three){
					end += (start * NumberConst.getIns().two);
				}
			}
			//自动战斗buff
			if(player.autoFightInfo.autoFightCount > NumberConst.getIns().zero && !GameSceneManager.getIns().partnerOperate){
				end += (start * NumberConst.getIns().autoFightRate);
			}
			
			result = end * 100;
			return result;
		}
		
		//过关经验
		public function get passLevelExp() : int{
			var result:int;
			var start:int;
			var double:int = 0;
			var autoFight:int = 0;
			var vipLv:int = 0;
			var doubleCard:int = 0;
			start = result = LevelManager.getIns().levelData.exp * add * NumberConst.getIns().percent10;
			//双倍副本
			if(DoubleDungeonManager.getIns().isInDoubleDungeon){
				result += (start * NumberConst.getIns().one);
			}
			//双倍卡
			if(player.autoFightInfo.doubleCardCount > NumberConst.getIns().zero){
				result += (result * NumberConst.getIns().one);
			}
			//vip下双倍副本
			if(DoubleDungeonManager.getIns().isInDoubleDungeon){
				if(ShopManager.getIns().vipLv >= NumberConst.getIns().three){
					result += (start * NumberConst.getIns().two);
				}
			}
			//自动战斗buff
			if(player.autoFightInfo.autoFightCount > NumberConst.getIns().zero && !GameSceneManager.getIns().partnerOperate){
				result += (start * NumberConst.getIns().autoFightRate);
			}
			//vip等级
			if(ShopManager.getIns().vipLv >= NumberConst.getIns().two){
				result += (start * NumberConst.getIns().vipExpRate);
			}
			return result;
		}
		
		//过关金币
		public function get passLevelMoney() : int{
			var result:int;
			var start:int;
			start = result = LevelManager.getIns().levelData.money * add * NumberConst.getIns().percent10;
			//双倍副本
			if(DoubleDungeonManager.getIns().isInDoubleDungeon){
				result += (start * NumberConst.getIns().one);
			}
			//双倍卡
			if(player.autoFightInfo.doubleCardCount > NumberConst.getIns().zero){
				result += (result * NumberConst.getIns().one);
			}
			//vip下双倍副本
			if(DoubleDungeonManager.getIns().isInDoubleDungeon){
				if(ShopManager.getIns().vipLv >= NumberConst.getIns().three){
					result += (start * NumberConst.getIns().two);
				}
			}
			//自动战斗buff
			if(player.autoFightInfo.autoFightCount > NumberConst.getIns().zero && !GameSceneManager.getIns().partnerOperate){
				result += (start * NumberConst.getIns().autoFightRate);
			}
			return result;
		}
		
		//过关战魂
		public function get passLevelSoul() : int{
			var result:int;
			var start:int;
			start = result = LevelManager.getIns().levelData.soul * add * NumberConst.getIns().percent10;
			//双倍副本
			if(DoubleDungeonManager.getIns().isInDoubleDungeon){
				result += (start * NumberConst.getIns().one);
			}
			//双倍卡
			if(player.autoFightInfo.doubleCardCount > NumberConst.getIns().zero){
				result += (result * NumberConst.getIns().one);
			}
			//vip下双倍副本
			if(DoubleDungeonManager.getIns().isInDoubleDungeon){
				if(ShopManager.getIns().vipLv >= NumberConst.getIns().three){
					result += (start * NumberConst.getIns().two);
				}
			}
			//自动战斗buff
			if(player.autoFightInfo.autoFightCount > NumberConst.getIns().zero && !GameSceneManager.getIns().partnerOperate){
				result += (start * NumberConst.getIns().autoFightRate);
			}
			
			return result;
		}
		
		//更新普通关卡数据		
		public function updateLevelInfo() : void{
			for each(var item:DungeonPassVo in player.dungeonPass){
				if(item.name == LevelManager.getIns().nowIndex){
					if(item.lv == -1){
						isFirstEnterLevel = true;
					}else{
						isFirstEnterLevel = false;
					}
					item.lv = (AssessManager.getIns().assessLevel()>item.lv?AssessManager.getIns().assessLevel():item.lv);
					item.hit = (AssessManager.getIns().lastCombo>item.hit?AssessManager.getIns().lastCombo:item.hit);
					item.hurt = (AssessManager.getIns().playerHurtScore()<item.hurt?AssessManager.getIns().playerHurt():item.hurt);
					item.time = (AssessManager.getIns().levelTimeCount<item.time?AssessManager.getIns().levelTimeCount:item.time);
					item.add = (AssessManager.getIns().extraScore()>item.add?AssessManager.getIns().extraScore():item.add);
					if(item.hurt == 0){
						item.hurt = AssessManager.getIns().playerHurtScore();
					}
					if(item.time == 0){
						item.time = AssessManager.getIns().levelTimeCount;
					}
				}
			}
			var info:Array = LevelManager.getIns().nowIndex.split("_");
			
			//开启对应的精英副本
			if(isFirstEnterLevel && info[1] % 3 == 0){
				var eliteItem:EliteDungeonPassVo = new EliteDungeonPassVo();
				eliteItem.lv = NumberConst.getIns().negativeOne;
				eliteItem.name = info[0] + "_" + int(info[1] / 3);
				eliteItem.num = NumberConst.getIns().zero;
				player.eliteDungeon.eliteDungeonPass.push(eliteItem);
			}
			
			
			//开启本场景下一关
			var str:String = info[0] + "_" + int(int(info[1]) + 1);
			var normalItem:DungeonPassVo;
			if(info[1] < 9 && !PlayerManager.getIns().hasDungeonInfo(str)){
				normalItem = new DungeonPassVo();
				normalItem.lv = NumberConst.getIns().negativeOne;
				normalItem.name = str;
				player.dungeonPass.push(normalItem);
			}
			
			
			//开启下一场景下一关
			var next:String = int(int(info[0]) + 1) + "_1";
			if(info[1] == 9 && !PlayerManager.getIns().hasDungeonInfo(next)){
				normalItem = new DungeonPassVo();
				normalItem.lv = NumberConst.getIns().negativeOne;
				normalItem.name = next;
				player.dungeonPass.push(normalItem);
				addSceneClearPublicNotice();
			}
			
			//隐藏副本添加关卡
			if(info[1] > 9 && info[1] < 12){
				if(!PlayerManager.getIns().hasDungeonInfo(str)){
					normalItem = new DungeonPassVo();
					normalItem.lv = NumberConst.getIns().negativeOne;
					normalItem.name = str;
					player.dungeonPass.push(normalItem);
				}
			}
			if(info[1] >= 10){
				for(var i:int = 0; i < player.hideMissionInfo.length; i++){
					if(player.hideMissionInfo[i].isShow){
						if(player.hideMissionInfo[i].id == (3000 + (info[0] - 1) * 10 + 2)){
							var index:int = HideMissionManager.getIns().getHideMissionIndex(player.hideMissionInfo[i].id)
							HideMissionManager.getIns().setMissionCompleteByIndex(index, info[1] - 10);
							HideMissionManager.getIns().judgeMissionComplete(player.hideMissionInfo[i].id);
						}
					}
				}
			}
		}
		
		private function addSceneClearPublicNotice():void{
			PublicNoticeManager.getIns().sendPublicNotice(3,LevelManager.getIns().levelData.scene_name);
		}
		
		//更新精英关卡数据
		public function updateEliteLevelInfo() : void{
			for each(var item:EliteDungeonPassVo in player.eliteDungeon.eliteDungeonPass){
				if(item.name == LevelManager.getIns().nowIndex){
					if(item.lv == -1){
						isFirstEnterLevel = true;
					}else{
						isFirstEnterLevel = false;
					}
					item.lv = (AssessManager.getIns().assessLevel()>item.lv?AssessManager.getIns().assessLevel():item.lv);
					item.hit = (AssessManager.getIns().lastCombo>item.hit?AssessManager.getIns().lastCombo:item.hit);
					item.hurt = (AssessManager.getIns().playerHurtScore()<item.hurt?AssessManager.getIns().playerHurt():item.hurt);
					item.time = (AssessManager.getIns().levelTimeCount<item.time?AssessManager.getIns().levelTimeCount:item.time);
					item.add = (AssessManager.getIns().extraScore()>item.add?AssessManager.getIns().extraScore():item.add);
					if(item.num < 5){
						item.num++;
					}
					if(item.hurt == 0){
						item.hurt = AssessManager.getIns().playerHurtScore();
					}
					if(item.time == 0){
						item.time = AssessManager.getIns().levelTimeCount;
					}
				}
			}
		}
		
		//检测该精英关卡今日次数是否达到5次
		public function isReachEliteCount() : Boolean{
			var result:Boolean = false;
			for each(var item:EliteDungeonPassVo in player.eliteDungeon.eliteDungeonPass){
				if(item.name == LevelManager.getIns().nowIndex){
					if(item.num >= NumberConst.getIns().five){
						result = true;
					}
				}
			}
			return result;
		}
		
		//获得制作书
		public function addBook() : void{
			if(LevelManager.getIns().levelData.book != "无"){
				var lastNum:Number = passLevelBook;
				var random:Number = Math.random();
				if(random < lastNum){
					_hasBook = true;
					var arr:Array = LevelManager.getIns().levelData.book.split("|");
					var nowIndex:int = arr[player.occupation - 1];
					_bookItem = PackManager.getIns().creatItem(nowIndex);
					PackManager.getIns().addItemIntoPack(_bookItem);
				}else{
					_hasBook = false;
				}
			}else{
				_hasBook = false;
			}
		}
		
		//显示制作书获得界面
		public function showBook() : void{
			if(_hasBook){
				(ViewFactory.getIns().initView(CongratulationView) as CongratulationView).startPlay(_bookItem.id, showSpecial);
				/*(ViewFactory.getIns().initView(GetSpecialView) as GetSpecialView).setSpecial(_bookItem, _bookItem.bookConfig.name, showSpecial);
				(ViewFactory.getIns().initView(GetSpecialView) as GetSpecialView).show();*/
			}else{
				showSpecial();
			}
		}
		
		//获得万能碎片	
		private function showSpecial() : void{
			if(_hasSpecial){
				(ViewFactory.getIns().initView(CongratulationView) as CongratulationView).startPlay(specialItem.id, showSkillBook);
				/*(ViewFactory.getIns().initView(GetSpecialView) as GetSpecialView).setSpecial(specialItem, specialItem.specialConfig.name, showSkillBook);
				(ViewFactory.getIns().initView(GetSpecialView) as GetSpecialView).show();*/
			}else{
				showSkillBook();
			}
		}
		
		//技能残卷
		private function showSkillBook():void{
			if(hasSkillBook){
				(ViewFactory.getIns().initView(GetSkillBookView) as GetSkillBookView).setInfo(_skillBookItem.name);
				(ViewFactory.getIns().initView(GetSkillBookView) as GetSkillBookView).show();
			}
		}
		
		//普通关卡获得材料	
		public function addNormalItem() : void{
			materialList = new Vector.<ItemVo>();
			var idList:Array = [];
			var strengthInfo:Array = LevelManager.getIns().levelData.strengthen.split("|");
			var materialInfo:Array = LevelManager.getIns().levelData.material.split("|");
			switch(add){
				case NumberConst.getIns().assessDing:
					break;
				case NumberConst.getIns().assessBing:
					idList.push(strengthInfo[int(strengthInfo.length * Math.random())]);
					break;
				case NumberConst.getIns().assessYi:
					idList.push(strengthInfo[int(strengthInfo.length * Math.random())]);
					idList.push(materialInfo[int(materialInfo.length * Math.random())]);
					break;
				case NumberConst.getIns().assessJia:
					idList.push(strengthInfo[int(strengthInfo.length * Math.random())]);
					idList.push(materialInfo[int(materialInfo.length * Math.random())]);
					break;
				case NumberConst.getIns().assessJi:
					idList.push(strengthInfo[int(strengthInfo.length * Math.random())]);
					idList.push(materialInfo[int(materialInfo.length * Math.random())]);
					break;
			}
			for(var i:int = 0; i < idList.length; i++){
				materialList.push(PackManager.getIns().creatItem(idList[i]));
				materialList[i].num = getMaterialNum;
				PackManager.getIns().addItemIntoPack(materialList[i]);
			}
			if(add == NumberConst.getIns().assessJi && getNowLevelAssess()){
				_hasSpecial = true;
				specialItem = PackManager.getIns().creatItem(NumberConst.getIns().wanNengId);
				PackManager.getIns().addItemIntoPack(specialItem);
			}else{
				_hasSpecial = false;
			}
		}
		
		//当前普通关卡是否已经获得过极评价
		private function getNowLevelAssess() : Boolean{
			var result:Boolean = true;
			for each(var item:DungeonPassVo in player.dungeonPass){
				if(item.name == LevelManager.getIns().nowIndex){
					if(item.lv == NumberConst.getIns().five){
						result = false;
					}
					break;
				}
			}
			return result;
		}
		
		// 精英关卡获得材料
		public function addEliteItem() : void{
			materialList = new Vector.<ItemVo>();
			specialList = new Vector.<ItemVo>();
			var idMaterialList:Array = [];
			var idSpecialList:Array = [];
			var specialInfo:Array = LevelManager.getIns().levelData.special.split("|");
			var materialInfo:Array = LevelManager.getIns().levelData.material.split("|");
			switch(add){
				case NumberConst.getIns().assessDing:
					idSpecialList.push(specialInfo[int(specialInfo.length * Math.random())]);
					break;
				case NumberConst.getIns().assessBing:
					idSpecialList.push(specialInfo[int(specialInfo.length * Math.random())]);
					break;
				case NumberConst.getIns().assessYi:
					idSpecialList.push(specialInfo[int(specialInfo.length * Math.random())]);
					idMaterialList.push(materialInfo[int(materialInfo.length * Math.random())]);
					break;
				case NumberConst.getIns().assessJia:
					idSpecialList.push(specialInfo[int(specialInfo.length * Math.random())]);
					idMaterialList.push(materialInfo[int(materialInfo.length * Math.random())]);
					break;
				case NumberConst.getIns().assessJi:
					idSpecialList.push(specialInfo[int(specialInfo.length *Math.random())]);
					idMaterialList.push(materialInfo[int(materialInfo.length * Math.random())]);
					break;
			}
			for(var i:int = 0; i < idMaterialList.length; i++){
				materialList.push(PackManager.getIns().creatItem(idMaterialList[i]));
				materialList[i].num = getMaterialNum;
				PackManager.getIns().addItemIntoPack(materialList[i]);
			}
			
			for(var j:int = 0; j < idSpecialList.length; j++){
				specialList.push(PackManager.getIns().creatItem(idSpecialList[j]));
				specialList[j].num = getMaterialNum;
				PackManager.getIns().addItemIntoPack(specialList[j]);
			}
			
			if(add == NumberConst.getIns().assessJi && getNowEliteLevelAssess()){
				_hasSpecial = true;
				specialItem = PackManager.getIns().creatItem(NumberConst.getIns().wanNengId);
				PackManager.getIns().addItemIntoPack(specialItem);
			}else{
				_hasSpecial = false;
			}
		}
		
		//当前精英关卡是否已经获得过极评价
		private function getNowEliteLevelAssess() : Boolean{
			var result:Boolean = true;
			for each(var item:EliteDungeonPassVo in player.eliteDungeon.eliteDungeonPass){
				if(item.name == LevelManager.getIns().nowIndex){
					if(item.lv == NumberConst.getIns().five){
						result = false;
					}
					break;
				}
			}
			return result;
		}
		
		public function get getMaterialNum() : int{
			var result:int = NumberConst.getIns().one;
			//双倍副本
			if(DoubleDungeonManager.getIns().isInDoubleDungeon){
				result += NumberConst.getIns().one;
			}
			//双倍卡
			if(player.autoFightInfo.doubleCardCount > NumberConst.getIns().zero){
				result += (result * NumberConst.getIns().one);
			}
			//vip双倍副本
			if(DoubleDungeonManager.getIns().isInDoubleDungeon
				&& ShopManager.getIns().vipLv >= NumberConst.getIns().three){
				result += NumberConst.getIns().two;
			}
			return result;
		}
	}
}