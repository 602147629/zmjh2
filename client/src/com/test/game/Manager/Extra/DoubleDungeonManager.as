package com.test.game.Manager.Extra
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Modules.MainGame.DoubleDungeonView;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.utils.getTimer;
	
	public class DoubleDungeonManager extends Singleton{
		private var _anti:Antiwear;
		private var _preTime:Number;
		public var nowInfo:Object;
		public var _doubleDate:Date;
		public function get doubleDate() : Date{
			return _doubleDate;
		}
		public function set doubleDate(value:Date) : void{
			_doubleDate = value;
		}
		public function get duration() : Number{
			return _anti["duration"];
		}
		public function set duration(value:Number) : void{
			_anti["duration"] = value;
		}
		public function get startDouble() : Boolean{
			return _anti["startDouble"];
		}
		public function set startDouble(value:Boolean) : void{
			_anti["startDouble"] = value;
		}
		
		public function DoubleDungeonManager(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["duration"] = 1;
			_anti["startDouble"] = false;
		}
		
		public static function getIns():DoubleDungeonManager{
			return Singleton.getIns(DoubleDungeonManager);
		}
		
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		private function get doubleDungeonView() : DoubleDungeonView{
			if(ViewFactory.getIns().getView(DoubleDungeonView) != null){
				return ViewFactory.getIns().getView(DoubleDungeonView) as DoubleDungeonView;
			}
			return null;
		}
		
		private function get extraBar() : ExtraBar{
			if(ViewFactory.getIns().getView(ExtraBar) != null){
				return ViewFactory.getIns().getView(ExtraBar) as ExtraBar;
			}
			return null;
		}
		
		public function setDoubleDuration() : void{
			/*if(ShopManager.getIns().vipLv >= NumberConst.getIns().three){
				duration = NumberConst.getIns().two;
			}else{
				duration = NumberConst.getIns().one;
			}*/
			duration = NumberConst.getIns().one;
			player.doubleDungeonVo.judgeDoubleDungeon();
			if(!GameConst.localData){
				(ViewFactory.getIns().getView(ExtraBar) as ExtraBar).doubleUpdate();
			}
		}
		
		public function startDoubleTime() : void{
			ViewFactory.getIns().getView(DoubleDungeonView).layer.mouseChildren = false;
			SaveManager.getIns().onSaveGame(
				function () : void{
					player.doubleDungeonVo.doubleTime = TimeManager.getIns().returnTimeNowStr();
					player.doubleDungeonVo.dungeonName = PlayerManager.getIns().getRandomDungeonName();
					doubleDate = new Date(2000, 0, 1, 0, 0, 0);
					doubleDate.time += (duration * NumberConst.getIns().timeMinute * NumberConst.getIns().timeMinute * 1000);
					_preTime = getTimer();
					startDouble = true;
				},
				function () : void{
					resetDoubleDungeonInfo();
					(ViewFactory.getIns().getView(DoubleDungeonView) as DoubleDungeonView).updateTimeStatus();
					(ViewFactory.getIns().getView(ExtraBar) as ExtraBar).doubleUpdate();
					ViewFactory.getIns().getView(DoubleDungeonView).layer.mouseChildren = true;
					(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).update();
				});
		}
		
		public function get nowUseGold() : int{
			return ConfigurationManager.getIns().getObjectByProperty(AssetsConst.PLAYER, "lv", player.character.lv).dailygold * 3;
		}
		
		public function resetDoubleDungeonJudge() : void{
			if(player.money >= ConfigurationManager.getIns().getObjectByProperty(AssetsConst.PLAYER, "lv", player.character.lv).dailygold * 3){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice("是否花费" + 
					ConfigurationManager.getIns().getObjectByProperty(AssetsConst.PLAYER, "lv", player.character.lv).dailygold * 3
					+ "金币重置双倍副本？",confirmResetDungeon);
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("金钱不足！");
			}
		}
		
		public function confirmResetDungeon() : void{
			player.doubleDungeonVo.dungeonName = PlayerManager.getIns().getDoubleDungeonName();
			resetDoubleDungeonInfo();
			doubleDungeonView.addChangerEffect();
			player.money -= ConfigurationManager.getIns().getObjectByProperty(AssetsConst.PLAYER, "lv", player.character.lv).dailygold * 3;
			(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).update();
		}
		
		public function resetDoubleDungeonInfo() : void{
			var name:String = player.doubleDungeonVo.dungeonName;
			var arr:Array = name.split("_");
			if(arr.length == 3){
				nowInfo = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.ELITE, "level_id", arr[0] + "_" + arr[1]);
			}else{
				nowInfo = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.LEVEL, "level_id", name);
			}
			if(doubleDungeonView != null){
				doubleDungeonView.update();
			}
		}
		
		public function updateDoubleTime() : void{
			var time:String = player.doubleDungeonVo.doubleTime;
			if(time != ""){
				var differ:Number = TimeManager.getIns().compareTime(time, TimeManager.getIns().returnTimeNowStr());
				if(differ < duration * NumberConst.getIns().timeMinute * NumberConst.getIns().timeMinute * 1000){
					doubleDate = new Date(2000, 0, 1, 0, 0, 0);
					doubleDate.time += (duration * NumberConst.getIns().timeMinute * NumberConst.getIns().timeMinute * 1000 - differ);
					_preTime = getTimer();
					startDouble = true;
				}else{
					startDouble = false;
				}
			}
			resetDoubleDungeonInfo();
		}
		
		public function get doubleStatus() : int{
			var result:int = 1;
			var time:String = player.doubleDungeonVo.doubleTime;
			if(time == ""){
				result = 1;
			}else{
				var differ:Number = TimeManager.getIns().compareTime(time, TimeManager.getIns().returnTimeNowStr());
				if(differ < (duration * NumberConst.getIns().timeMinute * NumberConst.getIns().timeMinute - 1) * 1000){
					result = 2;
				}else{
					result = 3;
				}
			}
			return result;
		}
		
		public function get isInDoubleDungeon() : Boolean{
			var result:Boolean = false;
			if(startDouble){
				/*var arr:Array = player.doubleDungeonVo.dungeonName.split("_");
				if(LevelManager.getIns().mapType == (arr.length == 3?1:0)
					&& (arr[0] + "_" + arr[1]) == LevelManager.getIns().levelData.level_id){
					result = true;
				}*/
				result = true;
			}
			
			return result;
		}
		
		private var _calculateTime:Number;
		public function step() : void{
			if(startDouble){
				_calculateTime = (getTimer() - _preTime);
				if(_calculateTime > 1000){
					_calculateTime = 0;
				}
				doubleDate.time -= _calculateTime;
				_preTime = getTimer();
				if(doubleDungeonView != null && !doubleDungeonView.isClose){
					doubleDungeonView.setTime(doubleDate.hours, doubleDate.minutes, doubleDate.seconds);
				}
				if(extraBar != null){
					extraBar.updateDoubleTime(doubleDate.hours, doubleDate.minutes, doubleDate.seconds);
				}
				if(doubleDate.hours == 0
					&& doubleDate.minutes == 0
					&& doubleDate.seconds == 0){
					startDouble = false;
					if(doubleDungeonView != null){
						doubleDungeonView.update();
					}
					if(extraBar != null){
						extraBar.doubleUpdate();
					}
				}
			}
		}
		
		public function clear() : void{
			startDouble = false;
			if(ViewFactory.getIns().getView(DoubleDungeonView) != null){
				(ViewFactory.getIns().getView(DoubleDungeonView) as DoubleDungeonView).clear();
			}
		}
	}
}