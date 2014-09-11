package com.test.game.Modules.MainGame.PlayerKilling
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Effect.PkExpBar;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.Pipei.PlayerKillingManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class PlayerKillingOverView extends BaseView
	{
		public var resultType:int = 0;
		public var showType:int = 0;
		private var _winAndLose:Sprite;
		private var _expBar:PkExpBar;
		private var _exp:int;
		private var _objInfo:Object;
		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function PlayerKillingOverView(){
			super();
			start();
		}
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("PlayerKillingOverView") as Sprite;
				layer.x = GameConst.stage.stageWidth * .5;
				layer.y = GameConst.stage.stageHeight * .5;
				_winAndLose = AssetsManager.getIns().getAssetObject("PlayerKillingWinAndLose") as Sprite;
				_winAndLose.x = GameConst.stage.stageWidth * .5;
				_winAndLose.y = GameConst.stage.stageHeight * .5;
				
				initParams();
				initUI();
				initBg();
			}
		}
		
		private function initParams():void{
			
		}
		
		private function initUI():void{
			restartPK.addEventListener(MouseEvent.CLICK, onRestartPK);
			quitPK.addEventListener(MouseEvent.CLICK, onQuitPK);
			
			pkBarLv.gotoAndStop(1);
		}
		
		protected function onQuitPK(event:MouseEvent):void{
			PlayerKillingManager.getIns().playerKillingOver();
			this.hide();
		}
		
		protected function onRestartPK(event:MouseEvent):void{
			PlayerKillingManager.getIns().restartPlayerKilling();
			this.hide();
		}
		
		public function setAllData(type:int) : void{
			resultType = type;
			_objInfo = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.PK_EXP, "lv", PlayerManager.getIns().player.pkInfo.pkLv);
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			setData();
			if(showType == 0){
				startMove();
			}else{
				onStep2();
			}
		}
		
		private function startMove():void{
			if(layer.parent != null){
				layer.parent.removeChild(layer);
			}
			this.addChild(_winAndLose);
			_winAndLose.scaleX = 5;
			_winAndLose.scaleY = 5;
			_winAndLose.alpha = 1;
			TweenLite.to(_winAndLose, .5, {scaleX:1, scaleY:1, ease:Bounce.easeOut, onComplete:onStep1});
		}
		
		private function onStep1() : void{
			TweenLite.to(_winAndLose, 1.2, {alpha:0, onComplete:onStep2});
		}
		
		public function onStep2() : void{
			if(_winAndLose.parent != null){
				_winAndLose.parent.removeChild(_winAndLose);
			}
			this.addChild(layer);
			layer.scaleX = 0;
			layer.scaleY = 0;
			TweenLite.to(layer, .5, {scaleX:1, scaleY:1, ease:Back.easeOut, onComplete:changeExpBar});
		}
		
		private function changeExpBar() : void{
			_expBar = new PkExpBar();
			_expBar.createExpBar((layer["PKExpBar"] as Sprite), _exp);
			_expBar.start();
		}
		
		private function setData():void{
			if(resultType == 0){
				pkExpTF.text = _objInfo.loserexp;
				pkSoulTF.text = _objInfo.losersoul;
				resultTitle.gotoAndStop(2);
				_exp = _objInfo.loserexp;
			}else if(resultType == 1){
				pkExpTF.text = _objInfo.winnerexp;
				pkSoulTF.text = _objInfo.winnersoul;
				resultTitle.gotoAndStop(1);
				_exp = _objInfo.winnerexp;
			}
			
			//pkBarLv.gotoAndStop(player.pkInfo.pkLv);
			//pkBarExp.text = (player.pkInfo.pkExp - player.pkInfo.preExp) + "/" + (player.pkInfo.nowExp - player.pkInfo.preExp);
			//pkExpBar.width = (player.pkInfo.pkExp - player.pkInfo.preExp) / (player.pkInfo.nowExp - player.pkInfo.preExp) * 229;
		}
		
		public function updateTF(hours:int, minute:int, second:int) : void{
			if(layer == null) return;
			coolDownTF.text = (hours * 60 + minute) + ":" + second;
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		private function get resultTitle() : MovieClip{
			return layer["ResultTitle"];
		}
		
		private function get restartPK() : SimpleButton{
			return layer["RestartPK"];
		}
		
		private function get quitPK() : SimpleButton{
			return layer["QuitPK"];
		}
		
		private function get coolDownTF() : TextField{
			return layer["CoolDownTF"];
		}
		
		private function get pkExpTF() : TextField{
			return layer["PKExpTF"];
		}
		
		private function get pkSoulTF() : TextField{
			return layer["PKSoulTF"];
		}
		
		private function get pkBarLv() : MovieClip{
			return layer["PKExpBar"]["PKLv"];
		}
		
		private function get pkBarExp() : TextField{
			return layer["PKExpBar"]["PKTF"];
		}
		
		private function get pkExpBar() : Sprite{
			return layer["PKExpBar"]["PKExpBar"];
		}
	}
}