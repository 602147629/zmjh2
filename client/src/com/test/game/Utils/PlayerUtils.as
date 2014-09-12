package com.test.game.Utils
{
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.CharacterType;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Mvc.Configuration.Book;
	import com.test.game.Mvc.Configuration.BossCard;
	import com.test.game.Mvc.Configuration.BossCardUp;
	import com.test.game.Mvc.Configuration.EightDiagrams;
	import com.test.game.Mvc.Configuration.Equipment;
	import com.test.game.Mvc.Configuration.Fashion;
	import com.test.game.Mvc.Configuration.Material;
	import com.test.game.Mvc.Configuration.Prop;
	import com.test.game.Mvc.Configuration.Special;
	import com.test.game.Mvc.Configuration.Strengthen;
	import com.test.game.Mvc.Vo.AttachInfo;
	import com.test.game.Mvc.Vo.AutoFightVo;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.Mvc.Vo.BlackMarketVo;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.DailyMissionVo;
	import com.test.game.Mvc.Vo.DoubleDungeonVo;
	import com.test.game.Mvc.Vo.DungeonPassVo;
	import com.test.game.Mvc.Vo.EliteDungeonPassVo;
	import com.test.game.Mvc.Vo.EliteDungeonVo;
	import com.test.game.Mvc.Vo.EquipInfo;
	import com.test.game.Mvc.Vo.EscortVo;
	import com.test.game.Mvc.Vo.FashionVo;
	import com.test.game.Mvc.Vo.GiftVo;
	import com.test.game.Mvc.Vo.HeroScriptVo;
	import com.test.game.Mvc.Vo.HideMissionVo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.JingMaiVo;
	import com.test.game.Mvc.Vo.LogGiftVo;
	import com.test.game.Mvc.Vo.LogMissionVo;
	import com.test.game.Mvc.Vo.LogVo;
	import com.test.game.Mvc.Vo.MidAutumnVo;
	import com.test.game.Mvc.Vo.MissionVo;
	import com.test.game.Mvc.Vo.OnlineBonusVo;
	import com.test.game.Mvc.Vo.PackVo;
	import com.test.game.Mvc.Vo.PlayerKillingVo;
	import com.test.game.Mvc.Vo.SignInVo;
	import com.test.game.Mvc.Vo.SkillInfo;
	import com.test.game.Mvc.Vo.SkillUpVo;
	import com.test.game.Mvc.Vo.StatisticsVo;
	import com.test.game.Mvc.Vo.SummerCarnivalVo;
	import com.test.game.Mvc.Vo.TitleVo;
	import com.test.game.Mvc.Vo.VipVo;
	import com.test.game.Mvc.Vo.WuYiVo;
	import com.test.game.Mvc.Vo.partnerSkillInfo;
	

	public class PlayerUtils
	{
		public function PlayerUtils()
		{
		}
			
		public static function assignCharacter(data:int, exp:int) : CharacterVo
		{
			var characterVo:CharacterVo = new CharacterVo();
			characterVo.id = data;
			characterVo.characterType = CharacterType.PLAYER;
			characterVo.lv = PlayerManager.getIns().getLevelInfo(exp)[2];
			characterVo.characterConfig.assign(ConfigurationManager.getIns().getObjectByID(AssetsConst.CHARACTERS, data));
			characterVo.assignConfigProperty();
			characterVo.assignLevelUpProperty(ConfigurationManager.getIns().getObjectByID(AssetsConst.CHARACTERS_UP, data));
			return characterVo;
		}
		
		
		/**
		 生成礼包数据
		 */		
		public static function assignGift(data:Object) : Array
		{
			var giftArr:Array = new Array;
			if(data != null){
				for each(var gift:Object in data)
				{
					var giftVo:GiftVo = new GiftVo();
					giftVo.id =  gift["id"];
					giftVo.isGet = gift["isGet"]==1?true:false;
					giftVo.getTime = gift["getTime"]==null?"":gift["getTime"];
					giftArr.push(giftVo);
				}
			}
			return giftArr;
		}
		
		/**
		 生成记录数据
		 */		
		public static function assignLog(data:Object) : LogVo
		{
			var vo:LogVo = new LogVo();
			if(data != null){
				if(data.gift){
					for each(var gift:Object in data.gift)
					{
						var giftLog:LogGiftVo = new LogGiftVo();
						giftLog.id =  gift["id"];
						if(gift["type"]){
							giftLog.type =  gift["type"];
						}else{
							giftLog.type =  "";
						}
						
						giftLog.time = gift["time"];
						vo.giftLogs.push(giftLog);
					}
				}
	
				if(data.mission){
					for each(var mission:Object in data.mission)
					{
						var missionLog:LogMissionVo = new LogMissionVo();
						missionLog.type =  mission["type"];
						missionLog.num =  mission["num"];
						missionLog.time = mission["time"];
						vo.missionLogs.push(missionLog);
					}
				}
				if(data.nameChange){
					vo.nameChange = data.nameChange;
				}
			}
			return vo;
		}
		
		
		/**
		 生成任务数据
		 */		
		public static function assignMissionVo(data:Object) : MissionVo
		{
			var missionVo:MissionVo = new MissionVo;
			missionVo.id = data.id;
			missionVo.isComplete = data.isComplete==1? true:false;
			
			return missionVo;
		}
		
		/**
		 生成每日任务数据
		 */		
		public static function assignDailyMissionVo(data:Object) : DailyMissionVo{
			var dailyMissionVo:DailyMissionVo = new DailyMissionVo();
			if(data != null){
				dailyMissionVo.missionTime = data.missionTime;
				dailyMissionVo.missionCount = data.missionCount;
				dailyMissionVo.missionType = data.missionType;
				dailyMissionVo.missionDungeon = data.missionDungeon;
				dailyMissionVo.materialType = data.materialType;
				dailyMissionVo.isComplete = (data.isComplete==1?true:false);
			}
			
			return dailyMissionVo;
		}
		
		public static function assignHideMissionVo(data:Object) : Vector.<HideMissionVo>{
			var result:Vector.<HideMissionVo> = new Vector.<HideMissionVo>();
			if(data != null){
				for each(var item:Object in data){
					var hideMission:HideMissionVo = new HideMissionVo();
					hideMission.id = item.id;
					hideMission.missionConfig = item.missionConfig.split("|");
					hideMission.isComplete = (item.isComplete==1?true:false);
					hideMission.isShow = (item.isShow==1?true:false);
					result.push(hideMission);
				}
			}
			return result;
		}
		
		/**
			生成通关数据
		 */		
		public static function assignDungeonPass(data:Object) : Vector.<DungeonPassVo>
		{
			var dungeonPassArr:Vector.<DungeonPassVo> = new Vector.<DungeonPassVo>();
			
			for each(var item:Object in data)
			{
				var dungeonPass:DungeonPassVo = new DungeonPassVo();
				dungeonPass.name =  item["name"];
				dungeonPass.lv = item["lv"];
				dungeonPass.hit = item["hit"];
				dungeonPass.time = item["time"];
				dungeonPass.hurt = item["hurt"];
				dungeonPass.add = item["add"];
				
				dungeonPassArr.push(dungeonPass);
			}
			
			return dungeonPassArr;
		}
		
		
		/**
		 生成精英副本通关数据
		 */		
		public static function assignEliteDungeonPass(data:Object) : EliteDungeonVo
		{
			var elitedungeon:EliteDungeonVo = new EliteDungeonVo();
			
			for each(var item:Object in data)
			{
				if(item.name == "time"){
					elitedungeon.eliteTime = item["time"];
				}else{
					var eliteDungeonPass:EliteDungeonPassVo = new EliteDungeonPassVo();
					eliteDungeonPass.name =  item["name"];
					eliteDungeonPass.lv = item["lv"];
					eliteDungeonPass.hit = item["hit"];
					eliteDungeonPass.time = item["time"];
					eliteDungeonPass.hurt = item["hurt"];
					eliteDungeonPass.num = item["num"];
					eliteDungeonPass.add = item["add"];
					elitedungeon.eliteDungeonPass.push(eliteDungeonPass);
				}
			}
			
			return elitedungeon;
		}
		
		/**
		 * 双倍副本
		 * @param data
		 * @return 
		 * 
		 */		
		public static function assignDoubleDungeon(data:Object) : DoubleDungeonVo{
			var result:DoubleDungeonVo = new DoubleDungeonVo();
			if(data != null){
				result.doubleTime = data.doubleTime;
				result.dungeonName = data.dungeonName;
			}
			return result;
		}

		/**
		 * 在线奖励
		 * @param data
		 * @return 
		 * 
		 */		
		public static function assignOnlineBonus(data:Object) : OnlineBonusVo{
			var result:OnlineBonusVo = new OnlineBonusVo();
			if(data != null){
				result.onlineTime = data.onlineTime;
				result.lv = data.lv;
			}
			return result;
		}
		
		
		/**
		 * 黑市
		 * @param data
		 * @return 
		 * 
		 */		
		public static function assignBlackMarket(data:Object) : BlackMarketVo{
			var result:BlackMarketVo = new BlackMarketVo();
			if(data != null){
				var itemArr:Array = new Array();
				var arr:Array = data.items.split("|");
				for(var i:int =0;i<arr.length;i++){
					var items:Array = arr[i].split(":");
					var obj:Object = new Object();
					obj.id = items[0];
					if(items.length!=2){
						obj.coupon = "0";
					}else{
						obj.coupon = items[1];
					}
					
					itemArr.push(obj);
				}
				
				result.items = itemArr;
				
				result.itemsEnable = data.itemsEnable.split("|");

				if(data.blackMarketTime != null){
					result.blackMarketTime = data.blackMarketTime;
				}
				result.freeRefresh = data.freeRefresh;
			}
			return result;
		}
		
		
		/**
		 生成伙伴技能数据
		 */	
		public static function assignPartnerSkill(data:Object) : partnerSkillInfo
		{
			var partnerSkillVo:partnerSkillInfo = new partnerSkillInfo();
			if(data != null){
				partnerSkillVo.skill_4 = data["key4"];
				partnerSkillVo.skill_5 = data["key5"];
				partnerSkillVo.skill_6 = data["key6"];
				partnerSkillVo.skill_7 = data["key7"];
				partnerSkillVo.skill_8 = data["key8"];
			}
			return partnerSkillVo;
		}
		
		
		/**
		 生成技能数据
		 */	
		public static function assignSkill(data:Object) : SkillInfo
		{
			var skillVo:SkillInfo = new SkillInfo();
			
			skillVo.kungfu1 = data["kungfu1"];
			skillVo.kungfu2 = data["kungfu2"];
			
			for(var i:int=1;i<11;i++){
				var str:String = "skill"+i;
				skillVo.skillArr.push(data[str]);
			}
	
			skillVo.skill_U = data["U"];
			skillVo.skill_I = data["I"];
			skillVo.skill_O = data["O"];
			skillVo.skill_L = data["L"];
			skillVo.skill_H = data["H"];
			return skillVo;
		}
		
		
		/**
		 * 技能升级
		 * @param data
		 * @return 
		 * 
		 */		
		public static function assignSkillUp(data:Object) : SkillUpVo{
			var result:SkillUpVo = new SkillUpVo();
			if(data != null){
				if(data["skillLevels"] != null){
					result.skillLevels = data["skillLevels"].split("|");
				}else{
					result.skillLevels = [0,0,0,0,0,0,0,0,0,0];
				}
				for(var i:int=1;i<=10;i++){
					result["skillBooks"+i] = data["skillBooks"+i].split("|");
				}
			}else{
				result.skillLevels = [0,0,0,0,0,0,0,0,0,0];
				for(var j:int=1;j<=10;j++){
					result["skillBooks"+j] = [NumberConst.getIns().zero,
												NumberConst.getIns().zero,
												NumberConst.getIns().zero,
												NumberConst.getIns().zero,
												NumberConst.getIns().zero,];
				}
			}
			return result;
		}
		
		/**
		 生成装备数据
		 */	
		public static function assignEquip(data:Object) : EquipInfo
		{
			var equip:EquipInfo = new EquipInfo();
			equip.weapon = data["weapon"] || -1;
			equip.head = data["head"] || -1;
			equip.neck = data["neck"] || -1;
			equip.clothes = data["clothes"] || -1;
			if(data["shoulder"]){
				equip.shoulder = data["shoulder"] || -1;
			}else{
				equip.shoulder = data["trousers"] || -1;
			}
			equip.shoes = data["shoes"] || -1;
			return equip;
		}
		
		/**
		 生成附体数据
		 */	
		public static function assignAttach(data:Object) : AttachInfo
		{
			var attach:AttachInfo = new AttachInfo();
			var arr:Array = [-1,-1,-1];
			if(data["front"]){
				
				arr[0] = (data["front"] || -1);
				arr[1] = (data["middle"] || -1);
				arr[2] = (data["back"] || -1);
			}else{
				arr[0] = (data["frontAttach"] || -1);
				arr[1] = ( data["middleAttach"] || -1);
				arr[2] = (data["backAttach"] || -1);
			}
			attach.attachArr = arr;


			return attach;
		}
		
		/**
		 生成背包数据
		 */	
		public static function assignPack(data:Object) : PackVo
		{
			var packVo:PackVo = new PackVo();
			// 装备
			packVo.equip = assignPackEquip(data["equipment"]);
			packVo.material = assignPackMaterial(data["material"]);
			packVo.special = assignPackSpecial(data["special"]);
			packVo.book = assignPackBook(data["book"]);
			packVo.prop = assignPackProp(data["prop"]);
			packVo.boss = assignPackBoss(data["bossCard"]);
			packVo.fashion = assignPackFashion(data["fashion"]);
			packVo.packMaxRoom = data["sum"];
			
			return packVo;
		}
		

		public static function assignWuyi(data:Object) : WuYiVo{
			var result:WuYiVo = new WuYiVo();
			if(data != null){
				result.isGet = data.isGet;
				result.time = data.time;
			}
			
			return result;
		}
	


		
		private static function assignPackEquip(equipData:Object):Vector.<ItemVo>{
			
			var equips:Vector.<ItemVo> = new Vector.<ItemVo>();
			var equip:ItemVo;
			for each(var equipJson:Object in equipData)
			{
				equip = new ItemVo();
				equip.equipConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.EQUIPMENT,equipJson["id"]) as Equipment;
				equip.strengthen= ConfigurationManager.getIns().getObjectByID(AssetsConst.STRENGTHEN,equipJson["lv"]) as Strengthen;
				
				if(equipJson["chargeLv"]){
					equip.equipConfig.chargeLvArr = equipJson["chargeLv"].split("|");	
				}else{
					equip.equipConfig.chargeLvArr = [0,0,0,0];
				}
				
				for(var i:int=0;i<equip.equipConfig.chargeLvArr.length;i++){
					equip.equipConfig.chargeLvArr[i]= int(equip.equipConfig.chargeLvArr[i])
				}
				equip.id = equipJson["id"];
				equip.lv = equipJson["lv"];
				equip.isEquiped = equipJson["isEquiped"]==1?true:false;
				equip.mid = equipJson["isEquiped"]==1? -1:equipJson["mid"];
				equip.name = equip.equipConfig.name;
				equip.sale_money = equip.equipConfig.sale_money;
				equip.type = ItemTypeConst.EQUIP;
				
				equips.push(equip);
			}
			
			return equips;
			
		}
		
	
	
	private static function assignPackMaterial(materialData:Object):Vector.<ItemVo>{
			var materials:Vector.<ItemVo> = new Vector.<ItemVo>();
			var material:ItemVo;
			for each(var materialJson:Object in materialData)
			{
				material = new ItemVo();
				material.materialConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.MATERIAL,materialJson["id"]) as Material;
				
				material.id = materialJson["id"];
				material.mid = materialJson["mid"];
				material.type = ItemTypeConst.MATERIAL;
				material.name = material.materialConfig.name;
				material.num = materialJson["num"];
				material.sale_money = material.materialConfig.sale_money;
				
				materials.push(material);
			}
			return materials;
		}
	
	
		private static function assignPackSpecial(specialData:Object):Vector.<ItemVo>{
			var specials:Vector.<ItemVo> = new Vector.<ItemVo>();
			var special:ItemVo;
			for each(var specialJson:Object in specialData)
			{
				special = new ItemVo();
				special.specialConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.SPECIAL,specialJson["id"]) as Special;
				
				special.id = specialJson["id"];
				special.mid = specialJson["mid"];
				special.name = special.specialConfig.name;
				special.type = ItemTypeConst.SPECIAL;
				special.num = specialJson["num"];
				special.sale_money = special.specialConfig.sale_money;
				
				specials.push(special);
			}
			return specials;
		}
		
		private static function assignPackBook(bookData:Object):Vector.<ItemVo>{
			var books:Vector.<ItemVo> = new Vector.<ItemVo>();
			var book:ItemVo;
			for each(var bookJson:Object in bookData)
			{
				book = new ItemVo();
				book.bookConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.BOOK,bookJson["id"]) as Book;
				
				book.id = bookJson["id"];
				book.mid = bookJson["mid"];
				book.name = book.bookConfig.name;
				book.sale_money = book.bookConfig.sale_money;
				book.type = ItemTypeConst.BOOK;
				
				books.push(book);
			}
			return books;
		}
		
		private static function assignPackProp(propData:Object):Vector.<ItemVo>
		{
			var props:Vector.<ItemVo> = new Vector.<ItemVo>();
			var prop:ItemVo;
			for each(var propJson:Object in propData)
			{
				prop = new ItemVo();
				prop.propConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.PROP,propJson["id"]) as Prop;
				
				prop.id = propJson["id"];
				prop.mid = propJson["mid"];
				prop.name = prop.propConfig.name;
				
				prop.num = propJson["num"];
				if(prop.id>=6001 && prop.id<=6099 && prop.num>NumberConst.getIns().one){
					prop.num = NumberConst.getIns().one;	
				}
				
				prop.type = ItemTypeConst.PROP;
				
				props.push(prop);
			}
			return props;
		}
		

		private static function assignPackBoss(bossData:Object):Vector.<ItemVo>
		{
			var bosses:Vector.<ItemVo> = new Vector.<ItemVo>();
			var boss:ItemVo;
			for each(var bossCardJson:Object in bossData)
			{
				boss = new ItemVo();
				boss.specialConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.SPECIAL,bossCardJson["id"]) as Special;
				boss.bossConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.BOSS,boss.specialConfig.bid) as BossCard;
				boss.bossUp = ConfigurationManager.getIns().getObjectByID(AssetsConst.BOSS_UP,bossCardJson["lv"]) as BossCardUp;
				
				boss.id = bossCardJson["id"];
				boss.mid = bossCardJson["mid"];
				boss.cid = bossCardJson["cid"];
				boss.name = boss.bossConfig.name;
				boss.type = ItemTypeConst.BOSS;
				boss.lv = bossCardJson["lv"];
				boss.sale_money = boss.specialConfig.sale_money;
				boss.isEquiped = bossCardJson["isEquiped"]==1?true:false;
				boss.isAttached = bossCardJson["isAttached"]==1?true:false;
				boss.isAssisted = bossCardJson["isAssisted"]==1?true:false;
				bosses.push(boss);
			}
			return bosses;
		}	
		
		private static function assignPackFashion(fashionData:Object):Vector.<ItemVo>
		{
			var fashions:Vector.<ItemVo> = new Vector.<ItemVo>();
			var fashion:ItemVo;
			for each(var fashionJson:Object in fashionData)
			{
				fashion = new ItemVo();
				fashion.fashionConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.FASHION,fashionJson["id"]) as Fashion;
				
				fashion.id = fashionJson["id"];
				fashion.mid = fashionJson["mid"];
				fashion.name = fashion.fashionConfig.name;
				fashion.type = ItemTypeConst.FASHION;
				fashion.time = (fashionJson["time"]==null?TimeManager.getIns().curTimeStr:fashionJson["time"]);
				fashions.push(fashion);
			}
			return fashions;
		}	
		
		
		
		public static function assignSignIn(data:Object) : SignInVo{
			var result:SignInVo = new SignInVo();
			if(data != null){
				result.signInCount = data.signInCount;
				result.signInTime = data.signInTime;
				result.achievements = data.achievements;
			}
			return result;
		}
		
		public static function assignAchieve(data:String) : Array{
			var result:Array = new Array();
			if(data != null){
				result = data.split("|");
				for(var i:int=0;i<result.length;i++){
					result[i]= int(result[i])
				}
			}else{
				result = [-1,-1,-1,-1,-1,-1];
			}
			return result;
		}
		
		public static function assignJingMai(data:Object) : JingMaiVo{
			var result:JingMaiVo = new JingMaiVo();
			if(data != null){
				var arr:Array = data["jingMaiArr"].split("|");
				for(var i:int=0;i<arr.length;i++){
					arr[i]= int(arr[i]);
				}
				result.jingMaiArr = arr;
				result.bookPoint = data["bookPoint"];
			}
			return result;
		}
		
		public static function assignTitle(data:Object) : TitleVo{
			var result:TitleVo = new TitleVo();
			if(data != null){
				var arr:Array = data["titleOwned"].split("|");
				for(var i:int=0;i<arr.length;i++){
					arr[i]= int(arr[i]);
				}
				result.titleOwned = arr;
				result.titleNow = data["titleNow"];
				result.titleShow = data["titleShow"];

			}
			return result;
		}
		
		public static function assignHeroScript(data:Object) : HeroScriptVo{
			var result:HeroScriptVo = new HeroScriptVo();
			if(data != null){
				var arr:Array = data["addValueArr"].split("|");
				for(var i:int=0;i<arr.length;i++){
					arr[i]= int(arr[i]);
				}
				result.addValueArr = arr;
				result.heroFightNum = data["heroFightNum"];
				result.heroSpecialFightNum = data["heroSpecialFightNum"];
				result.heroSpecialFightCount = data["heroSpecialFightCount"];
				result.heroTime = data["heroTime"];
			}
			return result;
		}
		
		public static function assignPkInfo(data:Object) : PlayerKillingVo{
			var result:PlayerKillingVo = new PlayerKillingVo();
			if(data != null){
				result.pkExp = data.pkExp;
				result.pkWin = data.pkWin;
				result.pkLose = data.pkLose;
				result.pkTime = data.pkTime;
				result.pkCanStart = data.pkCanStart;
				result.pkCount = data.pkCount;
				result.preResult = data.preResult;
				result.pkStatus = (data.pkStatus==null?1:data.pkStatus);
			}
			
			return result;
		}
		
		public static function assignVipVo(data:Object) : VipVo{
			var result:VipVo = new VipVo();
			if(data != null){
				result.vipGiftGetTime = data.vipGiftGetTime;
				result.isVipGiftGet = data.isVipGiftGet==1?true:false;
				result.curCoupon = data.curCoupon;
				result.totalRecharge = data.totalRecharge;
				if(data.firstCharge){
					result.firstCharge = data.firstCharge;
				}else{
					result.firstCharge = NumberConst.getIns().negativeOne;
				}
			}
			return result;
		}
		
		public static function assignAutoFightInfo(data:Object) : AutoFightVo{
			var result:AutoFightVo = new AutoFightVo();
			if(data != null){
				result.autoFightCount = data.autoFightCount;
				result.doubleCardCount = data.doubleCardCount;
				result.rpCardCount = data.rpCardCount;
			}
			
			return result;
		}
		
		public static function assignFasionId(data:int) : FashionVo{
			var result:FashionVo = new FashionVo();
			result.fashionId = data;
			result.showFashion = 2;
		
			return result;
		}
		
		
		public static function assignFasionInfo(data:Object) : FashionVo{
			var result:FashionVo = new FashionVo();
			if(data != null){
				result.fashionId = data.fashionId;
				result.showFashion = data.showFashion;
			}else{
				result.fashionId = -1;
				result.showFashion = 1;
			}
			return result;
		}
		
		
		public static function assignAttachBaGuaPieces(data:String) : Array{
			var result:Array = new Array();
			if(data != null){
				result = data.split("|");
			}else{
				result = [-1,-1,-1,-1,-1,-1,-1,-1];
			}
			return result;
		}
		
		
		public static function assignBaGuaPieces(data:Object) : Vector.<BaGuaPieceVo>{
			var baGuaPieces:Vector.<BaGuaPieceVo> = new Vector.<BaGuaPieceVo>();
			var baGuaPiece:BaGuaPieceVo;
			if(data!= null){
				for each(var baGuaJson:Object in data)
				{
					baGuaPiece = new BaGuaPieceVo();
					baGuaPiece.eightDiagram = ConfigurationManager.getIns().getObjectByID(AssetsConst.EIGHT_DIAGRAMS,baGuaJson["id"]) as EightDiagrams;
					
					baGuaPiece.id = baGuaJson["id"];
					baGuaPiece.cid = baGuaJson["cid"];
					if(baGuaJson["lv"]>=10){
						baGuaPiece.lv = NumberConst.getIns().baguaMaxLv;
						baGuaPiece.exp = baGuaPiece.maxExp;
					}else{
						baGuaPiece.lv = baGuaJson["lv"];
						baGuaPiece.exp = baGuaJson["exp"];
					}
					
					
					
					if(baGuaJson["protect"]){
						baGuaPiece.protect = baGuaJson["protect"];
					}else{
						baGuaPiece.protect = 0;
					}
					
					baGuaPiece.name = baGuaPiece.eightDiagram.name;
					
					baGuaPieces.push(baGuaPiece);
				}
			}

			return baGuaPieces;
		}
		
		public static function assignEscort(data:Object) : EscortVo{
			var result:EscortVo = new EscortVo();
			if(data != null){
				result.time = data.time;
				result.escortCount = data.escortCount;
				result.lootCount = data.lootCount;
				result.escortTime = data.escortTime;
				result.lootTime = data.lootTime;
			}else{
				result.initEscort();
			}
			
			return result
		}
		
		public static function assignStatistics(data:Object) : StatisticsVo{
			var result:StatisticsVo = new StatisticsVo();
			if(data != null){
				result.statisticsTime = data.statisticsTime;
				result.publicNoticeCount = (data.publicNoticeCount==null?NumberConst.getIns().zero:data.publicNoticeCount);
				result.weatherPropCount = (data.weatherPropCount==null?NumberConst.getIns().zero:data.weatherPropCount);
				result.funnyBossCount = (data.funnyBossCount==null?NumberConst.getIns().zero:data.funnyBossCount);
				result.midAutumnCount = (data.midAutumnCount==null?NumberConst.getIns().zero:data.midAutumnCount);
			}else{
				result.statisticsTime = "";
				result.publicNoticeCount = NumberConst.getIns().zero;
				result.weatherPropCount = NumberConst.getIns().zero;
				result.funnyBossCount = NumberConst.getIns().zero;
				result.midAutumnCount = NumberConst.getIns().zero;
			}
			
			return result;
		}
		
		public static function assignSummerCarnival(data:Object) : SummerCarnivalVo{
			var result:SummerCarnivalVo = new SummerCarnivalVo();
			if(data != null){
				result.summerRecharge = data.summerRecharge.split("|");
				result.summerConsume = data.summerConsume.split("|");
				result.summerTime = data.summerTime;
			}else{
				var arr:Array = new Array();
				for(var i:int = 0; i < 7; i++){
					arr.push(NumberConst.getIns().zero);
				}
				result.summerRecharge = arr;
				result.summerConsume = arr;
				result.summerTime = "";
			}
			
			return result;
		}

		public static function assignMidAutumm(data:Object) : MidAutumnVo{
			var result:MidAutumnVo = new MidAutumnVo();
			if(data != null){
				result.moonCakeCount = data.moonCakeCount;
				result.alreadyGet = data.alreadyGet.split("|");
			}else{
				result.moonCakeCount = NumberConst.getIns().zero;
				result.alreadyGet = new Array(6);
			}
			return result;
		}
		
	}
}