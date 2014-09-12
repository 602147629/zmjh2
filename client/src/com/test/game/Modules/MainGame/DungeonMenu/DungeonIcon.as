package com.test.game.Modules.MainGame.DungeonMenu
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.Extra.DoubleDungeonManager;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Mvc.Configuration.MainMission;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.key.GoToBattleControl;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class DungeonIcon extends Sprite
	{
		private var _data:Object;
		private var _obj:MovieClip;
		
		public var index:String;
		
		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function DungeonIcon()
		{
			_obj = AssetsManager.getIns().getAssetObject("DungeonIcon") as MovieClip;
			this.addChild(_obj);
		}
		
		private function setRank(lv:int) : void{
			if(lv > 0){
				_obj.gotoAndStop(1);
				DungeonRank.visible = true;
				DungeonRank.gotoAndStop(6-lv);
				if(!this.hasEventListener(MouseEvent.CLICK)){
					this.addEventListener(MouseEvent.CLICK, enterBattle);
				}
			}else if(lv == 0){
				_obj.gotoAndStop(2);
				this.removeEventListener(MouseEvent.CLICK, enterBattle);
			}else if(lv == -1){
				_obj.gotoAndStop(1);
				DungeonRank.visible = false;
				if(!this.hasEventListener(MouseEvent.CLICK)){
					this.addEventListener(MouseEvent.CLICK, enterBattle);
				}
			}
		}
		
		public function setData(data:Object, lv:int):void{
			_data = data;
			setRank(lv);
			setName();
			setMission();
			setDouble();
			setDailyMission();
		}
		
		private function setDailyMission():void{
			if(_obj.currentFrame == 1){
				var arr:Array = player.dailyMissionVo.missionDungeon.split("_");
				var index:String = arr[0] + "_" + arr[1];
				if(arr.length == 3 
					|| !DailyMissionManager.getIns().isDailyMissionStart
					|| DailyMissionManager.getIns().isDailyMissionComplete){
					DailyMissionIcon.visible = false;
					DailyMissionIcon.stop();
				}else{
					if(_data.level_id == index){
						DailyMissionIcon.visible = true;
						DailyMissionIcon.play();
						MissionIcon.visible = false;
						MissionIcon.stop();
					}else{
						DailyMissionIcon.visible = false;
						DailyMissionIcon.stop();
					}
				}
			}
		}
		
		private function setMission():void{
			if(_obj.currentFrame == 1){
				var missionData:MainMission = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.MAIN_MISSION, "id", player.mainMissionVo.id) as MainMission;
				var arr:Array = missionData.mission_rules_level.split("_");
				if(arr.length == 3){
					MissionIcon.visible = false;
					MissionIcon.stop();
				}else{
					if(_data.level_id == missionData.mission_rules_level
						&& missionData.lv <= PlayerManager.getIns().player.character.lv){
						MissionIcon.visible = true;
						MissionIcon.play();
						LevelManager.getIns().guideIndex = _data.level_id.split("_")[1];
					}else{
						MissionIcon.visible = false;
						MissionIcon.stop();
					}
				}
			}
		}
		
		private function setDouble() : void{
			if(_obj.currentFrame == 1){
				//var arr:Array = player.doubleDungeonVo.dungeonName.split("_");
				//var index:String = arr[0] + "_" + arr[1];
				if(!DoubleDungeonManager.getIns().startDouble){
					DoubleIcon.visible = false;
					DoubleIcon.stop();
				}else{
					//if(_data.level_id == index){
						DoubleIcon.visible = true;
						DoubleIcon.play();
					//}else{
					//	DoubleIcon.visible = false;
					//	DoubleIcon.stop();
					//}
				}
			}
		}
		
		private function setName() : void{
			index = _data.level_id;
			if(_obj.currentFrame == 1){
				BattleName.text = _data.level_name;
				while(RoleHead.numChildren > 0){
					var bne:BaseNativeEntity = RoleHead.getChildAt(0) as BaseNativeEntity;
					bne.parent.removeChild(bne);
					bne.destroy();
					bne = null;
				}
				var bossHead:BaseNativeEntity = new BaseNativeEntity();
				bossHead.data.bitmapData = AUtils.getNewObj(_data.fodder + "_LittleHead") as BitmapData;
				bossHead.x = -bossHead.width / 5 + 15;
				RoleHead.addChild(bossHead);
				TipsManager.getIns().addTips(this,{title:ColorConst.setGold(_data.level_name), tips:_data.bonus});
			}else{
				BattleName.text = "？？？";
				var arr:Array = index.split("_");
				var preData:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.LEVEL, "level_id", arr[0] + "_" + (arr[1] - 1));
				var preTips:String = "请通关" + preData.level_name;
				TipsManager.getIns().addTips(this,{title:preTips, tips:""});
			}
		}
		
		private function enterBattle(e:MouseEvent):void{
			LevelManager.getIns().mapType = 0;
			GoToBattleControl(ControlFactory.getIns().getControl(GoToBattleControl)).goToBattle(_data);
			(ViewFactory.getIns().getView(DungeonMenu) as DungeonMenu).hide();
			((ViewFactory.getIns().initView(MainToolBar) as MainToolBar) as MainToolBar).destroyGuide();
		}
		
		private function get DungeonRank():MovieClip{
			return _obj["DungeonRank"];
		}
		
		private function get BattleName():TextField{
			return _obj["BattleName"];
		}
		
		private function get RoleHead():Sprite{
			return _obj["RoleHead"];
		}
		
		private function get MissionIcon():MovieClip{
			return _obj["Mission"];
		}
		
		private function get DoubleIcon() : MovieClip{
			return _obj["Double"];
		}
		
		private function get DailyMissionIcon() : MovieClip{
			return _obj["DailyMission"];
		}
		
		
		public function destroy() : void{
			if(RoleHead != null){
				while(RoleHead.numChildren > 0){
					var bne:BaseNativeEntity = RoleHead.getChildAt(0) as BaseNativeEntity;
					bne.parent.removeChild(bne);
					bne.destroy();
					bne = null;
				}
			}
			_data = null;
			if(_obj != null){
				if(_obj.parent != null){
					_obj.parent.removeChild(_obj);
				}
				_obj = null;
			}
			this.removeEventListener(MouseEvent.CLICK, enterBattle);
		}
	}
}