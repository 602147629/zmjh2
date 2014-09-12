package com.test.game.Manager
{
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.View.Map.MemCpuView;
	import com.test.game.Const.DebugConst;
	import com.test.game.Manager.Gift.SummerRechargeManager;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.MainUI.TreasureToolBar;
	import com.test.game.Mvc.Vo.ItemVo;
	
	public class DebugManager extends Singleton
	{
		private var _saveData:Object;
		public function get saveData() : Object{
			return _saveData;
		}
		public function set saveData(value:Object) : void{
			_saveData = value;
		}
		
		public static function getIns():DebugManager{
			return Singleton.getIns(DebugManager);
		}
		
		public function init() : void{
			_saveData = new Object();
			DebugArea.getIns().init(GameConst.stage, analysis);
		}
		
		private function analysis(params:Array) : void{
			if(GameConst.useDebug){
				var type:String = params.shift();
				switch(type){
					case DebugConst.ADD:
						addItem(params);
						break;
					case DebugConst.MONEY:
						addMoney(params);
						break;
					case DebugConst.SOUL:
						addSoul(params);
						break;
					case DebugConst.EXP:
						addExp(params);
						break;
					case DebugConst.CONFIG:
						config(params);
						break;
					case DebugConst.MISSION:
						addMission(params);
						break;
					case DebugConst.SIGN:
						addSign(params);
						break;
					case DebugConst.WEATHER:
						changeWeather(params);
						break;
					case DebugConst.AUTOFIGHT:
						autoFight(params);
						break;
					case DebugConst.BAGUA:
						baGua(params);
						break;
					case DebugConst.BAGUAPAI:
						baGuaPai(params);
						break;
					case DebugConst.FASHION:
						fashion(params);
						break;
					case DebugConst.RECHARGE:
						recharge(params);
						break;
					case DebugConst.HERO:
						hero(params);
						break;
					case DebugConst.RESET_WEATHER_RATE:
						resetRate(params);
						break;
					case DebugConst.TITLE:
						getTitle(params);
						break;
				}
			}
		}
		
		private function getTitle(params:Array) : void{
			if(params.length > 0){
				TitleManager.getIns().addTitleById(7500 + int(params[0]));
			}else{
				DebugArea.getIns().showResult("参数错误", DebugConst.ERROR);
			}
		}
		
		private function resetRate(params:Array) : void{
			PlayerManager.getIns().player.statisticsInfo.weatherPropCount = 0;
			DebugArea.getIns().showResult("重新设置概率", DebugConst.NORMAL);
		}
		
		private function hero(params:Array) : void{
			if(params.length > 0){
				PlayerManager.getIns().player.heroScriptVo.heroFightNum += -params[0];
				DebugArea.getIns().showResult("设置列传挑战次数" + params[0], DebugConst.NORMAL);
			}else{
				DebugArea.getIns().showResult("参数错误", DebugConst.ERROR);
			}
		}
		
		private function recharge(params:Array) : void{
			if(params.length > 0){
				SummerRechargeManager.getIns().testRecharge = params[0];
				DebugArea.getIns().showResult("设置充值值" + params[0], DebugConst.NORMAL);
			}else{
				DebugArea.getIns().showResult("参数错误", DebugConst.ERROR);
			}
		}
		
		private function fashion(params:Array):void{
			if(PlayerManager.getIns().player.fashionInfo.fashionId == -1){
				PlayerManager.getIns().player.fashionInfo.fashionId = 1;
				DebugArea.getIns().showResult("当前为时装", DebugConst.NORMAL);
			}else if(PlayerManager.getIns().player.fashionInfo.fashionId == 1){
				PlayerManager.getIns().player.fashionInfo.fashionId = -1;
				DebugArea.getIns().showResult("当前为装备", DebugConst.NORMAL);
			}
		}
		
		private function baGuaPai(params:Array):void{
			if(params.length > 0){
				BaGuaManager.getIns().createBaGuaById(params[0]);
				DebugArea.getIns().showResult("增加八卦牌" + params[0], DebugConst.NORMAL);
			}else{
				DebugArea.getIns().showResult("参数错误", DebugConst.ERROR);
			}
		}
		
		private function baGua(params:Array):void{
			if(params.length > 0){
				PlayerManager.getIns().player.baGuaScore += int(params[0]);
				DebugArea.getIns().showResult("增加命格" + params[0], DebugConst.NORMAL);
			}else{
				DebugArea.getIns().showResult("参数错误", DebugConst.ERROR);
			}
		}
		
		private function autoFight(params:Array):void{
			if(params.length > 0){
				if(params[0] == 1){
					AutoFightManager.getIns().startAutoFight = true;
					DebugArea.getIns().showResult("开启自动战斗", DebugConst.NORMAL);
				}else if(params[0] == 2){
					AutoFightManager.getIns().startAutoFight = false;
					DebugArea.getIns().showResult("关闭自动战斗", DebugConst.NORMAL);
				}
			}
		}
		
		private function changeWeather(params:Array):void{
			if(params.length > 0){
				if(params[0] == 1){
					WeatherManager.getIns().blackStart();
					DebugArea.getIns().showResult("改变天气：黑夜", DebugConst.NORMAL);
				}else if(params[0] == 2){
					WeatherManager.getIns().rainStart();
					DebugArea.getIns().showResult("改变天气：雨天", DebugConst.NORMAL);
				}else if(params[0] == 3){
					WeatherManager.getIns().windStart();
					DebugArea.getIns().showResult("改变天气：大风", DebugConst.NORMAL);
				}else if(params[0] == 4){
					WeatherManager.getIns().thunderStart();
					DebugArea.getIns().showResult("改变天气：雷雨", DebugConst.NORMAL);
				}
			}
		}
		
		private function addSign(params:Array):void{
			if(params.length > 0){
				PlayerManager.getIns().player.signInVo.achievements += int(params[0]);
				DebugArea.getIns().showResult("增加签到成就" + params[0], DebugConst.NORMAL);
			}
		}
		
		private function addMission(params:Array):void{
			if(params.length > 0){
				if(params[0] == 1){
					PlayerManager.getIns().player.mainMissionVo.isComplete = true;
					DebugArea.getIns().showResult("主线任务完成", DebugConst.NORMAL);
				}else if(params[0] == 2){
					PlayerManager.getIns().player.dailyMissionVo.isComplete = true;
					DebugArea.getIns().showResult("奇遇任务完成", DebugConst.NORMAL);
				}else if(params[0] == 3){
					for(var i:int = 0; i < PlayerManager.getIns().player.hideMissionInfo.length; i++){
						PlayerManager.getIns().player.hideMissionInfo[i].isComplete = true;
					}
					DebugArea.getIns().showResult("异闻任务完成", DebugConst.NORMAL);
				}
			}
		}
		
		private function config(params:Array) : void{
			switch(params[0]){
				case "pk":
					/*if(ViewFactory.getIns().getView(TreasureToolBar) != null){
						(ViewFactory.getIns().getView(TreasureToolBar) as TreasureToolBar).addPlayerKilling();
						DebugArea.getIns().showResult("增加PK功能", DebugConst.NORMAL);
					}*/
					break;
				case "mem":
					ViewFactory.getIns().initView(MemCpuView).show();
					DebugArea.getIns().showResult("增加内存显示", DebugConst.NORMAL);
					break;
				case "hidemem":
					ViewFactory.getIns().initView(MemCpuView).hide();
					DebugArea.getIns().showResult("去除内存功能", DebugConst.NORMAL);
					break;
			}
		}
		
		private function addExp(params:Array):void{
			if(params.length > 0){
				PlayerManager.getIns().checkAdd("gm_exp",params[0],10*10000);
				PlayerManager.getIns().addExp(params[0]);
				DebugArea.getIns().showResult("增加经验" + params[0], DebugConst.NORMAL);
			}else{
				DebugArea.getIns().showResult("参数错误", DebugConst.ERROR);
			}
		}
		
		private function addSoul(params:Array):void{
			if(params.length > 0){
				PlayerManager.getIns().checkAdd("gm_soul",params[0],10000);
				PlayerManager.getIns().addSoul(params[0]);
				ViewFactory.getIns().getView(MainToolBar).update();
				DebugArea.getIns().showResult("增加战魂" + params[0], DebugConst.NORMAL);
			}else{
				DebugArea.getIns().showResult("参数错误", DebugConst.ERROR);
			}
		}
		
		private function addMoney(params:Array):void{
			if(params.length > 0){
				PlayerManager.getIns().checkAdd("gm_money",params[0],10000);
				PlayerManager.getIns().addMoney(params[0]);
				
				ViewFactory.getIns().getView(MainToolBar).update();
				DebugArea.getIns().showResult("增加金钱" + params[0], DebugConst.NORMAL);
			}else{
				DebugArea.getIns().showResult("参数错误", DebugConst.ERROR);
			}
		}
		
		private function addItem(params:Array) : void{
			if(params.length >= 2){
				var item:ItemVo = PackManager.getIns().creatItem(params[0]);
				if(item != null){
					item.num = params[1];
					if(params[0] > 500 && params[0] < 700){
						PlayerManager.getIns().addSkillUp(params[0], params[1]);
					}else{
						PackManager.getIns().addItemIntoPack(item);
					}
					DebugArea.getIns().showResult("增加" + item.name + item.num + "个", DebugConst.NORMAL);
				}else{
					DebugArea.getIns().showResult("参数错误", DebugConst.ERROR);
				}
			}else{
				DebugArea.getIns().showResult("参数错误", DebugConst.ERROR);
			}
		}
		
	}
}