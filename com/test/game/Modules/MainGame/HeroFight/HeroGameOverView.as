package com.test.game.Modules.MainGame.HeroFight
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.FunnyBossManager;
	import com.test.game.Manager.HeroFightManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.control.key.GotoFunnyBattleControl;
	import com.test.game.Mvc.control.key.GotoHeroBattleControl;
	import com.test.game.Utils.AllUtils;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class HeroGameOverView extends BaseView
	{
		public function HeroGameOverView()
		{
			super();
			start();
		}
		
		private function start() : void{
			layer = AssetsManager.getIns().getAssetObject("HeroFightFailureView") as Sprite;
			this.addChild(layer);
			
			initUI();
			initBg();
			setCenter();
		}
		
		private function initUI() : void{
			reliveBtn.addEventListener(MouseEvent.CLICK, onRelive);
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
		}
		
		protected function onClose(e:MouseEvent) : void{
			if(SceneManager.getIns().sceneType == SceneManager.HERO_SCENE){
				HeroFightManager.getIns().heroFightOver();
			}else if(SceneManager.getIns().sceneType == SceneManager.FUNNY_SCENE){
				FunnyBossManager.getIns().funyFailureOver();
			}
			this.hide();
		}
		
		protected function onRelive(e:MouseEvent) : void{
			var count:int;
			if(SceneManager.getIns().sceneType == SceneManager.HERO_SCENE){
				count = AllUtils.getSquareNum(HeroFightManager.getIns().reliveCount, NumberConst.getIns().two);
				if(PackManager.getIns().searchItemNum(NumberConst.getIns().lifeCoinId) >= count){
					PackManager.getIns().reduceItem(NumberConst.getIns().lifeCoinId, count);
					HeroFightManager.getIns().reliveCount++;
					(ControlFactory.getIns().getControl(GotoHeroBattleControl) as GotoHeroBattleControl).gameRelive();
					hide();
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("当前复活币不足");
				}
			}else if(SceneManager.getIns().sceneType == SceneManager.FUNNY_SCENE){
				count = AllUtils.getSquareNum(FunnyBossManager.getIns().reliveCount, NumberConst.getIns().two);
				if(PackManager.getIns().searchItemNum(NumberConst.getIns().lifeCoinId) >= count){
					PackManager.getIns().reduceItem(NumberConst.getIns().lifeCoinId, count);
					FunnyBossManager.getIns().reliveCount++;
					(ControlFactory.getIns().getControl(GotoFunnyBattleControl) as GotoFunnyBattleControl).gameRelive();
					hide();
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("当前复活币不足");
				}
			}
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			fuHuoBi.text = "剩余数量  " + PackManager.getIns().searchItemNum(NumberConst.getIns().lifeCoinId).toString();
			if(SceneManager.getIns().sceneType == SceneManager.HERO_SCENE){
				fuHuoBiUse.text = "消耗  " + (AllUtils.getSquareNum(HeroFightManager.getIns().reliveCount, NumberConst.getIns().two)).toString();
			}else if(SceneManager.getIns().sceneType == SceneManager.FUNNY_SCENE){
				fuHuoBiUse.text = "消耗  " + (AllUtils.getSquareNum(FunnyBossManager.getIns().reliveCount, NumberConst.getIns().two)).toString();
			}
			
			update();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function get reliveBtn() : SimpleButton{
			return layer["ReliveBtn"];
		}
		private function get closeBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
		private function get fuHuoBiUse() : TextField{
			return layer["FuHuoBiUse"]
		}
		private function get fuHuoBi() : TextField{
			return layer["FuHuoBi"]
		}
	}
}