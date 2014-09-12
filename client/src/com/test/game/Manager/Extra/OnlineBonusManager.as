package com.test.game.Manager.Extra
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.utils.getTimer;
	
	public class OnlineBonusManager extends Singleton{
		private var _anti:Antiwear;
		private var _onlineDate:Date;
		private function get startOnline() : Boolean{
			return _anti["startOnline"];
		}
		private function set startOnline(value:Boolean) : void{
			_anti["startOnline"] = value;
		}
		private function get onlineInfo() : Array{
			return _anti["onlineInfo"]
		}
		private function set onlineInfo(value:Array) : void{
			_anti["onlineInfo"] = value;
		}
		
		public function OnlineBonusManager(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["onlineInfo"] = [];
			
			init();
		}
		
		private function get extraBar() : ExtraBar{
			if(ViewFactory.getIns().getView(ExtraBar) != null){
				return ViewFactory.getIns().getView(ExtraBar) as ExtraBar;
			}
			return null;
		}
		
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public static function getIns():OnlineBonusManager{
			return Singleton.getIns(OnlineBonusManager);
		}
		
		public function init() : void{
			onlineInfo = ConfigurationManager.getIns().getAllData(AssetsConst.ONLINE_BONUS);
		}
		
		public function updateOnlineBonus() : void{
			var time:String = player.onlineBonusVo.onlineTime;
			if(time != ""){
				var differ:Number = TimeManager.getIns().compareTime(time, TimeManager.getIns().returnTimeNowStr());
				if(player.onlineBonusVo.lv < onlineInfo.length){
					if(differ < onlineInfo[player.onlineBonusVo.lv].time * NumberConst.getIns().timeMinute * 1000){
						_onlineDate = new Date(2000, 0, 1, 0, 0, 0);
						_onlineDate.time += (onlineInfo[player.onlineBonusVo.lv].time * NumberConst.getIns().timeMinute * 1000 - differ);
						_preTime = getTimer();
						startOnline = true;
					}else{
						startOnline = false;
					}
				}
			}
		}
		
		public function get onlineBonusStatus() : int{
			var result:int = 1;
			if(startOnline){
				result = 2;
			}
			if(player.onlineBonusVo.lv >= onlineInfo.length){
				result = 3;
			}
			return result;
		}
		
		public function getOnlineReward() : void{
			if(getOnlineBonus()){
				var result:Number = TimeManager.getIns().disDayNum(TimeManager.getIns().returnTimeNowStr(), player.onlineBonusVo.onlineTime);
				if(result != 0 && player.onlineBonusVo.lv > 0){
					player.onlineBonusVo.onlineTime = TimeManager.getIns().returnTimeNowStr();
					player.onlineBonusVo.lv = 0;
					startOnline = false;
					extraBar.completeOnlineTime();
					TimeManager.getIns().reqTime();
				}else{
					player.onlineBonusVo.onlineTime = TimeManager.getIns().returnTimeNowStr();
					player.onlineBonusVo.lv++;
					if(player.onlineBonusVo.lv < 8){
						_onlineDate = new Date(2000, 0, 1, 0, 0, 0);
						_onlineDate.time += onlineInfo[player.onlineBonusVo.lv].time * NumberConst.getIns().timeMinute * 1000;
						_preTime = getTimer();
						startOnline = true;
					}else{
						extraBar.completeOnlineTime();
					}
				}
				SaveManager.getIns().onSaveGame();
			}
		}
		
		private var _preTime:Number;
		private var _calculateTime:Number;
		public function step() : void{
			if(startOnline){
				_calculateTime = (getTimer() - _preTime);
				if(_calculateTime > 1000){
					_calculateTime = 0;
				}
				_onlineDate.time -= _calculateTime;
				_preTime = getTimer();
				if(extraBar != null){
					extraBar.updateOnlineTime(_onlineDate.hours, _onlineDate.minutes, _onlineDate.seconds);
				}
				if(_onlineDate.hours == 0
					&& _onlineDate.minutes == 0
					&& _onlineDate.seconds == 0){
					startOnline = false;
					if(extraBar != null){
						extraBar.update();
					}
				}
			}
		}
		
		private function get playerLv() : int{
			var result:int = 0;
			if(player.character.lv < NumberConst.getIns().thirty){
				result = NumberConst.getIns().zero;
			}else if(player.character.lv < NumberConst.getIns().fifty){
				result = NumberConst.getIns().one;
			}else if(player.character.lv < NumberConst.getIns().seventy){
				result = NumberConst.getIns().two;
			}else if(player.character.lv < NumberConst.getIns().ninety){
				result = NumberConst.getIns().three;
			}
			return result;
		}
		
		private function getOnlineBonus():Boolean{
			var result:Boolean = true;
			var onlineBonus:Object = onlineInfo[player.onlineBonusVo.lv];
			var items:Array = [onlineBonus.prop_id.split("|")[playerLv]];
			var itemNums:Array = onlineBonus.number.split("|");
			var itemVos:Array = new Array();
			if(items[0] != 0){
				for(var index:int = 0; index < items.length; index++){
					var item:ItemVo = PackManager.getIns().creatItem(items[index]);
					item.num = itemNums[index];
					itemVos.push(item);
				}
			}

			if(PackManager.getIns().checkMaxRooM(itemVos)){
				var message:Array = [];
				for(var i:int = 0; i < items.length; i++){
					if(items[i] == 0) continue;
					itemVos[i].mid = PackManager.getIns().firstEmptyMid;
					PackManager.getIns().addItemIntoPack(itemVos[i]);
					message.push(itemVos[i].name + "X" + itemVos[i].num);
				}
				
				if(onlineBonus.gold > 0){
					PlayerManager.getIns().checkAdd("ol_money", onlineBonus.gold, 10000);
					PlayerManager.getIns().addMoney(onlineBonus.gold);
					message.push("金钱X" + onlineBonus.gold);
				}
				if(onlineBonus.soul > 0){
					PlayerManager.getIns().checkAdd("ol_soul", onlineBonus.soul, 10000);
					PlayerManager.getIns().addSoul(onlineBonus.soul);
					message.push("战魂X" + onlineBonus.soul);
				}
				
				ViewFactory.getIns().getView(MainToolBar).update();
				
				GuideManager.getIns().bagGuideSetting();
				DeformTipManager.getIns().allCheck();
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"在线奖励获得\n"+ getMessageStr(message),function () : void{GuideManager.getIns().bagGuideSetting();});
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"背包空间不足！\n请留出空间后再使用");
				result = false;
			}
			return result;
		}
		
		private function getMessageStr(message:Array) : String{
			var result:String = "";
			for(var i:int = 0; i < message.length; i++){
				if(i != 0) result += "\n";
				result += message[i];
			}
			return result;
		}
		
		public function clear() : void{
			startOnline = false;
		}
	}
}