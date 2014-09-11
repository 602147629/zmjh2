package com.test.game.Modules.MainGame.Mission
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class MissionIcon extends BaseSprite
	{

		private var _obj:Sprite;

		private var _data:Object;

		private var _isComplete:Boolean;
		
		private var _index:int;

		public function get index():int
		{
			return _index;
		}
		public function set index(value:int):void
		{
			_index = value;
		}

		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player
		}
		
		public function MissionIcon()
		{
			this.buttonMode = true;
			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("MissionIcon") as Sprite;
				this.addChild(_obj);
				missionInfo.mouseEnabled = false;
			}
				
		}
		
		public function setData(id:int,isComplete:Boolean):void{
			
			_isComplete = isComplete;
			
			if(id==0){
				this.visible = false;
				return;
			}
			
			this.visible = true;
			setSelect(false);
			switch(int(id/1000)){
				case 1:
					renderMainMission(id);
					break;
				case 2:
					renderDailyMission(id);
					break;
				case 3:
					renderHideMission(id);
					break;
			}
			
			initEvent();
			
		}
		

		
		private function renderMainMission(id:int):void
		{
			_data = ConfigurationManager.getIns().getObjectByID(AssetsConst.MAIN_MISSION,id);
			
			missionInfo.text = "Lv."+_data.lv.toString()+" "+_data.mission_name;
			if(_data.lv > player.character.lv){
				missionInfo.textColor = ColorConst.red;
				completeIcon.gotoAndStop("lv");
			}else{
				missionInfo.textColor = ColorConst.white;
				if(_isComplete){
					completeIcon.gotoAndStop("complete");
				}else{
					completeIcon.gotoAndStop("none");
				}
			}
		}		
		
		private function renderDailyMission(id:int):void
		{
			_data = ConfigurationManager.getIns().getObjectByID(AssetsConst.DAILY_MISSION,id);
			var dungeonInfo:Object;
			var dungeonId:String = player.dailyMissionVo.missionDungeon;
			var arr:Array = dungeonId.split("_");
			if(arr.length == 3){
				dungeonInfo = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.ELITE, "level_id", arr[0]+"_"+arr[1]);
			}else{
				dungeonInfo = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.LEVEL, "level_id", dungeonId);
			}
			if(id == 2004){
				missionInfo.text = _data.mission_name.replace("[1]",dungeonInfo.boss_name);
			}else{
				missionInfo.text = _data.mission_name.replace("[1]",dungeonInfo.level_name);
			}
			
			missionInfo.textColor = ColorConst.white;
			if(_isComplete){
				completeIcon.gotoAndStop("complete");
			}else{
				completeIcon.gotoAndStop("none");
			}
		}
		
		
		private function renderHideMission(id:int):void{
			_data = ConfigurationManager.getIns().getObjectByID(AssetsConst.HIDE_MISSION,id);
			
			missionInfo.text = "Lv."+_data.lv.toString()+" "+_data.mission_name;
			missionInfo.textColor = ColorConst.white;
			if(_isComplete){
				completeIcon.gotoAndStop("complete");
			}else{
				completeIcon.gotoAndStop("none");
			}
		}
		
		public function setSelect(select:Boolean):void{
			if(select){
				iconSelect.gotoAndStop("select");
			}else{
				iconSelect.gotoAndStop("unSelect");
			}
		}
		
		private function initEvent():void{
			this.addEventListener(MouseEvent.CLICK,onMissionSelected);
		}
		
		protected function onMissionSelected(e:MouseEvent):void
		{
			EventManager.getIns().dispatchEvent(
				new CommonEvent(EventConst.MISSION_SELECT_CHANGE,[_data,this,index]));
			
		}	
		

		
		private function get missionInfo():TextField
		{
			return _obj["missionInfo"];
		}
		
		private function get completeIcon():MovieClip
		{
			return _obj["completeIcon"];
		}
		
		private function get iconSelect():MovieClip
		{
			return _obj["iconSelect"];
		}
		
		
		
		
		
		override public function destroy() : void{
			removeComponent(_obj);
			super.destroy();
		}
	}
}