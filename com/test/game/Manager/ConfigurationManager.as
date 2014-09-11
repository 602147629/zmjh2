package com.test.game.Manager
{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Loader.AssetsItem;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.DebugConst;
	import com.test.game.Mvc.Configuration.Achieve;
	import com.test.game.Mvc.Configuration.BaseConfiguration;
	import com.test.game.Mvc.Configuration.BlackMarket;
	import com.test.game.Mvc.Configuration.Book;
	import com.test.game.Mvc.Configuration.BossCard;
	import com.test.game.Mvc.Configuration.BossCardUp;
	import com.test.game.Mvc.Configuration.Character;
	import com.test.game.Mvc.Configuration.CharacterSkill;
	import com.test.game.Mvc.Configuration.CharactersUp;
	import com.test.game.Mvc.Configuration.Charge;
	import com.test.game.Mvc.Configuration.DailyMission;
	import com.test.game.Mvc.Configuration.EightDiagramSuits;
	import com.test.game.Mvc.Configuration.EightDiagrams;
	import com.test.game.Mvc.Configuration.Elite;
	import com.test.game.Mvc.Configuration.Enemy;
	import com.test.game.Mvc.Configuration.EnemyUp;
	import com.test.game.Mvc.Configuration.Equipment;
	import com.test.game.Mvc.Configuration.Fashion;
	import com.test.game.Mvc.Configuration.FashionConfiguration;
	import com.test.game.Mvc.Configuration.FeedbackMessage;
	import com.test.game.Mvc.Configuration.Festivals;
	import com.test.game.Mvc.Configuration.GiftPackage;
	import com.test.game.Mvc.Configuration.HeroUp;
	import com.test.game.Mvc.Configuration.HideMission;
	import com.test.game.Mvc.Configuration.JingMai;
	import com.test.game.Mvc.Configuration.JsonConfiguration;
	import com.test.game.Mvc.Configuration.Level;
	import com.test.game.Mvc.Configuration.LevelStory;
	import com.test.game.Mvc.Configuration.MainMission;
	import com.test.game.Mvc.Configuration.Material;
	import com.test.game.Mvc.Configuration.OnlineBonus;
	import com.test.game.Mvc.Configuration.PkExp;
	import com.test.game.Mvc.Configuration.Player;
	import com.test.game.Mvc.Configuration.PlayerSkill;
	import com.test.game.Mvc.Configuration.Prop;
	import com.test.game.Mvc.Configuration.PublicNotice;
	import com.test.game.Mvc.Configuration.Shop;
	import com.test.game.Mvc.Configuration.SignIn;
	import com.test.game.Mvc.Configuration.SignMonth;
	import com.test.game.Mvc.Configuration.SkillUp;
	import com.test.game.Mvc.Configuration.SouthMarket;
	import com.test.game.Mvc.Configuration.Special;
	import com.test.game.Mvc.Configuration.Strengthen;
	import com.test.game.Mvc.Configuration.StrengthenUp;
	import com.test.game.Mvc.Configuration.SummerCarnival;
	import com.test.game.Mvc.Configuration.Title;
	import com.test.game.Mvc.Configuration.UpdateMessage;
	import com.test.game.Mvc.Configuration.VehicleEscort;
	import com.test.game.Mvc.Configuration.VipInfo;
	
	import flash.utils.Dictionary;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	
	public class ConfigurationManager extends Singleton{
		public var dict:Dictionary = new Dictionary();
		private var jsonDict:Dictionary = new Dictionary();
		public function ConfigurationManager(){
			super();
		
		}
		
		public static function getIns():ConfigurationManager{
			return Singleton.getIns(ConfigurationManager);
		}
		
		public function init() : void{
			var ai:AssetsItem = AssetsManager.getIns().getAssetsItem(AssetsUrl.JSON_DATA);
			var zipFile:ZipFile = new ZipFile(ai.data);
			for each(var ze:ZipEntry in zipFile.entries){
				initJsonByByte(ze, zipFile);
			}
		}
		
		private function initJsonByByte(ze:ZipEntry, zipFile:ZipFile) : void{
			var type:String;
			var arr:Array = ze.name.split("/");
			if(arr.length >= 2 && arr[1] != ""){
				type = arr[1].split(".")[0];
				var jsonConfiguration:JsonConfiguration = new JsonConfiguration();
				jsonConfiguration.data = zipFile.getInput(ze).toString();
				jsonDict[type] = jsonConfiguration;
				dict[type] = calculateJsonData(type);
			}
		}
		
		public function getAllData(type:String) : Array{
			if(!dict[type]){
				dict[type] = calculateJsonData(type);
			}
			return dict[type];
		}
		
		//根据ID获得数据
		public function getObjectByID(type:String, id:int) : Object{
			if(!dict[type]){
				dict[type] = calculateJsonData(type);
			}
			var result:Object;
			for(var i:int = 0; i < dict[type].length; i++){
				if(dict[type][i].id == id){
					result = dict[type][i];
				}
			}
			
			if(result == null){
				DebugArea.getIns().showInfo("没有类型为" + type + "的，id为" + id + "的数据！", DebugConst.ERROR);
				throw new Error("没有类型为" + type + "的，id为" + id + "的数据！");
			}
			
			return result;
		}
		
		private function calculateJsonData(type:String) : Array{
			//var ai:AssetsItem = AssetsManager.getIns().getAssetsItem(AssetsUrl.getJsonObject(type));
			var objList:Array = com.adobe.serialization.json.JSON.decode(jsonDict[type].data).RECORDS;
			var result:Array = new Array();
			var cls:Class = getClass(type);
			if(objList != null && cls!= null){ 
				
				for(var i:int = 0; i < objList.length; i++){
					var item:BaseConfiguration = new cls();
					item.assign(objList[i]);
					result.push(item);
				}
			}
			
			return result;
		}
		
		private function getClass(type:String) : Class{
			var cls:Class;
			switch(type){
				case AssetsConst.CHARACTER_SKILL:
					cls = CharacterSkill;
					break;
				case AssetsConst.PLAYER_SKILL:
					cls = PlayerSkill;
					break;
				case AssetsConst.ENEMY:
					cls = Enemy;
					break
				case AssetsConst.ENEMY_SKILL:
					cls = PlayerSkill;
					break;
				case AssetsConst.ENEMY_UP:
					cls = EnemyUp;
					break;
				case AssetsConst.LEVEL:
					cls = Level;
					break;
				case AssetsConst.EQUIPMENT:
					cls = Equipment;
					break;
				case AssetsConst.CHARACTERS:
					cls = Character;
					break;
				case AssetsConst.CHARACTERS_UP:
					cls = CharactersUp;
					break;
				case AssetsConst.MATERIAL:
					cls = Material;
					break;
				case AssetsConst.PLAYER:
					cls = Player;
					break;
				case AssetsConst.BOOK:
					cls = Book;
					break;
				case AssetsConst.ELITE:
					cls = Elite;
					break;
				/*case AssetsConst.ELITE_DISPOSITION:
					cls = Level;
					break;*/
				case AssetsConst.SPECIAL:
					cls = Special;
					break;
				case AssetsConst.PROP:
					cls = Prop;
					break;
				case AssetsConst.STRENGTHEN:
					cls = Strengthen;
					break;
				case AssetsConst.STRENGTHEN_UP:
					cls = StrengthenUp;
					break;
				case AssetsConst.BOSS:
					cls = BossCard;
					break;
				case AssetsConst.BOSS_UP:
					cls = BossCardUp;
					break;
				case AssetsConst.MAIN_MISSION:
					cls = MainMission;
					break;
				case AssetsConst.DAILY_MISSION:
					cls = DailyMission;
					break;
				case AssetsConst.GIFT_PACKAGE:
					cls = GiftPackage;
					break;
				case AssetsConst.ONLINE_BONUS:
					cls = OnlineBonus;
					break;
				case AssetsConst.SIGN_IN:
					cls = SignIn;
					break;
				case AssetsConst.SIGN_MONTH:
					cls = SignMonth;
					break;
				case AssetsConst.BLACK_MARKET:
					cls = BlackMarket;
					break;
				case AssetsConst.SOUTH_MARKET:
					cls = SouthMarket;
					break;				
				case AssetsConst.HIDE_MISSION:
					cls = HideMission;
					break;
				case AssetsConst.SKILL_UP:
					cls = SkillUp;
					break;
				case AssetsConst.EIGHT_DIAGRAMS:
					cls = EightDiagrams;
					break;
				case AssetsConst.EIGHT_DIAGRAM_SUITS:
					cls = EightDiagramSuits;
					break;
				case AssetsConst.SHOP:
					cls = Shop;
					break;
				case AssetsConst.UPDATE_MESSAGE:
					cls = UpdateMessage;
					break;
				case AssetsConst.VIPINFO:
					cls = VipInfo;
					break;
				case AssetsConst.PK_EXP:
					cls = PkExp;
					break;
				case AssetsConst.FEEDBACK_MESSAGE:
					cls = FeedbackMessage;
					break;
				case AssetsConst.LEVEL_STORY:
					cls = LevelStory;
					break;
				case AssetsConst.FASHION:
					cls = Fashion;
					break;
				case AssetsConst.ACHIEVE:
					cls = Achieve;
					break;	
				case AssetsConst.VEHICLE_ESCORT:
					cls = VehicleEscort;
					break;
				case AssetsConst.PUBLICNOTICE:
					cls = PublicNotice;
					break;
				case AssetsConst.FASHION_CONFIGURATION:
					cls = FashionConfiguration;
					break;
				case AssetsConst.JINGMAI:
					cls = JingMai;
					break;
				case AssetsConst.SUMMER_CARNIVAL:
					cls = SummerCarnival;
					break;
				case AssetsConst.HEROUP:
					cls = HeroUp;
					break;
				case AssetsConst.CHARGE:
					cls = Charge;
					break;
				case AssetsConst.TITLE:
					cls = Title;
					break;
				case AssetsConst.FESTIVALS:
					cls = Festivals;
					break;
				default:
					cls = null;
					break;
			}
			return cls;
		}
		
		public function getObjectByProperty(type:String, property:String, input:*) : Object{
			if(!dict[type]){
				dict[type] = calculateJsonData(type);
			}
			var result:Object;
			for(var i:int = 0; i < dict[type].length; i++){
				if(dict[type][i][property] == input){
					result = dict[type][i];
				}
			}
			return result;
		}
		
		public function getSearchByProperty(type:String, property:String, input:*) : Array{
			var result:Array = new Array();
			if(!dict[type]){
				dict[type] = calculateJsonData(type);
			}
			for(var i:int = 0; i < dict[type].length; i++){
				if(dict[type][i][property] == input){
					result.push(dict[type][i]);
				}
			}
			return result;
		}
		
		public function getAllDataByLevel(id:int) : Array{
			var result:Array = new Array();
			if(!dict[AssetsConst.LEVEL]){
				dict[AssetsConst.LEVEL] = calculateJsonData(AssetsConst.LEVEL);
			}
			for(var i:int = 0; i < dict[AssetsConst.LEVEL].length; i++){
				if(int(dict[AssetsConst.LEVEL][i].level_id.split("_")[0]) == id){
					result.push(dict[AssetsConst.LEVEL][i]);
				}
			}
			return result;
		}
		
		public function getJsonData(type:String) : String{
			return jsonDict[type].data;
		}
		
	}
}