package com.test.game.Modules.MainGame.PlayerKilling
{
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.ViewTweenEffect;
	import com.test.game.Manager.ExtraBarManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.Pipei.PlayerKillingManager;
	import com.test.game.Modules.MainGame.Tip.ClearCoolDownView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class PlayerKillingFightView extends BaseView
	{
		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public function PlayerKillingFightView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([], [AssetsUrl.getAssetObject(AssetsConst.PLAYERKILLINGFIGHTVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.PLAYERKILLINGFIGHTVIEW.split("/")[1]) as Sprite;
				this.addChild(layer);
				layer.visible = false;
				initParams();
				initUI();
				setParams();
				setCenter();
				openTween();
			}
		}
		
		private function initUI() : void{
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			requestFightBtn.addEventListener(MouseEvent.CLICK, onAutoPipei);
			requestFightBtn.buttonMode = true;
			initBg();
		}
		
		public function onAutoPipei(event:MouseEvent = null):void{
			if(PlayerKillingManager.getIns().isCanPK){
				if(PlayerManager.getIns().player.pkInfo.pkCanStart == 1){
					PlayerKillingManager.getIns().startAutoPipei(showWaitView);
					this.hide();
				}else{
					(ViewFactory.getIns().initView(ClearCoolDownView) as ClearCoolDownView).setFun("您的请战CD已超过一个小时，无法继续请战，请等待CD冷却。\n（vip3的玩家可以清除CD）", null, clearPKTime);
				}
			}else{
				(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun("服务器关闭，无法请战！");
			}
		}
		
		private function clearPKTime() : void{
			var count:int = PlayerKillingManager.getIns().pkMinute;
			(ViewFactory.getIns().getView(TipView) as TipView).setFun("是否花费点券" + count * 5 + "清除请战CD？", sendClearData); 
		}
		
		private function sendClearData() : void{
			if(GameConst.localLogin){
				PlayerKillingManager.getIns().clearPKTime(0);
			}else{
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"系统正在处理当中，请稍等...",null,null,true);
				SaveManager.getIns().onJudgeMulti(
					function () : void{
						var num:int = PlayerKillingManager.getIns().pkMinute;
						var data:Object = {propId:"1562",count:num,price:NumberConst.getIns().five,idx:PlayerManager.getIns().player.index,tag:"pk"};
						ShopManager.getIns().buyPropNd(data, PlayerKillingManager.getIns().clearPKTime);
					});
			}
		}
		
		private function showWaitView() : void{
			this.hide();
			ViewFactory.getIns().initView(PlayerKillingWaitView).show();
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			update();
		}
		
		private function openTween():void{
			var pos:Point = ExtraBarManager.getIns().getBtnPos("PK");
			ViewTweenEffect.openTween(layer, pos.x, pos.y, centerX, centerY);
		}
		
		private function closeTween():void{
			var pos:Point = ExtraBarManager.getIns().getBtnPos("PK");
			ViewTweenEffect.closeTween(layer, pos.x, pos.y, hide);
		}
		
		override public function show() : void{
			if(layer == null) return;
			openTween();
			update();
			super.show();
		}
		
		protected function onClose(event:MouseEvent):void{
			closeTween();
		}
		
		override public function update():void{
			if(PlayerManager.getIns().player.pkInfo.pkCanStart == 1){
				requestFightBtn.mouseEnabled = true;
				//GreyEffect.reset(requestFightBtn);
			}else{
				requestFightBtn.mouseEnabled = false;
				//GreyEffect.change(requestFightBtn);
			}
			updateTF(0,0,0);
			pkBarLv.gotoAndStop(player.pkInfo.pkLv);
			if(player.pkInfo.pkLv >= 10){
				pkBarExp.text = "0/0";
				pkExpBar.width = 229;
			}else{
				pkBarExp.text = (player.pkInfo.pkExp - player.pkInfo.preExp) + "/" + (player.pkInfo.nowExp - player.pkInfo.preExp);
				pkExpBar.width = (player.pkInfo.pkExp - player.pkInfo.preExp) / (player.pkInfo.nowExp - player.pkInfo.preExp) * 229;
			}
		}
		
		public function updateTF(hours:int, minute:int, second:int) : void{
			if(layer == null) return;
			pkCoolDown.text = "请战冷却：" + (hours * 60 + minute) + ":" + second;
		}
		
		private function initParams() : void{
			
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function get closeBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
		private function get requestFightBtn() : Sprite{
			return layer["RequestFightBtn"];
		}
		private function get pkCoolDown() : TextField{
			return layer["RequestFightBtn"]["PKCoolDown"];
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