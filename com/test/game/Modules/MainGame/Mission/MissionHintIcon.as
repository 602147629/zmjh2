package com.test.game.Modules.MainGame.Mission
{
	import com.greensock.TweenMax;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.DebugConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Modules.MainGame.BagView;
	import com.test.game.Modules.MainGame.Role.RoleDetailView;
	import com.test.game.Modules.MainGame.Strengthen.StrengthenView;
	import com.test.game.Mvc.Vo.HideMissionVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class MissionHintIcon extends BaseSprite
	{
		public function MissionHintIcon()
		{
			this.mouseChildren = false;
			this.buttonMode = true;
			super();
		}
		
		private var _dailyMissionMcHide:Boolean;
		
		public var index:int;
		
		private var _obj:Sprite;
		
		private var _curMissionData:Object;
		
		private var _isComplete:Boolean;
		
		private var _curMissionId:int;
		
		
		public function setData(id:*):void{
			
			 
			
			if(id==0){
				this.visible = false;
				return;
			}
			
			this.visible = true;
			_curMissionId = id;
			
			
			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("MissionHintIcon") as Sprite;
				this.addChild(_obj);
			}
			
			dailyMissionOpen.visible = false;
			
			switch(int(id/1000)){
				case 1:
					_curMissionData = ConfigurationManager.getIns().getObjectByID(AssetsConst.MAIN_MISSION,id);
					renderMainMission();
					break;
				case 2:
					if(id == 2000){
						renderWaitDailyMission();
					}else{
						_curMissionData = ConfigurationManager.getIns().getObjectByID(AssetsConst.DAILY_MISSION,id);
						renderDailyMission();
						if(_dailyMissionMcHide == false){
							dailyMissionOpen.visible = true;
						}
					}

					break;
				case 3:
					_curMissionData = ConfigurationManager.getIns().getObjectByID(AssetsConst.HIDE_MISSION,id);
					renderHideMission();
			}
		
			initEvent();
		}
		
		private function renderHideMission():void
		{
			missionType.gotoAndStop("hide");
			missionName.text = _curMissionData.mission_name+"("+_curMissionData.lv.toString()+"级)";;
			
			if(_curMissionData.newFunction!="0"){
				newFunctionTxt.visible = true;
				newFunctionMc.visible = true;
				try{
					newFunctionMc.gotoAndStop(_curMissionData.newFunction);
				}catch(e:Error){
					DebugArea.getIns().showInfo("---没有当前的帧标签："+ _curMissionData.newFunction +"---", DebugConst.ERROR);
				}
			}else{
				newFunctionTxt.visible = false;
				newFunctionMc.visible = false;
			}
			
			//missionName.textColor = ColorConst.orange;
			//missionState.textColor = ColorConst.green;
			for each(var hiedeVo:HideMissionVo in player.hideMissionInfo){
				if(hiedeVo.id == _curMissionId){
					if(hiedeVo.isComplete){
						completeIcon.gotoAndStop("complete");
					}else{
						completeIcon.gotoAndStop("none");
					}
				}
			}
		}
		
		private function renderDailyMission():void
		{
			missionType.gotoAndStop("daily");
			newFunctionTxt.visible = false;
			newFunctionMc.visible = false;
			
			var dungeonData:Object;
			var dungeonId:String = player.dailyMissionVo.missionDungeon;
			var arr:Array = dungeonId.split("_");
			if(arr.length == 3){
				dungeonData = ConfigurationManager.getIns().getObjectByProperty(
					AssetsConst.ELITE, "level_id", arr[0]+"_"+arr[1]);
			}else{
				dungeonData = ConfigurationManager.getIns().getObjectByProperty(
					AssetsConst.LEVEL, "level_id", dungeonId);
			}
			
			var dungeonName:String = dungeonData.level_name;
			var bossName:String  = dungeonData.boss_name;
			
			if(_curMissionId == 2004){
				missionName.text = _curMissionData.mission_name.replace("[1]",bossName);
			}else{
				missionName.text = _curMissionData.mission_name.replace("[1]",dungeonName);
			}
			
			
			//missionName.textColor = ColorConst.orange;
			//missionState.textColor  = ColorConst.green;
			if(player.dailyMissionVo.isComplete){
				completeIcon.gotoAndStop("complete");
			}else{
				completeIcon.gotoAndStop("none");
			}
		}
		
		private function renderWaitDailyMission():void{
			missionType.gotoAndStop("daily");
			newFunctionTxt.visible = false;
			newFunctionMc.visible = false;
			missionName.text = "正在寻找新的奇遇任务…";
			completeIcon.gotoAndStop("none");
			_dailyMissionMcHide = false;
		}

		
		private function renderMainMission():void
		{
			missionType.gotoAndStop("main");
			missionName.text = _curMissionData.mission_name+"("+_curMissionData.lv.toString()+"级)";
			if(_curMissionData.newFunction!="0"){
				newFunctionTxt.visible = true;
				newFunctionMc.visible = true;
				newFunctionMc.gotoAndStop(_curMissionData.newFunction);
			}else{
				newFunctionTxt.visible = false;
				newFunctionMc.visible = false;
			}
			
			if(_curMissionData.lv > PlayerManager.getIns().player.character.lv){
				//missionName.textColor = ColorConst.red;
				completeIcon.gotoAndStop("lv");
/*				missionState.textColor  = ColorConst.red;
				missionState.text = _curMissionData.lv.toString()+"级开启此任务"; */
			}else{
				//missionName.textColor = ColorConst.orange;
				//missionState.textColor  = ColorConst.green;
				if(player.mainMissionVo.isComplete){
					completeIcon.gotoAndStop("complete");
				}else{
					completeIcon.gotoAndStop("none");
				}
			}
		}		
		
		
		
		
		
		private function initEvent():void{
			this.addEventListener(MouseEvent.CLICK,onMissionShow);
			this.addEventListener(MouseEvent.MOUSE_OVER,openTween);
			this.addEventListener(MouseEvent.MOUSE_OUT,closeTween);
		}
			
		
		private var _moving:Boolean;
		protected function closeTween(event:MouseEvent):void
		{
			TweenMax.to(this,0.4,{x:-4});
			_moving = false;
		}
		
		protected function openTween(event:MouseEvent):void
		{
			if(!_moving){
				_moving = true;
				TweenMax.to(this,0.4,{x:-135,onComplete:setTween});
			}
		}
		
		private function setTween():void{
			_moving = false;
		}
		
		protected function onMissionShow(e:MouseEvent):void
		{
/*			switch(int(_curMissionId/1000)){
				case 1:
					(ViewFactory.getIns().initView(MissionView) as MissionView).curMissionType
					= MissionView.MAIN_MISSION;
					break;
				case 2:
					(ViewFactory.getIns().initView(MissionView) as MissionView).curMissionType
					= MissionView.DAILY_MISSION;
					break;
			}*/
			if(_curMissionId!=2000){
				_dailyMissionMcHide = true;
				dailyMissionOpen.visible = false;
				(ViewFactory.getIns().initView(MissionView) as MissionView).curMissionId = _curMissionId;
				(ViewFactory.getIns().initView(MissionView) as MissionView).curMissionIndex = index;
				ViewFactory.getIns().initView(MissionView).show();
				
				hideView(StrengthenView);
				hideView(BagView);
				hideView(RoleDetailView);
			}

		}	
		
		private function hideView(cls:Class):void{
			if(ViewFactory.getIns().getView(cls)){
				ViewFactory.getIns().getView(cls).hide();
			}
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;	
		}
		
		
		private function get newFunctionTxt():TextField
		{
			return _obj["newFunctionTxt"];
		}
		
		private function get newFunctionMc():MovieClip
		{
			return _obj["newFunctionMc"];
		}
		
		private function get missionName():TextField
		{
			return _obj["missionName"];
		}
		
		private function get missionType():MovieClip
		{
			return _obj["missionType"];
		}
		
		private function get completeIcon():MovieClip
		{
			return _obj["completeIcon"];
		}

		
		private function get dailyMissionOpen():MovieClip
		{
			return _obj["dailyMissionOpen"];
		}
		
		
		override public function destroy() : void
		{		
			if(!_obj){
				return;
			}
			this.removeChild(_obj);
			_obj = null;
			_curMissionData = null;
		}
	}
}