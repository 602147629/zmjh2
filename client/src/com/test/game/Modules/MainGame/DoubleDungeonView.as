package com.test.game.Modules.MainGame
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Effect.ViewTweenEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.ExtraBarManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.Extra.DoubleDungeonManager;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.control.key.GoToBattleControl;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class DoubleDungeonView extends BaseView
	{
		private var _roleHead:BaseNativeEntity;
		public function DoubleDungeonView(){
			super();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.DOUBLEDUNGEONVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.DOUBLEDUNGEONVIEW.split("/")[1]) as Sprite;
				this.addChild(layer);
				layer.visible = false;
				initUI();
				setParams();
				setCenter();
				openTween();
			}
		}
		
		private function initUI():void{
			initBg();
			_roleHead = new BaseNativeEntity();
			_roleHead.x = 3;
			_roleHead.y = -18;
			dungeonHead.addChild(_roleHead);
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			selectDungeon.addEventListener(MouseEvent.CLICK, onSelectDungeon);
			selectDungeon.buttonMode = true;
			selectDungeon.mouseChildren = false;
			selectDungeon.stop();
			//resetBtn.addEventListener(MouseEvent.CLICK, onResetDungeon);
			minute_1.stop();
			minute_2.stop();
			second_1.stop();
			second_2.stop();
			minute_0.stop();
			minute_0.visible = false;
			update();
		}
		
		private function onResetDungeon(e:MouseEvent) : void{
			DoubleDungeonManager.getIns().resetDoubleDungeonJudge();
		}
		
		private function onSelectDungeon(e:MouseEvent) : void{
			switch(DoubleDungeonManager.getIns().doubleStatus){
				case 1:
					startDoubleDungeon();
					break;
				case 2:
					//enterDungeon();
					break;
				case 3:
					break;
			}
			
		}
		
		private var _assistEffect:BaseSequenceActionBind;
		private var _timeJudge:Boolean;
		private function startDoubleDungeon() : void{
			(ViewFactory.getIns().getView(TipView) as TipView).setFun(
				"是否花费" + DoubleDungeonManager.getIns().nowUseGold + "开启双倍",
				function () : void{
					if(PlayerManager.getIns().player.money >= DoubleDungeonManager.getIns().nowUseGold){
						PlayerManager.getIns().player.money -= DoubleDungeonManager.getIns().nowUseGold;
						_timeJudge = true;
						DoubleDungeonManager.getIns().startDoubleTime();
						addChangerEffect();
					}else{
						(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
							"金币不足，无法开启双倍");
					}
				}, null);
		}
		
		public function addChangerEffect() : void{
			_assistEffect = AnimationEffect.createAnimation(10015,["attachEffect"],false,updateAssist)
			_assistEffect.x = 513;
			_assistEffect.y = 227;
			this.addChild(_assistEffect);
			RenderEntityManager.getIns().removeEntity(_assistEffect);
			AnimationManager.getIns().addEntity(_assistEffect);
		}
		
		private function updateAssist(...args):void{
			if(_assistEffect != null){
				AnimationManager.getIns().removeEntity(_assistEffect);
				_assistEffect.destroy();
				_assistEffect = null;
			}
			TweenLite.delayedCall(2, function () : void{
				if(_timeJudge == true){
					(ViewFactory.getIns().initView(TipView) as TipView).setFun(
						"当前网络不稳定，请检查您的网络状况！", null, null, true);
				}
			});
		}
		
		public function updateTimeStatus() : void{
			_timeJudge = false;
			if(ViewFactory.getIns().initView(TipView).isClose == false){
				ViewFactory.getIns().initView(TipView).hide();
			}
		}
		
		private function enterDungeon():void{
			var level:String = PlayerManager.getIns().player.doubleDungeonVo.dungeonName;
			var arr:Array = level.split("_");
			if(arr.length == 3){
				var info:Array = PlayerManager.getIns().getEliteDungeonTimeInfo(arr[0]);
				if(info[arr[1] - 1] < 5){
					LevelManager.getIns().mapType = 1;
					(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).goToBattle(DoubleDungeonManager.getIns().nowInfo);
					((ViewFactory.getIns().initView(MainToolBar) as MainToolBar) as MainToolBar).destroyGuide();
					update();
					(ViewFactory.getIns().getView(ExtraBar) as ExtraBar).doubleUpdate();
					this.hide();
				}else{
					(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun("当前副本挑战次数已用完，明日会重新刷新。", null);
				}
			}else{
				LevelManager.getIns().mapType = 0;
				(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).goToBattle(DoubleDungeonManager.getIns().nowInfo);
				((ViewFactory.getIns().initView(MainToolBar) as MainToolBar) as MainToolBar).destroyGuide();
				update();
				(ViewFactory.getIns().getView(ExtraBar) as ExtraBar).doubleUpdate();
				this.hide();
			}
		}
		
		
		private function openTween():void{
			var pos:Point = ExtraBarManager.getIns().getBtnPos("Double");
			ViewTweenEffect.openTween(layer, pos.x, pos.y, centerX, centerY);
		}
		
		private function closeTween():void{
			var pos:Point = ExtraBarManager.getIns().getBtnPos("Double");
			ViewTweenEffect.closeTween(layer, pos.x, pos.y, hide);
		}
		
		override public function show() : void{
			if(layer == null) return;
			openTween();
			update();
			super.show();
		}
		
		
		private function onClose(e:MouseEvent) : void{
			closeTween();
		}
		
		override public function setParams():void{
			if(layer == null) return;
			update();
			goldTF.text = DoubleDungeonManager.getIns().nowUseGold.toString();
		}
		
		override public function update():void{
			switch(DoubleDungeonManager.getIns().doubleStatus){
				case 1:
					selectDungeon.gotoAndStop(2);
					GreyEffect.change(selectDungeon);
					moneyLayer.visible = true;
					//GreyEffect.change(resetBtn);
					//resetBtn.mouseEnabled = false;
					//_roleHead.visible = false;
					break;
				case 2:
					selectDungeon.gotoAndStop(1);
					GreyEffect.reset(selectDungeon);
					moneyLayer.visible = false;
					//GreyEffect.reset(resetBtn);
					//resetBtn.mouseEnabled = true;
					//addRoleHead();
					//dungeonName.text = DoubleDungeonManager.getIns().nowInfo.level_name;
					break;
				case 3:
					selectDungeon.gotoAndStop(1);
					GreyEffect.change(selectDungeon);
					moneyLayer.visible = false;
					//GreyEffect.change(resetBtn);
					//resetBtn.mouseEnabled = false;
					//addRoleHead();
					//dungeonName.text = DoubleDungeonManager.getIns().nowInfo.level_name;
					break;
			}
		}
		
		private function addRoleHead() : void{
			if(_roleHead.parent != null){
				_roleHead.parent.removeChild(_roleHead);
			}
			dungeonHead.addChild(_roleHead);
			_roleHead.data.bitmapData = AUtils.getNewObj(DoubleDungeonManager.getIns().nowInfo.fodder + "_LittleHead") as BitmapData;
			_roleHead.visible = true;
		}
		
		private var _minute:int;
		public function setTime(hour:Number, minute:Number, second:Number) : void{
			if(layer  == null) return;
			_minute = hour * 60 + minute;
			if(_minute >= 100){
				minute_0.gotoAndStop(2);
				minute_0.visible = true;
				minute_1.gotoAndStop(int((_minute - 100) / 10) + 1);
				minute_2.gotoAndStop((_minute - 100) % 10 + 1);
			}else{
				minute_0.visible = false;
				minute_1.gotoAndStop(int(_minute / 10) + 1);
				minute_2.gotoAndStop(_minute % 10 + 1);
			}
			second_1.gotoAndStop(int(second /  10) + 1);
			second_2.gotoAndStop(second % 10 + 1);
		}
		
		private function get closeBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
		private function get selectDungeon() : MovieClip{
			return layer["SelectDungeon"];
		}
		private function get dungeonHead() : Sprite{
			return layer["SelectDungeon"]["DungeonHead"]
		}
		public function get dungeonName() : TextField{
			return layer["SelectDungeon"]["DungeonName"]
		}
		private function get minute_0() : MovieClip{
			return layer["Minute_0"];
		}
		private function get minute_1() : MovieClip{
			return layer["Minute_1"];
		}
		private function get minute_2() : MovieClip{
			return layer["Minute_2"];
		}
		private function get second_1() : MovieClip{
			return layer["Second_1"];
		}
		private function get second_2() : MovieClip{
			return layer["Second_2"];
		}
		private function get resetBtn() : SimpleButton{
			return layer["ResetBtn"];
		}
		private function get goldTF() : TextField{
			return layer["Money"]["GoldTF"];
		}
		private function get moneyLayer() : Sprite{
			return layer["Money"];
		}
		
		public function clear() : void{
			setTime(0, 0, 0);
		}
	}
}