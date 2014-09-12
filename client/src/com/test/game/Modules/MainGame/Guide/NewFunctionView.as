package com.test.game.Modules.MainGame.Guide
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.GuideConst;
	import com.test.game.Const.StringConst;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Modules.MainGame.StartPageView;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.MainUI.TreasureToolBar;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class NewFunctionView extends BaseView
	{
		public function NewFunctionView(){
			super();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private var _guideMC:MovieClip;
		private var _functionType:Sprite;
		public var type:String;
		override public function setParams():void{
			if(layer == null){
				var index:int = LayerManager.getIns().gameLayer.getChildIndex(ViewFactory.getIns().getView(MainToolBar));
				LayerManager.getIns().gameLayer.setChildIndex(this, index);
				layer = new Sprite();
				this.addChild(layer);
				
				initBg();
				
				_guideMC = GuideManager.getIns().getGuideMCByName("GuideNewFunction", 470, 295);
				layer.addChild(_guideMC);
				
				var obj:Object = AssetsManager.getIns().getAssetObject("GuideFunctionType");
				_functionType = obj as Sprite;
				layer.addChild(_functionType);
			}
			(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).mouseEnable();
			(ViewFactory.getIns().getView(ExtraBar) as ExtraBar).mouseEnable();
			_guideMC.alpha = 1;
			_guideMC.scaleX = .3;
			_guideMC.scaleY = .3;
			TweenLite.to(_guideMC, .2, {scaleX:1.5, scaleY:1.5, onComplete:showLimit});
			
			_functionType.x = 425;
			_functionType.y = 175;
			_functionType.visible = false;
			showDetail();
		}
		
		private function showDetail():void{
			switch(type){
				case GuideConst.MISSION:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.MISSION_DETAIL;
					break;
				case GuideConst.BAG:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.BAG_DETAIL;
					break;
				case GuideConst.SKILL:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.SKILL_DETAIL;
					break;
				case GuideConst.STRENGTHEN:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.STRENGTHEN_DETAIL;
					break;
				case GuideConst.BOSSUPGRADE:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.UPGRADE_DETAIL;
					break;
				case GuideConst.SUMMON:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.SUMMON_DETAIL;
					break;
				case GuideConst.ELITE:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.ELITE_DETAIL;
					break;
				case GuideConst.EQUIPFORGE:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.FORGE_DETAIL;
					break;
				case GuideConst.BOSSASSIST:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.ASSIST_DETAIL;
					break;
				case GuideConst.ONLINE:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.ONLINE_DETAIL;
					break;
				case GuideConst.DOUBLE:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.DOUBLE_DETAIL;
					break;
				case GuideConst.DAILYMISSION:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.DAILY_MISSION_DETAIL;
					break;
				case GuideConst.SIGNIN:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.SIGN_IN_DETAIL;
					break;
				case GuideConst.BLACKMARKET:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.BLACK_MARKET_DETAIL;
					break;
				case GuideConst.HIDEMISSION:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.HIDE_MISSION_DETAIL;
					break;
				case GuideConst.MOZHULINHIDEDUNGEON:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.MO_ZHU_LIN_DETAIL;
					break;
				case GuideConst.CUIZHUZHANG:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.CUI_ZHU_ZHANG_DETAIL;
					break;
				case GuideConst.TAIXUGUANHIDEDUNGEON:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.TAI_XU_GUAN_DETAIL;
					break;
				case GuideConst.BAGUAPAN:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.BA_GUA_PAN_DETAIL;
					break;
				case GuideConst.GIFT:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.GIFT_DETAIL;
					break;
				case GuideConst.AUTOFIGHT:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.AUTO_FIGHT_DETAIL;
					break;
				case GuideConst.PLAYERKILLING:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.PLAYER_KILLING_DETAIL;
					break;
				case GuideConst.ESCORT:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.ESCORT_DETAIL;
					break;
				case GuideConst.LOOT:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.LOOT_DETAIL;
					break;
				case GuideConst.HERO:
					(_guideMC["FunctionDetail"] as TextField).text = StringConst.HERO_DETAIL;
					break;
			}
		}
		
		private function showLimit() : void{
			TweenLite.to(_guideMC, .3, {scaleX:1, scaleY:1, onComplete:completeFun, ease:Expo.easeIn});
		}
		
		private function baseFinal1() : void{
			(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).moveIcon(type);
			_functionType.visible = false;
		}
		
		private function baseFinal2() : void{
			(ViewFactory.getIns().getView(ExtraBar) as ExtraBar).show();
			(ViewFactory.getIns().getView(ExtraBar) as ExtraBar).moveIcon(type);
			(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).moveIcon("");
			_functionType.visible = false;
		}
		
		private function baseFinal3(index:int, xPos:int, yPos:int, fun:Function) : void{
			_functionType.visible = true;
			(_functionType["titleName"] as MovieClip).gotoAndStop(index);
			TweenLite.delayedCall(1,
				function () : void{
					TweenLite.to(_functionType, 1, {x:xPos, y:yPos, onComplete:fun});
				});
		}
		
		private function completeFun() : void{
			switch(type){
				case GuideConst.MISSION:
					(ViewFactory.getIns().getView(StartPageView) as StartPageView).isNew = false;
					firstFinal();
					baseFinal1();
					break;
				case GuideConst.BAG:
				case GuideConst.SKILL:
				case GuideConst.STRENGTHEN:
				case GuideConst.SUMMON:
					baseFinal1();
					break;
				case GuideConst.ELITE:
				case GuideConst.ONLINE:
				case GuideConst.DOUBLE:
				case GuideConst.GIFT:
				case GuideConst.PLAYERKILLING:
				case GuideConst.ESCORT:
					baseFinal2();
					break;
				case GuideConst.SIGNIN:
					baseFinal3(13, 800, 460, signInFunction);
					break;
				case GuideConst.DAILYMISSION:
					baseFinal3(4, 370, 490, dailyMissionFunction);
					break;
				case GuideConst.BOSSUPGRADE:
					baseFinal3(1, 705, 490, bossUpgradeFunction);
					break;
				case GuideConst.EQUIPFORGE:
					baseFinal3(3, 645, 490, strengthenFunction);
					break;
				case GuideConst.BOSSASSIST:
					baseFinal3(2, 705, 490, bossSummonFunction);
					break;
				case GuideConst.BLACKMARKET:
					baseFinal3(5, 375, 130, blackMarketFunction);
					(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).moveIcon("");
					break;
				case GuideConst.HIDEMISSION:
					baseFinal3(7, 430, 490, blackMarketFunction);
					(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).moveIcon("");
					break;
				case GuideConst.MOZHULINHIDEDUNGEON:
					baseFinal3(6, 100, 255, blackMarketFunction);
					(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).moveIcon("");
					break;
				case GuideConst.CUIZHUZHANG:
					baseFinal3(8, 280, 5, treasureFunction);
					(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).moveIcon("");
					break;
				case GuideConst.BAGUAPAN:
					baseFinal3(10, 280, 5, treasureFunction);
					(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).moveIcon("");
					break;
				case GuideConst.HERO:
					baseFinal3(14, 280, 5, treasureFunction);
					(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).moveIcon("");
					break;
				case GuideConst.TAIXUGUANHIDEDUNGEON:
					baseFinal3(9, 245, 210, blackMarketFunction);
					(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).moveIcon("");
					break;
				case GuideConst.AUTOFIGHT:
					baseFinal3(11, 10, 10, treasureFunction);
					(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).moveIcon("");
					break;
				case GuideConst.LOOT:
					baseFinal3(12, 625, -5, blackMarketFunction);
					(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).moveIcon("");
					break;
			}
			TweenLite.delayedCall(1.5, function () : void{
				(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).renderPosition(false);
				(ViewFactory.getIns().getView(ExtraBar) as ExtraBar).renderPosition(false);
				TweenLite.to(_guideMC, 1, {alpha:0,
					onComplete:function () : void{
						if(bg != null && bg.parent != null){
							bg.parent.removeChild(bg);
						}
					}
				});
			});
		}
		
		private function firstFinal() : void{
			(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).moveIcon(type);
			_functionType.visible = false;
			GuideManager.getIns().guideSetting(GuideManager.ARROW, new Point(723, 475));
		}
		
		private function signInFunction () : void{
			_functionType.visible = false;
			GuideManager.getIns().signInGuideSetting();
			(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).update();
		}
		
		private function dailyMissionFunction() : void{
			_functionType.visible = false;
			(ViewFactory.getIns().initView(MainToolBar) as MainToolBar).addGuideTip(GuideConst.MISSION);
		}
		
		private function treasureFunction() : void{
			_functionType.visible = false;
			(ViewFactory.getIns().initView(TreasureToolBar) as TreasureToolBar).update();
		}
		
		private function blackMarketFunction() : void{
			_functionType.visible = false;
		}
		
		private function bossSummonFunction() : void{
			_functionType.visible = false;
			(ViewFactory.getIns().initView(MainToolBar) as MainToolBar).addGuideTip(GuideConst.SUMMON);
		}
		
		private function bossUpgradeFunction() : void{
			_functionType.visible = false;
			(ViewFactory.getIns().initView(MainToolBar) as MainToolBar).addGuideTip(GuideConst.BAG);
		}
		
		private function strengthenFunction() : void{
			_functionType.visible = false;
			(ViewFactory.getIns().initView(MainToolBar) as MainToolBar).addGuideTip(GuideConst.STRENGTHEN);
		}
	}
}