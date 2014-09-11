package com.test.game.Modules.MainGame
{
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
	import com.test.game.Manager.AssessManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.SwitchViewManager;
	import com.test.game.Manager.URLManager;
	import com.test.game.Modules.MainGame.Skill.SkillLearnView;
	import com.test.game.Modules.MainGame.Strengthen.StrengthenView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.boss.BossView;
	import com.test.game.Mvc.BmdView.GameSenceView;
	import com.test.game.Mvc.control.View.GameSceneControl;
	import com.test.game.Mvc.control.key.GoToBattleControl;
	import com.test.game.Mvc.control.key.LeaveGameControl;
	import com.test.game.Utils.AllUtils;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class GameOverView extends BaseView
	{
		public function GameOverView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.GAMEOVERVIEW)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("GameOverView") as Sprite;
				this.addChild(layer);
				
				initUI();
				initParams();
				setParams();
				//setCenter();
			}
		}
		
		private function initParams():void{
			
		}
		
		private function initUI():void{
			initBg();
			(layer["RestartBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onRestart);
			(layer["ReliveBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onRelive);
			(layer["CloseBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onClose);
			
			(layer["TurnTo"]["Equip"]["GotoStrengthenBtn"] as Sprite).addEventListener(MouseEvent.CLICK, onGotoStrengthen);
			(layer["TurnTo"]["Skill"]["GotoSkillBtn"] as Sprite).addEventListener(MouseEvent.CLICK, onGotoSkill);
			(layer["TurnTo"]["Boss"]["GotoBossBtn"] as Sprite).addEventListener(MouseEvent.CLICK, onGotoBoss);
			(layer["GotoVideo"] as SimpleButton).addEventListener(MouseEvent.CLICK, onGotoVideo);
		}
		
		protected function onGotoVideo(event:MouseEvent):void{
			URLManager.getIns().openVideoURL();
		}
		
		private function onGotoStrengthen(e:MouseEvent) : void{
			(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice("是否确定退出关卡，开启强化界面？",
				function () : void{
					onClose();
					ViewFactory.getIns().initView(StrengthenView).show();
				});
		}
		
		private function onGotoSkill(e:MouseEvent) : void{
			(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice("是否确定退出关卡，开启技能界面？",
				function () : void{
					onClose();
					ViewFactory.getIns().initView(SkillLearnView).show();
				});
		}
		
		private function onGotoBoss(e:MouseEvent) : void{
			(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice("是否确定退出关卡，开启召唤界面？",
				function () : void{
					onClose();
					ViewFactory.getIns().initView(BossView).show();
				});
		}
		
		private function onRestart(e:MouseEvent) : void{
			SoundManager.getIns().fightSoundPlayer("EnterLevelSound");
			SwitchViewManager.getIns().eyesCloseCallback = function () : void{
				(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameRelive();
				(ControlFactory.getIns().getControl(LeaveGameControl) as LeaveGameControl).leaveLevel();
				(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).goToBattle(LevelManager.getIns().levelData, true);
				hide();
			}
			SwitchViewManager.getIns().eyesGameOver();
			
		}
		
		private function onRelive(e:MouseEvent) : void{
			var count:int = AllUtils.getSquareNum(AssessManager.getIns().reliveCount, 2);
			if(PackManager.getIns().searchItemNum(NumberConst.getIns().lifeCoinId) >= count){
				PackManager.getIns().reduceItem(NumberConst.getIns().lifeCoinId, count);
				AssessManager.getIns().reliveCount++;
				(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameRelive();
				(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).checkReliveGameOver();
				hide();
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("当前复活币不足");
			}
		}
		
		private function onClose(e:MouseEvent = null) : void{
			this.hide();
			(ControlFactory.getIns().getControl(LeaveGameControl) as LeaveGameControl).leaveLevel();
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			(layer["FuHuoBi"] as TextField).text = "剩余数量  " + PackManager.getIns().searchItemNum(NumberConst.getIns().lifeCoinId).toString();
			(layer["FuHuoBiUse"] as TextField).text = "消耗  " + (AllUtils.getSquareNum(AssessManager.getIns().reliveCount, 2)).toString();
			
			update();
		}
		
		override public function update():void{
			var index:int = PlayerManager.getIns().player.mainMissionVo.id;
			if(index <= 1002){
				layer["TurnTo"].visible = false;
			}else{
				layer["TurnTo"].visible = true;
				if(index > 1005){
					layer["TurnTo"]["Boss"].visible = true;
				}else{
					layer["TurnTo"]["Boss"].visible = false;
				}
				if(index > 1006){
					layer["TurnTo"]["Equip"].visible = true;
				}else{
					layer["TurnTo"]["Equip"].visible = false;
				}
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