package com.test.game.Manager.Activity
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.Map.ItemIconEntity;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DigitalManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Manager.TitleManager;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Configuration.Festivals;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class MidAutumnManager extends Singleton
	{
		private var _anti:Antiwear;
		public function get moonCakeIndex() : int{
			return _anti["moonCakeIndex"];
		}
		public function set moonCakeIndex(value:int) : void{
			_anti["moonCakeIndex"] = value;
		}
		public function get hasTuZi() : Boolean{
			return _anti["hasTuZi"];
		}
		public function set hasTuZi(value:Boolean) : void{
			_anti["hasTuZi"] = value;
		}
		public function get alreadyAppear() : Boolean{
			return _anti["alreadyAppear"];
		}
		public function set alreadyAppear(value:Boolean) : void{
			_anti["alreadyAppear"] = value;
		}
		private var _festivals:Array = new Array();
		private var _bar:Array = [23,60,60,60,60,60];
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public static function getIns():MidAutumnManager{
			return Singleton.getIns(MidAutumnManager);
		}
		
		public function MidAutumnManager()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["moonCakeIndex"] = 0;
			_anti["hasTuZi"] = false;
			
			_festivals = ConfigurationManager.getIns().getAllData(AssetsConst.FESTIVALS);
		}
		
		public function init() : void{
			var zhongQiu:int = TimeManager.getIns().disDayNum(NumberConst.getIns().moonCakeGiftDate, TimeManager.getIns().returnTimeNowStr().split(" ")[0]);
			if(zhongQiu <= 0 && zhongQiu >= -NumberConst.getIns().moonCakeDay){
				hasTuZi = true;
			}else{
				hasTuZi = false;
			}
			alreadyAppear = false;
		}
		
		public function calculateIndex() : Array{
			moonCakeIndex = 0;
			var result:Array = new Array(6);
			for(var i:int = 1; i <= 6; i++){
				if(player.midAutumnInfo.moonCakeCount >= _festivals[i - 1].number){
					moonCakeIndex = i;
					if(player.midAutumnInfo.alreadyGet[i - 1] == NumberConst.getIns().one){
						result[i - 1] = NumberConst.getIns().zero;
					}else{
						result[i - 1] = NumberConst.getIns().one;
					}
				}else{
					result[i - 1] = NumberConst.getIns().zero;
				}
			}
			return result;
		}
		
		public function get barLen() : int{
			var result:int;
			var len:int = 0;
			for(var j:int = 0; j < moonCakeIndex; j++){
				len += _bar[j];
			}
			if(moonCakeIndex == 0){
				result = player.midAutumnInfo.moonCakeCount/_festivals[0].number * _bar[0];
			}else if(moonCakeIndex < 6){
				result = len + (player.midAutumnInfo.moonCakeCount - _festivals[moonCakeIndex - 1].number)/(_festivals[moonCakeIndex].number - _festivals[moonCakeIndex - 1].number) * _bar[moonCakeIndex];
			}else if(moonCakeIndex == 6){
				result = 346;
			}
			return result;
		}
		
		public function getGift(index:int) : void{
			onGetReward(index - 1);
		}
		
		public function onGetReward(index:int) : void{
			var nowInfo:Festivals = _festivals[index];
			var items:Array = checkRoom(nowInfo);
			var message:String = "";
			if(items != null){
				for(var i:int = 0; i < items.length; i++){
					PackManager.getIns().addItemIntoPack(items[i]);
					message += "\n" + (items[i] as ItemVo).name + "X" + (items[i] as ItemVo).num;
				}
			}else{
				return;
			}
			if(nowInfo.gold != NumberConst.getIns().zero){
				PlayerManager.getIns().addMoney(nowInfo.gold);
				message += "\n金钱X" + nowInfo.gold;
			}
			if(nowInfo.soul != NumberConst.getIns().zero){
				PlayerManager.getIns().addSoul(nowInfo.soul);
				message += "\n战魂X" + nowInfo.soul;
			}
			if(nowInfo.title != NumberConst.getIns().zero){
				TitleManager.getIns().addTitleById(nowInfo.title);
			}
			var arr:Array = player.midAutumnInfo.alreadyGet;
			arr[index] = NumberConst.getIns().one;
			player.midAutumnInfo.alreadyGet = arr;
			(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("恭喜您获得"+ message);
			ViewFactory.getIns().getView(MainToolBar).update();
		}
		
		private function checkRoom(nowInfo:Festivals) : Array{
			var propID:Array = new Array();
			var propNum:Array = new Array();
			var items:Array = new Array();
			propID = nowInfo.prop_id.split("|");
			propNum = nowInfo.prop_number.split("|");
			for(var i:int; i < propID.length; i++){
				if(int(propID[i]) >= 10000 && int(propID[i]) < 12000){
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
				return items;
			}
		}
		
		private var _stepTime:int;
		public function step() : void{
			if(!hasTuZi || alreadyAppear) return;
			_stepTime++;
			if(_stepTime == 30){
				_stepTime = 0;
				var random:Number = Math.random();
				if(random < NumberConst.getIns().micrometer4 * Math.pow(NumberConst.getIns().percent93, player.statisticsInfo.midAutumnCount)){
					DebugArea.getIns().showInfo((NumberConst.getIns().micrometer4 * Math.pow(NumberConst.getIns().percent93, player.statisticsInfo.midAutumnCount)).toString());
					var result:Boolean = LevelManager.getIns().createTuZi(1023 + int(Math.random() * 2));
					if(result){
						player.statisticsInfo.midAutumnCount++;
						alreadyAppear = true;
					}
				}
			}
		}
		
		public function addTuZiItem(monster:MonsterEntity) : void{
			var itemVo:ItemVo = PackManager.getIns().creatItem(NumberConst.getIns().moonCakeId);
			itemVo.num = NumberConst.getIns().one;
			PackManager.getIns().addItemIntoPack(itemVo);
			var iie:ItemIconEntity = new ItemIconEntity(itemVo.type + itemVo.id, itemVo.name, monster.bodyPos, DigitalManager.getIns().getOneStauts());
			SceneManager.getIns().nowScene.addChild(iie);
		}
	}
}