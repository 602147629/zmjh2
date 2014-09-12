package com.test.game.Modules.MainGame.MainUI
{
	import com.gameServer.ApiFor4399;
	import com.greensock.TweenLite;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.GuideConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Event.ServerEvent;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.BagView;
	import com.test.game.Modules.MainGame.SignInView;
	import com.test.game.Modules.MainGame.StartPageView;
	import com.test.game.Modules.MainGame.Achieve.AchieveView;
	import com.test.game.Modules.MainGame.Escort.EscortView;
	import com.test.game.Modules.MainGame.FirstCharge.FirstChargeView;
	import com.test.game.Modules.MainGame.Gift.GiftView;
	import com.test.game.Modules.MainGame.Guide.OneKeyEquipView;
	import com.test.game.Modules.MainGame.Info.InfoView;
	import com.test.game.Modules.MainGame.JingMai.JingMaiView;
	import com.test.game.Modules.MainGame.Mission.MissionView;
	import com.test.game.Modules.MainGame.Role.RoleDetailView;
	import com.test.game.Modules.MainGame.Shop.ShopView;
	import com.test.game.Modules.MainGame.Skill.SkillView;
	import com.test.game.Modules.MainGame.Strengthen.StrengthenView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Title.TitleView;
	import com.test.game.Modules.MainGame.boss.BossView;
	import com.test.game.Mvc.Vo.MissionVo;
	import com.test.game.Mvc.Vo.PackVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	
	public class MainToolBar extends BaseView
	{
		private var _player:PlayerVo;
		
		private var _saveCoolDown:int;//存档冷却时间
		public function MainToolBar()
		{
			layer = AssetsManager.getIns().getAssetObject("MainToolBar") as Sprite;
			this.addChild(layer);
			
			initEvents();
			update();
			
			renderShowUI();
			
			guideInit();
			
			super();
			
		}
		
	

		
		
		private function initEvents():void
		{
			ApiFor4399.getIns().stage.addEventListener(EventConst.SERVER_SAVE_DATA,onSaveBack);
			this.addEventListener(Event.ENTER_FRAME,coolDown);
			EventManager.getIns().addEventListener(EventConst.CHECK_BAG_FULL,checkBagFull);
			saveBtn.addEventListener(MouseEvent.CLICK,saveGAME);
			missionBtn.addEventListener(MouseEvent.CLICK,showMissionView);
			roleBtn.addEventListener(MouseEvent.CLICK,showRoleDetailView);
			bagBtn.addEventListener(MouseEvent.CLICK,showBagView);
			strengthenBtn.addEventListener(MouseEvent.CLICK,showStrengthenView);
			bossBtn.addEventListener(MouseEvent.CLICK,showBossView);
			skillBtn.addEventListener(MouseEvent.CLICK,showSkillView);
			quitBtn.addEventListener(MouseEvent.CLICK,quitToMenu);
			shopBtn.addEventListener(MouseEvent.CLICK,showShopView);
			signInBtn.addEventListener(MouseEvent.CLICK, showSignInView);
			//soulTips.addEventListener(MouseEvent.CLICK, onEscort2);
			
			achieveBtn.addEventListener(MouseEvent.CLICK,onAchieveShow);
			
			jingMaiBtn.addEventListener(MouseEvent.CLICK,onShowJingMai);
			singlePlayerBtn.addEventListener(MouseEvent.CLICK, onGotoDoule);
			doublePlayerBtn.addEventListener(MouseEvent.CLICK, onGotoSingle);
			TipsManager.getIns().addTips(singlePlayerBtn, {title:"点击切换至双人模式", tips:""});
			TipsManager.getIns().addTips(doublePlayerBtn, {title:"点击切换至单人模式", tips:""});
		}
		
		protected function onGotoSingle(e:MouseEvent) : void{
			(ViewFactory.getIns().initView(InfoView) as InfoView).setType(9, {title:"", detail:"进入单人模式"}); 
			GameSceneManager.getIns().partnerOperate = false;
			renderPlayerOperate();
		}
		
		protected function onGotoDoule(e:MouseEvent) : void{
			(ViewFactory.getIns().initView(InfoView) as InfoView).setType(9, {title:"", detail:"进入双人模式"}); 
			GameSceneManager.getIns().partnerOperate = true;
			renderPlayerOperate();
		}
		
		protected function showSignInView(e:MouseEvent):void{
			GuideManager.getIns().signInGuideSetting();
			ViewFactory.getIns().initView(SignInView).show();
			
			if(ViewFactory.getIns().getView(BagView) != null){
				ViewFactory.getIns().getView(BagView).hide();
			}
			if(ViewFactory.getIns().getView(RoleDetailView) != null){
				ViewFactory.getIns().getView(RoleDetailView).hide();
			}
		}
		
		private function signInUpdate() : void{
			if(player.mainMissionVo.id > 1010){
				(layer["SignIn"] as Sprite).visible = true;
			}else{
				(layer["SignIn"] as Sprite).visible = false;
			}
		}
		
		protected function onShowJingMai(event:MouseEvent):void{
			ViewFactory.getIns().initView(JingMaiView).show();
			GuideManager.getIns().jingMaiGuideSetting();
		}
		
		protected function onBroadCast(event:MouseEvent):void{
			//PublicNoticeManager.getIns().sendPublicNotice(5,"猛虎下山|狂拽");
			var jlayer:Object = {
				"result":{
					"type" : 5,
					"name" : PlayerManager.getIns().player.name,
					"info" : "猛虎下山|狂拽"
				}
			};
			EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.PUBLIC_NOTICE,jlayer));
		}
		
		protected function onAchieveShow(event:MouseEvent):void{
			ViewFactory.getIns().initView(AchieveView).show();
		}
		
		protected function onFirstChargeShow(event:MouseEvent):void{
			ViewFactory.getIns().initView(FirstChargeView).show();
		}
		
		protected function onEscort2(event:MouseEvent):void{
			ViewFactory.getIns().initView(EscortView).show();
			//EscortManager.getIns().startLootBattle();
		}
		
		private function guideInit():void{
			switch(GuideManager.getIns().guideInit()){
				case 1:
					addGuideTip(GuideConst.BAG);
					break;
				case 11:
					addGuideTip(GuideConst.SKILL);
					break;
				case 31:
					addGuideTip(GuideConst.SUMMON);
					break;
				case 41:
					addGuideTip(GuideConst.STRENGTHEN);
					break;
				default:
					destroyGuide();
					break;
			}
		}
		
		protected function quitToMenu(event:MouseEvent):void{
			(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice("是否确定退出江湖？",
				function () : void{
					SaveManager.getIns().quitToMain();
				});
		}
		

		
		private function btnEnable(btn:SimpleButton,enable:Boolean):void{
			if(enable){
				GreyEffect.reset(btn);
			}else{
				GreyEffect.change(btn);
			}
		}
			
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}

		
		private function coolDown(e:Event):void
		{
			if(_saveCoolDown>0){
				_saveCoolDown--;
				saveCoolDown.text = "("+ int(_saveCoolDown/30) +")";
			}else{
				saveCoolDown.text = "";
			}
		}		
		
		override public function update():void{
			_player =  PlayerManager.getIns().player;
			Money.text = NumberConst.numTranslate(_player.money);
			Soul.text = NumberConst.numTranslate(_player.soul);
			TipsManager.getIns().addTips(moneyTips,{title:"金钱："+_player.money, tips:""});
			TipsManager.getIns().addTips(soulTips,{title:"战魂："+_player.soul, tips:""});
			renderShowUI();
			checkBagFull(null);
			signInUpdate();
			renderPlayerOperate();
		}
		
		public function updateMoneyAndSoul() : void{
			_player =  PlayerManager.getIns().player;
			Money.text = NumberConst.numTranslate(_player.money);
			Soul.text = NumberConst.numTranslate(_player.soul);
			TipsManager.getIns().addTips(moneyTips,{title:"金钱："+_player.money, tips:""});
			TipsManager.getIns().addTips(soulTips,{title:"战魂："+_player.soul, tips:""});
		}
		
		private function renderPlayerOperate() : void{
			if(GameSceneManager.getIns().partnerOperate){
				singlePlayerBtn.visible = false;
				doublePlayerBtn.visible = true;
			}else{
				singlePlayerBtn.visible = true;
				doublePlayerBtn.visible = false;
			}
			if(ViewFactory.getIns().getView(RoleStateView) != null){
				(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).renderPartner();
			}
		}
		
		private function checkBagFull(e:Event):void
		{
			if(bagBtn.visible == true){
				bagFullIcon.x = layer["bag"].x+10;
				if(pack.packUsed>=pack.packMaxRoom){
					bagFullIcon.visible = true;
				}else{
					bagFullIcon.visible = false;
				}
			}
		}
		
		
		public function addGuideTip(name:String) : void{
			_nowGuideName = name;
			destroyGuide();
			if(name == GuideConst.MISSION){
				if(PlayerManager.getIns().player.mainMissionVo.id < 1003){
					_guideMC = GuideManager.getIns().getGuideMCByName("ClickThis", layer[name].x - 20, layer[name].y - 70);
				}else{
					_guideMC = GuideManager.getIns().getGuideMCByName(GuideManager.ARROW, layer[name].x + 10, layer[name].y - 40);
				}
			}else{
				_guideMC = GuideManager.getIns().getGuideMCByName("ClickThis", layer[name].x - 20, layer[name].y - 70);
			}
			layer.addChild(_guideMC);
		}
		
		//按钮不能点
		public function mouseEnable() : void{
			layer.mouseEnabled = false;
			for(var i:int = 0; i < _showList.length; i++){
				if(layer[_showList[i]].visible){
					layer[_showList[i]].mouseChildren = false;
				}
			}
		}
		//按钮可以点
		public function mouseAble() : void{
			layer.mouseEnabled = true;
			for(var i:int = 0; i < _showList.length; i++){
				if(layer[_showList[i]].visible){
					layer[_showList[i]].mouseChildren = true;
				}
			}
		}
		
		private var _nowGuideName:String;
		//移动图标
		public function moveIcon(name:String) : void{
			_nowGuideName = name;
			if(_nowGuideName != ""){
				layer[_nowGuideName].mouseChildren = false;
				layer[_nowGuideName].visible = true;
				layer[_nowGuideName][_nowGuideName][_nowGuideName + "Bg"].visible = false;
				layer[_nowGuideName][_nowGuideName][_nowGuideName + "Title"].visible = false;
				layer[_nowGuideName].x = 445;
				layer[_nowGuideName].y = 135 + layer[_nowGuideName].height;
			}
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		//图标显示判断
		private function renderShowUI():void{
			var mission:MissionVo = PlayerManager.getIns().player.mainMissionVo;
			//任务
			if((ViewFactory.getIns().getView(StartPageView) as StartPageView).isNew){
				showIcon("mission", false);
			}else{
				showIcon("mission");
			}
			//技能
			if(mission.id <= 1001){
				showIcon("skill", false);
			}else{
				showIcon("skill");
			}
			//召唤
			if(mission.id <= 1004){
				showIcon("summon", false);
			}else{
				showIcon("summon");
			}
			
			//强化
			if(mission.id <= 1002){
				showIcon("strengthen", false);
			}else{
				showIcon("strengthen");
			}
			
			//老朽的考验
			/*var num:int = 0;
			for(var i:int=0;i<player.achieveArr.length;i++){
				if(int(player.achieveArr[i])==1){
					num++;
				}
			}
			if(num == 6){
				achieve.visible = achieveBtn.visible = false;
			}else{
				achieve.visible = achieveBtn.visible = true;
			}*/
			
			
			renderPosition();
		}
		
		private var _showList:Array = ["quit", "summon", "strengthen", "jingmai", "skill", "bag", "role", "mission"];
		private var _showHeight:Array = [66.2, 68.9, 70.5, 95.90, 63.65, 65.9, 63.7, 63.8, 84.25];
		private var _guideMC:MovieClip;
		//重新排列图标
		public function renderPosition(rightNow:Boolean = true):void{4
			var result:Array = [];
			var resultHeight:Array = [];
			for(var i:int = 0; i < _showList.length; i++){
				if(layer[_showList[i]].visible){
					result.push(layer[_showList[i]]);
					resultHeight.push(_showHeight[i]);
				}
			}
			if(rightNow){
				for(var j:int = 0; j < result.length; j++){
					result[j].x = 768 - j * 55;
					result[j].y = 580 - resultHeight[j];
				}
				layer["MainBg"].width = 150 + result.length * 64;
			}else{
				TweenLite.to(layer["MainBg"], 1, {width:150 + result.length * 64});
				for(var k:int = 0; k < result.length; k++){
					if(result[k].name == GuideConst.BAG){
						if(ViewFactory.getIns().getView(OneKeyEquipView) != null){
							(ViewFactory.getIns().getView(OneKeyEquipView) as OneKeyEquipView).tweenlitePosition(618 - k * 55);
						}
					}
					TweenLite.to(result[k], 1, {x:768 - k * 55, y:580 - resultHeight[k],
						onComplete:function(params:MovieClip) : void{
							params.mouseChildren = true;
							if(_nowGuideName != "" && params.name == _nowGuideName){
								layer[_nowGuideName][_nowGuideName][_nowGuideName + "Bg"].visible = true;
								layer[_nowGuideName][_nowGuideName][_nowGuideName + "Title"].visible = true;
								addGuideTip(_nowGuideName);
							}
						},
						onCompleteParams:[result[k]]
					});
				}
			}
		}
		
		private function showIcon(name:String, show:Boolean = true) : void{
			if(show){
				layer[name].visible = true;
			}else{
				layer[name].visible = false;
			}
		}
		
		private function onSaveBack(e:ServerEvent):void
		{
			if(e.result){
				_saveCoolDown=30*30;
			}
		}	
		
		public function saveGAME(e:MouseEvent = null):void{
			if(_saveCoolDown==0){
				SaveManager.getIns().onSaveGame();
			}
		}
		
		private function showMissionView(e:MouseEvent):void
		{
			hideGuideMC(e.target.name);
			
			hideView(StrengthenView);
			hideView(BagView);
			hideView(RoleDetailView);
			
			ViewFactory.getIns().initView(MissionView).show();
		}
		
		private function showRoleDetailView(e:MouseEvent):void{
			hideGuideMC(e.target.name);
			
			hideView(StrengthenView);
			hideView(MissionView);
			
			ViewFactory.getIns().initView(RoleDetailView).show();
		}
		
		private function showBagView(e:MouseEvent):void{
			hideGuideMC(e.target.name);
			
			hideView(StrengthenView);
			hideView(MissionView);
			
			ViewFactory.getIns().initView(BagView).show();
		}
		
		
		private function showStrengthenView(e:MouseEvent):void{
			hideGuideMC(e.target.name);
			
			hideView(BagView);
			hideView(RoleDetailView);
			hideView(MissionView);
			
			ViewFactory.getIns().initView(StrengthenView).show();
		}
		
		
		private function showBossView(e:MouseEvent):void{
			hideGuideMC(e.target.name);
			
			hideView(BagView);
			hideView(RoleDetailView);
			hideView(StrengthenView);
			hideView(MissionView);
			
			ViewFactory.getIns().initView(BossView).show();
		}
		
		private function showSkillView(e:MouseEvent):void{
			hideGuideMC(e.target.name);
			
			hideView(BagView);
			hideView(RoleDetailView);
			hideView(StrengthenView);
			hideView(MissionView);
			
			
			ViewFactory.getIns().initView(SkillView).show();
		}
		
		private function showGiftView(e:MouseEvent):void{
			hideGuideMC(e.target.name);
			(ViewFactory.getIns().initView(GiftView) as GiftView).show();
			
			hideView(BagView);
			hideView(RoleDetailView);
			hideView(StrengthenView);
			hideView(MissionView);
			
		}
		
		protected function showShopView(e:MouseEvent):void{
			hideGuideMC(e.target.name);
			
			hideView(BagView);
			hideView(RoleDetailView);
			
			ViewFactory.getIns().initView(ShopView).show();
		}
		
		private function hideGuideMC(name:String) : void{
			if(_guideMC != null && name == _nowGuideName + "Btn"){
				destroyGuide();
			}
		}
		
		public function destroyGuide() : void{
			if(_guideMC != null){
				if(_guideMC.parent != null){
					_guideMC.parent.removeChild(_guideMC);
				}
				_guideMC.stop();
				_guideMC = null;
			}
		}
		
		private function hideView(cls:Class):void{
			if(ViewFactory.getIns().getView(cls)){
				ViewFactory.getIns().getView(cls).hide();
			}
		}
		
		private function get pack():PackVo{
			return PlayerManager.getIns().player.pack;
		}
		
		private function get saveBtn():SimpleButton{
			return layer["save"]["save"]["saveBtn"];
		}
		
		private function get missionBtn():SimpleButton{
			return layer["mission"]["mission"]["missionBtn"];
		}
		
		private function get roleBtn():SimpleButton{
			return layer["role"]["role"]["roleBtn"];
		}
		
		private function get bagBtn():SimpleButton{
			return layer["bag"]["bag"]["bagBtn"];
		}

		private function get strengthenBtn():SimpleButton{
			return layer["strengthen"]["strengthen"]["strengthenBtn"];
		}
		
		private function get bossBtn():SimpleButton{
			return layer["summon"]["summon"]["summonBtn"];
		}
		
		private function get skillBtn():SimpleButton{
			return layer["skill"]["skill"]["skillBtn"];
		}

		private function get quitBtn():SimpleButton{
			return layer["quit"]["quit"]["quitBtn"];
		}
		
		public function get shopBtn() : SimpleButton{
			return layer["shop"]["shopBtn"];
		}
		
		private function get BaGuaBtn():SimpleButton{
			return layer["baGuaBtn"];
		}
		
		private function get Money():TextField{
			return layer["Money"];
		}
		
		private function get Soul():TextField{
			return layer["Soul"];
		}
		
		public function get moneyTips():Sprite
		{
			return layer["moneyTips"];
		}
		
		public function get soulTips():Sprite
		{
			return layer["soulTips"];
		}
		
		public function get achieve() : Sprite{
			return layer["achieve"];
		}
		public function get firstCharge() : Sprite{
			return layer["firstCharge"];
		}
		
		public function get achieveBtn() : SimpleButton{
			return layer["achieve"]["AchieveBtn"];
		}
		
		
		private function get saveCoolDown():TextField{
			return layer["save"]["save"]["saveCoolDown"];
		}
		
		public function get signInBtn() : SimpleButton{
			return layer["SignIn"]["SignIn"]["SignInBtn"];
		}
		
		private function get taskBtn() : SimpleButton{
			return layer["taskBtn"];
		}
		
		public function get misssionObj() : Sprite{
			return layer["mission"]["mission"];
		}
		public function get roleObj() : Sprite{
			return layer["role"]["role"];
		}
		public function get bagObj() : Sprite{
			return layer["bag"]["bag"];
		}
		public function get strengthenObj() : Sprite{
			return layer["strengthen"]["strengthen"];
		}
		public function get summonObj() : Sprite{
			return layer["summon"]["summon"];
		}
		public function get skillObj() : Sprite{
			return layer["skill"]["skill"];
		}
		public function get bagFullIcon() : Sprite{
			return layer["bagFullIcon"];
		}
		private function get jingMaiBtn() : SimpleButton{
			return layer["jingmai"]["jingmai"]["jingMaiBtn"];
		}
		private function get singlePlayerBtn() : SimpleButton{
			return layer["SinglePlayerBtn"];
		}
		private function get doublePlayerBtn() : SimpleButton{
			return layer["DoublePlayerBtn"];
		}

		public function getBtnPosition(name:String) : Point{
			if(layer[name] != null){
				return new Point(layer[name].x, layer[name].y);
			}else{
				return new Point(0, 0);
			}
		}
	}
}