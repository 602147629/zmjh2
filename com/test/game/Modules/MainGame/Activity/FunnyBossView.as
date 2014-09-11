package com.test.game.Modules.MainGame.Activity
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.FunnyBossManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class FunnyBossView extends BaseView
	{
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public function FunnyBossView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.FUNNYBOSSVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.FUNNYBOSSVIEW.split("/")[1]) as Sprite;
				this.addChild(layer);
				
				initUI();
				setParams();
				initBg();
				setCenter();
			}
		}
		
		private function initUI() : void{
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			startChallengeBtn.addEventListener(MouseEvent.CLICK, onStartChallenge);
		}
		
		protected function onStartChallenge(e:MouseEvent) : void{
			FunnyBossManager.getIns().startFunnyBoss();
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			update();
		}
		override public function update():void{
			challengeCount.text = (1 - player.statisticsInfo.funnyBossCount).toString();
		}
		
		protected function onClose(e:MouseEvent) : void{
			this.hide();
		}
		
		private function get closeBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
		private function get challengeCount() : TextField{
			return layer["ChallengeCount"];
		}
		private function get startChallengeBtn() : SimpleButton{
			return layer["StartChallengeBtn"];
		}
	}
}