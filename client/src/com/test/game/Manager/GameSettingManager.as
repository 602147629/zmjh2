package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	
	import flash.display.StageQuality;
	
	public class GameSettingManager extends Singleton
	{
		public static const SIMPLE_OPERATE:uint = 1;
		public static const NORMAL_OPERATE:uint = 2;
		public static const SHOW_PUBLIC_NOTICE:uint = 1;
		public static const HIDE_PUBLIC_NOTICE:uint = 2;
		public static const SHOW_EFFECT:uint = 1;
		public static const HIDE_EFFECT:uint = 2;
		public var stageQuality:int;
		public var operateMode:int;
		public var publicNotice:int;
		public var openEffect:int;
		public function GameSettingManager()
		{
			super();
		}
		
		public static function getIns():GameSettingManager{
			return Singleton.getIns(GameSettingManager);
		}
		
		public function init(data:Object) : void{
			if(data != null){
				SoundManager.getIns().bgSoundVolume = data["bgVolume"];
				SoundManager.getIns().fightSoundVolume = data["fightVolume"];
				GameConst.isPreLoading = (data["preLoading"]==1?true:false);
				DeformTipManager.getIns().deformTipControll = (data["deformTip"]==1?true:false);
				stageQuality = (data["stageQuality"]==null?3:data["stageQuality"]);
				operateMode = (data["operateMode"]==null?NORMAL_OPERATE:data["operateMode"]);
				publicNotice = (data["publicNotice"]==null?SHOW_PUBLIC_NOTICE:data["publicNotice"]);
				openEffect = (data["openEffect"]==null?SHOW_EFFECT:data["openEffect"]);
				qualityUpdate();
			}else{
				SoundManager.getIns().bgSoundVolume = 1;
				SoundManager.getIns().fightSoundVolume = 1;
				GameConst.isPreLoading = true;
				DeformTipManager.getIns().deformTipControll = true;
				stageQuality = 3;
				operateMode = NORMAL_OPERATE;
				publicNotice = SHOW_PUBLIC_NOTICE;
				openEffect = SHOW_EFFECT;
				qualityUpdate();
			}
		}
		
		private function qualityUpdate():void{
			switch(stageQuality){
				case 1:
					GameConst.stage.quality = StageQuality.LOW;
					break;
				case 2:
					GameConst.stage.quality = StageQuality.MEDIUM;
					break;
				case 3:
					GameConst.stage.quality = StageQuality.HIGH;
					break;
			}
		}
		
		public function getSetting() : Object{
			var gameSetting:Object = new Object();
			gameSetting.bgVolume = SoundManager.getIns().bgSoundVolume.toFixed(4);
			gameSetting.fightVolume = SoundManager.getIns().fightSoundVolume.toFixed(4);
			gameSetting.preLoading = (GameConst.isPreLoading==true?1:0);
			gameSetting.deformTip = (DeformTipManager.getIns().deformTipControll==true?1:0);
			gameSetting.stageQuality = stageQuality;
			gameSetting.operateMode = operateMode;
			gameSetting.publicNotice = publicNotice;
			gameSetting.openEffect = openEffect;
			return gameSetting
		}
	}
}