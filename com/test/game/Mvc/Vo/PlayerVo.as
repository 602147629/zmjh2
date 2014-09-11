package com.test.game.Mvc.Vo{
	import com.adobe.serialization.json.JSON;
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EquipmentType;
	import com.test.game.Const.MidConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.OccupationConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.CryptManager;
	import com.test.game.Manager.GameSettingManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LogManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.RankManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Manager.TitleManager;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Manager.Pipei.PlayerKillingManager;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Mvc.Configuration.StrengthenUp;
	import com.test.game.Utils.PlayerUtils;
	
	public class PlayerVo extends BaseVO{
		private var _items:Vector.<Item>;//背包数组，测试用
		private var _property:Property;//玩家属性，测试用
		public var strengthenUp:StrengthenUp;
		
		private var _anti:Antiwear;
		

		
		public function PlayerVo(){
			this._property = new Property();
			this._items = new Vector.<Item>();
			strengthenUp = new StrengthenUp();
			
			_isInit = false;
			_anti = new Antiwear(new binaryEncrypt());
			
			super();
		}

		//玩家用户id
		public function get gameKey():String
		{
			return _anti["gameKey"];
		}

		public function set gameKey(value:String):void
		{
			_anti["gameKey"] = value;
		}
		
		//存档索引
		public function get index():int
		{
			return _anti["index"];
		}
		
		public function set index(value:int):void
		{
			_anti["index"] = value;
		}

		//玩家姓名
		public function get name():String
		{
			return _anti["name"];
		}

		public function set name(value:String):void
		{
			_anti["name"] = value;
		}

		
		//玩家姓名
		public function get occupation():int
		{
			return _anti["occupation"];
		}
		
		public function set occupation(value:int):void
		{
			_anti["occupation"] = value;
		}

		
		//玩家经验
		public function get exp():int
		{
			return _anti["exp"];
		}

		public function set exp(value:int):void
		{
			_anti["exp"] = value;
		}
		
		//玩家金币
		public function get money():int
		{
			return _anti["money"];
		}
		
		public function set money(value:int):void
		{
			_anti["money"] = value;
		}
		
		//玩家战魂
		public function get soul():int
		{
			return _anti["soul"];
		}
		
		public function set soul(value:int):void
		{
			_anti["soul"] = value;
		}
		

		
		//玩家命数
		public function get baGuaScore():int
		{
			return _anti["baGuaScore"];
		}
		public function set baGuaScore(value:int):void
		{
			_anti["baGuaScore"] = value;
		}
		
		//玩家天命
		public function get baGuaFortune():int
		{
			return _anti["baGuaFortune"];
		}
		public function set baGuaFortune(value:int):void
		{
			_anti["baGuaFortune"] = value;
		}
		
		//玩家八卦背包容量
		public function get baGuaRoomMax():int
		{
			return _anti["baGuaRoomMax"];
		}
		public function set baGuaRoomMax(value:int):void
		{
			_anti["baGuaRoomMax"] = value;
		}
		
		public var operateMode:int;
		
		//玩家人物
		private var _character:CharacterVo;
		public function get character():CharacterVo
		{
			return _character;
		}
		
		public function set character(value:CharacterVo):void
		{
			_character = value;
		}
		
		
		//玩家任务数据
		private var _mainMissionVo:MissionVo;
		public function get mainMissionVo():MissionVo
		{
			return _mainMissionVo;
		}
		
		public function set mainMissionVo(value:MissionVo):void
		{
			_mainMissionVo = value;
		}
		
		//每日任务
		private var _dailyMissionVo:DailyMissionVo;
		public function get dailyMissionVo() : DailyMissionVo{
			return _dailyMissionVo;
		}
		public function set dailyMissionVo(value:DailyMissionVo) : void{
			_dailyMissionVo = value;
		}
		
		private var _hideMissionInfo:Vector.<HideMissionVo>  = new Vector.<HideMissionVo>();
		public function get hideMissionInfo() : Vector.<HideMissionVo>{
			return _hideMissionInfo;
		}
		public function set hideMissionInfo(value:Vector.<HideMissionVo>) : void{
			_hideMissionInfo = value;
		}
		
		public function get ShowHideMissionInfo():Vector.<HideMissionVo>{
			var vec:Vector.<HideMissionVo> = new Vector.<HideMissionVo>;
			for(var i:int =0; i< this.hideMissionInfo.length;i++){
				if(this.hideMissionInfo[i].isShow){
					vec.push(hideMissionInfo[i]);
				}
			}
			return vec;
		}
		
		//玩家礼包数据
		public function get gift():Array
		{
			if(_anti["giftVos"] == null){
				_anti["giftVos"] = new Array;
			}
			return _anti["giftVos"];
		}
		
		public function set gift(value:Array):void
		{
			_anti["giftVos"] = value;
		}
		
		//vip4修复金币和战魂
		public function get vipRepair() : int{
			return _anti["vipRepair"];
		}
		public function set vipRepair(value:int) : void{
			_anti["vipRepair"] = value;
		}
		
		//通关等级
		private var _dungeonPass:Vector.<DungeonPassVo>;
		public function get dungeonPass():Vector.<DungeonPassVo>
		{
			return _dungeonPass;
		}
		
		public function set dungeonPass(value:Vector.<DungeonPassVo>):void
		{
			_dungeonPass = value;
		}
		
		
		//精英副本通关等级
		private var _eliteDungeon:EliteDungeonVo;
		public function get eliteDungeon():EliteDungeonVo
		{
			return _eliteDungeon;
		}
		
		public function set eliteDungeon(value:EliteDungeonVo):void
		{
			_eliteDungeon = value;
		}
		
		//双倍副本
		private var _doubleDungeonVo:DoubleDungeonVo;
		public function get doubleDungeonVo() : DoubleDungeonVo{
			return _doubleDungeonVo;
		}
		public function set doubleDungeonVo(value:DoubleDungeonVo) : void{
			_doubleDungeonVo = value;
		}
		
		//在线奖励
		private var _onlineBonusVo:OnlineBonusVo;
		public function get onlineBonusVo() : OnlineBonusVo{
			return _onlineBonusVo;
		}
		public function set onlineBonusVo(value:OnlineBonusVo) : void{
			_onlineBonusVo = value;
		}
		
		
		//玩家黑市数据
		private var _blackMarket:BlackMarketVo;
		public function get blackMarket():BlackMarketVo
		{
			return _blackMarket;
		}
		
		public function set blackMarket(value:BlackMarketVo):void
		{
			_blackMarket = value;
		}
		
		//玩家装备的八卦牌数据
		public function get baGuaAttachs() : Array{
			return _anti["baGuaAttachs"];
		}
		public function set baGuaAttachs(value:Array) : void{
			_anti["baGuaAttachs"] = value;
		}
		
		//玩家八卦牌数据
		private var _baGuaPieces:Vector.<BaGuaPieceVo>  = new Vector.<BaGuaPieceVo>();
		public function get baGuaPieces() : Vector.<BaGuaPieceVo>{
			return _baGuaPieces;
		}
		public function set baGuaPieces(value:Vector.<BaGuaPieceVo>) : void{
			_baGuaPieces = value;
		}
		
		
		//玩家称号数据
		private var _titleInfo:TitleVo;
		public function get titleInfo() : TitleVo{
			return _titleInfo;
		}
		public function set titleInfo(value:TitleVo) : void{
			_titleInfo = value;
		}
		
		//英雄谱数据
		private var _heroScriptVo:HeroScriptVo;
		public function get heroScriptVo() : HeroScriptVo{
			return _heroScriptVo;
		}
		public function set heroScriptVo(value:HeroScriptVo) : void{
			_heroScriptVo = value;
		}
		
		//记录
		private var _logVo:LogVo;
		public function get logVo() : LogVo{
			return _logVo;
		}
		public function set logVo(value:LogVo) : void{
			_logVo = value;
		}
		
		//玩家背包
		private var _pack:PackVo;
		public function get pack():PackVo
		{
			return _pack;
		}

		public function set pack(value:PackVo):void
		{
			_pack = value;
		}
		
		//玩家装备
		private var _equipInfo:EquipInfo;
		public function get equipInfo():EquipInfo
		{
			return _equipInfo;
		}
		
		public function set equipInfo(value:EquipInfo):void
		{
			_equipInfo = value;
		}
		
		
		//玩家时装
		private var _fashionInfo:FashionVo;
		public function get fashionInfo():FashionVo
		{
			return _fashionInfo;
		}
		
		public function set fashionInfo(value:FashionVo):void
		{
			_fashionInfo = value;
		}
		
		//玩家附体
		private var _attachInfo:AttachInfo;
		public function get attachInfo():AttachInfo
		{
			return _attachInfo;
		}
		
		public function set attachInfo(value:AttachInfo):void
		{
			_attachInfo = value;
		}
		
		
		//玩家支援
		private var _assistInfo:int;
		public function get assistInfo():int
		{
			return _assistInfo;
		}
		
		public function set assistInfo(value:int):void
		{
			_assistInfo = value;
		}
		
		//伙伴技能
		private var _partnerSkill:partnerSkillInfo;
		public function get partnerSkill():partnerSkillInfo
		{
			return _partnerSkill;
		}
		
		public function set partnerSkill(value:partnerSkillInfo):void
		{
			_partnerSkill = value;
		}

		//玩家技能
		private var _skill:SkillInfo;
		public function get skill():SkillInfo
		{
			return _skill;
		}
		
		public function set skill(value:SkillInfo):void
		{
			_skill = value;
		}
		
		//玩家技能升级
		private var _skillUp:SkillUpVo;
		public function get skillUp():SkillUpVo
		{
			return _skillUp;
		}
		
		public function set skillUp(value:SkillUpVo):void
		{
			_skillUp = value;
		}
		
		//pk数据
		private var _pkInfo:PlayerKillingVo;
		public function get pkInfo() : PlayerKillingVo{
			return _pkInfo;
		}
		public function set pkInfo(value:PlayerKillingVo) : void{
			_pkInfo = value;
		}
		
		//自动战斗挂机次数
		private var _autoFightInfo:AutoFightVo;
		public function get autoFightInfo() : AutoFightVo{
			return _autoFightInfo;
		}
		public function set autoFightInfo(value:AutoFightVo) : void{
			_autoFightInfo = value;
		}
		
		private var _wuyiInfo:WuYiVo;
		public function get wuyiInfo() : WuYiVo{
			return _wuyiInfo;
		}
		public function set wuyiInfo(value:WuYiVo) : void{
			_wuyiInfo = value;
		}
		
		private var _escortInfo:EscortVo;
		public function get escortInfo() : EscortVo{
			return _escortInfo;
		}
		public function set escortInfo(value:EscortVo) : void{
			_escortInfo = value;
		}
		
		private var _midAutumnInfo:MidAutumnVo;
		public function get midAutumnInfo() : MidAutumnVo{
			return _midAutumnInfo;
		}
		public function set midAutumnInfo(value:MidAutumnVo) : void{
			_midAutumnInfo = value;
		}
		
		/**
		 * 初始化 
		 */		
		private var _isInit:Boolean;
		public function get isInit() : Boolean
		{
			return _isInit;
		}
		public function set isInit(value:Boolean) : void
		{
			_isInit = value;
		}

		public function get fodder():String{
			return _anti["fodder"];
		}
		
		public function set fodder(value:String):void
		{
			_anti["fodder"] = value;
		}
		
		private var _signInVo:SignInVo;
		public function get signInVo() : SignInVo{
			return _signInVo;
		}
		public function set signInVo(value:SignInVo) : void{
			_signInVo = value;
		}
		
		private var _vip:VipVo;
		public function get vip() : VipVo{
			return _vip;
		}
		public function set vip(value:VipVo) : void{
			_vip = value;
		}
		
		public function get achieveArr():Array{
			return _anti["achieveArr"];
		}
		public function set achieveArr(value:Array):void
		{
			_anti["achieveArr"] = value;
		}
		
		public function get firstCharge():int{
			return _anti["firstCharge"];
		}
		public function set firstCharge(value:int):void
		{
			_anti["firstCharge"] = value;
		}
		
		private var _jingMai:JingMaiVo;
		public function get jingMai():JingMaiVo{
			return _jingMai;
		}
		public function set jingMai(value:JingMaiVo):void
		{
			_jingMai = value;
		}
		
		public var statisticsInfo:StatisticsVo;
		
		public var summerCarnivalInfo:SummerCarnivalVo;
		
		public function init(configJson:Object) : void{
			isInit = true;
			if(GameConst.useCrypt){
				if(int(configJson["version"]) < 1080){
					parseJson(configJson);
				}else{
					if(judgeCrypt(configJson)){
						var returnString:String = CryptManager.getIns().decrypt(configJson["cryptData"], (configJson["version"] * .1));
						var returnData:Object = com.adobe.serialization.json.JSON.decode(returnString);
						parseJson(returnData);
					}
				}
			}else{
				parseJson(configJson);
			}
		}
		
		//加密判断
		public function judgeCrypt(data:Object) : Boolean{
			var result:Boolean = true;
			if(data["cryptData"] == null || CryptManager.keyObj[int((data["version"] as int) * .1)] == null){
				(ViewFactory.getIns().initView(TipView) as TipView).setFun(
					"经检测，您打开的页面游戏版本过低，请更新到最新版本进行游戏", null, null, true);
				result = false;
			}
			return result;
		}
		
		/**
		 * 解析JSON
		 * 
		 */		
		protected function parseJson(configJson:Object) : void{
			name = configJson["name"];
			money = configJson["money"];
			soul = configJson["soul"];
		    exp = configJson["exp"];
			character = PlayerUtils.assignCharacter(configJson["occupation"], exp);
			PlayerManager.getIns().initLevel();
			occupation = configJson["occupation"];
			strengthenUp = ConfigurationManager.getIns().getObjectByID(AssetsConst.STRENGTHEN_UP,configJson["occupation"]) as StrengthenUp;
			fodder = (occupation==OccupationConst.KUANGWU?"KuangWu":"XiaoYao");
			mainMissionVo = PlayerUtils.assignMissionVo(configJson["main_mission"]);
			gift = PlayerUtils.assignGift(configJson["gift"]);
			vipRepair = (configJson["vipRepair"]==null?0:configJson["vipRepair"]);
			dungeonPass = PlayerUtils.assignDungeonPass(configJson["dungeon_pass"]);
			eliteDungeon = PlayerUtils.assignEliteDungeonPass(configJson["elite_dungeon_pass"]);
			doubleDungeonVo = PlayerUtils.assignDoubleDungeon(configJson["double_dungeon"]);
			dailyMissionVo = PlayerUtils.assignDailyMissionVo(configJson["daily_mission"]);
			hideMissionInfo = PlayerUtils.assignHideMissionVo(configJson["hide_mission"]);
			onlineBonusVo = PlayerUtils.assignOnlineBonus(configJson["online_bonus"]);
			blackMarket = PlayerUtils.assignBlackMarket(configJson["black_market"]);
			vip = PlayerUtils.assignVipVo(configJson["vip"]);
			skill = PlayerUtils.assignSkill(configJson["skill"]);
			partnerSkill = PlayerUtils.assignPartnerSkill(configJson["partnerSkill"]);
			skillUp =  PlayerUtils.assignSkillUp(configJson["skill_up"]);
			equipInfo = PlayerUtils.assignEquip(configJson["now_equipment"]);
			if(configJson["fashionId"]){
				fashionInfo = PlayerUtils.assignFasionId(configJson["fashionId"]);
			}else{
				fashionInfo = PlayerUtils.assignFasionInfo(configJson["fashionInfo"]);
			}
			attachInfo = PlayerUtils.assignAttach(configJson["now_attach"]);
			assistInfo = configJson["now_assist"];
			achieveArr = PlayerUtils.assignAchieve(configJson["achieve"]);
			jingMai = PlayerUtils.assignJingMai(configJson["jingMai"]);
			signInVo = PlayerUtils.assignSignIn(configJson["sign_in"]);
			pkInfo = PlayerUtils.assignPkInfo(configJson["player_killing"]);
			autoFightInfo = PlayerUtils.assignAutoFightInfo(configJson["auto_fight"]);
			baGuaScore = (configJson["baGuaScore"]==null?0:configJson["baGuaScore"]);
			baGuaFortune = (configJson["baGuaFortune"]==null?0:configJson["baGuaFortune"]);
			baGuaRoomMax = (configJson["baGuaRoomMax"]==null?NumberConst.getIns().baGuaRoomMax:configJson["baGuaRoomMax"]);
			baGuaAttachs = PlayerUtils.assignAttachBaGuaPieces(configJson["baGua_attach"]);
			baGuaPieces = PlayerUtils.assignBaGuaPieces(configJson["baGua_pieces"]);
			logVo = PlayerUtils.assignLog(configJson["log"]);
			pack = PlayerUtils.assignPack(configJson["pack"]);
			wuyiInfo = PlayerUtils.assignWuyi(configJson["wuyi"]);
			GuideManager.getIns().guideIndex = (configJson["guide"] == null?0:configJson["guide"]);
			GameSettingManager.getIns().init(configJson["game_setting"]);
			escortInfo = PlayerUtils.assignEscort(configJson["escort"]);
			statisticsInfo = PlayerUtils.assignStatistics(configJson["statistics"]);
			summerCarnivalInfo = PlayerUtils.assignSummerCarnival(configJson["summer_carnival"]);
			heroScriptVo = PlayerUtils.assignHeroScript(configJson["heroScript"]);
			titleInfo = PlayerUtils.assignTitle(configJson["titleInfo"]);
			midAutumnInfo = PlayerUtils.assignMidAutumm(configJson["midAutumn"]);
			pack.packUsed = pack.allWithoutEquiped.length;
			PackManager.getIns().checkPackNumMax();
			PlayerManager.getIns().updatePropertys();
			//PlayerManager.getIns().updateLevelInfo();
			PlayerManager.getIns().checkAllAchieves();
			TitleManager.getIns().checkLogInTitles();
			PackManager.getIns().updatePackBoxs();
			PlayerKillingManager.getIns().startUpdateDate();
			
			if(judgeVersion(int(configJson["version"])) && judgeCheat(configJson["version"])
				&& judgeCheatNow()){
				judgeUpdate();
				RankManager.getIns().submitScoreToRankList();
			}
		}
		
		//版本判断
		private function judgeVersion(version:int):Boolean{
			var result:Boolean = true;
			if(version > GameConst.versionNum){
				(ViewFactory.getIns().initView(TipView) as TipView).setFun(
					"经检测，您打开的页面游戏版本过低，请更新到最新版本进行游戏", null, null, true);
				result = false;
			}
			return result;
		}
		
		//作弊判断
		private function judgeCheat(data:Object):Boolean{
			var result:Boolean = true;
			if(data == null){
				if(money > 400000
					|| soul > 400000
					|| pack.equip.length > 6
					|| PackManager.getIns().searchItemNum(NumberConst.getIns().wanNengId) > 24
					|| PackManager.getIns().searchItemNum(NumberConst.getIns().lifeCoinId) > 30
					|| PackManager.getIns().searchItemNum(NumberConst.getIns().resetSkillBookId) > 3){
					result = false;
					(ViewFactory.getIns().initView(TipView) as TipView).setFun(
						"经检测，您的账号数据存在异常，无法正常进行游戏，请找客服人员核实。", null, null, true);
				}
			}
			return result;
		}
		
		
		//当前版本作弊判断
		private function judgeCheatNow():Boolean{
			var result:Boolean = true;
			//判断技能等级是否大于等级上限（大于则必然作弊）
			/*var arr:Array = this.skillUp.skillLevels;
			for (var i:int=0;i<arr.length;i++){
				if((int(arr[i])+1)*2*5>this.character.lv){
					LogManager.getIns().addCheatLog("skillUp_cheat"+i,int(arr[i]));
					arr[i] = "0";
				}
			}
			this.skillUp.skillLevels = arr;*/
			
			
			//判断装备是否大于6个（大于则必然作弊）
			var equipNum:int = this.pack.equip.length;
			if( equipNum > 6){
				LogManager.getIns().addCheatLog("euip_cheat",equipNum);
			}
			
			
			//判断礼包记录里是否有领取了非礼包的东西
			var giftArr:Array = this.gift;
			for (var j:int=0;j<giftArr.length;j++){
				if(giftArr[j].id<NumberConst.getIns().levelGiftId_20 
					|| giftArr[j].id>NumberConst.getIns().vipGet3){
					LogManager.getIns().addCheatLog("gift_cheat"+j,giftArr[j].id);
				}
			}
			
			return result;
		}
		
		/**
		 * 时间判断
		 * 
		 */		
		private function judgeUpdate():void{
			//escortInfo.judgeResetEscort();
			eliteDungeon.judgeResetFightNum();
			dailyMissionVo.judgeResetDailyMission();
			onlineBonusVo.judgeOnlineBonus();
			signInVo.judgeSignInTime();
			hideMissionJudge();
			blackMarket.judgeResetRefreshNum();
			pkInfo.updatePKLv();
			heroScriptVo.judgeResetFightNum();
			PlayerManager.getIns().player.vip.updateVipGiftDate();
			var result:Boolean = statisticsInfo.judgeStatistics();
			shoulderDisappear();
			assistDisappear();
			attachDisappear();
			fashionDisappear();
			skillUpRepair();
			ShopManager.getIns().getNewBalance();
			ShopManager.getIns().setTotalRechaged(
				function () : void{
					if(result){
						SaveManager.getIns().onSaveGame(null, null, 2);
					}
				}
			);
		}
		
		private function skillUpRepair() : void{
			var arr:Array = this.skillUp.skillLevels;
			for(var i:int = 0; i < arr.length; i++){
				if(int(arr[i]) == 1){
					if(skillUp["skillBooks" + (i + 1)][0] < 5){
						arr[i] = NumberConst.getIns().zero;
					}
				}
			}
			skillUp.skillLevels = arr;
		}
		
		private function hideMissionJudge():void{
			if(mainMissionVo.id > 1017){
				if(!HideMissionManager.getIns().hasHideMission(HideMissionManager.MOZHULIN_ID)){
					HideMissionManager.getIns().addHideMission(HideMissionManager.MOZHULIN_ID);
				}
			}
			if(mainMissionVo.id > 1027){
				if(!HideMissionManager.getIns().hasHideMission(HideMissionManager.TAIXUGUAM_ID)){
					HideMissionManager.getIns().addHideMission(HideMissionManager.TAIXUGUAM_ID);
				}
			}
			if(HideMissionManager.getIns().checkWanEGuOpen){
				if(!HideMissionManager.getIns().hasHideMission(HideMissionManager.WANEGU_ID)){
					HideMissionManager.getIns().addHideMission(HideMissionManager.WANEGU_ID);
				}
			}
		}
		

		
		private function assistDisappear():void{
			if(assistInfo != -1){
				var result:Boolean = false;
				for(var i:int = 0; i < pack.boss.length; i++){
					if(pack.boss[i].id == assistInfo && pack.boss[i].mid == MidConst.ASSIST_POSIOTION){
						result = true;
						break;
					}
				}
				if(result == false){
					assistInfo = -1;
				}
			}
		}
		
		private function attachDisappear():void{
			if(attachInfo.attachArr[0] != -1){
				var result1:Boolean = false;
				for(var i:int = 0; i < pack.boss.length; i++){
					if(pack.boss[i].id == attachInfo.attachArr[0] && pack.boss[i].mid == MidConst.ATTACH_FRONT_POSITION){
						result1 = true;
						break;
					}
				}
				if(result1 == false){
					attachInfo.attachArr[0] = -1;
				}
			}
			
			if(attachInfo.attachArr[1] != -1){
				var result2:Boolean = false;
				for(var j:int = 0; j < pack.boss.length; j++){
					if(pack.boss[j].id == attachInfo.attachArr[1] && pack.boss[j].mid == MidConst.ATTACH_MIDDLE_POSITION){
						result2 = true;
						break;
					}
				}
				if(result2 == false){
					attachInfo.attachArr[1] = -1;
				}
			}
			
			if(attachInfo.attachArr[2] != -1){
				var result3:Boolean = false;
				for(var k:int = 0; k < pack.boss.length; k++){
					if(pack.boss[k].id == attachInfo.attachArr[2] && pack.boss[k].mid == MidConst.ATTACH_BACK_POSITION){
						result3 = true;
						break;
					}
				}
				if(result3 == false){
					attachInfo.attachArr[2] = -1;
				}
			}
			
			for(var l:int = 0; l < pack.boss.length; l++){
				if(pack.boss[l].mid == MidConst.ATTACH_BACK_POSITION && pack.boss[l].id != attachInfo.attachArr[2]){
					pack.boss[l].mid = PackManager.getIns().firstEmptyMid;
				}
			}
		}
		
		
		private function shoulderDisappear():void{
			if(equipInfo.shoulder == -1){
				for(var i:int = 0; i < pack.equip.length; i++){
					var obj:Object = ConfigurationManager.getIns().getObjectByID(AssetsConst.EQUIPMENT, pack.equip[i].id);
					if(obj.type == EquipmentType.SHOULDER && pack.equip[i].mid == -1){
						equipInfo.shoulder = pack.equip[i].id;
						break;
					}
				}
			}
		}
		
		private function fashionDisappear():void{
			if(fashionInfo.fashionId == -1){
				for(var i:int = 0; i < pack.fashion.length; i++){
					if(pack.fashion[i].mid == MidConst.FASHION_POSITION){
						fashionInfo.fashionId = pack.fashion[i].id;
						break;
					}
				}
			}
		}
		
		

		public function getPlayerDataJson() : String
		{
			var data:String;
			var player:Object = new Object();
			
			player.name = this.name;
			player.money = this.money;
			player.soul = this.soul;
			player.exp = this.exp;
			player.occupation = this.character.id;
			player.main_mission = getMission();
			player.gift = getGift();
			player.vipRepair = vipRepair;
			player.dungeon_pass = getDungeonPass();
			player.elite_dungeon_pass = eliteDungeon.getEliteDungeonPass();
			player.now_equipment = getEquip();
			player.fashionInfo = getFasion();
			player.now_attach = getAttach();
			player.now_assist = this.assistInfo;
			player.partnerSkill = getPartnerSkill();
			player.skill = getSkill();
			player.skill_up = getSkillUp();
			player.pack = getPack();
			player.guide = GuideManager.getIns().guideIndex;
			player.double_dungeon = getDoubleDungeon();
			player.daily_mission = getDailyMission();
			player.online_bonus = getOnlineBonus();
			player.game_setting = GameSettingManager.getIns().getSetting();
			player.sign_in = getSignIn();
			player.achieve = getAchieve();
			player.player_killing = getPkInfo();
			player.auto_fight = getAutoFight();
			player.black_market = getBlackMarket();
			player.hide_mission = getHideMission();
			//英雄谱数据
			player.heroScript = getHeroScript();
			//八卦盘数据
			player.baGuaScore = this.baGuaScore;
			//称号数据
			player.titleInfo = getTitle();
			player.baGuaRoomMax = this.baGuaRoomMax;
			player.baGuaFortune = this.baGuaFortune;
			player.baGua_attach = getBaGuaAttach();
			player.baGua_pieces = getBaGuaPieces();
			player.vip = getVip();
			player.wuyi = getWuyi();
			player.escort = getEscort();
			player.statistics = getStatistics();
			//经脉
			player.jingMai = getJingMai();
			player.summer_carnival = getSummerCarnival();
			player.midAutumn = getMidAutumn();
			//player.version = "1.09";
			player.version = GameConst.versionNum;
			//记录数据
			player.log = getLog(); 
			
			data = com.adobe.serialization.json.JSON.encode(player);

			if(GameConst.useCrypt && CryptManager.keyObj[int(GameConst.versionNum * .1)] != null){
				var crypt:Object = new Object();
				crypt.cryptData = CryptManager.getIns().encrypt(data, GameConst.versionNum * .1);
				crypt.version = GameConst.versionNum;
				data = com.adobe.serialization.json.JSON.encode(crypt);
			}
			//trace({"pack":{"special":{"special1":{"id":9003,"num":1,"mid":18},"special4":{"id":9012,"num":1,"mid":20},"special0":{"id":9002,"num":2,"mid":17},"special2":{"id":9011,"num":2,"mid":19},"special3":{"id":9001,"num":2,"mid":16}},"book":{},"material":{"material11":{"id":4303,"num":32,"mid":7},"material8":{"id":4421,"num":3,"mid":12},"material6":{"id":4313,"num":2,"mid":10},"material12":{"id":4102,"num":371,"mid":1},"material5":{"id":4101,"num":369,"mid":0},"material9":{"id":4104,"num":3,"mid":3},"material0":{"id":4301,"num":30,"mid":5},"material2":{"id":4201,"num":5,"mid":4},"material7":{"id":4312,"num":3,"mid":9},"material1":{"id":4302,"num":30,"mid":6},"material3":{"id":4103,"num":5,"mid":2},"material10":{"id":4311,"num":3,"mid":8},"material4":{"id":4411,"num":15,"mid":11}},"bossCard":{"boss1":{"id":10002,"isAssisted":0,"isAttached":0,"mid":21,"lv":1,"isEquiped":0},"boss2":{"id":10001,"isAssisted":0,"isAttached":1,"mid":-3,"lv":2,"isEquiped":1},"boss0":{"id":10003,"isAssisted":1,"isAttached":0,"mid":-2,"lv":1,"isEquiped":1}},"equipment":{"equip3":{"id":1303,"lv":3,"mid":-1,"isEquiped":1},"equip4":{"id":1203,"lv":12,"mid":-1,"isEquiped":1},"equip2":{"id":1503,"lv":1,"mid":-1,"isEquiped":1},"equip1":{"id":1103,"lv":0,"mid":-1,"isEquiped":1},"equip0":{"id":1403,"lv":0,"mid":-1,"isEquiped":1},"equip5":{"id":1003,"lv":29,"mid":-1,"isEquiped":1}},"prop":{"prop0":{"id":6201,"num":12,"mid":14},"prop2":{"id":6203,"num":1,"mid":15},"prop1":{"id":6004,"num":1,"mid":13}},"sum":24},"now_equipment":{"neck":1203,"shoes":1503,"head":1103,"trousers":1403,"weapon":1003,"clothes":1303},"occupation":1,"money":957652,"elite_dungeon_pass":{"1_2":{"hurt":0,"lv":4,"num":0,"hit":95,"name":"1_2","add":0},"2_1":{"hurt":0,"lv":4,"num":0,"hit":132,"name":"2_1","add":0},"1_1":{"hurt":0,"lv":3,"num":0,"hit":77,"name":"1_1","add":0},"2_3":{"hurt":0,"lv":-1,"num":0,"hit":0,"name":"2_3","add":0},"time":{"name":"time","time":"2014-03-11 09:57:38"},"2_2":{"hurt":0,"lv":3,"num":0,"hit":128,"name":"2_2","add":0},"1_3":{"hurt":0,"lv":3,"num":0,"hit":92,"name":"1_3","add":0}},"skill":{"U":2,"H":6,"kungfu1":5,"skill7":0,"L":8,"skill1":0,"skill5":1,"skill8":1,"skill3":0,"O":10,"skill9":0,"skill2":1,"skill6":1,"I":5,"kungfu2":5,"skill10":1,"skill4":0},"dungeon_pass":{"2_7":{"hurt":0,"hit":198,"name":"2_7","lv":3,"add":0},"2_1":{"hurt":0,"hit":273,"name":"2_1","lv":4,"add":0},"1_6":{"hurt":0,"hit":155,"name":"1_6","lv":4,"add":0},"1_1":{"hurt":0,"hit":52,"name":"1_1","lv":3,"add":0},"2_3":{"hurt":0,"hit":205,"name":"2_3","lv":4,"add":0},"1_5":{"hurt":0,"hit":173,"name":"1_5","lv":4,"add":0},"1_8":{"hurt":0,"hit":119,"name":"1_8","lv":4,"add":0},"2_9":{"hurt":0,"hit":223,"name":"2_9","lv":3,"add":0},"1_4":{"hurt":0,"hit":102,"name":"1_4","lv":4,"add":0},"1_9":{"hurt":0,"hit":102,"name":"1_9","lv":4,"add":0},"2_6":{"hurt":0,"hit":178,"name":"2_6","lv":3,"add":0},"2_5":{"hurt":0,"hit":245,"name":"2_5","lv":3,"add":0},"2_8":{"hurt":0,"hit":146,"name":"2_8","lv":3,"add":0},"1_2":{"hurt":0,"hit":69,"name":"1_2","lv":4,"add":0},"1_7":{"hurt":0,"hit":142,"name":"1_7","lv":4,"add":0},"2_4":{"hurt":0,"hit":114,"name":"2_4","lv":4,"add":0},"2_2":{"hurt":0,"hit":211,"name":"2_2","lv":4,"add":0},"1_3":{"hurt":0,"hit":66,"name":"1_3","lv":4,"add":0}},"now_assist":10003,"guide":89,"soul":880462,"now_attach":{"front":10001,"middle":-1,"back":-1},"gift":{"0":{"id":6021,"isGet":true,"getTime":""},"1":{"id":6065,"isGet":true,"getTime":""},"2":{"id":6024,"isGet":true,"getTime":""}},"name":"4399小勇士","exp":2535158,"main_mission":{"id":1027,"isComplete":0}});
			return data;
		}
		
		private function getMidAutumn() : Object{
			var result:Object = new Object();
			result.moonCakeCount = midAutumnInfo.moonCakeCount;
			result.alreadyGet = midAutumnInfo.alreadyGet.join("|");
			return result;
		}
		
		private function getTitle():Object
		{
			var result:Object = new Object();
			result.titleNow = titleInfo.titleNow;
			result.titleShow = titleInfo.titleShow;
			result.titleOwned = getArrString(titleInfo.titleOwned);
			return result;
		}
		
		private function getSummerCarnival() : Object{
			var result:Object = new Object();
			result.summerRecharge = summerCarnivalInfo.summerRecharge.join("|");
			result.summerConsume = summerCarnivalInfo.summerConsume.join("|");
			result.summerTime = summerCarnivalInfo.summerTime;
			return result;
		}
		
		private function getStatistics():Object{
			var result:Object = new Object();
			result.statisticsTime = statisticsInfo.statisticsTime;
			result.publicNoticeCount = statisticsInfo.publicNoticeCount;
			result.weatherPropCount = statisticsInfo.weatherPropCount;
			result.funnyBossCount = statisticsInfo.funnyBossCount;
			result.midAutumnCount = statisticsInfo.midAutumnCount;
			return result;
		}
		
		private function getEscort():Object
		{
			var result:Object = new Object();
			result.time = escortInfo.time;
			result.escortCount = escortInfo.escortCount;
			result.lootCount = escortInfo.lootCount;
			result.escortTime = escortInfo.escortTime;
			result.lootTime = escortInfo.lootTime;
			return result;
		}
		
		private function getWuyi():Object{
			var result:Object = new Object();
			result.isGet = wuyiInfo.isGet;
			result.time = wuyiInfo.time;
			return result;
		}
		
		private function getAutoFight():Object{
			var result:Object = new Object();
			result.autoFightCount = autoFightInfo.autoFightCount;
			result.rpCardCount = autoFightInfo.rpCardCount;
			result.doubleCardCount = autoFightInfo.doubleCardCount;
			return result;
		}
		
		private function getPkInfo():Object{
			var result:Object = new Object();
			result.pkExp = pkInfo.pkExp;
			result.pkWin = pkInfo.pkWin;
			result.pkLose = pkInfo.pkLose;
			result.pkTime = pkInfo.pkTime;
			result.pkCount = pkInfo.pkCount;
			result.pkCanStart = pkInfo.pkCanStart;
			result.preResult = pkInfo.preResult;
			result.pkStatus = pkInfo.pkStatus;
			return result;
		}		

		private function getHideMission():Object{
			var result:Object = new Object();
			for(var i:int = 0; i < hideMissionInfo.length; i++){
				var hideMission:Object = new Object();
				hideMission.id = hideMissionInfo[i].id;
				hideMission.missionConfig = hideMissionInfo[i].missionConfig.join("|");
				hideMission.isComplete = (hideMissionInfo[i].isComplete==true?1:0);
				hideMission.isShow = (hideMissionInfo[i].isShow==true?1:0);
				result[i] = hideMission;
			}
			return result;
		}
		
		private function getSignIn():Object{
			var result:Object = new Object();
			result.signInCount = signInVo.signInCount;
			result.signInTime = signInVo.signInTime;
			result.achievements = signInVo.achievements;
			return result;
		}
		
		private function getAchieve():String{
			return getArrString(achieveArr);
		}
		
		
		private function getHeroScript():Object{
			var result:Object = new Object();
			result.addValueArr = getArrString(heroScriptVo.addValueArr);
			result.heroFightNum = heroScriptVo.heroFightNum;
			result.heroSpecialFightNum = heroScriptVo.heroSpecialFightNum;
			result.heroSpecialFightCount = heroScriptVo.heroSpecialFightCount;
			result.heroTime = heroScriptVo.heroTime;
			return result;
		}
		
		private function getJingMai():Object{
			var result:Object = new Object();
			result.jingMaiArr = getArrString(jingMai.jingMaiArr);
			result.bookPoint = jingMai.bookPoint;
			return result;
		}
		
		private function getOnlineBonus() : Object{
			var result:Object = new Object();
			result.onlineTime = onlineBonusVo.onlineTime;
			result.lv = onlineBonusVo.lv;
			return result;
		}
		
		
		private function getVip():Object{
			var result:Object = new Object();
			result.vipGiftGetTime = vip.vipGiftGetTime;
			result.isVipGiftGet = (vip.isVipGiftGet==true?1:0);
			result.totalRecharge = vip.totalRecharge;
			result.curCoupon = vip.curCoupon;
			result.firstCharge = vip.firstCharge;
			return result;
		}
		
		private function getLog():Object{
			var result:Object = new Object();
			
			result.gift = new Object();
			result.mission = new Object();
			
			for(var i:int=0;i<this.logVo.giftLogs.length;i++){
				var gift:Object = new Object();
				gift.id = this.logVo.giftLogs[i].id;
				gift.type = this.logVo.giftLogs[i].type;
				gift.time = this.logVo.giftLogs[i].time;
				
				var day1:Number = TimeManager.getIns().disDayNum(TimeManager.getIns().returnTimeNowStr(),gift.time);
				if(day1>-7){
					result.gift[i] = gift;	
				}
				
			}
			
			for(var j:int=0;j<this.logVo.missionLogs.length;j++){
				var mission:Object = new Object();
				mission.type = this.logVo.missionLogs[j].type;
				mission.num = this.logVo.missionLogs[j].num;
				mission.time = this.logVo.missionLogs[j].time;
				
				var day2:Number = TimeManager.getIns().disDayNum(TimeManager.getIns().returnTimeNowStr(),mission.time);
				if(day2>-7){
					result.mission[j] = mission;
				}
				
			}
			
			result.nameChange = this.logVo.nameChange;
			
			return result;
		}
		
		private function getBlackMarket() : Object{
			var result:Object = new Object();
			
			var items:Array = new Array();
			for(var i:int =0;i<blackMarket.items.length;i++){
				var item:String = blackMarket.items[i].id+":"+blackMarket.items[i].coupon;
				items.push(item);
			}
			result.items = getArrString(items);
			result.itemsEnable = getArrString(blackMarket.itemsEnable);
			result.blackMarketTime = blackMarket.blackMarketTime;
			result.freeRefresh = blackMarket.freeRefresh;
			
			return result;
		}
		
		private function getArrString(arr:Array):String{
			var result:String = "";
			for(var i:int = 0; i<arr.length;i++){
				if(i==arr.length-1){
					result+=arr[i];
				}else{
					result+=arr[i]+"|";
				}
			}
			return result;
		}
		
		private function getDoubleDungeon() : Object{
			var doubleDungeon:Object = new Object();
			doubleDungeon.doubleTime = doubleDungeonVo.doubleTime;
			doubleDungeon.dungeonName = doubleDungeonVo.dungeonName;
			return doubleDungeon;
		}
		
		private function getDailyMission() : Object{
			var dailyMission:Object = new Object();
			dailyMission.missionTime = dailyMissionVo.missionTime;
			dailyMission.missionCount = dailyMissionVo.missionCount;
			dailyMission.missionDungeon = dailyMissionVo.missionDungeon;
			dailyMission.missionType = dailyMissionVo.missionType;
			dailyMission.materialType = dailyMissionVo.materialType;
			dailyMission.isComplete = (dailyMissionVo.isComplete==true?1:0);
			
			return dailyMission;
		}
		
		private function getEquip() : Object
		{
			var equip:Object = new Object(); 
			equip.weapon = this.equipInfo.weapon;
			equip.head = this.equipInfo.head;
			equip.neck = this.equipInfo.neck;
			equip.clothes = this.equipInfo.clothes;
			equip.shoulder = this.equipInfo.shoulder;
			equip.shoes = this.equipInfo.shoes;
			
			return equip;
		}
		
		
		private function getFasion():Object{
			var fashionInfo:Object = new Object(); 
			fashionInfo.fashionId = this.fashionInfo.fashionId;
			fashionInfo.showFashion = this.fashionInfo.showFashion;
			
			return fashionInfo;
		}
		
		private function getAttach() : Object
		{
			var attach:Object = new Object(); 
			attach.front = this.attachInfo.attachArr[0];
			attach.middle = this.attachInfo.attachArr[1];
			attach.back = this.attachInfo.attachArr[2];
			
			return attach;
		}
		
		private function getSkill() : Object
		{
			var skill:Object = new Object(); 
			skill.kungfu1 = this.skill.kungfu1;
			skill.kungfu2 = this.skill.kungfu2;
			for(var i:int=1;i<11;i++){
				var str:String = "skill"+i;
				skill[str]=this.skill.skillArr[i - 1];
			}
			skill.H = this.skill.skill_H;
			skill.U = this.skill.skill_U;
			skill.I = this.skill.skill_I;
			skill.O = this.skill.skill_O;
			skill.L = this.skill.skill_L;
			
			return skill;
		}
		
		private function getPartnerSkill() : Object
		{
			var partnerSkill:Object = new Object(); 
			partnerSkill.key4 = this.partnerSkill.skill_4;
			partnerSkill.key5 = this.partnerSkill.skill_5;
			partnerSkill.key6 = this.partnerSkill.skill_6;
			partnerSkill.key7 = this.partnerSkill.skill_7;
			partnerSkill.key8 = this.partnerSkill.skill_8;
			
			return partnerSkill;
		}
		
		
		private function getSkillUp():Object
		{
			var result:Object = new Object();
			
			result["skillLevels"] = getArrString(skillUp.skillLevels);
			for(var i:int=1;i<=10;i++){
				result["skillBooks"+i] = getArrString(skillUp["skillBooks"+i]);
			}
			return result;
		}
	
		private function getBaGuaPieces():Object
		{
			var pieces:Object = new Object(); 
			for(var i:int=0;i<this.baGuaPieces.length;i++){
				var piece:Object = new Object();
				piece.id = this.baGuaPieces[i].id;
				piece.cid = this.baGuaPieces[i].cid;
				piece.exp = this.baGuaPieces[i].exp;
				piece.lv = this.baGuaPieces[i].lv;
				piece.protect = this.baGuaPieces[i].protect;
				pieces[i] = piece;
			}
			return pieces;
		}
		
		private function getBaGuaAttach():Object
		{
			var result:Object = new Object();
			result = getArrString(this.baGuaAttachs);
			return result;
		}
		
		
		private function getMission() : Object
		{
			var mission:Object = new Object(); 
			mission.id = this.mainMissionVo.id;
			mission.isComplete = this.mainMissionVo.isComplete==true?1:0;
			return mission;
		}
		
		private function getGift():Object
		{
			var giftss:Object = new Object(); 
			for(var i:int=0;i<this.gift.length;i++){
				var gift:Object = new Object();
				gift.id = this.gift[i].id;
				gift.isGet = this.gift[i].isGet;
				gift.getTime = this.gift[i].getTime;
				giftss[i] = gift;
			}
			return giftss;
		}
		
		private function getDungeonPass() : Object
		{
			var dungeons:Object = new Object(); 
			for(var i:int=0;i<this.dungeonPass.length;i++){
				var dungeon:Object = new Object();
				dungeon.name = this.dungeonPass[i].name;
				dungeon.lv = this.dungeonPass[i].lv;
				dungeon.hit = this.dungeonPass[i].hit;
				dungeon.hurt = this.dungeonPass[i].hurt;
				dungeon.add = this.dungeonPass[i].add;
				dungeon.time = this.dungeonPass[i].time;
				dungeons[dungeon.name] = dungeon;
			}
			
			return dungeons;
		}
		
		private function getPack():Object{
			var pack:Object = new Object();
			pack.sum = this.pack.packMaxRoom;
			pack.equipment = getPackEquip();
			pack.material = getPackMaterial()
			pack.book = getPackBook();
			pack.special = getPackSpecial();
			pack.prop = getPackProp();
			pack.bossCard = getPackBossCard();
			pack.fashion = getPackFashion();
			return pack;
		}
		
		private function getPackEquip():Object{
			var equips:Object = new Object(); 
			for(var i:int=0;i<this.pack.equip.length;i++){
				var equip:Object = new Object();
				var equipVo:ItemVo = this.pack.equip[i];
				equip.mid = equipVo.mid;
				equip.id = equipVo.id;
				equip.lv = equipVo.lv;
				equip.isEquiped = equipVo.isEquiped==true?1:0;
				equip.chargeLv = getArrString(equipVo.equipConfig.chargeLvArr);
				var str:String = "equip"+i;
				equips[str] = equip;
			}
			
			return equips;
		}
		
		private function getPackMaterial():Object{
			var materials:Object = new Object(); 
			for(var i:int=0;i<this.pack.material.length;i++){
				var material:Object = new Object();
				material.mid = this.pack.material[i].mid;
				material.id = this.pack.material[i].id;
				material.num = this.pack.material[i].num;
				var str:String = "material"+i;
				materials[str] = material;
			}
			
			return materials;
		}
		
		private function getPackBook():Object{
			var books:Object = new Object(); 
			for(var i:int=0;i<this.pack.book.length;i++){
				var book:Object = new Object();
				book.mid = this.pack.book[i].mid;
				book.id = this.pack.book[i].id;
				book.num = this.pack.book[i].num;
				var str:String = "book"+i;
				books[str] = book;
			}
			
			return books;
		}
		
		private function getPackSpecial():Object{
			var specials:Object = new Object(); 
			for(var i:int=0;i<this.pack.special.length;i++){
				var special:Object = new Object();
				special.mid = this.pack.special[i].mid;
				special.id = this.pack.special[i].id;
				special.num = this.pack.special[i].num;
				var str:String = "special"+i;
				specials[str] = special;
			}
			
			return specials;
		}
		
		private function getPackProp():Object{
			var props:Object = new Object(); 
			for(var i:int=0;i<this.pack.prop.length;i++){
				var prop:Object = new Object();
				prop.mid = this.pack.prop[i].mid;
				prop.id = this.pack.prop[i].id;
				prop.num = this.pack.prop[i].num;
				var str:String = "prop"+i;
				props[str] = prop;
			}
			
			return props;
		}
		
		private function getPackBossCard():Object{
			var bosses:Object = new Object(); 
			for(var i:int=0;i<this.pack.boss.length;i++){
				var boss:Object = new Object();
				boss.mid = this.pack.boss[i].mid;
				boss.id = this.pack.boss[i].id;
				boss.lv = this.pack.boss[i].lv;
				boss.isEquiped = this.pack.boss[i].isEquiped==true?1:0;
				boss.isAttached = this.pack.boss[i].isAttached==true?1:0;
				boss.isAssisted = this.pack.boss[i].isAssisted==true?1:0;
				var str:String = "boss"+i;
				bosses[str] = boss;
			}
			
			return bosses;
		}
		
		private function getPackFashion():Object{
			var fashions:Object = new Object(); 
			for(var i:int=0;i<this.pack.fashion.length;i++){
				var fashion:Object = new Object();
				fashion.mid = this.pack.fashion[i].mid;
				fashion.id = this.pack.fashion[i].id;
				fashion.time = this.pack.fashion[i].time;
				var str:String = "fashion"+i;
				fashions[str] = fashion;
			}
			return fashions;
		}

		public function get items():Vector.<Item>
		{
			return _items;
		}

		public function set items(value:Vector.<Item>):void
		{
			_items = value;
		}

		public function get property():Property
		{
			return _property;
		}

		public function set property(value:Property):void
		{
			_property = value;
		}


	}
}