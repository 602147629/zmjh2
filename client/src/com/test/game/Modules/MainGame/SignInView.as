package com.test.game.Modules.MainGame
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.greensock.TweenMax;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Modules.MainGame.Info.GetSpecialView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Configuration.SignMonth;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ItemIcon;
	import com.test.game.UI.SignBossIcon;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SignInView extends BaseView
	{
		private var _anti:Antiwear;
		private function get signInInfo() : Array{
			return _anti["signInInfo"];
		}
		private function set signInInfo(value:Array) : void{
			_anti["signInInfo"] = value;
		}
		private var _signMonthInfo:SignMonth;
		private var _signInIconList:Array;
		private var _itemDataList:Array;
		private var _purpleBoss:ItemVo;
		private var _lightBG:MovieClip;
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public function SignInView()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["signInInfo"] = new Array();
			
			start();
		}
		override public function init() : void{
			super.init();
			/*AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.SIGNINVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();*/
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.SIGNINVIEW.split("/")[1]) as Sprite;
				this.addChild(layer);
				layer.visible = false;
				
				initParams();
				initUI();
				setParams();
				setCenter();
				openTween();
			}
		}
		
		private function initParams():void{
			signInInfo = ConfigurationManager.getIns().getAllData(AssetsConst.SIGN_IN);
			var time:Array = TimeManager.getIns().curTimeStr.split("-");
			_signMonthInfo = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SIGN_MONTH, "month", time[0] + "-" + time[1]) as SignMonth;
		}
		
		private function initUI():void{
			initBg();
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			exchangeBtn.addEventListener(MouseEvent.CLICK, onExchangeBoss);
			refreshBtn.addEventListener(MouseEvent.CLICK, onRefresh);
			achievementAreaBtn.addEventListener(MouseEvent.CLICK, onAchievementArea);
			initSignInIcon();
			initFreeBossIcon();
			initFreePurpleBoss();
			_lightBG = AssetsManager.getIns().getAssetObject("SignInLightMc") as MovieClip;
			_lightBG.mouseEnabled = false;
		}
		
		protected function onAchievementArea(e:MouseEvent):void{
			this.hide();
			ViewFactory.getIns().initView(AchievementsView).show();
		}
		
		protected function onRefresh(e:MouseEvent):void{
			if(player.signInVo.signInCount < (NumberConst.getIns().twenty + NumberConst.getIns().five)){
				var count:int;
				if(player.signInVo.signInCount < NumberConst.getIns().ten){
					count = 1;
				}else if(player.signInVo.signInCount >= NumberConst.getIns().ten
					&& player.signInVo.signInCount < NumberConst.getIns().twenty){
					count = 2;
				}else{
					count = 3;
				}
				var num:int = PackManager.getIns().searchItemNum(NumberConst.getIns().refreshCouponId);
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice(
					"是否花费" + count + "张刷新券？\n当前拥有刷新券：" + num, startRefresh);
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"本月已全部签到！");
			}
		}
		
		private function startRefresh() : void{
			if(player.signInVo.signInCount < NumberConst.getIns().ten){
				if(PackManager.getIns().searchItemNum(NumberConst.getIns().refreshCouponId) >= NumberConst.getIns().one){
					signComplete(NumberConst.getIns().one);
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"刷新券不足！");
				}
			}else if(player.signInVo.signInCount >= NumberConst.getIns().ten
				&& player.signInVo.signInCount < NumberConst.getIns().twenty){
				if(PackManager.getIns().searchItemNum(NumberConst.getIns().refreshCouponId) >= NumberConst.getIns().two){
					signComplete(NumberConst.getIns().two);
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"刷新券不足！");
				}
			}else{
				if(PackManager.getIns().searchItemNum(NumberConst.getIns().refreshCouponId) >= NumberConst.getIns().three){
					signComplete(NumberConst.getIns().three);
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"刷新券不足！");
				}
			}
		}
		
		protected function onExchangeBoss(e:MouseEvent):void{
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
		
		private function initFreePurpleBoss():void{
			_purpleBoss = PackManager.getIns().creatBossDataBySpecial(_signMonthInfo.purple);
			var itemIcon:SignBossIcon = new SignBossIcon();
			itemIcon.setData(_purpleBoss);
			itemIcon.x = 45;
			itemIcon.y = 130;
			layer.addChild(itemIcon);
		}
		
		private function initFreeBossIcon():void{
			var itemVo1:ItemVo = PackManager.getIns().creatBossDataBySpecial(_signMonthInfo.green);
			var itemIcon1:ItemIcon = new ItemIcon();
			itemIcon1.menuable = false;
			itemIcon1.setData(itemVo1);
			itemIcon1.x = 4;
			itemIcon1.y = 4;
			freeBoss.addChild(itemIcon1);
			
			var itemVo2:ItemVo = PackManager.getIns().creatBossDataBySpecial(_signMonthInfo.blue);
			var itemIcon2:ItemIcon = new ItemIcon();
			itemIcon2.menuable = false;
			itemIcon2.setData(itemVo2);
			itemIcon2.x = 59;
			itemIcon2.y = 4;
			freeBoss.addChild(itemIcon2);
		}
		
		private function initSignInIcon():void{
			_signInIconList = new Array();
			_itemDataList = new Array();
			for(var i:int = 0; i < 25; i++){
				var icon:Sprite = AssetsManager.getIns().getAssetObject("SignInIcon") as Sprite;
				(icon["SignDate"] as TextField).text = (i + 1).toString();
				(icon["AlreadySign"] as MovieClip).visible = false;
				icon.x = i % 5 * 51 + 170;
				icon.y = int(i / 5) * 51.5 + 80;
				icon.name = "sign" + i;
				icon.mouseChildren = true;
				icon.buttonMode = true;
				layer.addChild(icon);
				_signInIconList.push(icon);
				var itemVo:ItemVo = new ItemVo();
				if(signInInfo[i].Achievements == 0 && signInInfo[i].gold == 0 && signInInfo[i].soul == 0){
					if(signInInfo[i].prop_id == -1){
						itemVo = PackManager.getIns().creatBossDataBySpecial(_signMonthInfo.green);
					}else if(signInInfo[i].prop_id == -2){
						itemVo = PackManager.getIns().creatBossDataBySpecial(_signMonthInfo.blue);
					}else{
						itemVo = PackManager.getIns().creatItem(signInInfo[i].prop_id);
					}
					itemVo.num = signInInfo[i].number;
					var itemIcon:ItemIcon = new ItemIcon();
					itemIcon.menuable = false;
					itemIcon.setData(itemVo);
					itemIcon.x = 1;
					itemIcon.y = 5;
					icon.addChildAt(itemIcon, 1);
					_itemDataList.push(itemVo);
				}else{
					var sp:Sprite;
					if(signInInfo[i].Achievements != 0){
						sp = SignIcon(0, signInInfo[i].Achievements);
						icon.addChildAt(sp, 1);
					}else if(signInInfo[i].gold != 0){
						sp = SignIcon(1, signInInfo[i].gold);
						icon.addChildAt(sp, 1);
					}else if(signInInfo[i].soul != 0){
						sp = SignIcon(2, signInInfo[i].soul);
						icon.addChildAt(sp, 1);
					}
					_itemDataList.push(sp);
				}
			}
		}
		
		private function SignIcon(type:int, number:int) : Sprite{
			var icon:Sprite = AUtils.getNewObj("SignSpecialIcon") as Sprite;
			icon["NumberTF"].text = number.toString();
			var bne:BaseNativeEntity = new BaseNativeEntity();
			(icon["AchievementsTF"] as TextField).visible = false;
			switch(type){
				case 0:
					(icon["AchievementsTF"] as TextField).visible = true;
					break;
				case 1:
					bne.x = 8;
					bne.y = 8;
					bne.data.bitmapData = AUtils.getNewObj("WeatherMoney") as BitmapData;
					break;
				case 2:
					bne.x = 10;
					bne.y = 5;
					bne.data.bitmapData = AUtils.getNewObj("WeatherSoul") as BitmapData;
					break;
			}
			icon.addChild(bne);
			return icon;
		}
		
		
		private function openTween():void{
			layer.scaleX = layer.scaleY = 0;
			layer.visible = true;
			TweenMax.fromTo(layer,0.4,{scaleX:0,scaleY:0,x:830,y:492},{scaleX:1,scaleY:1,x:this.centerX,y:this.centerY});			
		}
		
		private function closeTween():void{
			TweenMax.to(layer,0.4,{scaleX:0,scaleY:0,x:830,y:492,onComplete:hide});			
		}
		
		protected function onClose(event:MouseEvent):void{
			closeTween();
		}
		
		protected function onSignIn(e:MouseEvent):void{
			if(getSignIn()){
				var index:int = player.signInVo.signInCount;
				_signInIconList[index].buttonMode = false;
				_signInIconList[index].removeEventListener(MouseEvent.CLICK, onSignIn);
				player.signInVo.signInCount++;
				player.signInVo.signInTime = TimeManager.getIns().returnTimeNowStr();
				update();
				GuideManager.getIns().signInGuideSetting();
				SaveManager.getIns().onSaveGame();
			}
		}
		
		private function signComplete(count:int = 0) : void{
			if(getSignIn()){
				if(count != 0){
					PackManager.getIns().reduceItem(NumberConst.getIns().refreshCouponId, count);
				}
				var index:int = player.signInVo.signInCount;
				_signInIconList[index].buttonMode = false;
				_signInIconList[index].removeEventListener(MouseEvent.CLICK, onSignIn);
				player.signInVo.signInCount++;
				update();
				GuideManager.getIns().signInGuideSetting();
				SaveManager.getIns().onSaveGame();
			}
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			player.signInVo.resetSignIn();
			update();
		}
		
		override public function update() : void{
			var index:int = player.signInVo.signInCount;
			if(_lightBG != null && _lightBG.parent != null){
				_lightBG.parent.removeChild(_lightBG);
			}
			for(var i:int = 0; i < _signInIconList.length; i++){
				if(i < index){
					(_signInIconList[i]["AlreadySign"] as MovieClip).visible = true;
					(_signInIconList[i]["SignIconBg"] as MovieClip).gotoAndStop(2);
				}else{
					(_signInIconList[i]["AlreadySign"] as MovieClip).visible = false;
					(_signInIconList[i]["SignIconBg"] as MovieClip).gotoAndStop(1);
				}
				if(_signInIconList[i].hasEventListener(MouseEvent.CLICK)){
					_signInIconList[i].removeEventListener(MouseEvent.CLICK, onSignIn);
				}
				if(i == index && player.signInVo.canSignIn){
					_signInIconList[i].addEventListener(MouseEvent.CLICK, onSignIn);
					_lightBG.x = _signInIconList[i].x - 3;
					_lightBG.y = _signInIconList[i].y + 1;
					layer.addChildAt(_lightBG, layer.getChildIndex(_signInIconList[i]));
				}
			}
			
			signInTime.text = (25 - index).toString();
			signInAchievements.text = player.signInVo.achievements.toString();
			
			//兑换按钮
			if(player.signInVo.achievements >= NumberConst.getIns().purpleBossCount){
				GreyEffect.reset(exchangeBtn);
				exchangeBtn.mouseEnabled = true;
			}else{
				GreyEffect.change(exchangeBtn);
				exchangeBtn.mouseEnabled = false;
			}
		}
		
		private function getSignIn():Boolean{
			var result:Boolean = true;
			var signIn:Object = signInInfo[player.signInVo.signInCount];
			var items:Array = signIn.prop_id.split("|");
			var itemNums:Array = signIn.number.split("|");
			var itemVos:Array = new Array();
			for(var index:int = 0; index<items.length; index++){
				if(int(items[index]) != 0){
					var item:ItemVo;
					if(int(items[index]) == -1 || int(items[index]) == -2){
						item = _itemDataList[player.signInVo.signInCount];
					}else{
						item = PackManager.getIns().creatItem(items[index]);
					}
					item.num = itemNums[index];
					itemVos.push(item);
				}
			}
			if(PackManager.getIns().checkMaxRooM(itemVos)){
				var message:Array = [];
				for(var i:int = 0; i<items.length; i++){
					if(items[i] == 0) continue;
					PackManager.getIns().addItemIntoPack(_itemDataList[player.signInVo.signInCount].copy());
					message.push(_itemDataList[player.signInVo.signInCount].name + "X" + _itemDataList[player.signInVo.signInCount].num);
				}
				
				if(signIn.gold>0){
					PlayerManager.getIns().checkAdd("sign_money",signIn.gold,10000);
					PlayerManager.getIns().addMoney(signIn.gold);
					message.push("金钱X" + signIn.gold);
				}
				if(signIn.soul>0){
					PlayerManager.getIns().checkAdd("sign_soul",signIn.soul,10000);
					PlayerManager.getIns().addSoul(signIn.soul);
					message.push("战魂X" + signIn.soul);
				}
				if(signIn.Achievements>0){
					player.signInVo.achievements += signIn.Achievements;
					message.push("签到成就X" + signIn.Achievements)
				}
				
				ViewFactory.getIns().getView(MainToolBar).update();
				
				GuideManager.getIns().bagGuideSetting();
				DeformTipManager.getIns().allCheck();
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"今日签到成功\n获得\n"+ getMessageStr(message),function () : void{GuideManager.getIns().signInGuideSetting();});
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"背包空间不足！\n请留出空间后再使用");
				result = false;
			}
			return result;
		}
		
		private function getMessageStr(message:Array) : String{
			var result:String = "";
			for(var i:int = 0; i < message.length; i++){
				if(i != 0) result += "、";
				result += message[i];
			}
			return result;
		}
		
		override public function show():void{
			if(layer == null) return;
			openTween();
			update();
			super.show();
		}
		
		override public function hide() : void{
			super.hide();
			GuideManager.getIns().signInGuideSetting(true);
		}
		
		public function get freeBoss() : Sprite{
			return layer["FreeBoss"];
		}
		public function get signInAchievements() : TextField{
			return layer["SignInAchievements"];
		}
		public function get signInTime() : TextField{
			return layer["SignInTime"];
		}
		public function get closeBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
		public function get exchangeBtn() : SimpleButton{
			return layer["ExchangeBtn"];
		}
		public function get refreshBtn() : SimpleButton{
			return layer["RefreshBtn"];
		}
		public function get achievementAreaBtn() : SimpleButton{
			return layer["AchievementAreaBtn"];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
	}
}