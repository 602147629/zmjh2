package com.test.game.Modules.MainGame.PassLevel
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.ExpBar;
	import com.test.game.Effect.ShakeEffect;
	import com.test.game.Manager.AssessManager;
	import com.test.game.Manager.BattleUIManager;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.MoveActionManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.SwitchViewManager;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Modules.MainGame.Guide.FirstLevelGuideView;
	import com.test.game.Modules.MainGame.Map.BaseMapBgView;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	import com.test.game.Modules.MainGame.Mission.MissionView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.BmdView.GameSenceView;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.control.View.PassLevelControl;
	import com.test.game.Mvc.control.key.GoToBattleControl;
	import com.test.game.Mvc.control.key.LeaveGameControl;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class PassLevelView extends BaseView
	{
		public function PassLevelView(){
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.PASSLEVELVIEW)], start, LoadManager.getIns().onProgress);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = AssetsManager.getIns().getAssetObject("PassLevelView") as Sprite;
				layer.x = 0;
				layer.y = 0;
				this.addChild(layer);
				
				initUI();
				initParams();
				//setParams();
				//setCenter();
			}
		}
		
		private function initParams():void{
			
		}
		
		private function initUI():void{
			initBg();
			this.addEventListener(MouseEvent.CLICK, onRightNow);
			(layer["ButtonLayer"]["QuitBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onClose);
			(layer["ButtonLayer"]["RestartBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onRestart);
			
			for(var i:int = 1; i < 3; i++){
				var itemIcon:ItemIcon = new ItemIcon();
				itemIcon.selectable = false;
				itemIcon.menuable = false;
				(layer["Second"]["Item" + i] as Sprite).addChild(itemIcon);
			}
		}
		
		private function onRightNow(e:MouseEvent) : void{
			MoveActionManager.getIns().onRightNow();
			EffectManager.getIns().setLastDigital();
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			if(ViewFactory.getIns().getView(FirstLevelGuideView) != null){
				ViewFactory.getIns().destroyView(FirstLevelGuideView);
			}
			SoundManager.getIns().bgSoundPlay(AssetsConst.PASSLEVELSOUND);
			if(BmdViewFactory.getIns().getView(GameSenceView) != null){
				(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).clearDeactivate();
			}
			(layer["ButtonLayer"] as Sprite).visible = false;
			(layer["First"] as MovieClip).visible = true;
			(layer["First"] as MovieClip).alpha = 1;
			(layer["Second"] as MovieClip).visible = false;
			(layer["AssessLevel"] as MovieClip).visible = false;
			(layer["AssessLevelBg"] as Sprite).visible = false;
			(layer["BackGround"]["LittleBg"] as Sprite).visible = false;
			(layer["BackGround"]).x = -30;
			(layer["BackGround"]).y = -590;
			(layer["First"]["NewRecord1"] as Sprite).visible = false;
			(layer["First"]["NewRecord2"] as Sprite).visible = false;
			(layer["First"]["ComboName"] as Sprite).visible = false;
			(layer["First"]["ComboDetail"] as Sprite).visible = false;
			(layer["First"]["TimeName"] as Sprite).visible = false;
			(layer["First"]["PassTimeMin"] as Sprite).visible = false;
			(layer["First"]["PassTimeSec"] as Sprite).visible = false;
			(layer["First"]["PlayerHurtDetail"] as Sprite).visible = false;
			(layer["First"]["ExtraScore"] as Sprite).visible = false;
			(layer["ButtonLayer"]["CoolDown"] as TextField).visible = false;
			for(var i:int = 1; i < 5; i++){
				(layer["First"]["Label" + i]).x = 36 * (i - 1) + 650;
			}
			startMove();
		}
		
		private function startMove():void{
			EffectManager.getIns().createDigital(AssessManager.getIns().lastCombo, (layer["First"]["ComboDetail"] as Sprite), "ComboDetail");
			EffectManager.getIns().createDigital(AssessManager.getIns().levelTimeCount / 60, (layer["First"]["PassTimeMin"] as Sprite), "PassTimeMin");
			EffectManager.getIns().createDigital(AssessManager.getIns().levelTimeCount % 60, (layer["First"]["PassTimeSec"] as Sprite), "PassTimeSec");
			EffectManager.getIns().createDigital(AssessManager.getIns().playerHurt(), (layer["First"]["PlayerHurtDetail"] as Sprite), "PlayerHurtDetail");
			EffectManager.getIns().createDigital(AssessManager.getIns().extraScore(), (layer["First"]["ExtraScore"] as Sprite), "ExtraScore");
			
			(layer["AssessLevel"] as MovieClip).gotoAndStop(AssessManager.getIns().assessLevel());
			
			MoveActionManager.getIns().addMoveObj((layer["BackGround"]), .2, {x:220, y:0});
			
			MoveActionManager.getIns().addMoveObj((layer["BackGround"]["LittleBg"]), .1, {visible:true});
			for(var i:int = 1; i < 5; i++){
				MoveActionManager.getIns().addMoveObj((layer["First"]["Label" + i]), .2, {x:36 * (i - 1)});
			}
			
			MoveActionManager.getIns().addMoveObj((layer["First"]["ComboName"] as Sprite), .5,{
				onStart:function() : void{
					(layer["First"]["ComboName"] as Sprite).visible = true;
					(layer["First"]["ComboDetail"] as Sprite).visible = true;
					EffectManager.getIns().scoreDigital["ComboDetail"].start();
				}
			});
			MoveActionManager.getIns().addMoveObj((layer["First"]["TimeName"] as Sprite), .5, {
				onStart:function() : void{
					(layer["First"]["TimeName"] as Sprite).visible = true;
					(layer["First"]["PassTimeMin"] as Sprite).visible = true;
					(layer["First"]["PassTimeSec"] as Sprite).visible = true;
					EffectManager.getIns().scoreDigital["PassTimeMin"].start();
					EffectManager.getIns().scoreDigital["PassTimeSec"].start();
				}
			});
			MoveActionManager.getIns().addMoveObj((layer["First"]["PlayerHurtDetail"]), .5, {
				onStart:function() : void{
					(layer["First"]["PlayerHurtDetail"] as Sprite).visible = true;
					EffectManager.getIns().scoreDigital["PlayerHurtDetail"].start();
				}
			});
			MoveActionManager.getIns().addMoveObj((layer["First"]["ExtraScore"]), .5, {
				onStart:function() : void{
					(layer["First"]["ExtraScore"] as Sprite).visible = true;
					EffectManager.getIns().scoreDigital["ExtraScore"].start();
				}
			});
			
			MoveActionManager.getIns().addMoveObj((layer["AssessLevelBg"] as Sprite), .01, {visible:true});
			MoveActionManager.getIns().addMoveObj((layer["AssessLevel"] as MovieClip), .01, {visible:true, scaleX:5, scaleY:5});
			MoveActionManager.getIns().addMoveObj((layer["AssessLevel"] as MovieClip), .4, {scaleX:1.2, scaleY:1.2, ease:Elastic.easeOut});
			MoveActionManager.getIns().addMoveObj(layer, .05, {
				onComplete:function() : void{
					var shake:ShakeEffect = new ShakeEffect([layer], 5);
				}
			}, MoveActionManager.getIns().indexLength - 1);
			
			MoveActionManager.getIns().callback = secondMove;
			MoveActionManager.getIns().start();
		}
		
		private var _expBar:ExpBar;
		private var _passLevelControl:PassLevelControl;
		private function secondMove() : void{
			_passLevelControl = ControlFactory.getIns().getControl(PassLevelControl) as PassLevelControl;
			var add:Number = ((AssessManager.getIns().assessLevel() - 1) * .1 + .8);
			EffectManager.getIns().createDigital(_passLevelControl.showExpNum, (layer["Second"]["ExpDetail"] as Sprite), "ExpDetail");
			EffectManager.getIns().createDigital(_passLevelControl.showMoneyNum, (layer["Second"]["RewardDetail"] as Sprite), "RewardDetail");
			EffectManager.getIns().createDigital(_passLevelControl.showSoulNum, (layer["Second"]["SoulDetail"] as Sprite), "SoulDetail");
			(layer["Second"]["Addition"] as TextField).text = _passLevelControl.showRateNum + "%";
			
			_expBar = new ExpBar();
			_expBar.createExpBar((layer["Second"]["ExpShow"] as Sprite), LevelManager.getIns().levelData.exp * add);
			
			if(ShopManager.getIns().vipLv >= NumberConst.getIns().two){
				(layer["Second"]["VipTF"] as TextField).visible = true;
			}else{
				(layer["Second"]["VipTF"] as TextField).visible = false;
			}
			
			MoveActionManager.getIns().addMoveObj((layer["First"] as MovieClip), 4, {});
			MoveActionManager.getIns().addMoveObj((layer["First"] as MovieClip), 1, {alpha:0});
			MoveActionManager.getIns().addMoveObj((layer["Second"] as MovieClip), .1, {alpha:0, visible:true});
			MoveActionManager.getIns().addMoveObj((layer["Second"] as MovieClip), 1, {alpha:1});
			
			MoveActionManager.getIns().addMoveObj((layer["Second"]["ExpDetail"]), .5, {
				onStart:function() : void{
					EffectManager.getIns().scoreDigital["ExpDetail"].start();
				}
			});
			MoveActionManager.getIns().addMoveObj((layer["Second"]["RewardDetail"]), .5, {
				onStart:function() : void{
					EffectManager.getIns().scoreDigital["RewardDetail"].start();
				}
			});
			MoveActionManager.getIns().addMoveObj((layer["Second"]["SoulDetail"]), .5, {
				onStart:function() : void{
					EffectManager.getIns().scoreDigital["SoulDetail"].start();
				}
			});
			MoveActionManager.getIns().addMoveObj((layer["Second"]["ExpShow"]), .5, {
				onStart:function() : void{
					_expBar.start();
				}
			});
			MoveActionManager.getIns().addMoveObj((layer["ButtonLayer"]), .5, {
				onStart:function() : void{
					(ControlFactory.getIns().getControl(PassLevelControl) as PassLevelControl).showBook();
					(layer["ButtonLayer"] as Sprite).visible = true;
					if((ControlFactory.getIns().getControl(PassLevelControl) as PassLevelControl).isFirstEnterLevel){
						(layer["ButtonLayer"]["RestartBtn"] as SimpleButton).visible = false;
					}else{
						(layer["ButtonLayer"]["RestartBtn"] as SimpleButton).visible = true;
						autoFightJudge();
					}
					guideShowClickThis();
				}
			});
			
			
			MoveActionManager.getIns().callback = thirdMove;
			MoveActionManager.getIns().start();
			
			showMaterial();
		}
		
		public function onCoolDown() : void{
			(layer["ButtonLayer"]["CoolDown"] as TextField).text = "(  5  )";
			TweenLite.delayedCall(1, coolDown4);
			TweenLite.delayedCall(2, coolDown3);
			TweenLite.delayedCall(3, coolDown2);
			TweenLite.delayedCall(4, coolDown1);
			TweenLite.delayedCall(5, coolDown0);
		}
		
		private function coolDown4() : void{
			(layer["ButtonLayer"]["CoolDown"] as TextField).text = "(  4  )";
		}
		private function coolDown3() : void{
			(layer["ButtonLayer"]["CoolDown"] as TextField).text = "(  3  )";
		}
		private function coolDown2() : void{
			(layer["ButtonLayer"]["CoolDown"] as TextField).text = "(  2  )";
		}
		private function coolDown1() : void{
			(layer["ButtonLayer"]["CoolDown"] as TextField).text = "(  1  )";
		}
		private function coolDown0() : void{
			(layer["ButtonLayer"]["CoolDown"] as TextField).text = "(  0  )";
		}
		
		public function autoFightJudge() : void{
			if(PlayerManager.getIns().player.autoFightInfo.autoFightCount > NumberConst.getIns().zero
				&& !GameSceneManager.getIns().partnerOperate){
				_passLevelControl.continueAutoFight = true;
				TweenLite.delayedCall(6, onRestart);
				onCoolDown();
				(layer["ButtonLayer"]["CoolDown"] as TextField).visible = true;
			}else{
				_passLevelControl.continueAutoFight = false;
				(layer["ButtonLayer"]["CoolDown"] as TextField).visible = false;
			}
		}
		
		//显示获得的材料
		private function showMaterial() : void{
			var materialInfo:Vector.<ItemVo> = (ControlFactory.getIns().getControl(PassLevelControl) as PassLevelControl).materialList;
			((layer["Second"]["Item1"] as Sprite).getChildAt(0) as ItemIcon).visible = false;
			((layer["Second"]["Item2"] as Sprite).getChildAt(0) as ItemIcon).visible = false;
			(layer["Second"]["Bg1"] as Sprite).visible = false;
			(layer["Second"]["Bg2"] as Sprite).visible = false;
			if(LevelManager.getIns().mapType == NumberConst.getIns().zero){
				for(var i:int = 0; i < materialInfo.length; i++){
					(layer["Second"]["Bg" + (i + 1)] as Sprite).visible = true;
					((layer["Second"]["Item" + (i + 1)] as Sprite).getChildAt(0) as ItemIcon).visible = true;
					((layer["Second"]["Item" + (i + 1)] as Sprite).getChildAt(0) as ItemIcon).setData(materialInfo[i]);
				}
			}else if(LevelManager.getIns().mapType == NumberConst.getIns().one){
				var specialInfo:Vector.<ItemVo> = (ControlFactory.getIns().getControl(PassLevelControl) as PassLevelControl).specialList;
				(layer["Second"]["Bg1"] as Sprite).visible = true;
				((layer["Second"]["Item1"] as Sprite).getChildAt(0) as ItemIcon).visible = true;
				((layer["Second"]["Item1"] as Sprite).getChildAt(0) as ItemIcon).setData(specialInfo[0]);
				if(materialInfo.length > 0){
					(layer["Second"]["Bg2"] as Sprite).visible = true;
					((layer["Second"]["Item2"] as Sprite).getChildAt(0) as ItemIcon).visible = true;
					((layer["Second"]["Item2"] as Sprite).getChildAt(0) as ItemIcon).setData(materialInfo[0]);
				}
			}
		}
		
		private function thirdMove():void{
			
		}
		
		private function killAllDelay() : void{
			TweenLite.killDelayedCallsTo(onRestart);
			TweenLite.killDelayedCallsTo(coolDown4);
			TweenLite.killDelayedCallsTo(coolDown3);
			TweenLite.killDelayedCallsTo(coolDown2);
			TweenLite.killDelayedCallsTo(coolDown1);
			TweenLite.killDelayedCallsTo(coolDown0);
		}
		
		private function onRestart(e:MouseEvent = null) : void{
			killAllDelay();
			SoundManager.getIns().fightSoundPlayer("EnterLevelSound");
			if(!eliteCountJudge()){
				SwitchViewManager.getIns().eyesCloseCallback = function () : void{
					clear();
					MoveActionManager.getIns().onRightNow();
					EffectManager.getIns().clearDigital();
					(ViewFactory.getIns().getView(BaseMapView) as BaseMapView).mapBitmap.filters = null;
					(ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView).mapBg.filters = null;
					BattleUIManager.getIns().resetCoolDownTime();
					(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).gameRelive();
					(ControlFactory.getIns().getControl(LeaveGameControl) as LeaveGameControl).leaveLevel();
					(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).goToBattle(LevelManager.getIns().levelData, true);
				}
				SwitchViewManager.getIns().eyesReEndEnter();
			}
		}
		
		private function eliteCountJudge() : Boolean{
			var result:Boolean = false;
			if(LevelManager.getIns().mapType == 1){
				if((ControlFactory.getIns().getControl(PassLevelControl) as PassLevelControl).isReachEliteCount()){
					result = true;
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("当前副本挑战次数已用完，明日会重新刷新，请退出关卡。");
				}
			}
			
			return result;
		}
		
		private function onClose(e:MouseEvent) : void{
			killAllDelay();
			_passLevelControl.continueAutoFight = false;
			SwitchViewManager.getIns().eyesCloseCallback = 
				function () : void{
					clear();
					MoveActionManager.getIns().onRightNow();
					EffectManager.getIns().clearDigital();
					(ControlFactory.getIns().getControl(LeaveGameControl) as LeaveGameControl).leaveLevel();
					guideShowMission();
				};
			SwitchViewManager.getIns().eyesEndEnter();
		}
		
		private var _guideMC:MovieClip;
		//引导
		private function guideShowClickThis():void{
			if((ControlFactory.getIns().getControl(PassLevelControl) as PassLevelControl).isFirstEnterLevel){
				if((LevelManager.getIns().nowIndex == "1_1" 
					|| LevelManager.getIns().nowIndex == "1_2") && LevelManager.getIns().mapType == NumberConst.getIns().zero){
					_guideMC = GuideManager.getIns().getGuideMCByName("ClickThis", 805, 350);
					layer.addChild(_guideMC);
				}
			}
		}
		
		private function guideShowMission() : void{
			if((ControlFactory.getIns().getControl(PassLevelControl) as PassLevelControl).showMission){
				ViewFactory.getIns().initView(MissionView).show();
			}
			/*if((ControlFactory.getIns().getControl(PassLevelControl) as PassLevelControl).isFirstEnterLevel){
				if((LevelManager.getIns().nowIndex == "1_1"
					|| LevelManager.getIns().nowIndex == "1_2"
					|| LevelManager.getIns().nowIndex == "1_3") && LevelManager.getIns().mapType == NumberConst.getIns().zero){
					ViewFactory.getIns().initView(MissionView).show();
				}
			}*/
		}
		
		private function clear() : void{
			this.hide();
			if(_guideMC != null){
				if(_guideMC.parent != null){
					_guideMC.parent.removeChild(_guideMC);
				}
				_guideMC.stop();
				_guideMC = null;
			}
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy() : void{
			super.destroy();
		}
	}
}