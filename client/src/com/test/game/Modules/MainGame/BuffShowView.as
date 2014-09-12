package com.test.game.Modules.MainGame
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.BuffConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.Extra.DoubleDungeonManager;
	import com.test.game.Modules.MainGame.Buff.WeatherSelectView;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class BuffShowView extends BaseView
	{
		public var buffList:Array = new Array();
		public var countList:Array = new Array();
		public var iconList:Array = new Array();
		public var buffLayer:Sprite;
		
		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function BuffShowView(){
			super();
		}
		
		override public function init() : void{
			super.init();
			layer = new Sprite();
			layer.x = 750;
			layer.y = 10;
			this.addChild(layer);
			buffLayer = new Sprite();
			layer.addChild(buffLayer);
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function setParams():void{
			update();
		}
		
		override public function update() : void{
			clear();
			updateBuffInfo();
			updateBuffShow();
		}
		
		private function updateBuffShow():void{
			for(var i:int = 0; i < buffList.length; i++){
				var newBne:BaseNativeEntity = new BaseNativeEntity();
				newBne.data.bitmapData = AUtils.getNewObj(buffList[i]) as BitmapData;
				newBne.x = -int(i / 3) * 35;
				newBne.y = int(i % 3) * 35;
				buffLayer.addChild(newBne);
				iconList.push(newBne);
				if(buffList[i] == BuffConst.AUTO_FIGHT_BUFF
					|| buffList[i] == BuffConst.RP_CARD_BUFF
					|| buffList[i] == BuffConst.DOUBLE_CARD_BUFF
					|| buffList[i] == BuffConst.WEATHER_SELECT_BUFF){
					var count:Sprite = AUtils.getNewObj("CountCircle") as Sprite;
					count.x = -int(i / 3) * 35 + 15;
					count.y = int(i % 3) * 35;
					switch(buffList[i]){
						case BuffConst.AUTO_FIGHT_BUFF:
							(count["Count"] as TextField).text = player.autoFightInfo.autoFightCount.toString();
							break;
						case BuffConst.RP_CARD_BUFF:
							(count["Count"] as TextField).text = player.autoFightInfo.rpCardCount.toString();
							break;
						case BuffConst.DOUBLE_CARD_BUFF:
							(count["Count"] as TextField).text = player.autoFightInfo.doubleCardCount.toString();
							break;
						case BuffConst.WEATHER_SELECT_BUFF:
							(count["Count"] as TextField).text = PackManager.getIns().searchItemNum(NumberConst.getIns().weatherSelectID).toString();
							break;
					}
					buffLayer.addChild(count);
					countList.push(count);
				}
				switch(buffList[i]){
					case BuffConst.SUMMER_BUFF:
						TipsManager.getIns().addTips(newBne, {title:"最后的狂欢", tips:"少侠们最后的狂欢！获得BUFF期间释放技能不消耗元气，所有技能的冷却时间减半。（此BUFF会覆盖掉“老朽的祝福”）"});
						break;
					case BuffConst.PROTECT_BUFF:
						TipsManager.getIns().addTips(newBne, {title:"老朽的祝福", tips:"初出江湖的少侠们可以获得此BUFF，使用技能不消耗元气，所有技能冷却时间减半。（此效果一直持续到15级）"});
						break;
					case BuffConst.AUTO_FIGHT_BUFF:
						if(GameSceneManager.getIns().partnerOperate){
							GreyEffect.change(newBne);
							GreyEffect.change(count);
							TipsManager.getIns().addTips(newBne, {title:"高手卡", tips:"双人模式下无法使用高手卡"});
						}
						break;
					case BuffConst.WEATHER_SELECT_BUFF:
						TipsManager.getIns().addTips(newBne, {title:"天气控制器", tips:"晴天时点击该图标可使用天气控制器！"});
						newBne.buttonMode = true;
						newBne.addEventListener(MouseEvent.CLICK, useWeatherSelect);
						break;
				}
			}
		}
		
		private function useWeatherSelect(e:MouseEvent) : void{
			ViewFactory.getIns().initView(WeatherSelectView).show();
		}
		
		private function updateBuffInfo():void{
			updateDoubleInfo();
			updateDailyInfo();
			updateAutoFightInfo();
			updateRPCardInfo();
			updateDoubleCardInfo();
			updateProtectInfo();
			updateWeatherSelectInfo();
			updateSummerInfo();
			//updateChildrenDayInfo();
		}
		
		private function updateWeatherSelectInfo() : void{
			var index:int = buffList.indexOf(BuffConst.WEATHER_SELECT_BUFF);
			if(PackManager.getIns().searchItemNum(NumberConst.getIns().weatherSelectID) > NumberConst.getIns().zero){
				if(index == -1){
					buffList.push(BuffConst.WEATHER_SELECT_BUFF);
				}
			}else{
				if(index != -1){
					buffList.splice(index, 1);
				}
			}
		}
		
		private function updateProtectInfo():void{
			var index:int = buffList.indexOf(BuffConst.PROTECT_BUFF);
			if(PlayerManager.getIns().protectedType == NumberConst.getIns().two){
				if(index == -1){
					buffList.push(BuffConst.PROTECT_BUFF);
				}
			}else{
				if(index != -1){
					buffList.splice(index, 1);
				}
			}
		}
		
		private function updateSummerInfo() : void{
			var index:int = buffList.indexOf(BuffConst.SUMMER_BUFF);
			if(PlayerManager.getIns().protectedType == NumberConst.getIns().one){
				if(index == -1){
					buffList.push(BuffConst.SUMMER_BUFF);
				}
			}else{
				if(index != -1){
					buffList.splice(index, 1);
				}
			}
		}
		
		private function updateChildrenDayInfo():void{
			var index:int = buffList.indexOf(BuffConst.CHILDREN_DAY_BUFF);
			if(TimeManager.getIns().checkEveryDayPlay(NumberConst.getIns().childrenDay)){
				if(index == -1){
					buffList.push(BuffConst.CHILDREN_DAY_BUFF);
				}
			}else{
				if(index != -1){
					buffList.splice(index, 1);
				}
			}
		}
		
		private function updateDoubleCardInfo():void{
			var index:int = buffList.indexOf(BuffConst.DOUBLE_CARD_BUFF);
			if(player.autoFightInfo.doubleCardCount > 0){
				if(index == -1){
					buffList.push(BuffConst.DOUBLE_CARD_BUFF);
				}
			}else{
				if(index != -1){
					buffList.splice(index, 1);
				}
			}
		}
		
		private function updateRPCardInfo():void{
			var index:int = buffList.indexOf(BuffConst.RP_CARD_BUFF);
			if(player.autoFightInfo.rpCardCount > 0){
				if(index == -1){
					buffList.push(BuffConst.RP_CARD_BUFF);
				}
			}else{
				if(index != -1){
					buffList.splice(index, 1);
				}
			}
		}
		
		private function updateAutoFightInfo():void{
			var index:int = buffList.indexOf(BuffConst.AUTO_FIGHT_BUFF);
			if(player.autoFightInfo.autoFightCount > 0){
				if(index == -1){
					buffList.push(BuffConst.AUTO_FIGHT_BUFF);
				}
			}else{
				if(index != -1){
					buffList.splice(index, 1);
				}
			}
		}
		
		private function updateDailyInfo():void{
			if(DailyMissionManager.getIns().isDailyMissionStart){
				if(player.dailyMissionVo.isComplete == false){
					var arr:Array = player.dailyMissionVo.missionDungeon.split("_");
					var name:String = arr[0] + "_" + arr[1];
					var index:int = buffList.indexOf(BuffConst.DAILY_BUFF);
					if(LevelManager.getIns().nowIndex == name
						&& LevelManager.getIns().mapType == (arr.length==3?1:0)){
						if(index == -1){
							buffList.push(BuffConst.DAILY_BUFF);
						}
					}else{
						if(index != -1){
							buffList.splice(index, 1);
						}
					}
				}
			}
		}
		
		//双倍副本
		private function updateDoubleInfo() : void{
			var index:int = buffList.indexOf(BuffConst.DOUBLE_BUFF);
			if(DoubleDungeonManager.getIns().startDouble){
				if(index == -1){
					buffList.push(BuffConst.DOUBLE_BUFF);
				}
			}else{
				if(index != -1){
					buffList.splice(index, 1);
				}
			}
		}
		
		private function clear() : void{
			for(var i:int = 0; i < buffList.length; i++){
				if(buffList[i] == BuffConst.PROTECT_BUFF
					|| buffList[i] == BuffConst.AUTO_FIGHT_BUFF){
					TipsManager.getIns().removeTips(iconList[i]);
				}else if(buffList[i] == BuffConst.WEATHER_SELECT_BUFF){
					iconList[i].removeEventListener(MouseEvent.CLICK, useWeatherSelect);
				}
				(iconList[i] as BaseNativeEntity).destroy();
				iconList[i] = null;
			}
			iconList.length = 0;
			for(var j:int = 0; j < countList.length; j++){
				if(countList[j] != null){
					if(countList[j].parent != null){
						countList[j].parent.removeChild(countList[j]);
					}
					countList[j] = null;
				}
			}
			countList.length = 0;
			buffList.length = 0;
		}
		
		override public function destroy():void{
			clear();
			super.destroy();
		}
	}
}