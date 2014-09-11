package com.test.game.Const
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.Singleton;
	
	public class NumberConst extends Singleton
	{
		private var _anti:Antiwear;
		public static const GAME_WIDTH:uint = 940;
		public static const GAME_HEIGHT:uint = 590;
		
		
		public function NumberConst()
		{
			_anti = new Antiwear(new binaryEncrypt());
			gameId = 152;
			apiGameID = 100021992;
			tenYearsGameID = 19;
				
			itemNumMax= 999;
			negativeOne = -1;
			negativeTwo = -2;
			negativeThree = -3;
			zero= 0;
			one = 1;
			initialBagSum = 24;
			summonBossCost = 25;
			maxBossLv = 15;
			dailyMissionMaxCount = 10;
			wanNengId = 9000;
			maxLv = 50;
			missionIdEnd = 1048;
			_anti["lastDungeon"] = "5_1";
			
			//高手卡
			gaoShouCard = 6103;
			cardNum = 30;
			enableGaoShouCardMissionId = 1007;
			//人品卡
			rpCard = 6101;
			//双倍卡
			doubleCard = 6102;
			//改名卡
			changeNameCard = 6104;
			
			lifeCoinId = 6201;
			jinNangBoxId = 6202;
			resetSkillBookId = 6203;
			refreshCouponId = 6204;
			wanNengKeyId = 6205;
			bossUpPrice = 1000;
			expId = 6105;
			highExpId = 6106;
			moonCakeId = 6208;
			
			
			//礼包本地ID
			levelGiftId_20 = 6001;
			levelGiftId_200 = 6020;
			beginnerGiftId = 6021;
			jiangHuGiftId = 6022;
			guiZuGiftId = 6023;
			wuYiGiftId = 6054;
			wuYiGiftDate = "2014-05-07";
			returnGiftId = 6024;
			duanwuGiftId = 6056;
			duanwuGiftDate = "2014-06-10";
			openingGiftId = 6065;
			returnGiftDate = "2014-06-11";
			openingGiftDate = "2014-04-11";
			fiveYearsGiftId = 6028;
			fiveYearsGiftDate = "2014-07-21";
			tenYearsGiftId = 6025;
			tenYearsGiftDate = "2014-07-27";
			firstChargeGiftId = 6027;
			qiXiGiftId = 6058;
			huiKuiGiftId = 6026;
			zhongQiuGiftId = 6060;
			zhongQiuGiftDate = "2014-09-10";
			zhongQiuDay = 5;
			moonCakeGiftDate = "2014-09-08";
			moonCakeDay = 6;
			
			giftIdArray =  [guiZuGiftId, zhongQiuGiftId];
			
			//积分礼包服务器ID
			scoreGiftNetId = 856;
			duanwuGiftNetId = 1282;
			fiveGiftNetId = 1862;
			qiXiGiftNetId = 2262;
			zhongQiuNetId = 2840;
			
			_anti["timeMinute"] = 60;
			_anti["normalBossCount"] = 800;
			blackMarketRecommend = [wanNengId,lifeCoinId,resetSkillBookId,refreshCouponId,wanNengKeyId];
			_anti["fiveBossCount"] = 4000;
			_anti["purpleBossCount"] = 5000;
			_anti["greenCardRate"] = .4;
			_anti["purpleCardRate"] = 0.02;
			_anti["two"] = 2;
			_anti["three"] = 3;
			_anti["four"] = 4;
			_anti["five"] = 5;
			_anti["six"] = 6;
			_anti["seven"] = 7;
			_anti["eight"] = 8;
			_anti["ten"] = 10;
			_anti["twenty"] = 20;
			_anti["thirty"] = 30;
			_anti["fifty"] = 50;
			_anti["seventy"] = 70;
			_anti["ninety"] = 90
			_anti["xiaoYaoEvasionRate"] = .4;
			_anti["xiaoYaoHurtDeepenRate"] = .5;
			_anti["kuangWuSpeedRate"] = .5;
			_anti["kuangWuCritRate"] = .25;
			buyItemMaxNum = 99;
			
			_anti["assessDing"] = 8;
			_anti["assessBing"] = 9;
			_anti["assessYi"] = 10;
			_anti["assessJia"] = 11;
			_anti["assessJi"] = 12;
			
			_anti["protectedBuffLv"] = 15;
			
			_anti["autoFightRate"] = 0.5;
			_anti["pkMaxLv"] = 10;
			
			_anti["vipLuckyRate"] = .03;
			_anti["vipExpRate"] = .5;
			_anti["rpRate"] = .15;
			
			_anti["wuyiDate"] = "2014-05-01";
			_anti["childrenDay"] = "2014-06-01";
			_anti["summerStartDate"] = "2014-07-01|00:00:00";
			_anti["summerEndDate"] = "2014-08-31|23:59:59";
			
			//八卦盘
			fortuneMax = 32;
			fivePercentage = 5;
			fiftyPercentage = 50;
			buMingPrice = 500;
			baGuaRoomMax = 18;
			xianLingPrice = 1000;
			suanGuaBaseScore = 512;
			suanGuaCost = 50;
			_anti["baguaGreen"] = 10;
			_anti["baguaBlue"] = 20;
			_anti["baguaPurple"] = 40;
			
			blueBaguaPropId = 1563;
			blueBaguaPrice = 30;
			purpleBaguaPropId = 1564;
			purpleBaguaPrice = 300;
			baguaMaxLv = 10;
			
			
			
			//采集道具
			materialTool_1 = 5001;
			materialTool_2 = 5002;
			materialTool_3 = 5003;
			
			//经脉
			jingMaiMax = 16;
			
			//称号
			title_1 = 7501;
			title_2 = 7502;
			title_3 = 7503;
			title_4 = 7504;
			title_5 = 7505;
			title_6 = 7506;
			title_7 = 7507;
			title_8 = 7508;
			title_9 = 7509;
			title_10 = 7510;
			
			//天气充能
			weatherCombinePrice = 10000;
			
			//vip
			vipMaxLv = 5;
			vipGift1 = 6080;
			vipGift2 = 6081;
			vipGift3 = 6082;
			vipGift4 = 6083;
			vipGift5 = 6084;
			vipGet1 = 6090;
			vipGet2 = 6091;
			vipGet3 = 6092;
			vipGet4 = 6093;
			vipGet5 = 6094;
			
			_anti["micrometer4"] = 0.004;
			_anti["percent3"] = .03;
			_anti["percent5"] = .05;
			_anti["percent7"] = .07;
			_anti["percent10"] = .1;
			_anti["percent20"] = .2;
			_anti["percent25"] = .25;
			_anti["percent30"] = .3;
			_anti["percent50"] = .5;
			_anti["percent60"] = .6;
			_anti["percent70"] = .7;
			_anti["percent80"] = .8;
			_anti["percent90"] = .9;
			_anti["percent93"] = .93;
			_anti["percent95"] = .95;
			
			_anti["exceptionEscort"] = 4;
			_anti["hideMissionRate"] = 1.5;
			
			_anti["haoHuaBiaoCheCoupon"] = 200;
			_anti["haoHuaBiaoCheID"] = 1642;
			_anti["heroFightCoupon"] = 299;
			_anti["heroFightID"] = 1740;
			_anti["funnyBossCoupon"] = 250;
			_anti["funnyBossID"] = 1813;			
			
			_anti["autoFightMissionID"] = 1009;
			
			_anti["oneHundred"] = 100;
			_anti["fiveHundred"] = 500;
			_anti["oneThousand"] = 1000;
			_anti["fiveThousand"] = 5000;
			_anti["tenThousand"] = 10000;
			_anti["twentyThousand"] = 20000;
			_anti["fiftyThousand"] = 50000;
			_anti["oneHundredThousand"] = 100000;
			
			_anti["weatherSelectID"] = 6207;
			
			super();
		}
		
		public function get oneHundred() : int{
			return _anti["oneHundred"];
		}
		public function get fiveHundred() : int{
			return _anti["fiveHundred"];
		}
		public function get oneThousand() : int{
			return _anti["oneThousand"];
		}
		public function get fiveThousand() : int{
			return _anti["fiveThousand"];
		}
		public function get tenThousand() : int{
			return _anti["tenThousand"];
		}
		public function get twentyThousand() : int{
			return _anti["twentyThousand"];
		}
		public function get fiftyThousand() : int{
			return _anti["fiftyThousand"];
		}
		public function get oneHundredThousand() : int{
			return _anti["oneHundredThousand"];
		}
		
		public function get autoFightMissionID() : int{
			return _anti["autoFightMissionID"];
		}
		public function get haoHuaBiaoCheCoupon() : int{
			return _anti["haoHuaBiaoCheCoupon"];
		}
		public function get haoHuaBiaoCheID() : int{
			return _anti["haoHuaBiaoCheID"];
		}
		public function get hideMissionRate() : Number{
			return _anti["hideMissionRate"];
		}
		//劫镖护镖例外的大关卡
		public function get exceptionEscort() : int{
			return _anti["exceptionEscort"];
		}
		//当前可打到的最后一个关卡
		public function get lastDungeon() : String{
			return _anti["lastDungeon"];
		}
		public function get heroFightID() : int{
			return _anti["heroFightID"];
		}
		public function get heroFightCoupon() : int{
			return _anti["heroFightCoupon"];
		}
		public function get funnyBossID() : int{
			return _anti["funnyBossID"];
		}
		public function get funnyBossCoupon() : int{
			return _anti["funnyBossCoupon"];
		}
		
		public function get childrenDay() : String{
			return _anti["childrenDay"];
		}
		
		public function get summerStartDate() : String{
			return _anti["summerStartDate"];
		}
		
		public function get summerEndDate() : String{
			return _anti["summerEndDate"];
		}
		
		public function get micrometer4() : Number{
			return _anti["micrometer4"];
		}
		
		public function get percent3() : Number{
			return _anti["percent3"];
		}
		public function get percent5() : Number{
			return _anti["percent5"];
		}
		public function get percent7() : Number{
			return _anti["percent7"];
		}
		public function get percent10() : Number{
			return _anti["percent10"];
		}
		public function get percent20() : Number{
			return _anti["percent20"];
		}
		public function get percent25() : Number{
			return _anti["percent25"];
		}
		public function get percent30() : Number{
			return _anti["percent30"];
		}
		public function get percent50() : Number{
			return _anti["percent50"];
		}
		public function get percent60() : Number{
			return _anti["percent60"];
		}
		public function get percent70() : Number{
			return _anti["percent70"];
		}
		public function get percent80() : Number{
			return _anti["percent80"];
		}
		public function get percent90() : Number{
			return _anti["percent90"];
		}
		public function get percent93() : Number{
			return _anti["percent93"];
		}
		public function get percent95() : Number{
			return _anti["percent95"];
		}
		
		public function get wuyiDate() : String{
			return _anti["wuyiDate"];
		}
		public function get vipExpRate() : Number{
			return _anti["vipExpRate"];
		}
		public function get vipLuckyRate() : Number{
			return _anti["vipLuckyRate"];
		}
		public function get pkMaxLv() : int{
			return _anti["pkMaxLv"];
		}
		public function get autoFightRate() : Number{
			return _anti["autoFightRate"];
		}
		public function get rpRate() : Number{
			return _anti["rpRate"];
		}
		
		/**
		 * 游戏Id
		 */		
		public function get gameId() : int
		{
			return 	_anti["gameId"];
		}
		public function set gameId(value:int) : void
		{
			_anti["gameId"] = value;
		}
		
		public function get apiGameID() : int{
			return _anti["apiGameID"];
		}
		public function set apiGameID(value:int) : void{
			_anti["apiGameID"] = value;
		}
		
		public function get tenYearsGameID() : int{
			return _anti["tenYearsGameID"];
		}
		public function set tenYearsGameID(value:int) : void{
			_anti["tenYearsGameID"] = value;
		}
		
		public function get baguaGreen() : int{
			return _anti["baguaGreen"];
		}
		public function get baguaBlue() : int{
			return _anti["baguaBlue"];
		}
		public function get baguaPurple() : int{
			return _anti["baguaPurple"];
		}
		
		public static function getIns():NumberConst{
			return Singleton.getIns(NumberConst);
		}
		
		public function get assessDing() : int{
			return _anti["assessDing"];
		}
		public function get assessBing() : int{
			return _anti["assessBing"];
		}
		public function get assessYi() : int{
			return _anti["assessYi"];
		}
		public function get assessJia() : int{
			return _anti["assessJia"];
		}
		public function get assessJi() : int{
			return _anti["assessJi"];
		}
		
		public function set buyItemMaxNum(value:int) : void{
			_anti["southMarketMaxNum"] = value;
		}
		public function get buyItemMaxNum() : int{
			return _anti["southMarketMaxNum"];
		}
		
		public function get kuangWuSpeedRate() : Number{
			return _anti["kuangWuSpeedRate"];
		}
		public function get kuangWuCritRate() : Number{
			return _anti["kuangWuCritRate"];
		}
		public function get xiaoYaoEvesionRate() : Number{
			return _anti["xiaoYaoEvasionRate"];
		}
		public function get xiaoYaoHurtDeepenRate() : Number{
			return _anti["xiaoYaoHurtDeepenRate"];
		}
		public function get two() : int{
			return _anti["two"];
		}
		public function get three() : int{
			return _anti["three"];
		}
		public function get four() : int{
			return _anti["four"];
		}
		public function get five() : int{
			return _anti["five"];
		}
		public function get eight() : int{
			return _anti["eight"];
		}
		public function get ten() : int{
			return _anti["ten"];
		}
		public function get protectedBuffLv() : int{
			return _anti["protectedBuffLv"]
		}
		public function get twenty() : int{
			return _anti["twenty"]
		}
		public function get thirty() : int{
			return _anti["thirty"];
		}
		public function get fifty() : int{
			return _anti["fifty"];
		}
		public function get six() : int{
			return _anti["six"];
		}
		public function get seven() : int{
			return _anti["seven"];
		}
		public function get seventy() : int{
			return _anti["seventy"];
		}
		public function get ninety() : int{
			return _anti["ninety"];
		}
		
		public function get greenCardRate() : Number{
			return _anti["greenCardRate"];
		}
		public function get purpleCardRate() : Number{
			return _anti["purpleCardRate"];
		}
		
		/**
		 * 数字-1
		 */		
		public function get negativeOne() : int
		{
			return 	_anti["negativeOne"];
		}
		public function set negativeOne(value:int) : void
		{
			_anti["negativeOne"] = value;
		}
		
		/**
		 * 数字-2
		 */		
		public function get negativeTwo() : int
		{
			return 	_anti["negativeTwo"];
		}
		public function set negativeTwo(value:int) : void
		{
			_anti["negativeTwo"] = value;
		}
		
		/**
		 * 数字-3
		 */		
		public function get negativeThree() : int
		{
			return 	_anti["negativeThree"];
		}
		public function set negativeThree(value:int) : void
		{
			_anti["negativeThree"] = value;
		}
		
		
		
		
		/**
		 * 数字0
		 */		
		public function get zero() : int
		{
			return 	_anti["zero"];
		}
		public function set zero(value:int) : void
		{
			_anti["zero"] = value;
		}
		
		/**
		 * 数字1
		 */		
		public function get one() : int
		{
			return 	_anti["one"];
		}
		public function set one(value:int) : void
		{
			_anti["one"] = value;
		}

		
		/**
		 * 初始背包容量
		 */		
		public function get initialBagSum() : int
		{
			return 	_anti["initialBagSum"];
		}
		public function set initialBagSum(value:int) : void
		{
			_anti["initialBagSum"] = value;
		}
		
		
		/**
		 * 最高等级
		 */		
		public function get maxLv() : int
		{
			return 	_anti["maxLv"];
		}
		public function set maxLv(value:int) : void
		{
			_anti["maxLv"] = value;
		}

		/**
		 * 合成BOSS卡片要求
		 */		
		public function get summonBossCost() : int
		{
			return 	_anti["summonBossCost"];
		}
		public function set summonBossCost(value:int) : void
		{
			_anti["summonBossCost"] = value;
		}
		

		
		
		/**
		 * 橙三星BOSS等级
		 */		
		public function get bossMaxLv() : int
		{
			return 	_anti["maxBossLv"];
		}
		public function set maxBossLv(value:int) : void
		{
			_anti["maxBossLv"] = value;
		}
		
		/**
		 * 当前最终任务ID
		 */		
		public function get missionIdEnd() : int
		{
			return 	_anti["missionIdEnd"];
		}
		public function set missionIdEnd(value:int) : void
		{
			_anti["missionIdEnd"] = value;
		}
		
		/**
		 * 每日任务次数最大值
		 */		
		public function get dailyMissionMaxCount() : int
		{
			return 	_anti["dailyMissionMaxCount"];
		}
		public function set dailyMissionMaxCount(value:int) : void
		{
			_anti["dailyMissionMaxCount"] = value;
		}
		
		/**
		 * 万能碎片ID
		 */		
		public function get wanNengId() : int
		{
			return 	_anti["wanNengId"];
		}
		public function set wanNengId(value:int) : void
		{
			_anti["wanNengId"] = value;
		}
		
		/**
		 * 高手卡ID
		 */		
		public function get gaoShouCard() : int
		{
			return 	_anti["gaoShouCard"];
		}
		public function set gaoShouCard(value:int) : void
		{
			_anti["gaoShouCard"] = value;
		}
		
		
		/**
		 * 高手卡
		 */		
		public function get cardNum() : int
		{
			return 	_anti["cardNum"];
		}
		public function set cardNum(value:int) : void
		{
			_anti["cardNum"] = value;
		}
		
		
		/**
		 * 高手卡开启任务id
		 */		
		public function get enableGaoShouCardMissionId() : int
		{
			return 	_anti["enableGaoShouCardMissionId"];
		}
		public function set enableGaoShouCardMissionId(value:int) : void
		{
			_anti["enableGaoShouCardMissionId"] = value;
		}
		
		/**
		 * 人品卡id
		 */		
		public function get rpCard() : int
		{
			return 	_anti["rpCard"];
		}
		public function set rpCard(value:int) : void
		{
			_anti["rpCard"] = value;
		}
		
		/**
		 * 双倍卡id
		 */		
		public function get doubleCard() : int
		{
			return 	_anti["doubleCard"];
		}
		public function set doubleCard(value:int) : void
		{
			_anti["doubleCard"] = value;
		}
		
		/**
		 * 改名卡id
		 */		
		public function get changeNameCard() : int
		{
			return 	_anti["changeNameCard"];
		}
		public function set changeNameCard(value:int) : void
		{
			_anti["changeNameCard"] = value;
		}
		

		
		/**
		 * 复活币ID
		 */		
		public function get lifeCoinId() : int
		{
			return 	_anti["lifeCoinId"];
		}
		public function set lifeCoinId(value:int) : void
		{
			_anti["lifeCoinId"] = value;
		}
		
		/**
		 * 锦囊宝盒ID
		 */		
		public function get jinNangBoxId() : int
		{
			return 	_anti["jinNangBoxId"];
		}
		public function set jinNangBoxId(value:int) : void
		{
			_anti["jinNangBoxId"] = value;
		}
		
		/**
		 * 重修之书ID
		 */		
		public function get resetSkillBookId() : int
		{
			return 	_anti["resetSkillBookId"];
		}
		public function set resetSkillBookId(value:int) : void
		{
			_anti["resetSkillBookId"] = value;
		}
		
		/**
		 * 刷新券ID
		 */		
		public function get refreshCouponId() : int
		{
			return 	_anti["refreshCouponId"];
		}
		public function set refreshCouponId(value:int) : void
		{
			_anti["refreshCouponId"] = value;
		}
		
		/**
		 * 万能钥匙ID
		 */		
		public function get wanNengKeyId() : int
		{
			return 	_anti["wanNengKeyId"];
		}
		public function set wanNengKeyId(value:int) : void
		{
			_anti["wanNengKeyId"] = value;
		}
		
		public function get expId() : int{
			return _anti["expId"];
		}
		public function set expId(value:int) : void{
			_anti["expId"] = value;
		}
		
		public function get highExpId() : int{
			return _anti["highExpId"];
		}
		public function set highExpId(value:int) : void{
			_anti["highExpId"] = value;
		}
		
		public function get moonCakeId() : int{
			return _anti["moonCakeId"];
		}
		public function set moonCakeId(value:int) : void{
			_anti["moonCakeId"] = value;
		}
		
		/**
		 * 20级礼包ID
		 */		
		public function get levelGiftId_20() : int
		{
			return 	_anti["levelGiftId_20"];
		}
		public function set levelGiftId_20(value:int) : void
		{
			_anti["levelGiftId_20"] = value;
		}
		
		/**
		 * 200级礼包ID
		 */		
		public function get levelGiftId_200() : int
		{
			return 	_anti["levelGiftId_200"];
		}
		public function set levelGiftId_200(value:int) : void
		{
			_anti["levelGiftId_200"] = value;
		}
		
		/**
		 * 回归礼包ID
		 */		
		public function get returnGiftId() : int
		{
			return 	_anti["returnGiftId"];
		}
		public function set returnGiftId(value:int) : void
		{
			_anti["returnGiftId"] = value;
		}
		


		/**
		 * 回归礼包截止日期
		 */		
		public function get returnGiftDate() : String
		{
			return 	_anti["returnGiftDate"];
		}
		public function set returnGiftDate(value:String) : void
		{
			_anti["returnGiftDate"] = value;
		}
		
		
		/**
		 * 新手礼包ID
		 */		
		public function get beginnerGiftId() : int
		{
			return 	_anti["beginnerGiftId"];
		}
		public function set beginnerGiftId(value:int) : void
		{
			_anti["beginnerGiftId"] = value;
		}
		
		/**
		 * 开服礼包ID
		 */		
		public function get openingGiftId() : int
		{
			return 	_anti["openingGiftId"];
		}
		public function set openingGiftId(value:int) : void
		{
			_anti["openingGiftId"] = value;
		}

		/**
		 * 开服礼包截止日期
		 */		
		public function get openingGiftDate() : String
		{
			return 	_anti["openingGiftDate"];
		}
		public function set openingGiftDate(value:String) : void
		{
			_anti["openingGiftDate"] = value;
		}
		
		/**
		 * 五一劳动节礼包ID
		 */		
		public function get wuYiGiftId() : int
		{
			return 	_anti["wuYiGiftId"];
		}
		public function set wuYiGiftId(value:int) : void
		{
			_anti["wuYiGiftId"] = value;
		}
		
		/**
		 * 五一劳动节礼包截止日期
		 */		
		public function get wuYiGiftDate() : String
		{
			return 	_anti["wuYiGiftDate"];
		}
		public function set wuYiGiftDate(value:String) : void
		{
			_anti["wuYiGiftDate"] = value;
		}
		
		//十周年礼包
		public function get tenYearsGiftId() : int{
			return 	_anti["tenYearsGiftId"];
		}
		public function set tenYearsGiftId(value:int) : void{
			_anti["tenYearsGiftId"] = value;
		}
		
		//十周年礼包截止日期
		public function get tenYearsGiftDate() : String
		{
			return 	_anti["tenYearsGiftDate"];
		}
		public function set tenYearsGiftDate(value:String) : void
		{
			_anti["tenYearsGiftDate"] = value;
		}
		
		public function get fiveYearsGiftId() : int{
			return 	_anti["fiveYearsGiftId"];
		}
		public function set fiveYearsGiftId(value:int) : void{
			_anti["fiveYearsGiftId"] = value;
		}
		
		public function get fiveYearsGiftDate() : String{
			return 	_anti["fiveYearsGiftDate"];
		}
		public function set fiveYearsGiftDate(value:String) : void{
			_anti["fiveYearsGiftDate"] = value;
		}
		
		//七夕礼包id
		public function get qiXiGiftId() : int{
			return 	_anti["qiXiGiftId"];
		}
		public function set qiXiGiftId(value:int) : void{
			_anti["qiXiGiftId"] = value;
		}
		
		public function get zhongQiuGiftId() : int{
			return _anti["zhongQiuGiftId"];
		}
		public function set zhongQiuGiftId(value:int) : void{
			_anti["zhongQiuGiftId"] = value;
		}
		
		public function get zhongQiuGiftDate() : String{
			return _anti["zhongQiuGiftDate"];
		}
		public function set zhongQiuGiftDate(value:String) : void{
			_anti["zhongQiuGiftDate"] = value;
		}
		
		public function get moonCakeGiftDate() : String{
			return _anti["moonCakeGiftDate"];
		}
		public function set moonCakeGiftDate(value:String) : void{
			_anti["moonCakeGiftDate"] = value;
		}
		
		public function get zhongQiuDay() : int{
			return _anti["zhongQiuDay"];
		}
		public function set zhongQiuDay(value:int) : void{
			_anti["zhongQiuDay"] = value;
		}
		
		public function get moonCakeDay() : int{
			return _anti["moonCakeDay"];
		}
		public function set moonCakeDay(value:int) : void{
			_anti["moonCakeDay"] = value;
		}
		
		public function get huiKuiGiftId() : int{
			return 	_anti["huiKuiGiftId"];
		}
		public function set huiKuiGiftId(value:int) : void{
			_anti["huiKuiGiftId"] = value;
		}
		
		
		/**
		* 端午节礼包ID
		*/		
		public function get duanwuGiftId() : int
		{
			return 	_anti["duanwuGiftId"];
		}
		public function set duanwuGiftId(value:int) : void
		{
			_anti["duanwuGiftId"] = value;
		}
			
			
		/**
		 * 端午节礼包截止日期
		 */		
		public function get duanwuGiftDate() : String
		{
			return 	_anti["duanwuGiftDate"];
		}
		public function set duanwuGiftDate(value:String) : void
		{
			_anti["duanwuGiftDate"] = value;
		}
		
		
		/**
		 * 积分江湖礼包ID
		 */		
		public function get jiangHuGiftId() : int
		{
			return 	_anti["jiangHuGiftId"];
		}
		public function set jiangHuGiftId(value:int) : void
		{
			_anti["jiangHuGiftId"] = value;
		}
		
		/**
		 * 积分贵族礼包ID
		 */		
		public function get guiZuGiftId() : int
		{
			return 	_anti["guiZuGiftId"];
		}
		public function set guiZuGiftId(value:int) : void
		{
			_anti["guiZuGiftId"] = value;
		}
		
		
		
		/**
		 * 首充礼包ID
		 */		
		public function get firstChargeGiftId() : int
		{
			return 	_anti["firstChargeGiftId"];
		}
		public function set firstChargeGiftId(value:int) : void
		{
			_anti["firstChargeGiftId"] = value;
		}
		
		
		/**
		 * boss升级提升的售价 
		 */		
		public function get bossUpPrice() : int
		{
			return 	_anti["bossUpPrice"];
		}
		public function set bossUpPrice(value:int) : void
		{
			_anti["bossUpPrice"] = value;
		}
		
		/**
		 * 物品堆叠上限 
		 */		
		public function get itemNumMax() : int
		{
			return 	_anti["itemNumMax"];
		}
		public function set itemNumMax(value:int) : void
		{
			_anti["itemNumMax"] = value;
		}
		
		public function get timeMinute() : int{
			return 	_anti["timeMinute"];
		}
		public function set timeMinute(value:int) : void{
			_anti["timeMinute"] = value;
		}
		
		public function get blackMarketRecommend() : Array{
			return 	_anti["blackMarketRecommend"];
		}
		public function set blackMarketRecommend(value:Array) : void{
			_anti["blackMarketRecommend"] = value;
		}
		
		public function get giftIdArray() : Array{
			return 	_anti["giftIdArray"];
		}
		public function set giftIdArray(value:Array) : void{
			_anti["giftIdArray"] = value;
		}
		
		public function get scoreGiftNetId() : int{
			return 	_anti["scoreGiftNetId"];
		}
		public function set scoreGiftNetId(value:int) : void{
			_anti["scoreGiftNetId"] = value;
		}
		
		public function get duanwuGiftNetId() : int{
			return 	_anti["duanwuGiftNetId"];
		}
		public function set duanwuGiftNetId(value:int) : void{
			_anti["duanwuGiftNetId"] = value;
		}
		
		public function get fiveGiftNetId() : int{
			return 	_anti["fiveGiftNetId"];
		}
		public function set fiveGiftNetId(value:int) : void{
			_anti["fiveGiftNetId"] = value;
		}
		
		public function get qiXiGiftNetId() : int{
			return 	_anti["qiXiGiftNetId"];
		}
		public function set qiXiGiftNetId(value:int) : void{
			_anti["qiXiGiftNetId"] = value;
		}
		
		public function get zhongQiuNetId() : int{
			return _anti["zhongQiuNetId"];
		}
		public function set zhongQiuNetId(value:int) : void{
			_anti["zhongQiuNetId"] = value;
		}
		
		public static function numTranslate(num:int):String{
			var result:String;
			if(num>=10*10000){
				result = int(num/10000).toString() + "万";
			}else{
				result = num.toString() ;
			}
			return result;
		}
		
		public function get purpleBossCount() : int{
			return _anti["purpleBossCount"];
		}
		public function set purpleBossCount(value:int) : void{
			_anti["purpleBossCount"] = value;
		}
		
		public function get fiveBossCount() : int{
			return _anti["fiveBossCount"];
		}
		public function set fiveBossCount(value:int) : void{
			_anti["fiveBossCount"] = value;
		}
		
		public function get normalBossCount() : int{
			return _anti["normalBossCount"];
		}
		public function set normalBossCount(value:int) : void{
			_anti["normalBossCount"] = value;
		}
		
		/**
		 * 
		 * 八卦牌天命上限
		 * 
		 */		
		public function get fortuneMax() : int{
			return _anti["fortuneMax"];
		}
		public function set fortuneMax(value:int) : void{
			_anti["fortuneMax"] = value;
		}
		
		/**
		 * 
		 * 八卦牌卜命价格
		 * 
		 */		
		public function get buMingPrice() : int{
			return _anti["buMingPrice"];
		}
		public function set buMingPrice(value:int) : void{
			_anti["buMingPrice"] = value;
		}
		
		
		/**
		 * 八卦牌显灵价格
		 */		
		public function get xianLingPrice() : int{
			return _anti["xianLingPrice"];
		}
		public function set xianLingPrice(value:int) : void{
			_anti["xianLingPrice"] = value;
		}
		
		/**
		 * 
		 * 50%
		 * 
		 */		
		public function get fiftyPercentage() : int{
			return _anti["fiftyPercentage"];
		}
		public function set fiftyPercentage(value:int) : void{
			_anti["fiftyPercentage"] = value;
		}
		
		/**
		 * 
		 * 5%
		 * 
		 */		
		public function get fivePercentage() : int{
			return _anti["fivePercentage"];
		}
		public function set fivePercentage(value:int) : void{
			_anti["fivePercentage"] = value;
		}
		
		/**
		 * 初始八卦背包
		 */		
		public function get baGuaRoomMax() : int{
			return _anti["baGuaRoomMax"];
		}
		public function set baGuaRoomMax(value:int) : void{
			_anti["baGuaRoomMax"] = value;
		}
		
		
		/**
		 * 算卦价格
		 */		
		public function get suanGuaCost() : int{
			return _anti["suanGuaCost"];
		}
		public function set suanGuaCost(value:int) : void{
			_anti["suanGuaCost"] = value;
		}
		
		/**
		 * 初始算卦得分
		 */		
		public function get suanGuaBaseScore() : int{
			return _anti["suanGuaBaseScore"];
		}
		public function set suanGuaBaseScore(value:int) : void{
			_anti["suanGuaBaseScore"] = value;
		}
		
		
		/**
		 * 蓝色八卦商城Id
		 */		
		public function get blueBaguaPropId() : int{
			return _anti["blueBaguaPropId"];
		}
		public function set blueBaguaPropId(value:int) : void{
			_anti["blueBaguaPropId"] = value;
		}
		
		/**
		 * 蓝色八卦商城价格
		 */		
		public function get blueBaguaPrice() : int{
			return _anti["blueBaguaPrice"];
		}
		public function set blueBaguaPrice(value:int) : void{
			_anti["blueBaguaPrice"] = value;
		}
		
		/**
		 * 紫色八卦商城Id
		 */		
		public function get purpleBaguaPropId() : int{
			return _anti["purpleBaguaPropId"];
		}
		public function set purpleBaguaPropId(value:int) : void{
			_anti["purpleBaguaPropId"] = value;
		}
		
		/**
		 * 紫色八卦商城价格
		 */		
		public function get purpleBaguaPrice() : int{
			return _anti["purpleBaguaPrice"];
		}
		public function set purpleBaguaPrice(value:int) : void{
			_anti["purpleBaguaPrice"] = value;
		}
		
		/**
		 * 八卦最高等级
		 */		
		public function get baguaMaxLv() : int{
			return _anti["baguaMaxLv"];
		}
		public function set baguaMaxLv(value:int) : void{
			_anti["baguaMaxLv"] = value;
		}
		
	
		
		
		
		/*       采集道具            */
		/**
		 * 镰刀 墨竹林采集道具
		 */		
		public function get materialTool_1() : int{
			return _anti["materialTool_1"];
		}
		public function set materialTool_1(value:int) : void{
			_anti["materialTool_1"] = value;
		}
		
		/**
		 * 矿镐 太虚观采集道具
		 */		
		public function get materialTool_2() : int{
			return _anti["materialTool_2"];
		}
		public function set materialTool_2(value:int) : void{
			_anti["materialTool_2"] = value;
		}
		
		/**
		 * 铁锹  万恶谷采集道具
		 */		
		public function get materialTool_3() : int{
			return _anti["materialTool_3"];
		}
		public function set materialTool_3(value:int) : void{
			_anti["materialTool_3"] = value;
		}
		
		
		/*       称号            */
		/**
		 * 初出江湖
		 */		
		public function get title_1() : int{
			return _anti["title_1"];
		}
		public function set title_1(value:int) : void{
			_anti["title_1"] = value;
		}
		
		/**
		 * 初显锋芒
		 */		
		public function get title_2() : int{
			return _anti["title_2"];
		}
		public function set title_2(value:int) : void{
			_anti["title_2"] = value;
		}
		
		/**
		 * 锋芒毕露
		 */		
		public function get title_3() : int{
			return _anti["title_3"];
		}
		public function set title_3(value:int) : void{
			_anti["title_3"] = value;
		}
		
		/**
		 * 行侠仗义
		 */		
		public function get title_4() : int{
			return _anti["title_4"];
		}
		public function set title_4(value:int) : void{
			_anti["title_4"] = value;
		}
		
		/**
		 * 德高望重
		 */		
		public function get title_5() : int{
			return _anti["title_5"];
		}
		public function set title_5(value:int) : void{
			_anti["title_5"] = value;
		}
		
		/**
		 * 绝世高手
		 */		
		public function get title_6() : int{
			return _anti["title_6"];
		}
		public function set title_6(value:int) : void{
			_anti["title_6"] = value;
		}
		
		/**
		 * 腰缠万贯
		 */		
		public function get title_7() : int{
			return _anti["title_7"];
		}
		public function set title_7(value:int) : void{
			_anti["title_7"] = value;
		}
		
		/**
		 * 花好月圆
		 */		
		public function get title_8() : int{
			return _anti["title_8"];
		}
		public function set title_8(value:int) : void{
			_anti["title_8"] = value;
		}
		
		/**
		 * 傲视天下
		 */		
		public function get title_9() : int{
			return _anti["title_9"];
		}
		public function set title_9(value:int) : void{
			_anti["title_9"] = value;
		}
		
		/**
		 * 神
		 */		
		public function get title_10() : int{
			return _anti["title_10"];
		}
		public function set title_10(value:int) : void{
			_anti["title_10"] = value;
		}
		
		/*       经脉参数              */
		/**
		 * 经脉总数
		 */		
		public function get jingMaiMax() : int{
			return _anti["jingMaiMax"];
		}
		public function set jingMaiMax(value:int) : void{
			_anti["jingMaiMax"] = value;
		}
		
		
		/*       天气充能              */
		/**
		 * 天气碎片合成价格
		 */		
		public function get weatherCombinePrice() : int{
			return _anti["weatherCombinePrice"];
		}
		public function set weatherCombinePrice(value:int) : void{
			_anti["weatherCombinePrice"] = value;
		}
		
		
		/**
		 * 最大VIP等级
		 */		
		public function get vipMaxLv() : int
		{
			return 	_anti["vipMaxLv"];
		}
		public function set vipMaxLv(value:int) : void
		{
			_anti["vipMaxLv"] = value;
		}
		
		/**
		 * vip1级礼包
		 */		
		public function get vipGift1() : int
		{
			return 	_anti["vipGift1"];
		}
		public function set vipGift1(value:int) : void
		{
			_anti["vipGift1"] = value;
		}
		
		/**
		 * vip2级礼包
		 */		
		public function get vipGift2() : int
		{
			return 	_anti["vipGift2"];
		}
		public function set vipGift2(value:int) : void
		{
			_anti["vipGift2"] = value;
		}
		
		/**
		 * vip3级礼包
		 */		
		public function get vipGift3() : int
		{
			return 	_anti["vipGift3"];
		}
		public function set vipGift3(value:int) : void
		{
			_anti["vipGift3"] = value;
		}
		
		/**
		 * vip4级礼包
		 */		
		public function get vipGift4() : int
		{
			return 	_anti["vipGift4"];
		}
		public function set vipGift4(value:int) : void
		{
			_anti["vipGift4"] = value;
		}
		
		/**
		 * vip5级礼包
		 */		
		public function get vipGift5() : int
		{
			return 	_anti["vipGift5"];
		}
		public function set vipGift5(value:int) : void
		{
			_anti["vipGift5"] = value;
		}
		
		
		/**
		 * vip1级获得
		 */		
		public function get vipGet1() : int
		{
			return 	_anti["vipGet1"];
		}
		public function set vipGet1(value:int) : void
		{
			_anti["vipGet1"] = value;
		}
		
		/**
		 *  vip2级获得
		 */		
		public function get vipGet2() : int
		{
			return 	_anti["vipGet2"];
		}
		public function set vipGet2(value:int) : void
		{
			_anti["vipGet2"] = value;
		}
		
		/**
		 *  vip3级获得
		 */		
		public function get vipGet3() : int
		{
			return 	_anti["vipGet3"];
		}
		public function set vipGet3(value:int) : void
		{
			_anti["vipGet3"] = value;
		}
		
		/**
		 *  vip4级获得
		 */		
		public function get vipGet4() : int
		{
			return 	_anti["vipGet4"];
		}
		public function set vipGet4(value:int) : void
		{
			_anti["vipGet4"] = value;
		}
		
		
		/**
		 *  vip5级获得
		 */		
		public function get vipGet5() : int
		{
			return 	_anti["vipGet5"];
		}
		public function set vipGet5(value:int) : void
		{
			_anti["vipGet5"] = value;
		}
		
		public function get weatherSelectID() : int{
			return _anti["weatherSelectID"];
		}
		
	}
}