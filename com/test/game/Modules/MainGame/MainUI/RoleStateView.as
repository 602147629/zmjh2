package com.test.game.Modules.MainGame.MainUI
{
	import com.greensock.TweenLite;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
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
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.AssistManager;
	import com.test.game.Manager.AutoFightManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GameSceneManager;
	import com.test.game.Manager.GameSettingManager;
	import com.test.game.Manager.GiftManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.StoryManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.URLManager;
	import com.test.game.Manager.WuYiManager;
	import com.test.game.Modules.MainGame.UpdateInfoView;
	import com.test.game.Modules.MainGame.Activity.MidAutumnView;
	import com.test.game.Modules.MainGame.Setting.GameSettingView;
	import com.test.game.Modules.MainGame.Setting.SoundSettingView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Title.TitleView;
	import com.test.game.Modules.MainGame.Vip.VipView;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.DungeonPassVo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.View.GameSceneControl;
	import com.test.game.Mvc.control.View.PassLevelControl;
	import com.test.game.UI.RoleStateBar;
	import com.test.game.Utils.AllUtils;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class RoleStateView extends BaseView
	{
		private var _obj:Sprite;
		private var _character:CharacterVo;
		private var _partnerBar:RoleStateBar;
		private var _roleBars:Array = new Array();
		private var _giftEnable:Boolean;
		
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		public function RoleStateView(){
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.MAINUI)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("RoleStateView") as Sprite;
				layer.x = 10;
				layer.y = 10;
				this.addChild(layer);
				
				
				
				initParams();
				initUI();
				setParams();
			}
		}
		
		private var _roleHead:BaseNativeEntity;
		private function initUI():void{
			_roleHead = new BaseNativeEntity();
			_roleHead.data.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "_LittleHead") as BitmapData;
			_roleHead.data.scaleX = -1;
			RoleHead.addChild(_roleHead);
			urlBtn.addEventListener(MouseEvent.CLICK, onTurnToUrl);
			musicBtn.addEventListener(MouseEvent.CLICK, onMusicSetting);
			settingBtn.addEventListener(MouseEvent.CLICK, onGameSetting);
			autoFightBtn.addEventListener(MouseEvent.CLICK, onStartAutoFight);
			skipPlotBtn.addEventListener(MouseEvent.CLICK, onSkipPlot);
			updateSp.addEventListener(MouseEvent.CLICK, onShowUpdate);
			titleBtn.addEventListener(MouseEvent.CLICK, onShowTitle);
			TipsManager.getIns().addTips(autoFight, {title:"点击切换自动战斗，BOSS战时无法使用！使用高手卡可全程自动战斗。\n（晚上23点至凌晨6点不能自动战斗，主角也是需要休息的）", tips:""});
			vipBtn.buttonMode = true;
			vipBtn.addEventListener(MouseEvent.CLICK, onShowVip);
			vipGiftMc.buttonMode =true;
			vipGiftMc.addEventListener(MouseEvent.CLICK,onGetVipGift);
			midAutumnBtn.addEventListener(MouseEvent.CLICK, onShowMidAutumn);
			initPartnerRole();
			//wuyiBtn.addEventListener(MouseEvent.CLICK, onWuyi);
			//TipsManager.getIns().addTips(wuyi, {title:"五一期间每日在线半个小时可领取以下奖励：\n5月1日：高手卡1张\n5月2日：人品卡1张\n5月3日：双倍卡1张", tips:""});
			//RoleHead.addEventListener(MouseEvent.CLICK, onTeamStart);
			
		}
		
		protected function onShowMidAutumn(e:MouseEvent) : void{
			ViewFactory.getIns().initView(MidAutumnView).show();
		}
		
		private function initPartnerRole() : void{
			var arr:Array = RoleManager.getIns().getPartnerInfo();
			_partnerBar = new RoleStateBar(arr[0], arr[1]);
			_partnerBar.x = 5;
			_partnerBar.y = 105;
			this.addChild(_partnerBar);
			_partnerBar.addEventListener(MouseEvent.CLICK, onClickPartner);
			_roleBars.push(_partnerBar);
			EventManager.getIns().addEventListener(EventConst.SHOW_PARTNER_ROLE, showPartner);
			EventManager.getIns().addEventListener(EventConst.HIDE_PARTNER_ROLE, hidePartner);
		}
		
		protected function hidePartner(e:CommonEvent):void{
			if(SceneManager.getIns().isTwoPlayerScene){
				SceneManager.getIns().nowScene["hidePartner"]();
			}
			SceneManager.getIns().isShowPartner = false;
			_partnerBar.roleBar.visible = false;
			GreyEffect.change(_partnerBar);
		}
		
		protected function showPartner(e:CommonEvent):void{
			if(SceneManager.getIns().isTwoPlayerScene){
				SceneManager.getIns().nowScene["showPartner"]();
			}
			SceneManager.getIns().isShowPartner = true;
			_partnerBar.roleBar.visible = true;
			GreyEffect.reset(_partnerBar);
		}
		
		
		protected function onShowTitle(e:MouseEvent):void{
			if(MapManager.getIns().mapType == MapManager.NONE_MAP){
				ViewFactory.getIns().initView(TitleView).show();
			}
		}
		
		protected function onClickPartner(e:MouseEvent):void{
			if(SceneManager.getIns().sceneType == SceneManager.AUTO_PK_SCENE
				|| SceneManager.getIns().sceneType == SceneManager.PK_SCENE
				|| SceneManager.getIns().sceneType == SceneManager.LOOT_SCENE
				|| SceneManager.getIns().sceneType == SceneManager.ESCORT_SCENE
				|| GameSceneManager.getIns().partnerOperate){
				
			}else{
				if(SceneManager.getIns().isShowPartner){
					EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.HIDE_PARTNER_ROLE));
				}else{
					EventManager.getIns().dispatchEvent(new CommonEvent(EventConst.SHOW_PARTNER_ROLE));
				}
			}
		}
		
		protected function onTeamStart(e:MouseEvent):void{
			//(ControlFactory.getIns().getControl(GotoFunnyBattleControl) as GotoFunnyBattleControl).goToBattle();
			//(ControlFactory.getIns().getControl(GotoHeroBattleControl) as GotoHeroBattleControl).goToBattle();
			//ViewFactory.getIns().initView(PartnerSkillLearnView).show();
			//(ViewFactory.getIns().initView(CongratulationView) as CongratulationView).startPlay(-1, null);
			//ConvoyManager.getIns().startConvoyBattle();
			//LootManager.getIns().startLootBattle();
			//(ControlFactory.getIns().getControl(NewGameControl) as NewGameControl).gotoNewGame();
			//ViewFactory.getIns().initView(PartnerSkillLearnView).show();
		}
		
		protected function onSkipPlot(event:MouseEvent):void{
			StoryManager.getIns().startStoryControl = !StoryManager.getIns().startStoryControl;
			renderSkipPlot();
		}
		
		protected function onWuyi(event:MouseEvent):void{
			if(player.wuyiInfo.canGet
				&& player.wuyiInfo.isGet == NumberConst.getIns().zero
				&& !WuYiManager.getIns().startWuyiCount){
				player.wuyiInfo.isGet = NumberConst.getIns().one;
				var duration:int = TimeManager.getIns().disDayNum(NumberConst.getIns().wuyiDate, TimeManager.getIns().curTimeStr);
				//高手
				var id:int = 0;
				if(duration == 0){
					id = 6103;
				}
				//人品
				else if(duration == 1){
					id = 6101;
				}
				//双倍
				else if(duration == 2){
					id = 6102;
				}
				var item:ItemVo = PackManager.getIns().creatItem(id);
				PackManager.getIns().addItemIntoPack(item);
				SaveManager.getIns().onSaveGame();
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("获得" + item.name + "x1");
				renderWuyiBtn();
			}
		}
		
		protected function onShowVip(event:MouseEvent):void{
			if(MapManager.getIns().mapType == MapManager.NONE_MAP){
				ViewFactory.getIns().initView(VipView).show();
			}
		}
		
		protected function onShowUpdate(event:MouseEvent):void{
			if(MapManager.getIns().mapType == MapManager.NONE_MAP){
				ViewFactory.getIns().initView(UpdateInfoView).show();
			}
		}
		
		protected function onGetVipGift(event:MouseEvent):void
		{
			if(_giftEnable){
				_giftEnable = false;
				SaveManager.getIns().onSaveGame(
					function () : void{
						GiftManager.getIns().addVipDailyGift();
					},
					function () : void{
						updateVipGift();
					});
			}
		}
		
		private function updateVipGift():void{
			if(MapManager.getIns().mapType == MapManager.NONE_MAP){
				if(ShopManager.getIns().vipLv > NumberConst.getIns().zero){
					if(!player.vip.isVipGiftGet){
						enableGift(true);
						TipsManager.getIns().addTips(vipGiftMc,{title:"点击领取VIP每日礼包",tips:""});
					}else{
						enableGift(false);
					}
				}else{
					enableGift(false);
				}
			}else{
				enableGift(false);
			}
		}
		
		private function enableGift(enable:Boolean):void{
			if(enable){
				_giftEnable = true;
				vipGiftMc.visible = true;
				vipGiftMc.play();
			}else{
				_giftEnable = false;
				vipGiftMc.visible = false;
				vipGiftMc.stop();
			}
		}
		
		protected function onStartAutoFight(event:MouseEvent):void{
			AutoFightManager.getIns().startAutoFight = !AutoFightManager.getIns().startAutoFight;
			renderAutoFightBtn();
		}
		
		public function settingEnAble() : void{
			GreyEffect.change(openSetting);
			settingBtn.mouseEnabled = false;
			
			GreyEffect.change(updateSp);
			GreyEffect.change(titleBtn);
		}
		public function settingAble() : void{
			GreyEffect.reset(openSetting);
			settingBtn.mouseEnabled = true;
			
			GreyEffect.reset(updateSp);
			GreyEffect.reset(titleBtn);
		}
		
		private function onGameSetting(e:MouseEvent) : void{
			if(MapManager.getIns().mapType == MapManager.NONE_MAP){
				ViewFactory.getIns().initView(GameSettingView).show();
			}
		}
		
		private function onMusicSetting(e:MouseEvent) : void{
			(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameStopRender();
			ViewFactory.getIns().initView(SoundSettingView).show();
		}
		
		private function onTurnToUrl(e:MouseEvent) : void{
			URLManager.getIns().openForumURL();
		}
		
		
		private function initParams():void{
			maskTest();
			setHp(PlayerManager.getIns().player.character.totalProperty.hp, PlayerManager.getIns().player.character.totalProperty.hp);
			setMp(PlayerManager.getIns().player.character.totalProperty.mp, PlayerManager.getIns().player.character.totalProperty.mp);

		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			RenderEntityManager.getIns().addEntity(this);
			
			level.text = PlayerManager.getIns().player.character.lv.toString();
			
			setBossHead();
			setRoleHead();
			setAutoFightStatus();
			setVip();
			update();
		}
		
		private function setAutoFightStatus():void{
			if(MapManager.getIns().mapType == MapManager.NORMAL_MAP
				&& PlayerManager.getIns().player.mainMissionVo.id > NumberConst.getIns().autoFightMissionID){
				var date:Date = TimeManager.getIns().returnTimeNow();
				if(PlayerManager.getIns().player.autoFightInfo.autoFightCount > 0
					&& (ControlFactory.getIns().getControl(PassLevelControl) as PassLevelControl).continueAutoFight
					&& date.hours <= 22 && date.hours >= 5
					&& !GameSceneManager.getIns().partnerOperate){
					AutoFightManager.getIns().startAutoFight = true;
				}else{
					AutoFightManager.getIns().startAutoFight = false;
				}
			}
		}
		
		
		override public function update():void{
			if(player.logVo.nameChange>0){
				nameLight.visible = true;
			}else{
				nameLight.visible = false;
			}
			playerName.text = PlayerManager.getIns().player.name;
			renderAutoFightBtn();
			renderSkipPlot();
			renderBtnStatus();
			renderBtnShow();
			//renderChildrenDay();
			renderPartner();
			renderAssist();
			renderRole();
			renderMidAutumn();
			updateVipGift();
		}
		
		private function renderRole() : void{
			if(MapManager.getIns().isTwoPlayerMap){
				if(GameSceneManager.getIns().partnerOperate){
					role.scaleX = .8;
					role.scaleY = .8;
				}else{
					role.scaleX = 1;
					role.scaleY = 1;
				}
			}else{
				role.scaleX = 1;
				role.scaleY = 1;
			}
		}
		
		private function renderAssist() : void{
			if(MapManager.getIns().isTwoPlayerMap){
				if(GameSceneManager.getIns().partnerOperate){
					assist.x = 0;
					assist.y = 80;
				}else{
					assist.x = 0;
					assist.y = 160;
				}
			}else{
				assist.x = 0;
				assist.y = 160;
			}
		}
		
		public function renderPartner():void{
			var arr:Array = RoleManager.getIns().getPartnerInfo();
			_partnerBar.resetRole(arr[0], arr[1]);
			if(MapManager.getIns().isTwoPlayerMap){
				if(GameSceneManager.getIns().partnerOperate){
					_partnerBar.x = 250;
					_partnerBar.y = 15;
				}else{
					_partnerBar.x = 5;
					_partnerBar.y = 105;
				}
			}else{
				_partnerBar.x = 5;
				_partnerBar.y = 105;
			}
			TipsManager.getIns().removeTips(_partnerBar);
			if(GameSceneManager.getIns().partnerOperate){
				if(GameSettingManager.getIns().operateMode == GameSettingManager.NORMAL_OPERATE){
					TipsManager.getIns().addTips(_partnerBar, {title:"<font color='#ffcc00'>当前处于双人模式。</font>", tips:"键盘右侧上下左右可操作伙伴移动，小键盘1=攻击，小键盘2=跳跃，小键盘0=怒气爆发，小键盘4,5,6,7,8=技能按钮。"});
				}else if(GameSettingManager.getIns().operateMode == GameSettingManager.SIMPLE_OPERATE){
					TipsManager.getIns().addTips(_partnerBar, {title:"<font color='#ffcc00'>当前处于双人模式。</font>", tips:"键盘右侧上下左右可操作伙伴跑动，小键盘1=攻击，小键盘2=跳跃，小键盘3=前冲及压制，小键盘0=怒气爆发，小键盘4,5,6,7,8=技能按钮。"});
				}
			}else{
				TipsManager.getIns().addTips(_partnerBar, {title:"点击可以隐藏伙伴让其休息；灰色状态时可以再次点击让其出场。（伙伴死亡后无法出场）\n关卡中可以用快捷键E切换状态", tips:""});
			}
		}
		
		private function renderMidAutumn() : void{
			if(MapManager.getIns().mapType == MapManager.NONE_MAP){
				var zhongQiu:int = TimeManager.getIns().disDayNum(NumberConst.getIns().moonCakeGiftDate, TimeManager.getIns().returnTimeNowStr().split(" ")[0]);
				if(zhongQiu <= 0 && zhongQiu >= -NumberConst.getIns().moonCakeDay){
					midAutumnBtn.visible = true;
				}else{
					midAutumnBtn.visible = false;
				}
			}else{
				midAutumnBtn.visible = false;
			}
		}
		
		private function renderChildrenDay():void{
			if(MapManager.getIns().mapType == MapManager.NONE_MAP){
				var interval:int = TimeManager.getIns().disDayNum(NumberConst.getIns().summerEndDate, TimeManager.getIns().returnTimeNowStr())
				if(interval < 1 && interval > -7){
					summerBuffLayer.visible = true;
					TipsManager.getIns().addTips(summerBuffLayer, {title:"最后的狂欢", tips:"8月26日至8月31日所有少侠可以获得“最后的狂欢”BUFF。获得BUFF期间释放技能不消耗元气，所有技能的冷却时间减半。（此BUFF会覆盖掉“老朽的祝福”）"});
				}else{
					summerBuffLayer.visible = false;
				}
			}else{
				summerBuffLayer.visible = false;
			}
		}
		
		public function renderWuyiBtn():void{
			if(player.wuyiInfo.canGet == true){
				GreyEffect.reset(wuyiBtn);
				if(player.wuyiInfo.isGet == NumberConst.getIns().zero){
					GreyEffect.reset(wuyiBtn);
				}else{
					GreyEffect.change(wuyiBtn);
				}
				wuyiTime.visible = true;
			}else{
				GreyEffect.change(wuyiBtn);
				wuyiTime.visible = false;
			}
			setWuyiStatus();
		}
		
		private function setWuyiStatus() : void{
			if(player.wuyiInfo.canGet){
				if(WuYiManager.getIns().startWuyiCount){
					wuyiTime["OnlineClick"].visible = false;
					wuyiTime["Time"].visible = true;
					GreyEffect.change(wuyiBtn);
				}else{
					if(player.wuyiInfo.isGet == 0){
						wuyiTime["OnlineClick"].visible = true;
						wuyiTime["Time"].visible = false;
						GreyEffect.reset(wuyiBtn);
					}else{
						wuyiTime["OnlineClick"].visible = false;
						wuyiTime["Time"].visible = true;
						wuyiTime["Time"].text = "今日已领";
						GreyEffect.change(wuyiBtn);
					}
				}
			}
		}
		
		public function renderWuyiTime(min:int, sec:int) : void{
			wuyiTime["Time"].text = AllUtils.addPre(min) + ":" + AllUtils.addPre(sec);
		}
		
		private function renderBtnShow():void{
			if(MapManager.getIns().mapType == MapManager.PK_MAP){
				updateSp.visible = false;
				titleBtn.visible = false;
				openMusic.visible = false;
				openSetting.visible = false;
				openUrl.visible = false;
				vipBtn.visible = false;
				playerGameID.visible = true;
				playerGameID.text = "UID:" + GameConst.UID;
			}else{
				updateSp.visible = true;
				titleBtn.visible = true;
				openMusic.visible = true;
				openSetting.visible = true;
				openUrl.visible = true;
				vipBtn.visible = true;
				playerGameID.visible = false;
			}
		}
		
		private function renderBtnStatus():void{
			if(MapManager.getIns().mapType != MapManager.NONE_MAP){
				settingEnAble();
			}else{
				settingAble();
			}
		}
		
		public function renderAutoFightBtn():void{
			if(MapManager.getIns().mapType == MapManager.NORMAL_MAP
				&& PlayerManager.getIns().player.mainMissionVo.id > NumberConst.getIns().autoFightMissionID
				&& !GameSceneManager.getIns().partnerOperate){
				autoFight.visible = true;
				if(AutoFightManager.getIns().startAutoFight){
					autoFightBg.gotoAndStop(2);
				}else{
					autoFightBg.gotoAndStop(1);
				}
				var date:Date = TimeManager.getIns().returnTimeNow();
				if(date.hours <= 22 && date.hours > 5){
					autoFightBtn.mouseEnabled = true;
					GreyEffect.reset(autoFight);
				}else{
					autoFightBtn.mouseEnabled = false;
					GreyEffect.change(autoFight);
				}
			}else{
				autoFight.visible = false;
			}
		}
		
		private function renderSkipPlot():void{
			if(MapManager.getIns().mapType == MapManager.NORMAL_MAP
				&& LevelManager.getIns().mapType == 0){
				skipPlot.visible = true;
				if(StoryManager.getIns().startStoryControl){
					skipPlotBg.gotoAndStop(2);
				}else{
					skipPlotBg.gotoAndStop(1);
				}
				skipPlotBtn.mouseEnabled = true;
				for each(var item:DungeonPassVo in player.dungeonPass){
					if(item.name == LevelManager.getIns().nowIndex){
						if(item.lv == NumberConst.getIns().negativeOne){
							skipPlotBtn.mouseEnabled = false;
							break;
						}
					}
				}
				if(GameSceneManager.getIns().partnerOperate){
					skipPlot.x = 460;
					skipPlot.y = 16;
				}else{
					skipPlot.x = 372;
					skipPlot.y = 16;
				}
			}else{
				skipPlot.visible = false;
			}
		}
		
		public function skipUnEnabled() : void{
			skipPlotBtn.mouseEnabled = false;
		}
		
		private function setRoleHead():void{
			_roleHead.y = 0;
			_roleHead.data.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "_LittleHead") as BitmapData;
		}
		
		private var _hurtStep:int = 0;
		public function setRoleHurtHead(count:int) : void{
			if(_hurtStep < count){
				_hurtStep = count;
			}
			_roleHead.y = -2;
			_roleHead.data.bitmapData = AUtils.getNewObj(PlayerManager.getIns().player.fodder + "_LittleHurtHead") as BitmapData;
		}
		
		override public function step():void{
			if(_hurtStep > 0){
				_hurtStep--;
				if(_hurtStep == 0){
					setRoleHead();
				}
			}
		}
		
		private var _bossHead:BaseNativeEntity = new BaseNativeEntity;
		private function setBossHead():void{
			if(PlayerManager.getIns().player.assistInfo == -1){
				assist.visible = false;
				return;
			}else{
				assist.visible = true;
				var curAssist:ItemVo = AssistManager.getIns().AssistVo;
				var skills:Array = curAssist.bossConfig.skill_info.split("|");
				var str:String = "\n" + skills[1] + "\n释放消耗"+curAssist.bossConfig.skill_energy+"格能量" + "\n<font color='#FFFF00'>按Q键可随时释放</font>";
				TipsManager.getIns().addTips(assist, {title:skills[0], tips:str});
			}
			
			var obj:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SPECIAL, "id", PlayerManager.getIns().player.assistInfo);
			var boss:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.BOSS, "id", obj.bid);
			_bossHead.data.bitmapData = AUtils.getNewObj(boss.fodder + "_LittleHead") as BitmapData;
			_bossHead.data.scaleX = -.5;
			_bossHead.data.scaleY = .5;
			if(_bossHead.parent == null){
				BossHead.addChild(_bossHead);
			}
		}
		
		private var _hpMask:Sprite;
		private var _mpMask:Sprite;
		private var _arcMask:Sprite;
		private var _angle:Number;

		private function maskTest():void{
			_hpMask = new Sprite();
			_hpMask.graphics.beginFill(0xFF0000);
			_hpMask.graphics.drawRect(0, 0, 164, 20);
			_hpMask.graphics.endFill();
			hpBar.addChild(_hpMask);
			hpBar.mask = _hpMask;
			
			_mpMask = new Sprite();
			_mpMask.graphics.beginFill(0xFF0000);
			_mpMask.graphics.drawRect(0, 0, 136, 20);
			_mpMask.graphics.endFill();
			mpBar.addChild(_mpMask);
			mpBar.mask = _mpMask;
			
			_arcMask = new Sprite();
			_arcMask.graphics.beginFill(0xFF0000);
			_arcMask.scaleX = -1;
			_angle = 185;
			drawSector(_arcMask.graphics,_angle);
			BossBar.addChild(_arcMask);
			BossBar.mask=_arcMask;
		}
		
		public function setOtherHp(useHp:Number, totalHp:Number, index:int) : void{
			if(_roleBars[index - 1] != null){
				_roleBars[index - 1].setHp(useHp, totalHp);
			}
		}
		
		public function setOtherMp(useMp:Number, totalMp:Number, index:int) : void{
			if(_roleBars[index - 1] != null){
				_roleBars[index - 1].setMp(useMp, totalMp);
			}
		}
		
		public function setHp(useHp:Number, totalHp:Number) : void{
			var rate:Number = useHp / totalHp;
			if(rate <= 0){
				rate = 0;
			}else if(rate > 1){
				rate = 1;
			}
			if(_hpMask != null){
				TweenLite.to(_hpMask, 1, {width:rate * 164});
				hpTF.text = int(useHp<0?0:useHp) + "/" + totalHp;
				//TipsManager.getIns().addTips(hpBar, {title:"体力 " + useHp + "/" + totalHp, tips:""});
			}
		}
		
		public function setMp(useMp:Number, totalMp:Number) : void{
			var rate:Number = useMp / totalMp;
			if(rate <= 0){
				rate = 0;
			}else if(rate > 1){
				rate = 1;
			}
			if(_mpMask != null){
				TweenLite.to(_mpMask, 1, {width:rate * 136});
				mpTF.text = int(useMp<0?0:useMp) + "/" + totalMp;
				//TipsManager.getIns().addTips(mpBar, {title:"元气 " + useMp + "/" + totalMp, tips:""});
			}
		}
		
		public function addBossCount(rate:Number) : void{
			if(rate <= 0){
				rate = 0;
			}else if(rate > 1){
				rate = 1;
			}
			_angle = 185 * rate;
			drawSector(_arcMask.graphics, _angle);
		}
		
		private function drawSector(g:Graphics,lAngle:Number,x:Number = -18, y:Number = 8, radius:Number = 30, sAngle:Number = 20):void{
			g.clear();
			g.beginFill(0xFF0000);
			var sx:Number = radius;
			var sy:Number = 0;
			if (sAngle != 0) {
				sx = Math.cos(sAngle * Math.PI/180) * radius;
				sy = Math.sin(sAngle * Math.PI/180) * radius;
			}
			g.moveTo(x, y);
			g.lineTo(x + sx, y +sy);
			var a:Number =  lAngle * Math.PI / 180 / lAngle;
			var cos:Number = Math.cos(a);
			var sin:Number = Math.sin(a);
			var b:Number = 0;
			for (var i:Number = 0; i < lAngle; i++) {
				var nx:Number = cos * sx - sin * sy;
				var ny:Number = cos * sy + sin * sx;
				sx = nx;
				sy = ny;
				g.lineTo(sx + x, sy + y);
			}
			g.lineTo(x, y);
			g.endFill();
		}
		
		public function upDataLevel(lv:int) : void{
			level.text = lv.toString();
		}
		
		public function resetState() : void{
			addBossCount(1);
			setParams();
		}
		
		public function setVip():void{
			if(ShopManager.getIns().vipLv > NumberConst.getIns().zero){
				(vipBtn["vipLvMc"] as MovieClip).gotoAndStop("vip"+ShopManager.getIns().vipLv);
				(vipBtn["shineMc"] as MovieClip).play();
				GreyEffect.reset(vipBtn);
			}else{
				(vipBtn["vipLvMc"] as MovieClip).gotoAndStop("vip1");
				(vipBtn["shineMc"] as MovieClip).stop();
				GreyEffect.change(vipBtn);
			}
			updateVipGift();
		}
		
		public function get playerName():TextField{
			return layer["Role"]["playerName"];
		}
		public function get level():TextField{
			return layer["Role"]["level"];
		}
		
		public function get hpBar():Sprite{
			return layer["Role"]["HpBar"];
		}
		public function get mpBar():Sprite{
			return layer["Role"]["MpBar"];
		}
		public function get BossBar():Sprite{
			return layer["Assist"]["BossBar"];
		}
		public function get RoleHead():Sprite{
			return layer["Role"]["RoleHead"];
		}
		public function get BossHead():Sprite{
			return layer["Assist"]["BossHead"];
		}
		public function get autoFight() : Sprite{
			return layer["AutoFight"];
		}
		private function get skipPlot() : Sprite{
			return layer["SkipPlot"];
		}
		private function get updateSp() : Sprite{
			return layer["Role"]["Update"];
		}
		private function get openMusic() : Sprite{
			return layer["Role"]["OpenMusic"];
		}
		private function get openSetting() : Sprite{
			return layer["Role"]["OpenSetting"];
		}
		private function get openUrl() : Sprite{
			return layer["Role"]["OpenUrl"]
		}
		
		public function get hpTF() : TextField{
			return layer["Role"]["HpLayer"]["HpTF"];
		}
		public function get mpTF() : TextField{
			return layer["Role"]["MpLayer"]["MpTF"];
		}
		public function get barRect() : Sprite{
			return layer["Role"]["BarRect"];
		}
		public function get urlBtn() : SimpleButton{
			return layer["Role"]["OpenUrl"]["UrlBtn"];
		}
		public function get musicBtn() : SimpleButton{
			return layer["Role"]["OpenMusic"]["MusicBtn"];
		}
		public function get settingBtn() : SimpleButton{
			return layer["Role"]["OpenSetting"]["SettingBtn"];
		}
		public function get autoFightBtn() : SimpleButton{
			return layer["AutoFight"]["AutoFightBtn"];
		}
		private function get autoFightBg() : MovieClip{
			return layer["AutoFight"]["AutoFightBg"];
		}
		private function get skipPlotBtn() : SimpleButton{
			return layer["SkipPlot"]["SkipPlotBtn"];
		}
		private function get skipPlotBg() : MovieClip{
			return layer["SkipPlot"]["SkipPlotBg"];
		}
		private function get updateBtn() : SimpleButton{
			return layer["Role"]["Update"]["UpdateBtn"];
		}
		private function get wuyiBtn() : SimpleButton{
			return layer["WuYi"]["WuYiBtn"];
		}
		private function get wuyiTime() : Sprite{
			return layer["WuYi"]["WuyiLayer"];
		}
		private function get wuyi() : Sprite{
			return layer["WuYi"];
		}
		private function get vipBtn() : MovieClip{
			return layer["Role"]["vipIconMc"];
		}
		private function get playerGameID() : TextField{
			return layer["Role"]["playerGameID"]
		}
		private function get nameLight() : MovieClip{
			return layer["Role"]["nameLight"]
		}
		private function get summerBuffLayer() : Sprite{
			return layer["SummerBuffLayer"];
		}
		private function get role() : Sprite{
			return layer["Role"];
		}
		private function get midAutumnBtn() : SimpleButton{
			return layer["MidAutumnBtn"];
		}
		
		private function get vipGiftMc():MovieClip
		{
			return layer["Role"]["vipGiftMc"];
		}
		
		private function get assist() : Sprite{
			return layer["Assist"];
		}
		
		private function get titleBtn() : SimpleButton{
			return layer["Role"]["titleBtn"];
		}

		
		override public function destroy():void{
			_mpMask = null;
			_hpMask = null;
			_arcMask = null;
			layer = null;
			super.destroy();
		}

	}
}