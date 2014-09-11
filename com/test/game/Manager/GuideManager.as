package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.GuideConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Modules.MainGame.BagView;
	import com.test.game.Modules.MainGame.Guide.BossAssistGuideView;
	import com.test.game.Modules.MainGame.Guide.BossAttachGuideView;
	import com.test.game.Modules.MainGame.Guide.BossSummonGuideView;
	import com.test.game.Modules.MainGame.Guide.BossUpgradeGuideView;
	import com.test.game.Modules.MainGame.Guide.EquipForgeView;
	import com.test.game.Modules.MainGame.Guide.EquipStrengthenView;
	import com.test.game.Modules.MainGame.Guide.FirstLevelGuideView;
	import com.test.game.Modules.MainGame.Guide.NewFunctionView;
	import com.test.game.Modules.MainGame.Guide.OneKeyEquipView;
	import com.test.game.Modules.MainGame.Guide.RoleDetailGuideView;
	import com.test.game.Modules.MainGame.Guide.SkillGuideView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Mission.MissionView;
	import com.test.game.Modules.MainGame.Skill.SkillButtonSetView;
	import com.test.game.Modules.MainGame.Strengthen.StrengthenView;
	import com.test.game.Modules.MainGame.boss.BossView;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class GuideManager extends Singleton
	{
		public static const ARROW:String = "ClickThisOnlyArrow";
		public static const ARROW_REVERSE:String = "ClickThisOnlyArrowReverse";
		public var guideIndex:int;
		public var guideMC:MovieClip;
		private var _guideList:Vector.<MovieClip>;
		public function GuideManager(){
			super();
			_guideList = new Vector.<MovieClip>();
		}
		
		public static function getIns():GuideManager{
			return Singleton.getIns(GuideManager);
		}
		
		public function judgeShowFirstLevelGuide() : void{
			if(LevelManager.getIns().mapType == 0){
				if((LevelManager.getIns().nowIndex == "1_1" && !PlayerManager.getIns().hasPassDungeonInfo("1_1"))
					||(LevelManager.getIns().nowIndex == "1_2" && !PlayerManager.getIns().hasPassDungeonInfo("1_2"))){
					(ViewFactory.getIns().initView(FirstLevelGuideView) as FirstLevelGuideView);
				}
			}
		}
		
		public function guideInit() : int{
			var result:int = 0;
			if(guideIndex == 1
				|| guideIndex == 11
				|| guideIndex == 31
				|| guideIndex == 41){
				result = guideIndex;
			}
			return result;
		}
		
		//任务界面引导
		public function missionGuideSetting(type:String) : void{
			switch(type){
				case "背包":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.BAG);
					guideIndex = 1;
					break;
				case "技能":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.SKILL);
					guideIndex = 11;
					break;
				case "精英副本":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.ELITE);
					guideIndex = 21;
					break;
				case "召唤，附体":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.SUMMON);
					guideIndex = 31;
					break;
				case "BOSS升级":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.BOSSUPGRADE);
					guideIndex = 41;
					break
				case "强化":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.STRENGTHEN);
					guideIndex = 61;
					break;
				case "打造":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.EQUIPFORGE);
					guideIndex = 71;
					break;
				case "援护":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.BOSSASSIST);
					guideIndex = 81;
					break;
				case "在线":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.ONLINE);
					guideIndex = 91;
					break;
				case "双倍":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.DOUBLE);
					guideIndex = 101;
					break;
				case "奇遇":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.DAILYMISSION);
					guideIndex = 111;
					break;
				case "签到":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.SIGNIN);
					guideIndex = 121;
					break;
				case "黑市":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.BLACKMARKET);
					guideIndex = 131;
					break;
				case "异闻":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.HIDEMISSION);
					guideIndex = 141;
					break;
				case "墨竹林隐藏副本":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.MOZHULINHIDEDUNGEON);
					guideIndex = 151;
					break;
				case "翠竹杖":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.CUIZHUZHANG);
					guideIndex = 161;
					break;
				case "太虚观隐藏副本":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.TAIXUGUANHIDEDUNGEON);
					guideIndex = 171;
					break;
				case "八卦盘":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.BAGUAPAN);
					guideIndex = 181;
					break;
				case "礼包":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.GIFT);
					guideIndex = 201;
					break;
				case "自动战斗":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.AUTOFIGHT);
					guideIndex = 211;
					break;
				case "PK":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.PLAYERKILLING);
					guideIndex = 221;
					break;
				case "护镖":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.ESCORT);
					guideIndex = 231;
					break;
				case "劫镖":
					ViewFactory.getIns().getView(MissionView).hide();
					addNewFunction(GuideConst.LOOT);
					guideIndex = 241;
					break;
				case "任务":
					addNewFunction(GuideConst.MISSION);
					guideIndex = 251;
					break;
				case "英雄谱":
					addNewFunction(GuideConst.HERO);
					guideIndex = 261;
					break;
				/*case "充能":
					addNewFunction(GuideConst.HERO);
					guideIndex = 271;
					break;*/
			}
		}
		
		public function jingMaiGuideSetting(close:Boolean = false) : void{
			if(close == true){
				guideIndex = 259;
				destoryGuideMC();
				return;
			}
			switch(guideIndex){
				case 251:
					guideSetting(ARROW, new Point(450, 135));
					guideIndex = 252;
					break;
				case 252:
					guideSetting(ARROW, new Point(537, 105));
					guideIndex = 253;
					break;
				case 253:
					guideSetting(ARROW, new Point(384, 290), LayerManager.getIns().gameTipLayer);
					guideIndex = 254;
					break;
				case 254:
					guideSetting(ARROW_REVERSE, new Point(708, 75));
					guideIndex = 255;
					break;
				case 255:
					guideSetting(ARROW_REVERSE, new Point(890, 55));
					guideIndex = 256;
					break;
			}
		}
		
		public function qiYuGuideSetting() : void{
			switch(guideIndex){
				case 111:
					guideSetting(ARROW_REVERSE, new Point(325, 230));
					guideIndex = 112;
					break;
				case 112:
					destoryGuideMC();
					guideIndex = 113;
					break;
			}
		}
		
		public function baGuaPanGuideSetting() : void{
			switch(guideIndex){
				case 181:
					guideSetting(ARROW, new Point(590, 390));
					guideIndex = 182;
					break;
				case 182:
					destoryGuideMC();
					guideIndex = 183;
					break;
			}
		}
		
		public function signInGuideSetting(over:Boolean = false) : void{
			if(over){
				destoryGuideMC();
				if(guideIndex >= 121 && guideIndex <= 125){
					guideIndex = 126;
				}
				return;
			}
			switch(guideIndex){
				case 121:
					guideSetting(ARROW, new Point(810, 430));
					guideIndex = 122;
					break;
				case 122:
					guideSetting(ARROW, new Point(410, 110));
					guideIndex = 123;
					break;
				case 123:
					guideSetting(ARROW, new Point(460, 315), LayerManager.getIns().gameTipLayer);
					guideIndex = 124;
					break;
				case 124:
					guideSetting(ARROW_REVERSE, new Point(670, 110));
					guideIndex = 125;
					break;
			}
		}
		
		//强化打造界面
		public function strengthenGuideSetting(over:Boolean = false) : void{
			if(over){
				destoryGuideMC();
				if(guideIndex == 64 || guideIndex == 76){
					(ViewFactory.getIns().initView(MainToolBar) as MainToolBar).addGuideTip(GuideConst.MISSION);
				}
				if(guideIndex >= 61 && guideIndex <= 64){
					guideIndex = 65;
				}
				if(guideIndex >= 71 && guideIndex <= 76){
					guideIndex = 77;
				}
				return;
			}
			switch(guideIndex){
				case 61:
					destoryGuideMC();
					ViewFactory.getIns().initView(EquipStrengthenView).show();
					guideIndex = 62;
					break;
				case 62:
					guideSetting(ARROW, new Point(280, 397), (ViewFactory.getIns().getView(StrengthenView) as StrengthenView).layer);
					guideIndex = 63;
					break;
				case 63:
					guideSetting(ARROW_REVERSE, new Point(390, 80), (ViewFactory.getIns().getView(StrengthenView) as StrengthenView).layer);
					guideIndex = 64;
					break;
				
				
				case 71:
					guideSetting(ARROW, new Point(290, 35), (ViewFactory.getIns().getView(StrengthenView) as StrengthenView).layer);
					guideIndex = 72;
					break;
				case 72:
					destoryGuideMC();
					ViewFactory.getIns().initView(EquipForgeView).show();
					guideIndex = 73;
					break;
				case 73:
					guideSetting(ARROW, new Point(60, 185), (ViewFactory.getIns().getView(StrengthenView) as StrengthenView).layer);
					guideIndex = 74;
					break;
				case 74:
					guideSetting(ARROW, new Point(275, 400), (ViewFactory.getIns().getView(StrengthenView) as StrengthenView).layer);
					guideIndex = 75;
					break;
				case 75:
					guideSetting(ARROW_REVERSE, new Point(390, 80), (ViewFactory.getIns().getView(StrengthenView) as StrengthenView).layer);
					guideIndex = 76;
					break;
			}
		}
		
		// Boss升级界面
		public function bossUpgradeGuideSetting(over:Boolean = false) : void{
			if(over){
				destoryGuideMC();
				if(guideIndex == 50){
					(ViewFactory.getIns().initView(MainToolBar) as MainToolBar).addGuideTip(GuideConst.MISSION);
				}
				if(guideIndex >= 45 && guideIndex <= 50){
					guideIndex = 51;
				}
				return;
			}
			switch(guideIndex){
				case 45:
					guideSetting(ARROW, new Point(405, 10));
					guideIndex = 46;
					break;
				case 46:
					destoryGuideMC();
					ViewFactory.getIns().initView(BossUpgradeGuideView).show();
					guideIndex = 47;
					break;
				case 47:
					if(PackManager.getIns().hasAttachBoss()){
						guideSetting(ARROW, new Point(545, -20), (ViewFactory.getIns().getView(BossView) as BossView).upgradeTabView);
					}else{
						guideSetting(ARROW, new Point(520, 50), (ViewFactory.getIns().getView(BossView) as BossView).upgradeTabView);
					}
					guideIndex = 48;
					break;
				case 48:
					guideSetting(ARROW, new Point(220, 325), (ViewFactory.getIns().getView(BossView) as BossView).upgradeTabView);
					guideIndex = 49;
					break;
				case 49:
					guideSetting(ARROW_REVERSE, new Point(890, 55));
					guideIndex = 50;
					break;
			}
		}
		
		//Boss援护界面
		public function bossAssistGuideSetting(over:Boolean = false) : void{
			if(over){
				destoryGuideMC();
				if(guideIndex == 88){
					//guideSetting(ARROR, new Point(135, 245));
					(ViewFactory.getIns().initView(MainToolBar) as MainToolBar).addGuideTip(GuideConst.MISSION);
				}
				if(guideIndex >= 81 && guideIndex <= 88){
					guideIndex = 89;
				}
				return;
			}
			switch(guideIndex){
				case 81:
					guideSetting(ARROW, new Point(280, 75));
					guideIndex = 82;
					break;
				case 82:
					guideSetting(ARROW, new Point(673, 350), (ViewFactory.getIns().getView(BossView) as BossView).summonTabView);
					guideIndex = 83;
					break;
				case 83:
					guideSetting(ARROW, new Point(452, 295));
					guideIndex = 84;
					break;
				case 84:
					guideSetting(ARROW, new Point(690, 10));
					guideIndex = 85;
					break;
				case 85:
					destoryGuideMC();
					ViewFactory.getIns().initView(BossAssistGuideView).show();
					guideIndex = 86;
					break;
				case 86:
					guideSetting("GuideBossAssistImg", new Point(400, 55), (ViewFactory.getIns().getView(BossView) as BossView).assistTabView);
					guideIndex = 87;
					break;
				case 87:
					guideSetting(ARROW_REVERSE, new Point(890, 55));
					guideIndex = 88;
					break;
			}
		}
		
		//Boss附体界面
		public function bossAttachGuideSetting(over:Boolean = false) : void{
			if(over){
				destoryGuideMC();
				if(guideIndex == 38){
					(ViewFactory.getIns().initView(MainToolBar) as MainToolBar).addGuideTip(GuideConst.MISSION);
				}
				if(guideIndex >= 31 && guideIndex <= 38){
					guideIndex = 39;
				}
				return;
			}
			switch(guideIndex){
				case 31:
					destoryGuideMC();
					ViewFactory.getIns().initView(BossSummonGuideView).show();
					guideIndex = 32;
					break;
				case 32:
					guideSetting(ARROW, new Point(670, 345), (ViewFactory.getIns().getView(BossView) as BossView).summonTabView);
					guideIndex = 33;
					break;
				case 33:
					guideSetting(ARROW, new Point(452, 295));
					guideIndex = 34;
					break;
				case 34:
					guideSetting(ARROW, new Point(545, 10));
					guideIndex = 35;
					break;
				case 35:
					destoryGuideMC();
					ViewFactory.getIns().initView(BossAttachGuideView).show();
					guideIndex = 36;
					break;
				case 36:
					guideSetting("GuideBossAttachImg", new Point(175, 30), (ViewFactory.getIns().getView(BossView) as BossView).attachTabView);
					guideIndex = 37;
					break;
				case 37:
					guideSetting(ARROW_REVERSE, new Point(890, 55));
					guideIndex = 38;
					break;
			}
		}
		
		//Boss界面总引导判断
		public function bossGuideSetting(guideType:String = "", over:Boolean = false) : void{
			if(guideType != ""){
				switch(guideType){
					case GuideConst.BOSSUPGRADE:
						bossUpgradeGuideSetting(over);
						break;
					case GuideConst.BOSSATTACH:
						bossAttachGuideSetting(over);
						break;
					case GuideConst.BOSSASSIST:
						bossAssistGuideSetting(over);
						break;
				}
			}else{
				if(guideIndex >= 31 && guideIndex <= 38){
					bossAttachGuideSetting(over);
				}
				if(guideIndex >= 45 && guideIndex <= 50){
					bossUpgradeGuideSetting(over);
				}
				if(guideIndex >= 81 && guideIndex <= 88){
					bossAssistGuideSetting(over);
				}
			}
		}
		
		//Boss界面Tab按钮判断
		public function bossTabJudge(index:int = -1) : void{
			if(index == -1){
				if(guideIndex == 82){
					bossGuideSetting();
				}
				if(guideIndex == 48){
					bossGuideSetting();
				}
			}else{
				if(guideIndex == 35 && index == 2){
					bossGuideSetting();
				}
				if(guideIndex == 46 && index == 1){
					bossGuideSetting();
				}
				if(guideIndex == 85 && index == 3){
					bossGuideSetting();
				}
			}
		}
		
		//包裹界面引导
		public function bagGuideSetting(type:String = GuideConst.NONE) : void{
			if(type == GuideConst.CLOSE){
				destoryGuideMC();
				if(guideIndex == 192){
					(ViewFactory.getIns().initView(MainToolBar) as MainToolBar).addGuideTip(GuideConst.MISSION);
				}
				if(guideIndex >= 191 && guideIndex <= 192){
					guideIndex = 193;
				}
				
				if(guideIndex == 44){
					(ViewFactory.getIns().initView(MainToolBar) as MainToolBar).addGuideTip(GuideConst.SUMMON);
				}
				if(guideIndex >= 41 && guideIndex <= 44){
					guideIndex = 45;
				}
			}else if(type == GuideConst.OPEN){
				var index:int;
				if(guideIndex == 18){
					index = PackManager.getIns().getUnEquipItem().mid;
					guideSetting("GuideDressEquipment", new Point(80 + index % 6 * 51, 150 + int(index / 6) * 51), ViewFactory.getIns().getView(BagView));
					guideIndex = 191;
				}else if(guideIndex == 41){
					index = PackManager.getIns().searchItem(NumberConst.getIns().jinNangBoxId)[0].mid;
					guideSetting(ARROW_REVERSE, new Point(60 + index % 6 * 51, 125 + int(index / 6) * 51), ViewFactory.getIns().getView(BagView));
					guideIndex = 42;
				}
			}else{
				switch(guideIndex){
					/*case 2:
						destoryGuideMC();
						ViewFactory.getIns().initView(RoleDetailGuideView).show();
						guideIndex = 3;
						break;*/
					case 191:
						guideSetting(ARROW_REVERSE, new Point(355, 70), ViewFactory.getIns().getView(BagView));
						guideIndex = 192;
						break;
					case 42:
						guideSetting(ARROW, new Point(460, 315), LayerManager.getIns().gameTipLayer);
						guideIndex = 43;
						break;
					case 43:
						guideSetting(ARROW_REVERSE, new Point(355, 70), ViewFactory.getIns().getView(BagView));
						guideIndex = 44;
						break;
				}
			}
		}
		
		//大地图引导
		public function mainMapGuideSetting() : void{
			switch(guideIndex){
				case 5:
					((ViewFactory.getIns().initView(MainToolBar) as MainToolBar) as MainToolBar).destroyGuide();
					break;
				case 89:
					destoryGuideMC();
					break;
			}
		}
		
		//技能界面引导
		public function skillGuideSetting(type:String = GuideConst.NONE) : void{
			switch(type){
				case GuideConst.CLOSE:
					destoryGuideMC();
					if(guideIndex == 17){
						(ViewFactory.getIns().initView(MainToolBar) as MainToolBar).addGuideTip(GuideConst.BAG);
					}
					if(guideIndex >= 11 && guideIndex <= 17){
						guideIndex = 18;
						destroyAllMC();
					}
					break;
				case GuideConst.TYPEONE:
					if(guideIndex == 13){
						destroyAllMC();
						guideSetting(ARROW, new Point(125, 215));
					}
					break;
				case GuideConst.TYPETWO:
					if(guideIndex == 13){
						destroyAllMC();
						guideSetting(ARROW, new Point(125, 430));
					}
					break;
				case GuideConst.NONE:
					switch(guideIndex){
						case 11:
							ViewFactory.getIns().initView(SkillGuideView).show();
							guideIndex = 12;
							break;
						case 12:
							guideSetting(ARROW, new Point(125, 310));
							guideIndex = 13;
							break;
						case 13:
							destroyAllMC();
							guideSetting(ARROW, new Point(818, 115));
							guideIndex = 14;
							break;
						case 14:
							(ViewFactory.getIns().initView(SkillButtonSetView) as SkillButtonSetView).callback = 
							function () : void{
								guideSetting("GuideSkillDrag", new Point(80, 70), ViewFactory.getIns().getView(SkillButtonSetView).layer);
							}
							guideIndex = 15;
							break;
						case 15:
							destoryGuideMC();
							guideSetting(ARROW_REVERSE, new Point(650, 200));
							guideIndex = 16;
							break;
						case 16:
							destoryGuideMC();
							guideSetting(ARROW_REVERSE, new Point(885, 65));
							guideIndex = 17;
							break;
					}
					break;
			}
		}
		
		private function getOneKeyEquip() : void{
			(ViewFactory.getIns().initView(OneKeyEquipView) as OneKeyEquipView).show();
		}
		
		public function oneKeyEquipJudge() : void{
			(ViewFactory.getIns().initView(OneKeyEquipView) as OneKeyEquipView).show();
			mainMapGuideSetting();
		}
		
		//新功能开启
		public function addNewFunction(type:String) : void{
			(ViewFactory.getIns().initView(NewFunctionView) as NewFunctionView).type = type;
			ViewFactory.getIns().initView(NewFunctionView).show();
		}
		
		//显示主角信息界面引导
		public function showRoleDetailGuide() : void{
			ViewFactory.getIns().initView(RoleDetailGuideView).show();
		}
		//主角信息界面移动
		public function tweenLiteGuidePosition() : void{
			(ViewFactory.getIns().initView(RoleDetailGuideView) as RoleDetailGuideView).tweenlitePosition();
		}
		
		public function guideSetting(type:String, point:Point, layer:Sprite = null, newMC:Boolean = false) : void{
			if(!newMC){	
				destoryGuideMC();
				guideMC = getGuideMCByName(type, point.x, point.y);
				guideMC.mouseEnabled = false;
				guideMC.mouseChildren = false;
				if(layer == null){
					LayerManager.getIns().gameInfoLayer.addChild(guideMC);
				}else{
					layer.addChild(guideMC);
				}
			}else{
				var mc:MovieClip = new MovieClip();
				mc = getGuideMCByName(type, point.x, point.y);
				mc.mouseEnabled = false;
				mc.mouseChildren = false;
				if(layer == null){
					LayerManager.getIns().gameInfoLayer.addChild(mc);
				}else{
					layer.addChild(mc);
				}
				_guideList.push(mc);
			}
		}
		
		//获得素材
		public function getGuideMCByName(name:String, xPos:int = 0, yPos:int = 0) : MovieClip{
			var obj:Object = AssetsManager.getIns().getAssetObject(name);
			var guideMC:MovieClip = obj as MovieClip;
			guideMC.x = xPos;
			guideMC.y = yPos;
			return guideMC;
		}
		
		private function destroyAllMC() : void{
			for(var i:int = 0; i < _guideList.length; i++){
				if(_guideList[i].parent != null){
					_guideList[i].parent.removeChild(_guideList[i]);
				}
				_guideList[i] = null;
			}
			_guideList.length = 0;
		}

		public function destoryGuideMC() : void{
			if(guideMC != null){
				if(guideMC.parent != null){
					guideMC.parent.removeChild(guideMC);
				}
			}
		}
		
		public function clear() : void{
			guideIndex = 0;
			destoryGuideMC();
			destroyAllMC();
			if(ViewFactory.getIns().getView(MainToolBar) != null){
				(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).destroyGuide();
			}
		}
	}
}