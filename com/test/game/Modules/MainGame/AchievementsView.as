package com.test.game.Modules.MainGame
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Modules.MainGame.Info.GetSpecialView;
	import com.test.game.Modules.MainGame.Tip.GetFiveCardView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.SignBossIcon;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class AchievementsView extends BaseView
	{
		private var _signMonthInfo:Object;
		private var _purpleBoss:ItemVo;
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public function AchievementsView()
		{
			super();
		}
		override public function init() : void{
			super.init();
			start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("AchievementsView") as Sprite;
				this.addChild(layer);
				
				initParams();
				initUI();
				setParams();
				setCenter();
			}
		}
		
		private function initParams():void{
			var time:Array = TimeManager.getIns().curTimeStr.split("-");
			_signMonthInfo = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SIGN_MONTH, "month", time[0] + "-" + time[1]);
		}
		
		private function initUI():void{
			initBg();
			signInBtn.addEventListener(MouseEvent.CLICK, onSignIn);
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			exchangeBtn.addEventListener(MouseEvent.CLICK, onExchange);
			fiveGetBtn.addEventListener(MouseEvent.CLICK, onFiveGet);
			normalGetBtn.addEventListener(MouseEvent.CLICK, onNormalGet);
			initFreePurpleBoss();
		}
		
		protected function onNormalGet(event:MouseEvent):void{
			if(player.signInVo.achievements >= NumberConst.getIns().normalBossCount){
				var bossCard:Vector.<ItemVo> = PackManager.getIns().curBossCardData;
				var itemVo:ItemVo = bossCard[int(bossCard.length * Math.random())];
				if(PackManager.getIns().checkMaxRooM([itemVo])){
					var bossItemVo:ItemVo;
					this.mouseChildren = false;
					SaveManager.getIns().onSaveGame(
						function () : void{
							if(Math.random() <= NumberConst.getIns().greenCardRate){
								bossItemVo = PackManager.getIns().creatBossData(itemVo.specialConfig.bid, 4)
							}else{
								bossItemVo = PackManager.getIns().creatBossData(itemVo.specialConfig.bid, 1)
							}
							PackManager.getIns().addItemIntoPack(bossItemVo);
							player.signInVo.achievements -= NumberConst.getIns().normalBossCount;
						},
						function () : void{
							(ViewFactory.getIns().initView(GetSpecialView) as GetSpecialView).setSpecial(bossItemVo, bossItemVo.name);
							(ViewFactory.getIns().initView(GetSpecialView) as GetSpecialView).show();
							fiveGetComplete();
						});
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"背包空间不足！\n请留出空间后再使用");
				}
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"成就不足，无法兑换！");
			}
		}
		
		private function fiveGetComplete() : void{
			this.mouseChildren = true;
			update();
		}
		
		protected function onFiveGet(event:MouseEvent):void{
			if(player.signInVo.achievements >= NumberConst.getIns().fiveBossCount){
				var bossCard:Vector.<ItemVo> = PackManager.getIns().curBossCardData;
				var getBossCard:Array = new Array();
				var lastBossCard:Vector.<ItemVo> = new Vector.<ItemVo>();
				for(var i:int = 0; i < 5; i++){
					getBossCard.push(bossCard[int(Math.random() * bossCard.length)].copy());
				}
				
				if(PackManager.getIns().checkMaxRooM(getBossCard)){
					var card:ItemVo;
					this.mouseChildren = false;
					SaveManager.getIns().onSaveGame(
						function () : void{
							card = getBossCard.pop();
							if(Math.random() <= NumberConst.getIns().purpleCardRate){
								lastBossCard.push(PackManager.getIns().creatBossData(card.specialConfig.bid, NumberConst.getIns().ten));
							}else{
								lastBossCard.push(PackManager.getIns().creatBossData(card.specialConfig.bid, NumberConst.getIns().seven));
							}
							
							for(var j:int = 0; j < getBossCard.length; j++){
								card = getBossCard[j];
								if(Math.random() <= NumberConst.getIns().greenCardRate){
									lastBossCard.push(PackManager.getIns().creatBossData(card.specialConfig.bid, NumberConst.getIns().four));
								}else{
									lastBossCard.push(PackManager.getIns().creatBossData(card.specialConfig.bid, NumberConst.getIns().one));
								}
							}
							for(var k:int = 0; k < lastBossCard.length; k++){
								PackManager.getIns().addItemIntoPack(lastBossCard[k]);
							}
							player.signInVo.achievements -= NumberConst.getIns().fiveBossCount;
							(ViewFactory.getIns().initView(GetFiveCardView) as GetFiveCardView).setSpecial(lastBossCard);
							ViewFactory.getIns().initView(GetFiveCardView).show();
						}, getComplete);
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"背包空间不足！\n请留出空间后再使用");
				}
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"成就不足，无法兑换！");
			}
		}
		
		private function getComplete() : void{
			mouseChildren = true;
			update();
		}
		
		protected function onExchange(e:MouseEvent):void{
			if(player.signInVo.achievements >= NumberConst.getIns().purpleBossCount){
				if(PackManager.getIns().checkMaxRooM([_purpleBoss])){
					PackManager.getIns().addItemIntoPack(_purpleBoss.copy());
					player.signInVo.achievements -= NumberConst.getIns().purpleBossCount;
					(ViewFactory.getIns().initView(GetSpecialView) as GetSpecialView).setSpecial(_purpleBoss, _purpleBoss.name);
					(ViewFactory.getIns().initView(GetSpecialView) as GetSpecialView).show();
					update();
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"背包空间不足！\n请留出空间后再使用");
				}
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"成就不足，无法兑换！");
			}
		}
		
		protected function onClose(e:MouseEvent):void{
			this.hide();
		}
		
		protected function onSignIn(e:MouseEvent):void{
			this.hide();
			ViewFactory.getIns().getView(SignInView).show();
		}
		
		private function initFreePurpleBoss():void{
			_purpleBoss = PackManager.getIns().creatBossData(ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SPECIAL, "id", _signMonthInfo.purple).bid,
				int((_signMonthInfo.purple - 10000) / 100) + 1);
			var itemIcon:SignBossIcon = new SignBossIcon();
			itemIcon.setData(_purpleBoss);
			itemIcon.x = 48;
			itemIcon.y = 130;
			layer.addChild(itemIcon);
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			update();
		}
		
		override public function update():void{
			
			signInAchievements.text = player.signInVo.achievements.toString();
		}
		
		public function get signInBtn() : SimpleButton{
			return layer["SignInBtn"];
		}
		public function get closeBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
		public function get signInAchievements() : TextField{
			return layer["SignInAchievements"]
		}
		public function get exchangeBtn() : SimpleButton{
			return layer["ExchangeBtn"];
		}
		public function get fiveGetBtn() : SimpleButton{
			return layer["FiveGetBtn"];
		}
		public function get normalGetBtn() : SimpleButton{
			return layer["NormalGetBtn"];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
	}
}