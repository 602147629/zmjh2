package com.test.game.Manager
{
	import com.adobe.serialization.json.JSON;
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.OccupationConst;
	import com.test.game.Const.StringConst;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Configuration.CharactersUp;
	import com.test.game.Mvc.Configuration.Charge;
	import com.test.game.Mvc.Configuration.EightDiagramSuits;
	import com.test.game.Mvc.Configuration.Equipment;
	import com.test.game.Mvc.Configuration.FashionConfiguration;
	import com.test.game.Mvc.Configuration.JingMai;
	import com.test.game.Mvc.Configuration.Title;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.Mvc.Vo.BasePropertyVo;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.DungeonPassVo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.View.PlayerUIControl;
	import com.test.game.Mvc.control.data.DataControl;
	import com.test.game.Utils.AllUtils;
	
	public class PlayerManager extends Singleton
	{
		public var saveIndex:int;
		
		private var _anti:Antiwear;	
		
		private var _player:PlayerVo;
		
		private var _character:CharacterVo;
		
		public var playerData:String;
		
		public function PlayerManager()
		{
			_anti = new Antiwear(new binaryEncrypt());
			super();
		}
		
		public static function getIns():PlayerManager{
			return Singleton.getIns(PlayerManager);
		}
		
		
		public function get player() : PlayerVo
		{
			return _player;
		}

		public function reqPlayerData(callback:Function) : void
		{
			_player = new PlayerVo();
			if(GameConst.localLogin){
				if(GameConst.localData){
					onLocalData();
				}else{
					parseData(com.adobe.serialization.json.JSON.decode(playerData));
				}
			}else{
				parseData(com.adobe.serialization.json.JSON.decode(playerData));
			}
			//trace(playerData);
			
			if(callback){
				callback();
			}
		}
		
		/**
		 * 本地加载配置文件初始化玩家数据 
		 * 
		 */
		private var _playerConfigJson:Object;
		private function onLocalData() : void
		{
			_playerConfigJson = (ControlFactory.getIns().getControl(DataControl) as DataControl).getPlayerDataJson();
			
			parseData(_playerConfigJson);

		}
		
		/**
		 * 解析玩家数据Json
		 * @param configJson
		 * 
		 */		
		private function parseData(configJson:Object) : void
		{
			_player.init(configJson);
		}	
		
		
		
		/**
		 * 生成当前玩家数据Json
		 * 
		 */		
		public function getPlayerDataJson() : String
		{
			return _player.getPlayerDataJson();
		}	


		
		/**
		 * 生成初始玩家数据Json
		 * 
		 */		
		public function initPlayerDataJson(name:String, occ:int, totalRecharged:int) : String
		{
			var data:String;
			var player:Object = new Object(); 
			
			player.name = name;
			player.exp = NumberConst.getIns().zero;
			player.money = NumberConst.getIns().oneThousand;
			player.soul = NumberConst.getIns().oneThousand;
			player.occupation = occ;
			player.main_mission = initMission();
			player.gift = initGift();
			player.dungeon_pass = initDungeonPass();
			player.elite_dungeon_pass = new Object();
			player.now_equipment = initEquip();
			player.now_attach = initAttach();
			player.now_assist = NumberConst.getIns().negativeOne;;
			player.skill = initSkill();
			player.pack = initPack(occ);
			player.vip = initVip(totalRecharged);
			
			data = com.adobe.serialization.json.JSON.encode(player);
			
			return data;
		}
		
		private function initGift():Object
		{
			var gifts:Object = new Object();
			var gift:Object = new Object();
			gift.id = NumberConst.getIns().huiKuiGiftId;
			gift.isGet = true;
			gift.getTime = TimeManager.getIns().curTimeStr;
			gifts[0] = gift;
/*			for(var i:int=0;i<3;i++){
				var gift:Object = new Object();
				switch(i){
					case 0:
						gift.id = NumberConst.getIns().openingGiftId;
						break;
					case 1:
						gift.id = NumberConst.getIns().returnGiftId;
						break;
					case 2:
						gift.id = NumberConst.getIns().beginnerGiftId;
						break;
				}
				gift.isGet = false;
				gifts["gift"+i+1] = gift;
			}*/
			return gifts;
		}
		
		private function initMission():Object
		{
			var dungeon:Object = new Object();
			
			dungeon.id = 1001;
			dungeon.isComplete = false;
			
			return dungeon;
		}
		
		private function initDungeonPass() : Object
		{
			var dungeons:Object = new Object();
			var dungeon:Object = new Object();
			dungeon.name = "1_1";
			dungeon.lv = NumberConst.getIns().negativeOne;
			dungeon.hit = NumberConst.getIns().zero;
			dungeon.hurt =  NumberConst.getIns().zero;
			dungeon.add =  NumberConst.getIns().zero;
			dungeons[dungeon.name] = dungeon;
			return dungeons;
		}
		

		
		private function initEquip() : Object
		{
			var equip:Object = new Object(); 
			equip.weapon = NumberConst.getIns().negativeOne;
			equip.head = NumberConst.getIns().negativeOne;
			equip.neck = NumberConst.getIns().negativeOne;
			equip.clothes = NumberConst.getIns().negativeOne;
			equip.shoulder = NumberConst.getIns().negativeOne;
			equip.shoes = NumberConst.getIns().negativeOne;
			
			return equip;
		}
		
		private function initAttach() : Object
		{
			var attach:Object = new Object(); 
			attach.frontAttach = NumberConst.getIns().negativeOne;
			attach.middleAttach = NumberConst.getIns().negativeOne;
			attach.backAttach = NumberConst.getIns().negativeOne;
			
			return attach;
		}
		
		private function initSkill() : Object
		{
			var skill:Object = new Object(); 
			skill.kungfu1 = NumberConst.getIns().one;
			skill.kungfu2 = NumberConst.getIns().zero;
			for(var i:int=1;i<11;i++){
				var str:String = "skill"+i;
				skill[str]=NumberConst.getIns().zero;
			}
			skill.H = NumberConst.getIns().one;
			skill.U = NumberConst.getIns().zero;
			skill.I = NumberConst.getIns().zero;
			skill.O = NumberConst.getIns().zero;
			skill.L = NumberConst.getIns().zero;
			
			return skill;
		}
		
		private function initPack(occ:int):Object{
			var pack:Object = new Object();
			pack.sum = NumberConst.getIns().initialBagSum
			pack.equipment = new Object;
			pack.material = new Object;
			pack.book = new Object;
			pack.special = new Object;
			pack.prop = new Object;
			pack.bossCard = new Object;
			return pack;
		}
		
		private function initVip(total:int):Object{
			var result:Object = new Object();
			result.vipGiftGetTime = "";
			result.isVipGiftGet = false;
			result.firstCharge = NumberConst.getIns().negativeOne;
			result.totalRecharge = total;
			result.curCoupon = NumberConst.getIns().zero;
			return result;
		}
		
		public function get ConfigProperty() : BasePropertyVo
		{
			var properyVo:BasePropertyVo = new BasePropertyVo();
			properyVo.hp = _player.character.characterConfig.hp
			properyVo.mp = _player.character.characterConfig.mp;
			properyVo.atk = _player.character.characterConfig.atk;
			properyVo.def = _player.character.characterConfig.def;
			properyVo.ats = _player.character.characterConfig.ats;
			properyVo.adf = _player.character.characterConfig.adf;
			properyVo.hit = _player.character.characterConfig.hit;
			properyVo.spd = _player.character.characterConfig.spd;
			properyVo.evasion = _player.character.characterConfig.evasion;
			properyVo.crit = _player.character.characterConfig.crit;
			properyVo.toughness = _player.character.characterConfig.toughness;
			properyVo.hp_regain = _player.character.characterConfig.hp_regain;
			properyVo.mp_regain = _player.character.characterConfig.mp_regain;
			
			return properyVo;
		}
		
		// 所有装备基础 
		private var _weaponProperty:BasePropertyVo;
		private var _headProperty:BasePropertyVo;
		private var _neckProperty:BasePropertyVo;
		private var _clothesProperty:BasePropertyVo;
		private var _trousersProperty:BasePropertyVo;
		private var _shoesProperty:BasePropertyVo;
		
		public function get EquipProperty() : BasePropertyVo
		{
			var equipProperty:BasePropertyVo = new BasePropertyVo();
			var equips:Vector.<ItemVo> = EquipedManager.getIns().EquipedVos;
			for(var i:int=0; i<6;i++){
				if(equips[i]){
					var name:String = EquipedManager.getIns().getPropertyName(equips[i])[0]; 
					equipProperty[name] += equips[i].equipConfig[name]+equips[i].lv*_player.strengthenUp[name];
					
					//充能
					var chargeData:Charge = ConfigurationManager.getIns().getObjectByProperty(
						AssetsConst.CHARGE,"name",equips[i].equipConfig.type) as Charge;
					
					for(var j:int=0; j<4;j++){
						var lv:int = equips[i].equipConfig.chargeLvArr[j];
						var num:int = (lv+1)*lv*Number(chargeData.value[j])/2*100;
						var totalCharge:Number = num/100;
						equipProperty[chargeData.type[j]] += totalCharge;
					}
				}

			}
			return equipProperty;
		}
		
		public function get AttachProperty() : BasePropertyVo
		{
			var attachProperty:BasePropertyVo = new BasePropertyVo();
			var attachs:Vector.<ItemVo> = AttachManager.getIns().AttachVos;
			for(var i:int=0; i<3;i++){
				if(attachs[i]){
					for(var j:int =0;j<attachs[i].bossConfig.add_type.length;j++){
						attachProperty[attachs[i].bossConfig.add_type[j]] += int(attachs[i].bossConfig.add_value[j])*attachs[i].bossUp.add_rate;
					}
				}
			}
			return attachProperty;
		}
		
		public function get FashionProperty() : BasePropertyVo
		{
			var fashionProperty:BasePropertyVo = new BasePropertyVo();
			var fashion:ItemVo = EquipedManager.getIns().EquipedFashionVo;
			if(fashion){
				for(var i:int =0;i<fashion.fashionConfig.add_type.length;i++){
					fashionProperty[fashion.fashionConfig.add_type[i]] += int(fashion.fashionConfig.add_value[i]);
				}
			}

			return fashionProperty;
		}
		
		public function get JingMaiProperty() : BasePropertyVo
		{
			var jingMaiProperty:BasePropertyVo = new BasePropertyVo();
			for(var i:int =0;i<player.jingMai.jingMaiArr.length;i++){
				if(player.jingMai.jingMaiArr[i]>0){
					var jingMaiData:JingMai = ConfigurationManager.getIns().getObjectByID(
						AssetsConst.JINGMAI,i+1) as JingMai;
					for(var j:int =0;j<player.jingMai.jingMaiArr[i];j++){
						jingMaiProperty[jingMaiData.add_type[j]] += int(jingMaiData.add_value[j]);
					}
				}
				
			}
			
			return jingMaiProperty;
		}
		
		
		public function get TitleProperty() : BasePropertyVo
		{
			var titleProperty:BasePropertyVo = new BasePropertyVo();
			if(player.titleInfo.titleNow>0){
				var titleData:Title = ConfigurationManager.getIns().getObjectByID(
					AssetsConst.TITLE,player.titleInfo.titleNow) as Title;
				for(var j:int =0;j<titleData.add_type.length;j++){
					titleProperty[titleData.add_type[j]] += int(titleData.add_value[j]);
				}
			}
			return titleProperty;
		}
		
		
		
		public function get BaGuaProperty() : BasePropertyVo
		{
			var baGuaProperty:BasePropertyVo = new BasePropertyVo();
			var baGuas:Vector.<BaGuaPieceVo> = BaGuaManager.getIns().attachBaGuaPiece;
			for(var i:int=0; i<baGuas.length;i++){
				for(var j:int =0;j<baGuas[i].eightDiagram.add_type.length;j++){
					var propertyName:String = baGuas[i].eightDiagram.add_type[j];
					var addValue:Number = Number(baGuas[i].eightDiagram.add_value[j])*baGuas[i].lv
					baGuaProperty[propertyName] += addValue;
				}
			}
			var suitArr:Array = BaGuaManager.getIns().getSuitData();
			for(var x:int=0;x<suitArr.length;x++){
				if(suitArr[x].id!=0){
					var suitData:EightDiagramSuits = ConfigurationManager.getIns().getObjectByID(AssetsConst.EIGHT_DIAGRAM_SUITS,suitArr[x].id) as EightDiagramSuits;
					if(suitArr[x].num>=NumberConst.getIns().three){
						baGuaProperty[suitData.first_add[0]] += Number(suitData.first_add[1]);
					}
					if(suitArr[x].num>=NumberConst.getIns().five){
						baGuaProperty[suitData.second_add[0]] += Number(suitData.second_add[1]);
					}
					if(suitArr[x].num==NumberConst.getIns().eight){
						baGuaProperty[suitData.third_add[0]] += Number(suitData.third_add[1]);
					}
				}
			}
			return baGuaProperty;
		}

		
		public function get LevelUpProperty() : BasePropertyVo
		{
			var obj:CharactersUp = ConfigurationManager.getIns().getObjectByID(AssetsConst.CHARACTERS_UP, player.occupation) as CharactersUp;
			var properyVo:BasePropertyVo = new BasePropertyVo();
			properyVo.hp = (player.character.lv - 1) * obj.hp_rate;
			properyVo.mp = (player.character.lv - 1) * obj.mp_rate;
			properyVo.atk = (player.character.lv - 1) * obj.atk_rate;
			properyVo.def = (player.character.lv - 1) * obj.def_rate;
			properyVo.ats = (player.character.lv - 1) * obj.ats_rate;
			properyVo.adf = (player.character.lv - 1) * obj.adf_rate;
			
			return properyVo;
		}
		
		public function get heroUpgradeProperty() : BasePropertyVo{
			var properVo:BasePropertyVo = new BasePropertyVo();
			properVo.hp = player.heroScriptVo.addValueArr[0];
			properVo.mp = player.heroScriptVo.addValueArr[1];
			properVo.atk = player.heroScriptVo.addValueArr[2];
			properVo.def = player.heroScriptVo.addValueArr[3];
			properVo.ats = player.heroScriptVo.addValueArr[4];
			properVo.adf = player.heroScriptVo.addValueArr[5];
			return properVo;
		}
		
		
		public function updatePropertys():void{
			_player.character.configProperty = ConfigProperty;
			_player.character.equipProperty = EquipProperty;
			_player.character.levelUpProperty = LevelUpProperty;
			_player.character.attachProperty = AttachProperty;
			_player.character.baGuaProperty = BaGuaProperty;
			_player.character.fashionProperty = FashionProperty;
			_player.character.jingMaiProperty = JingMaiProperty;
			_player.character.titleProperty = TitleProperty;
			_player.character.countTotalProperty();
			
			TitleManager.getIns().checkBattlePowerTitle();
			(ControlFactory.getIns().getControl(PlayerUIControl) as PlayerUIControl).setHP(_player.character.totalProperty.hp, _player.character.totalProperty.hp, _player.character.characterType);
			(ControlFactory.getIns().getControl(PlayerUIControl) as PlayerUIControl).setMP(_player.character.totalProperty.mp, _player.character.totalProperty.mp, _player.character.characterType);
		}
		
		
		
		public function checkNumber(name:String,cost:int):Boolean{
			if(_player[name]-cost<0){
				return false;
			}else{
				return true;
			}
		}
		
		/**
		 *增加资源的存档记录检测 
		 * @param type
		 * @param num
		 * @param max
		 * 
		 */		
		public function checkAdd(type:String,num:int,max:int):void{
			if(num>=max){
				LogManager.getIns().addMissionLog(type,num);
			}
		}
		
		public function addMoney(money:int):void{
			if(money>100*10000){
				money = 0;
			}
			_player.money+=money;
			if(ViewFactory.getIns().getView(MainToolBar)){
				(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).updateMoneyAndSoul();
			}
		}
		
		public function addSoul(soul:int) : void{
			if(soul>100*10000){
				soul = 0;
			}
			_player.soul += soul;
			if(ViewFactory.getIns().getView(MainToolBar)){
				(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).updateMoneyAndSoul();
			}
		}
		
		public function reduceMoney(money:int):void{
			if(checkNumber("money",money) && money>=0){
				_player.money-=money;
				ViewFactory.getIns().getView(MainToolBar).update();
			}
		}
		
		public function reduceSoul(soul:int):void{
			if(checkNumber("soul",soul) && soul>=0){
				_player.soul-=soul;
				ViewFactory.getIns().getView(MainToolBar).update();
			}
		}
		
		public function reduceBaGuaScore(value:int):void{
			if(checkNumber("baGuaScore",value) && value>=0){
				_player.baGuaScore-=value;
			}
		}
		
		public  function addBaGuaFortune():void
		{
			player.baGuaFortune ++;
			if(player.baGuaFortune >NumberConst.getIns().fortuneMax){
				player.baGuaFortune = NumberConst.getIns().fortuneMax;
			}
		}
		
		public  function completeAchieve(id:int):Boolean
		{
			var result:Boolean = false;
			var arr:Array = player.achieveArr;
			if(int(arr[id-1]) == NumberConst.getIns().negativeOne){
				arr[id-1] = NumberConst.getIns().zero;
				player.achieveArr = arr;
				result = true;
			}
			return result;
		}
		
		public  function clearBaGuaFortune():void
		{
			player.baGuaFortune = 0;
		}
		
		
		public var isReachMaxLevel:Boolean;
		//初始化等级
		public function initLevel() : void{
			var arr:Array = ConfigurationManager.getIns().getAllData(AssetsConst.PLAYER);
			for(var i:int = 0; i < NumberConst.getIns().maxLv - 1; i++){
				if(_player.exp >= arr[i].exp){
					continue;
				}else{
					_player.character.lv = arr[i].lv;
					if(_player.exp == arr[NumberConst.getIns().maxLv - 2].exp){
						isReachMaxLevel = true;
					}
					break;
				}
			}
		}
		
		//添加经验
		public function addExp(count:int) : Boolean{
			if(count>=10*10000){
				LogManager.getIns().addMissionLog("exp",count);
			}
			var arr:Array = ConfigurationManager.getIns().getAllData(AssetsConst.PLAYER);
			var isLevelUp:Boolean = false;
			if(isReachMaxLevel || _player.exp == arr[NumberConst.getIns().maxLv - 2].exp){
				return isLevelUp;
			}
			_player.exp += count;
			var indexLv:int = (_player.character.lv-1<0?0:_player.character.lv-1);
			for(var i:int = indexLv; i < NumberConst.getIns().maxLv - 1; i++){
				if(_player.exp >= arr[i].exp){
					if(_player.exp >= arr[NumberConst.getIns().maxLv - 2].exp){
						_player.character.lv = arr[NumberConst.getIns().maxLv - 1].lv;
						_player.exp = arr[NumberConst.getIns().maxLv - 2].exp;
						if(!isReachMaxLevel){
							isLevelUp = true;
						}
						isReachMaxLevel = true;
						break;
					}else{
						isLevelUp = true;
					}
					continue;
				}else{
					_player.character.lv = arr[i].lv;
					break;
				}
			}
			
			//升级
			if(isLevelUp || isReachMaxLevel){
				updatePropertys();
				//添加关卡信息
				//updateLevelInfo();
			}
			
			return isLevelUp;
		}
		
		public function updateLevelInfo() : void{
			var levelInfo:Array = ConfigurationManager.getIns().getAllData(AssetsConst.LEVEL);
			for(var j:int = 0; j < levelInfo.length; j++){
				if(int(levelInfo[j].level_id.split("_")[1]) < 10){ 
					if(levelInfo[j].level_lv <= _player.character.lv && !hasDungeonInfo(levelInfo[j].level_id)){
						var dungeon:DungeonPassVo = new DungeonPassVo();
						dungeon.name = levelInfo[j].level_id;
						dungeon.lv = -1;
						_player.dungeonPass.push(dungeon);
					}
				}
			}
			
			var nowLevel:int = 0;
			var nowDungeon:int = 0;
			var firstDungeon:Array = [];
			var info:Array = [];
			for(var i:int = 0; i < _player.dungeonPass.length; i++){
				info = _player.dungeonPass[i].name.split("_");
				nowLevel = (int(info[0])>nowLevel?info[0]:nowLevel);
			}
			
			for(var k:int = 0; k < _player.dungeonPass.length; k++){
				info = _player.dungeonPass[k].name.split("_");
				if(nowLevel == int(info[0]) && int(info[1]) <= 9){
					nowDungeon = (int(info[1])>nowDungeon?info[1]:nowDungeon);
				}
			}
			var lastInfo:String = nowLevel + "_" + nowDungeon;
			for(var l:int = 0; l < _player.dungeonPass.length; l++){
				if(_player.dungeonPass[l].name == lastInfo){
					if(_player.dungeonPass[l].lv > 0){
						var nextDungeon:DungeonPassVo = new DungeonPassVo();
						if(nowDungeon == 9){
							nextDungeon.name = (nowLevel + 1) + "_1";
							nextDungeon.lv = -1;
							_player.dungeonPass.push(nextDungeon);
						}else{
							nextDungeon.name = nowLevel + "_" + (nowDungeon + 1);
							nextDungeon.lv = -1;
							_player.dungeonPass.push(nextDungeon);
						}
					}
				}
			}
		}
		
		
		/**
		 *更新成就数据 
		 * 
		 */
		public function checkAllAchieves():void{
			checkFirstDungeonAchieve();
			checkFirstEliteAchieve();
			checkFirstBossAchieve();
			checkLvTenAchieve();
			checkLvTwentyAchieve();
			checkFirstJiAchieve();

		}
		
		public function checkFirstDungeonAchieve():Boolean{
			var result:Boolean = false;
			if(player.achieveArr[0] == NumberConst.getIns().negativeOne){
				for(var dIdx:int =0;dIdx<player.dungeonPass.length;dIdx++){
					if(player.dungeonPass[dIdx].lv > NumberConst.getIns().zero){
						if(completeAchieve(1)){
							result = true;
						}
						break;
					}
				}	
			}
			return result;
		}
		
		public function checkFirstEliteAchieve():Boolean{
			var result:Boolean = false;
			if(player.achieveArr[1] == NumberConst.getIns().negativeOne){
				for(var eliteIdx:int =0;eliteIdx<player.eliteDungeon.eliteDungeonPass.length;eliteIdx++){
					if(player.eliteDungeon.eliteDungeonPass[eliteIdx].lv > NumberConst.getIns().zero){
						if(completeAchieve(2)){
							result = true;
						}
						break;
					}
				}
			}
			return result;
		}
		
		public function checkFirstBossAchieve():Boolean{
			var result:Boolean = false;
			if(player.achieveArr[2] == NumberConst.getIns().negativeOne){
				if(player.pack.boss.length>0){
					if(completeAchieve(3)){
						result = true;
					}
				}
			}
			return result;
		}
		
		public function checkLvTenAchieve():Boolean{
			var result:Boolean = false;
			if(player.achieveArr[3] == NumberConst.getIns().negativeOne){
				if(player.character.lv>=10){
					if(completeAchieve(4)){
						result = true;
					}
				}
			}
			return result;
		}
		
		public function checkLvTwentyAchieve():Boolean{
			var result:Boolean = false;
			if(player.achieveArr[4] == NumberConst.getIns().negativeOne){
				if(player.character.lv>=20){
					if(completeAchieve(5)){
						result = true;
					}
				}
			}
			return result;
		}
		
		public function checkFirstJiAchieve():Boolean{
			var result:Boolean = false;
			if(player.achieveArr[5] == NumberConst.getIns().negativeOne){
				for(var i:int =0;i<player.dungeonPass.length;i++){
					if(player.dungeonPass[i].lv == NumberConst.getIns().five){
						if(completeAchieve(6)){
							result = true;
						}
						break;
					}
				}
				if(!result){
					for(var j:int =0;j<player.eliteDungeon.eliteDungeonPass.length;j++){
						if(j<player.eliteDungeon.eliteDungeonPass[j].lv == NumberConst.getIns().five){
							if(completeAchieve(6)){
								result = true;
							}
							break;
						}
					}	
				}
			}
			return result;
		}
		
		
		/**
		 * 获得输入的经验值对应等级的数据
		 * @param exp
		 * @return 
		 * 
		 */		
		public function getLevelInfo(exp:int) : Array{
			var result:Array = new Array;
			var _levelInfo:Array = ConfigurationManager.getIns().getAllData(AssetsConst.PLAYER);
			for(var i:int = 0; i < _levelInfo.length; i++){
				if(exp >= _levelInfo[i].exp){
					continue;
				}else{
					if(i - 1 < 0){
						result.push(0);
					}else{
						result.push(_levelInfo[i - 1].exp);
					}
					result.push(_levelInfo[i].exp);
					result.push(i + 1);
					break;
				}
			}
			
			if(result[2] == NumberConst.getIns().maxLv){
				result = [_levelInfo[i-1].exp, _levelInfo[i-1].exp, NumberConst.getIns().maxLv];
			}
			return result;
		}
		
		/**
		 * 获得当前可打的所有关卡的随机一个关卡
		 * @return 
		 * 
		 */		
		public function getRandomDungeonName() : String{
			var result:Array = [];
			for(var i:int = 0; i < player.dungeonPass.length; i++){
				if(player.dungeonPass[i].name != NumberConst.getIns().lastDungeon){
					result.push(player.dungeonPass[i].name);
				}
			}
			for(var j:int = 0; j < player.eliteDungeon.eliteDungeonPass.length; j++){
				if(player.eliteDungeon.eliteDungeonPass[j].num != 5){
					result.push(player.eliteDungeon.eliteDungeonPass[j].name + "_1");
				}
			}
			var dungeonName:String = result[int(result.length * Math.random())];
			return dungeonName;
		}
		
		public function getDoubleDungeonName() : String{
			var result:Array = [];
			for(var i:int = 0; i < player.dungeonPass.length; i++){
				if(player.dungeonPass[i].name != NumberConst.getIns().lastDungeon){
					result.push(player.dungeonPass[i].name);
				}
			}
			for(var j:int = 0; j < player.eliteDungeon.eliteDungeonPass.length; j++){
				if(player.eliteDungeon.eliteDungeonPass[j].num != 5){
					result.push(player.eliteDungeon.eliteDungeonPass[j].name + "_1");
				}
			}
			var index:int = result.indexOf(player.doubleDungeonVo.dungeonName);
			if(index != -1){
				result.splice(index, 1);
			}
			var dungeonName:String = result[int(result.length * Math.random())];
			return dungeonName;
		}
		
		/**
		 * 获得当前可打的所有普通关卡中的随机一个关卡
		 * @param exception		代表例外的大关
		 * @return 
		 * 
		 */		
		public function getSimpleDungeonName(exception:int = -1) : String{
			var result:Array = [];
			for(var i:int = 0; i < player.dungeonPass.length; i++){
				if(player.dungeonPass[i].name != NumberConst.getIns().lastDungeon
					&& player.dungeonPass[i].name.split("_")[0] != exception){
					result.push(player.dungeonPass[i].name);
				}
			}
			var dungeonName:String = result[int(result.length * Math.random())];
			return dungeonName;
		}

		/**
		 * 获得普通关卡信息
		 * @param lv
		 * @return 
		 * 
		 */		
		public function getDungeonInfo(lv:int) : Array{
			var result:Array = [0,0,0,0,0,0,0,0,0,0,0,0];
			var info:Array = new Array();
			for(var i:int = 0; i < _player.dungeonPass.length; i++){
				info = _player.dungeonPass[i].name.split("_");
				if(info[0] == lv){
					result[info[1] - 1] = _player.dungeonPass[i].lv;
				}
			}
			return result;
		}
		
		/**
		 * 获得精英关卡信息
		 * @param lv
		 * @return 
		 * 
		 */
		public function getEliteDungeonInfo(lv:int) : Array{
			var result:Array = [0,0,0,0];
			var info:Array = new Array();
			for(var i:int = 0; i < _player.eliteDungeon.eliteDungeonPass.length; i++){
				info = _player.eliteDungeon.eliteDungeonPass[i].name.split("_");
				if(info[0] == lv){
					result[int(info[1]) - 1] = _player.eliteDungeon.eliteDungeonPass[i].lv;
				}
			}
			return result;
		}
		
		/**
		 * 获得精英关卡今日通关次数
		 * @param lv
		 * @return 
		 * 
		 */		
		public function getEliteDungeonTimeInfo(lv:int) : Array{
			var result:Array = [-1,-1,-1,-1];
			var info:Array = new Array();
			for(var i:int = 0; i < _player.eliteDungeon.eliteDungeonPass.length; i++){
				info = _player.eliteDungeon.eliteDungeonPass[i].name.split("_");
				if(info[0] == lv){
					result[int(info[1]) - 1] = _player.eliteDungeon.eliteDungeonPass[i].num;
				}
			}
			return result;
		}
		
		/**
		 * 获得精英关卡可以打开的关卡数
		 * @return 
		 * 
		 */		
		public function getElitePassInfo() : Array{
			var info:Array = [];
			var large:int = 0;
			var lv:int = 0;
			for(var i:int = 0; i < _player.eliteDungeon.eliteDungeonPass.length; i++){
				lv = _player.eliteDungeon.eliteDungeonPass[i].name.split("_")[0];
				info.push(lv - 1);
				large = (large > lv?large:lv);
			}
			var result:Array = new Array(large);
			for(var j:int = 0; j < info.length; j++){
				result[info[j]] = 1;
			}
			return result;
		}
		
		/**
		 * 是否有通关该关卡
		 * @param index
		 * @return 
		 * 
		 */		
		public function hasPassDungeonInfo(index:String) : Boolean{
			var result:Boolean = false;
			if(_player != null){
				for(var i:int = 0; i < _player.dungeonPass.length; i++){
					if(_player.dungeonPass[i].name == index && _player.dungeonPass[i].lv > 0){
						result = true;
						break;
					}
				}
			}
			return result;
		}
		
		/**
		 * 是否开启该关卡
		 * @param index
		 * @return 
		 * 
		 */		
		public function hasDungeonInfo(index:String) : Boolean{
			var result:Boolean = false;
			for(var i:int = 0; i < _player.dungeonPass.length; i++){
				if(_player.dungeonPass[i].name == index){
					result = true;
					break;
				}
			}
			return result;
		}
		
		
		//任务完成 进入领取奖励
		public function completeMainMission():void{
			_player.mainMissionVo.isComplete = true;
		}
		//领取奖励完成 进入下一主线
		public function openNextMainMission():void{

				_player.mainMissionVo.id ++;
				_player.mainMissionVo.isComplete = false;
			
		}
		
		//是否还在保护等级之内
		public function get hasProtect() : Boolean{
			var result:Boolean = false;
			if(_player.character.lv <= NumberConst.getIns().protectedBuffLv
				||TimeManager.getIns().disDayNum(NumberConst.getIns().summerEndDate, TimeManager.getIns().curTimeStr) <= 0){
				result = true;
			}
			return result;
		}
		
		public function get protectedType() : int{
			var result:int = NumberConst.getIns().zero;
			if(TimeManager.getIns().disDayNum(NumberConst.getIns().summerEndDate, TimeManager.getIns().curTimeStr) <= 0){
				result = NumberConst.getIns().one;
			}else if(_player.character.lv <= NumberConst.getIns().protectedBuffLv){
				result = NumberConst.getIns().two;
			}
			return result;
		}
		
		//是否领取首冲礼包
		public function get hasGetFirstCharge() : Boolean{
			var result:Boolean = true;
			if(_player.vip.firstCharge == NumberConst.getIns().one){
				result = false;
			}
			return result;
		}
		
		public function getPartnerEquipped() : Array{
			var result:Array = [];
			var info:Array = [];
			var occ:int = (_player.occupation==1?2:1);
			var fodder:String = (occ==OccupationConst.KUANGWU?"KuangWu":"XiaoYao");
			var lv:Array = player.heroScriptVo.getAverageLv();
			info.push(getWeaponFodder(occ * 1000 + lv[0], occ, fodder));
			info.push(getHeadFodder(occ * 1000 + 100 + lv[2], occ, fodder));
			info.push(getShoulderFodder(occ * 1000 + 400 + lv[3], occ, fodder));
			info.push(getClothesFodder(occ * 1000 + 300 + lv[1], occ, fodder));
			/*info.push(getWeaponFodder((_player.equipInfo.weapon==-1?-1:_player.equipInfo.weapon + (occ - 1) * 1000), occ, fodder));
			info.push(getHeadFodder((_player.equipInfo.head==-1?-1:_player.equipInfo.head + (occ - 1) * 1000), occ, fodder));
			info.push(getShoulderFodder((_player.equipInfo.shoulder==-1?-1:_player.equipInfo.shoulder + (occ - 1) * 1000), occ, fodder));
			info.push(getClothesFodder((_player.equipInfo.clothes==-1?-1:_player.equipInfo.clothes + (occ - 1) * 1000), occ, fodder));*/
			
			switch(occ){
				case OccupationConst.KUANGWU:
					result.push(info[0][0]);
					result.push(info[3][0]);
					result.push(info[1][0]);
					result.push(info[2][0]);
					result.push(info[0][1]);
					result.push(info[1][1]);
					break;
				case OccupationConst.XIAOYAO:
					result.push(info[3][0]);
					result.push(info[1][0]);
					result.push(info[3][1]);
					result.push(info[1][1]);
					result.push(info[0][0]);
					result.push(info[3][2]);
					result.push(info[2][0]);
					result.push(info[1][2]);
					break;
			}
			return result;
		}
		
		public function getNewGameEquipped(occ:int, fodder:String) : Array{
			var result:Array = [];
			var info:Array = [];
			if(_player == null){
				info.push(getWeaponFodder(-1, occ, fodder));
				info.push(getHeadFodder(-1, occ, fodder));
				info.push(getShoulderFodder(-1, occ, fodder));
				info.push(getClothesFodder(-1, occ, fodder));	
			}
			switch(occ){
				case OccupationConst.KUANGWU:
					result.push(info[0][0]);
					result.push(info[3][0]);
					result.push(info[1][0]);
					result.push(info[2][0]);
					result.push(info[0][1]);
					result.push(info[1][1]);
					break;
				case OccupationConst.XIAOYAO:
					result.push(info[3][0]);
					result.push(info[1][0]);
					result.push(info[3][1]);
					result.push(info[1][1]);
					result.push(info[0][0]);
					result.push(info[3][2]);
					result.push(info[2][0]);
					result.push(info[1][2]);
					break;
			}
			return result;
		}
		
		public function getEquipped() : Array{
			var result:Array = [];
			var info:Array = [];
			if(_player.fashionInfo.fashionId == -1 || _player.fashionInfo.showFashion == 0){
				info.push(getWeaponFodder(_player.equipInfo.weapon, _player.occupation, _player.fodder));
				info.push(getHeadFodder(_player.equipInfo.head, _player.occupation, _player.fodder));
				info.push(getShoulderFodder(_player.equipInfo.shoulder, _player.occupation, _player.fodder));
				info.push(getClothesFodder(_player.equipInfo.clothes, _player.occupation, _player.fodder));
			}else{
				info.push(getFashionWeaponFodder(_player.fashionInfo.fashionId));
				info.push(getFashionHeadFodder(_player.fashionInfo.fashionId));
				info.push(getFashionShoulderFodder(_player.fashionInfo.fashionId));
				info.push(getFashionClothesFodder(_player.fashionInfo.fashionId));
			}
			switch(_player.occupation){
				case OccupationConst.KUANGWU:
					result.push(info[0][0]);
					result.push(info[3][0]);
					result.push(info[1][0]);
					result.push(info[2][0]);
					result.push(info[0][1]);
					result.push(info[1][1]);
					break;
				case OccupationConst.XIAOYAO:
					result.push(info[3][0]);
					result.push(info[1][0]);
					result.push(info[3][1]);
					result.push(info[1][1]);
					result.push(info[0][0]);
					result.push(info[3][2]);
					result.push(info[2][0]);
					result.push(info[1][2]);
					break;
			}
			return result;
		}
		
		//武器显示
		private function getWeaponFodder(weaponId:int, occ:int, fodder:String) : Array{
			var result:Array = [];
			if(weaponId != -1){
				var weapon:Equipment  = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.EQUIPMENT, "id", weaponId) as Equipment;
				switch(occ){
					case OccupationConst.KUANGWU:
						var weapons:Array = weapon.fodder.split("|");
						result.push(fodder + "BackWeapon" + (int(weapons[0])==0?"":AllUtils.getLastNum(weapon.id, 2)));
						result.push(fodder + "FrontWeapon" + (int(weapons[1])==0?"":AllUtils.getLastNum(weapon.id, 2)));
						break;
					case OccupationConst.XIAOYAO:
						result.push(fodder + "Weapon" + (int(weapon.fodder)==0?"":AllUtils.getLastNum(weapon.id, 2)));
						break;
				}
			}else{
				switch(occ){
					case OccupationConst.KUANGWU:
						result.push(fodder + "BackWeapon");
						result.push(fodder + "FrontWeapon");
						break;
					case OccupationConst.XIAOYAO:
						result.push(fodder + "Weapon");
						break;
				}
			}
			return result;
		}
		
		//头盔显示
		private function getHeadFodder(headId:int, occ:int, fodder:String) : Array{
			var result:Array = [];
			if(headId != -1){
				var head:Equipment  = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.EQUIPMENT, "id", headId) as Equipment;
				var heads:Array = head.fodder.split("|");
				switch(occ){
					case OccupationConst.KUANGWU:
						result.push(fodder + "Head" + (int(heads[0])==0?"":AllUtils.getLastNum(head.id, 2)));
						result.push(fodder + "Hair" + (int(heads[1])==0?"":AllUtils.getLastNum(head.id, 2)));
						break;
					case OccupationConst.XIAOYAO:
						result.push(fodder + "BackHair" + (int(heads[0])==0?"":AllUtils.getLastNum(head.id, 2)));
						result.push(fodder + "Head" + (int(heads[1])==0?"":AllUtils.getLastNum(head.id, 2)));
						result.push(fodder + "FrontHair" + (int(heads[2])==0?"":AllUtils.getLastNum(head.id, 2)));
						break;
				}
			}else{
				switch(occ){
					case OccupationConst.KUANGWU:
						result.push(fodder + "Head");
						result.push(fodder + "Hair");
						break;
					case OccupationConst.XIAOYAO:
						result.push(fodder + "BackHair");
						result.push(fodder + "Head");
						result.push(fodder + "FrontHair");
						break;
				}
			}
			return result;
		}
		
		//护肩显示
		private function getShoulderFodder(shoulderId:int, occ:int, fodder:String) : Array{
			var result:Array = [];
			if(shoulderId != -1){
				var shoulder:Equipment  = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.EQUIPMENT, "id", shoulderId) as Equipment;
				result.push(fodder + "Shoulder" + (int(shoulder.fodder)==0?"":AllUtils.getLastNum(shoulder.id, 2)));
			}else{
				result.push(fodder + "Shoulder");
			}
			return result;
		}
		
		//衣服显示
		private function getClothesFodder(clothesId:int, occ:int, fodder:String) : Array{
			var result:Array = [];
			if(clothesId != -1){
				var clothes:Equipment  = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.EQUIPMENT, "id", clothesId) as Equipment;
				switch(occ){
					case OccupationConst.KUANGWU:
						result.push(fodder + "Clothes" + (int(clothes.fodder)==0?"":AllUtils.getLastNum(clothes.id, 2)));
						break;
					case OccupationConst.XIAOYAO:
						var clotheses:Array = clothes.fodder.split("|");
						result.push(fodder + "BackHand" + (int(clotheses[0])==0?"":AllUtils.getLastNum(clothes.id, 2)));
						result.push(fodder + "Clothes" + (int(clotheses[1])==0?"":AllUtils.getLastNum(clothes.id, 2)));
						result.push(fodder + "FrontHand" + (int(clotheses[2])==0?"":AllUtils.getLastNum(clothes.id, 2)));
						break;
				}
			}else{
				switch(occ){
					case OccupationConst.KUANGWU:
						result.push(fodder + "Clothes");
						break;
					case OccupationConst.XIAOYAO:
						result.push(fodder + "BackHand");
						result.push(fodder + "Clothes");
						result.push(fodder + "FrontHand");
						break;
				}
			}
			return result;
		}
		
		
		//时装武器
		private function getFashionWeaponFodder(fashionIndex:int) : Array{
			var result:Array = [];
			var info:FashionConfiguration = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.FASHION_CONFIGURATION, "fashion_id", fashionIndex) as FashionConfiguration;
			var arr:Array = info.weapon.split("|");
			switch(_player.occupation){
				case OccupationConst.KUANGWU:
					result.push(_player.fodder + "BackWeapon" + (int(arr[0])==0?"":"Fashion" + info.fodder));
					result.push(_player.fodder + "FrontWeapon" + (int(arr[1])==0?"":"Fashion" + info.fodder));
					break;
				case OccupationConst.XIAOYAO:
					result.push(_player.fodder + "Weapon" + (int(arr[0])==0?"":"Fashion" + info.fodder));
					break;
			}
			return result;
		}
		
		//头盔时装
		private function getFashionHeadFodder(fashionIndex:int) : Array{
			var result:Array = [];
			var info:FashionConfiguration = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.FASHION_CONFIGURATION, "fashion_id", fashionIndex) as FashionConfiguration;
			var arr:Array = info.head.split("|");
			switch(_player.occupation){
				case OccupationConst.KUANGWU:
					result.push(_player.fodder + "Head" + (int(arr[0])==0?"":"Fashion" + info.fodder));
					result.push(_player.fodder + "Hair" + (int(arr[1])==0?"":"Fashion" + info.fodder));
					break;
				case OccupationConst.XIAOYAO:
					result.push(_player.fodder + "BackHair" + (int(arr[0])==0?"":"Fashion" + info.fodder));
					result.push(_player.fodder + "Head" + (int(arr[1])==0?"":"Fashion" + info.fodder));
					result.push(_player.fodder + "FrontHair" + (int(arr[2])==0?"":"Fashion" + info.fodder));
					break;
			}
			return result;
		}
		
		//护肩时装
		private function getFashionShoulderFodder(fashionIndex:int) : Array{
			var result:Array = [];
			var info:FashionConfiguration = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.FASHION_CONFIGURATION, "fashion_id", fashionIndex) as FashionConfiguration;
			var arr:Array = info.shoulder.split("|");
			switch(_player.occupation){
				case OccupationConst.KUANGWU:
					result.push(_player.fodder + "Shoulder" + (int(arr[0])==0?"":"Fashion" + info.fodder));
					break;
				case OccupationConst.XIAOYAO:
					result.push(_player.fodder + "Shoulder" + (int(arr[0])==0?"":"Fashion" + info.fodder));
					break;
			}
			return result;
		}
		
		//衣服时装
		private function getFashionClothesFodder(fashionIndex:int) : Array{
			var result:Array = [];
			var info:FashionConfiguration = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.FASHION_CONFIGURATION, "fashion_id", fashionIndex) as FashionConfiguration;
			var arr:Array = info.clothes.split("|");
			switch(_player.occupation){
				case OccupationConst.KUANGWU:
					result.push(_player.fodder + "Clothes" + (int(arr[0])==0?"":"Fashion" + info.fodder));
					break;
				case OccupationConst.XIAOYAO:
					result.push(_player.fodder + "BackHand" + (int(arr[0])==0?"":"Fashion" + info.fodder));
					result.push(_player.fodder + "Clothes" + (int(arr[1])==0?"":"Fashion" + info.fodder));
					result.push(_player.fodder + "FrontHand" + (int(arr[2])==0?"":"Fashion" + info.fodder));
					break;
			}
			return result;
		}
		
		/**
		 * 技能重修
		 * 
		 */		
		public function resetSkills() : void{
			for(var i:int = 0; i < 10; i++){
				_player.skill.skillArr[i] = 0;
			}
			_player.skill.skill_H = 0;
			_player.skill.skill_I = 0;
			_player.skill.skill_L = 0;
			_player.skill.skill_O = 0;
			_player.skill.skill_U = 0;
		}
		
		
		/**
		 * 经脉重修
		 * 
		 */		
		public function resetJingMai() : void{
			var arr:Array = _player.jingMai.jingMaiArr;
			arr[0]=NumberConst.getIns().zero;
			_player.jingMai.bookPoint+=NumberConst.getIns().one;
			for(var i:int = 1;i<NumberConst.getIns().jingMaiMax;i++){
				arr[i] = NumberConst.getIns().negativeOne;
			}
			_player.jingMai.jingMaiArr = arr;
		}
		
		
		public function get battlePower():int{
			var power:int;
			power = (_player.character.totalProperty.hp + _player.character.totalProperty.mp
				+ _player.character.totalProperty.atk + _player.character.totalProperty.def
				+ _player.character.totalProperty.ats + _player.character.totalProperty.adf
				+ (_player.character.totalProperty.hp_regain + _player.character.totalProperty.mp_regain)* 50)
				* (1 + _player.character.totalProperty.evasion 
					+ _player.character.totalProperty.toughness
					+ _player.character.totalProperty.hit
					+ _player.character.totalProperty.crit
					+ _player.character.totalProperty.hurt_deepen
					+ _player.character.totalProperty.hurt_reduce);
			return power;
		}
		
		
		public function get heroBattlePower():int{
			var power:int;
			power = (_player.character.configProperty.hp + _player.character.levelUpProperty.hp +_player.heroScriptVo.addValueArr[0]
					+ _player.character.configProperty.mp + _player.character.levelUpProperty.mp + _player.heroScriptVo.addValueArr[1]
					+ _player.character.configProperty.atk + _player.character.levelUpProperty.atk + _player.heroScriptVo.addValueArr[2]
					+ _player.character.configProperty.def + _player.character.levelUpProperty.def + _player.heroScriptVo.addValueArr[3]
					+ _player.character.configProperty.ats + _player.character.levelUpProperty.ats + _player.heroScriptVo.addValueArr[4] 
					+ _player.character.configProperty.adf + _player.character.levelUpProperty.adf + _player.heroScriptVo.addValueArr[5]
				+ (_player.character.configProperty.hp_regain + _player.character.configProperty.mp_regain)* 50)
				* (1 + _player.character.configProperty.evasion 
					+ _player.character.configProperty.toughness
					+ _player.character.configProperty.hit
					+ _player.character.configProperty.crit
					+ _player.character.configProperty.hurt_deepen
					+ _player.character.configProperty.hurt_reduce);
			return power;
		}
		
		public function get occName():String{
			var name:String;
			switch(_player.occupation){
				case OccupationConst.KUANGWU:
					name = StringConst.ROLE_KUANGWU;
					break;
				case OccupationConst.XIAOYAO:
					name = StringConst.ROLE_XIAOYAO;
					break;
			}
			return name;
		}
		
		//添加技能升级id
		public function addSkillUp(id:int, num:int = 1) : void{
			var index:int = id - 1 - (player.occupation * 100 + 400);
			var skillLv:int = int(index / 10);
			var skillId:int = index - skillLv * 10;
			var arr:Array = player.skillUp["skillBooks" + (skillId + 1)];
			arr[skillLv] = int(arr[skillLv]) + num;
			player.skillUp["skillBooks" + (skillId + 1)] = arr;
		}
		
		//正常关卡获得残卷
		public function normalSkillUpInfo(lv:int) : Array{
			var result:Array = new Array();
			if(lv < 6){
				for(var i:int = 1; i <= 10; i++){
					if(i == 5 || i == 10) continue;
					if(player.skillUp["skillBooks" + i][lv - 1] < NumberConst.getIns().five * lv){
						result.push(i);
					}
				}
			}
			return result;
		}
		
		//精英关卡获得残卷
		public function specialSkillUpInfo(lv:int) : Array{
			var result:Array = new Array();
			if(lv < 6){
				for(var i:int = 1; i <= 10; i++){
					if(player.skillUp["skillBooks" + i][lv - 1] < NumberConst.getIns().five * lv){
						result.push(i);
					}
				}
			}
			return result;
		}

		public function playerClear() : void{
			_player = null;
		}
		

	}
}