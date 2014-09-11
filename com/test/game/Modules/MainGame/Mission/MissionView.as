package com.test.game.Modules.MainGame.Mission
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.Map.GetItemIconEntity;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.LogManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.URLManager;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Modules.MainGame.EliteSelectView;
	import com.test.game.Modules.MainGame.DungeonMenu.DungeonMenu;
	import com.test.game.Modules.MainGame.Escort.EscortView;
	import com.test.game.Modules.MainGame.Guide.OneKeyEquipView;
	import com.test.game.Modules.MainGame.Info.InfoView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Configuration.DailyMission;
	import com.test.game.Mvc.Configuration.HideMission;
	import com.test.game.Mvc.Configuration.MainMission;
	import com.test.game.Mvc.Configuration.Player;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.View.PlayerUIControl;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class MissionView extends BaseView
	{
		
		private var _curMainMissionData:MainMission;
		private var _curHideMissionData:HideMission;
		private var _curDailyMissionData:DailyMission;
		
		private var _curPlayerSet:Player;
		private var _curDungeonInfo:Object;
		
		public static var MAIN_MISSION:int = 0;
		public static var DAILY_MISSION:int = 1;
		public static var HIDE_MISSION:int = 2;
		
		
		private var mainMissionIcon:MissionIcon;
		
		private var dailyMissionIcon:MissionIcon;
		
		private var hideMissionIconList:Array = new Array();
		
		private var iconArr:Array;
		
		private var _itemIcon1:ItemIcon;
		
		private var _itemIcon2:ItemIcon;
		
		private var _itemVo1:ItemVo;
		
		private var _itemVo2:ItemVo;
		
		private var _guideData:Object;
		private var _anti:Antiwear;
		private var _hideMissionSelectList:Array = new Array();
		
		public var curMissionIndex:int;
		
		public function get curMissionId():int
		{
			return _anti["curMissionId"];
		}
		
		public function set curMissionId(value:int):void
		{
			_anti["curMissionId"] = value;
		}

		

		public function get curExp():int
		{
			return _anti["curExp"];
		}

		public function set curExp(value:int):void
		{
			_anti["curExp"] = value;
		}

		
		
		public function get curMoney():int
		{
			return _anti["curMoney"];
		}
		
		public function set curMoney(value:int):void
		{
			_anti["curMoney"] = value;
		}
		
		
		public function get curSoul():int
		{
			return _anti["curSoul"];
		}
		
		public function set curSoul(value:int):void
		{
			_anti["curSoul"] = value;
		}
		
		
		public function MissionView()
		{
			_anti = new Antiwear(new binaryEncrypt());
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.MISSIONVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView,LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		
		
		private function renderView(...args):void{
			LoadManager.getIns().hideProgress();			
			
			 layer = AssetsManager.getIns().getAssetObject("MissionView") as Sprite;
			this.addChild(layer);
			layer.visible = false;
			
			initSelectList();
			
			_itemIcon1 = new ItemIcon();
			_itemIcon1.x = 280;
			_itemIcon1.y = 352;
			_itemIcon1.menuable = false;
			layer.addChild(_itemIcon1);
			
			_itemIcon2 = new ItemIcon();
			_itemIcon2.x = 336;
			_itemIcon2.y = 352;
			_itemIcon2.menuable = false;
			layer.addChild(_itemIcon2);
			
			var format:TextFormat=new TextFormat();
			format.underline = true;
			urlMc.buttonMode = true;
			urlMc.mouseChildren = false;
			urlMc["urlText"].setTextFormat(format);
			
			//update();
			initEvent();
			
			initBg();
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xFFFFFF, 1);
			sp.graphics.drawRect(0,0,missionContent.width,missionContent.height);
			sp.graphics.endFill();
			sp.filters = [new BlurFilter(15,15,BitmapFilterQuality.LOW)];
			missionContent.mask = sp;
			sp.x = missionContent.x;
			sp.y = missionContent.y;
			layer["missionContent"].addChild(sp);
			
			/*var txtFormat:TextFormat = new TextFormat();
			txtFormat.kerning = true;
			txtFormat.letterSpacing = -1;
			missionContent.defaultTextFormat = txtFormat;*/
			setCenter();
			openTween();
		}
		
		private function initSelectList():void{
			for(var i:int = 0; i < 6; i++){
				var bne:BaseNativeEntity = new BaseNativeEntity();
				bne.data.bitmapData = AUtils.getNewObj("HideMissionSelect") as BitmapData;
				_hideMissionSelectList.push(bne);
			}
		}
		
		private function get player():PlayerVo
		{
			return PlayerManager.getIns().player;
		}		
		
		

		
		override public function update():void{
			iconArr = [];
			if(curMissionId == 0){
				curMissionId = player.mainMissionVo.id;
				curMissionIndex = 0;
			}
			renderMainMissionIcon();
			renderHideMissionIcon();	
			renderDailyMissionIcon();
			setCurMission(curMissionId);
			
			GuideManager.getIns().qiYuGuideSetting();
		}
		
		
		/**
		 *渲染主线任务Icon 
		 * 
		 */	
		private function renderMainMissionIcon():void{
			var mainMissionId:int = player.mainMissionVo.id;
			var firstData:MainMission = ConfigurationManager.getIns().getObjectByID(
				AssetsConst.MAIN_MISSION,mainMissionId) as MainMission;
			
			
			if(!mainMissionIcon){
				mainMissionIcon = new MissionIcon();
				mainMissionIcon.x = 60;
				mainMissionIcon.y = 112;
				layer.addChild(mainMissionIcon);
			}
			mainMissionIcon.index = 0;
			iconArr.push(mainMissionIcon);

			
			if(mainMissionId >= NumberConst.getIns().missionIdEnd){
				//达到最终任务id
				mainMissionId = NumberConst.getIns().missionIdEnd;
				mainMissionIcon.setData(mainMissionId,false);
			}else if(firstData.lv > PlayerManager.getIns().player.character.lv){
				//等级不足
				mainMissionIcon.setData(mainMissionId,false);
			}else{
				//isComplete   true 已完成 领取奖励  显示下一个   false未完成
				if(player.mainMissionVo.isComplete){
					mainMissionIcon.setData(mainMissionId,true);
				}else{
					mainMissionIcon.setData(mainMissionId,false);
				}
			}
			
			guideShowClickThis();
		}
		
		/**
		 *渲染奇遇任务Icon 
		 * 
		 */		
		private function renderDailyMissionIcon():void
		{

			if(!dailyMissionIcon){
				dailyMissionIcon = new MissionIcon();
				dailyMissionIcon.x = 60;
				
				layer.addChild(dailyMissionIcon);	
			}
			

			iconArr.push(dailyMissionIcon);
			
			if(DailyMissionManager.getIns().checkDailyMission){
				if(player.dailyMissionVo.missionType!=NumberConst.getIns().negativeOne){
					
					var hideLength:int = player.ShowHideMissionInfo.length;
					var dailyMissionId:int = player.dailyMissionVo.missionType+2000;
					var dailyMissionData:DailyMission = ConfigurationManager.getIns().getObjectByID
						(AssetsConst.DAILY_MISSION,dailyMissionId) as DailyMission;
					
					dailyMissionIcon.y = 178 + (hideLength)*30;
					dailyMissionIcon.index = hideLength+1;
					dailyTitle.y = 158 + (hideLength)*30;
					
					dailyTitle.visible = true;
					dailyMissionIcon.visible = true;
					//isComplete   true 已完成 领取奖励  显示下一个   false未完成
					if(player.dailyMissionVo.isComplete){
						dailyMissionIcon.setData(dailyMissionId,true);
					}else{
						dailyMissionIcon.setData(dailyMissionId,false);
					}
				}else{
					dailyMissionIcon.visible = false;
					dailyTitle.visible =false;
				}

			}else{
				dailyMissionIcon.visible = false;
				dailyTitle.visible =false;
			}
		}		
		
		/**
		 *渲染轶闻任务Icon 
		 * 
		 */	
		private function renderHideMissionIcon():void
		{
			if(HideMissionManager.getIns().checkMoZhuLinOpen){
				hideTitle.visible = true;
				var count:int = 0;
				clearHideMissionIcon();
				for(var i:int =0; i< player.hideMissionInfo.length;i++){
					if(player.hideMissionInfo[i].isShow){
						var hideMissionIcon:MissionIcon = new MissionIcon();
						hideMissionIcon.x = 60;
						hideMissionIcon.y = 160+25*count;
						hideMissionIcon.index = 1+count;
						layer.addChild(hideMissionIcon);
						hideMissionIconList.push(hideMissionIcon);
						count++;
						
						var hideMissionId:int = player.hideMissionInfo[i].id;
						var hideMissionData:HideMission = ConfigurationManager.getIns().getObjectByID
							(AssetsConst.HIDE_MISSION,hideMissionId) as HideMission;
						
						//isComplete   true 已完成 领取奖励  显示下一个   false未完成
						if(player.hideMissionInfo[i].isComplete){
							hideMissionIcon.setData(hideMissionId,true);
						}else{
							hideMissionIcon.setData(hideMissionId,false);
						}
						
						iconArr.push(hideMissionIcon);
					}
				}
				if(count == 0){
					hideTitle.visible = false;
				}
			}else{
				hideTitle.visible = false;
			}
		}	
		
		private function clearHideMissionIcon():void
		{
			for(var i:int = 0; i < hideMissionIconList.length; i++){
				hideMissionIconList[i].destroy();
				hideMissionIconList[i] = null;
			}
			hideMissionIconList.length = 0;
		}
		
		private function initEvent():void{
			EventManager.getIns().addEventListener(EventConst.MISSION_SELECT_CHANGE,onMissionSelect);
			enterBtn.addEventListener(MouseEvent.CLICK,enterBattle);
			rewardBtn.addEventListener(MouseEvent.CLICK,getReward);
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			moveBar.addEventListener(MouseEvent.MOUSE_DOWN,moveView);
			moveBar.addEventListener(MouseEvent.MOUSE_UP,putView);
			urlMc.addEventListener(MouseEvent.CLICK,urlClick);
		}
		
		protected function urlClick(event:MouseEvent):void
		{
			URLManager.getIns().openForumURL();
		}		
		
		
		private function onMissionSelect(e:CommonEvent):void{
			curMissionId = int(e.data[0].id)
			curMissionIndex = e.data[2];
			setCurMission(int(e.data[0].id));
			GuideManager.getIns().qiYuGuideSetting();
		}
		
		
		/**
		 * 
		 * 设置missionIcon选择框
		 * 
		 */
		private function setIconSelect(index:int):void{
			for each(var icon:MissionIcon in iconArr){
				icon.setSelect(false);
			}
			iconArr[index].setSelect(true);
		}
		
		private function setCurMission(missionId:int):void{	
			_curPlayerSet = ConfigurationManager.getIns().getObjectByProperty(
				AssetsConst.PLAYER, "lv", player.character.lv) as Player;
			
			var dungeonId:String = player.dailyMissionVo.missionDungeon;
			var arr:Array = dungeonId.split("_");
			if(arr.length == 3){
				_curDungeonInfo = ConfigurationManager.getIns().getObjectByProperty(
					AssetsConst.ELITE, "level_id", arr[0]+"_"+arr[1]);
			}else{
				_curDungeonInfo = ConfigurationManager.getIns().getObjectByProperty(
					AssetsConst.LEVEL, "level_id", dungeonId);
			}
			
			urlMc.visible = false;
			clearHideMissionSelect();
			switch(int(missionId/1000)-1){
				case MAIN_MISSION:
					_curMainMissionData=ConfigurationManager.getIns().getObjectByID(
						AssetsConst.MAIN_MISSION,missionId) as MainMission;
					
					setCurMainMission();
					break;
				case DAILY_MISSION:
					_curDailyMissionData = ConfigurationManager.getIns().getObjectByID
					(AssetsConst.DAILY_MISSION,missionId) as DailyMission;
					
					setCurDailyMission();
					break;
				case HIDE_MISSION:
					_curHideMissionData = ConfigurationManager.getIns().getObjectByID
					(AssetsConst.HIDE_MISSION,missionId) as HideMission;
					
					setCurHideMission();
					break;
			}
			
			renderText();
			setIconSelect(curMissionIndex);
			
		}
		
		
		/**
		 *显示主线任务内容
		 * 
		 */	
		private function setCurMainMission():void
		{
			missionName.text = _curMainMissionData.mission_name;
			missionContent.text = "    "+_curMainMissionData.mission_description;
			missionObject.text  = _curMainMissionData.mission_rules;
			if(_curMainMissionData.evaluation==0){
				dungeonRank.visible = false;
			}else{
				dungeonRank.visible = true;
				dungeonRank.gotoAndStop("rank"+_curMainMissionData.evaluation);
			}
			
			
			firstTxt.gotoAndStop("money");
			secondTxt.visible = true;
			
			curExp = _curMainMissionData.exp;
			curMoney = _curMainMissionData.gold;
			curSoul = _curMainMissionData.soul;
			
			expReward.text = curExp.toString();
			moneyReward.text = NumberConst.numTranslate(curMoney);
			soulReward.text = NumberConst.numTranslate(curSoul);
			
			renderMainItems();
			renderMainMissionBtns();
		}
		
		
		
		/**
		 *显示奇遇任务内容 
		 * 
		 */	
		private function setCurDailyMission():void
		{
			
			var dungeonName:String = _curDungeonInfo.level_name;
			var bossName:String  = _curDungeonInfo.boss_name;
			if(_curDailyMissionData.id == 2004){
				missionName.text = _curDailyMissionData.mission_name.replace("[1]",bossName);
				missionContent.htmlText = "    "+_curDailyMissionData.mission_description.replace(
					"[1]",ColorConst.setGold(bossName));
			}else{
				missionName.text = _curDailyMissionData.mission_name.replace("[1]",dungeonName);
				missionContent.htmlText = "    "+_curDailyMissionData.mission_description.replace(
					"[1]",ColorConst.setGold(dungeonName));
			}
			
			missionObject.htmlText  = _curDailyMissionData.mission_rules.replace(
				"[1]",ColorConst.setGold(dungeonName));
			dungeonRank.visible = false;
			
			
			//PlayerManager.getIns().numTraslate(_player.money);
			secondTxt.visible = false;
			
			curExp = _curPlayerSet.dailyexp*(NumberConst.getIns().hideMissionRate);
			
			
			expReward.text = curExp.toString();	
			soulReward.text = "";
			switch(_curDailyMissionData.goldOrSoul){
				case 0:
					firstTxt.gotoAndStop("money");
					curMoney = _curPlayerSet.dailygold*(NumberConst.getIns().hideMissionRate);
					curSoul = 0;
					moneyReward.text = NumberConst.numTranslate(curMoney);
					break;
				case 1:
					firstTxt.gotoAndStop("soul");
					curMoney = 0;
					curSoul = _curPlayerSet.dailysoul*(NumberConst.getIns().hideMissionRate);
					moneyReward.text = NumberConst.numTranslate(curSoul);
					break;
			}
			
			
			
			renderDailyItems();
			missionTips.visible = false;
			//isComplete   true 已完成 领取奖励  显示下一个   false未完成
			showRewardBtn(player.dailyMissionVo.isComplete);
		}
		
		
		
		/**
		 *显示奇遇任务物品 
		 * 
		 */		
		private function renderDailyItems():void{
			
			var arr:Array = player.dailyMissionVo.missionDungeon.split("_");
			
			var materialArr:Array = _curDungeonInfo.material.split("|");
			if(materialArr.length==1){
				_itemVo1 =  PackManager.getIns().creatItem(materialArr[0]);
			}else{
				_itemVo1 =  PackManager.getIns().creatItem(materialArr[player.dailyMissionVo.materialType]);
			}
			
			if(arr.length == 3){
				_itemVo2 =  PackManager.getIns().creatItem(_curDungeonInfo.special);
			}else{
				_itemVo2 =  PackManager.getIns().creatItem(_curDungeonInfo.strengthen);
			}
			
			_itemVo1.num = _curDailyMissionData.reward1;
			_itemVo2.num = _curDailyMissionData.reward2;
			
			_itemIcon1.setData(_itemVo1);
			_itemIcon2.setData(_itemVo2);
		}
		
		
		private function setCurHideMission():void
		{
			if(curMissionId != -1){
				missionName.text = _curHideMissionData.mission_name;
				missionContent.text = "    "+_curHideMissionData.mission_description;
				var index:int = HideMissionManager.getIns().getHideMissionIndex(curMissionId);
				var objectArr:Array = _curHideMissionData.mission_rules.split("|");
				missionObject.text = "";
				for(var i:int = 0 ; i<objectArr.length ; i++){
					if(objectArr.length == 5){
						missionObject.text  += objectArr[i]+"       ";
						if(i != 0 &&  (i+1)%2 == 0){
							missionObject.text += "\n";
						}
						if(int(player.hideMissionInfo[index].missionConfig[i]) == 1){
							_hideMissionSelectList[i].x = 285 + (i%2) * 90;
							_hideMissionSelectList[i].y = 204 + int(i/2) * 15;
							layer.addChild(_hideMissionSelectList[i]);
						}
					}else if(objectArr.length == 3){
						missionObject.text  += objectArr[i]+"       \n";
						if(int(player.hideMissionInfo[index].missionConfig[i]) == 1){
							_hideMissionSelectList[i].x = 345;
							_hideMissionSelectList[i].y = 204 + i * 15;
							layer.addChild(_hideMissionSelectList[i]);
						}
					}else{
						missionObject.text  += objectArr[i]+" ";
					}
				}
				
				if(curMissionId == HideMissionManager.MOZHULIN_ID
					|| curMissionId == HideMissionManager.TAIXUGUAM_ID
					|| curMissionId == HideMissionManager.WANEGU_ID){
					urlMc.visible = true;
				}
				
				dungeonRank.visible = false;
				
				firstTxt.gotoAndStop("money");
				secondTxt.visible = true;
				
				curExp = _curHideMissionData.exp;
				curMoney = _curHideMissionData.gold;
				curSoul = _curHideMissionData.soul;
				
				expReward.text = curExp.toString();
				moneyReward.text = NumberConst.numTranslate(curMoney);
				soulReward.text = NumberConst.numTranslate(curSoul);
				
				//隐藏任务物品显示（调用主线任务物品显示）
				renderHideItems();
				missionTips.visible = false;
				//隐藏任务按钮显示
				showRewardBtn(HideMissionManager.getIns().returnHideMissionStatus(curMissionId));
			}
		}
		
		private function renderHideItems():void{
			var items:Array = _curHideMissionData.item.split("|");
			var itemNums:Array = _curHideMissionData.item_number.split("|");
	
			if(items[0] != 0){
				var itemVo1:ItemVo = PackManager.getIns().creatItem(items[0]);
				itemVo1.num = itemNums[0];
				_itemIcon1.setData(itemVo1);
				
				if(items.length >= 2 && items[1]!=0){
					var itemVo2:ItemVo = PackManager.getIns().creatItem(items[1]);
					itemVo2.num = itemNums[1];
					_itemIcon2.setData(itemVo2);
					
					_itemVo2 = itemVo2;
					
				}else{
					_itemIcon2.setData(null);
					
					_itemVo2 = null;
				}
				
				_itemVo1 = itemVo1;
			}
		}
		
		private function clearHideMissionSelect():void{
			for(var i:int = 0; i < _hideMissionSelectList.length; i++){
				if(_hideMissionSelectList[i].parent != null){
					_hideMissionSelectList[i].parent.removeChild(_hideMissionSelectList[i]);
				}
			}
		}		
		
		private function renderMainMissionBtns():void
		{
			if((_curMainMissionData.id >= NumberConst.getIns().missionIdEnd) 
				|| (_curMainMissionData.lv > PlayerManager.getIns().player.character.lv)){
				//达到最终任务id 或 等级不足
				enterBtn.visible = false;
				rewardBtn.visible = false;
				missionTips.visible = true;
			}else{
				missionTips.visible = false;
				//isComplete   true 已完成 领取奖励  显示下一个   false未完成
				showRewardBtn(player.mainMissionVo.isComplete);
			}
		}		
		
		private function renderText():void{
			if(missionContent.mask != null){
				missionContent.mask.width = 0;
				TweenLite.to(missionContent.mask, 2, {width:missionContent.width});
			}
		}
		
		
		private function renderMainItems():void{
			var equips:Array
			if(_curMainMissionData.hasOwnProperty("equipment")){
				equips = _curMainMissionData.equipment.split("|");
			}else{
				equips = [0];
			}
			
			var items:Array = _curMainMissionData.item.split("|");
			var itemNums:Array = _curMainMissionData.item_number.split("|");
			
			if(equips[0] != 0){
				var equipVo:ItemVo = PackManager.getIns().creatItem(equips[player.occupation-1]);
				_itemIcon1.setData(equipVo);
				if(items[0] != 0){
					var itemVo:ItemVo = PackManager.getIns().creatItem(items[0]);
					itemVo.num = itemNums[0];
					_itemIcon2.setData(itemVo);
					_itemVo2 = itemVo;
					
				}else{
					_itemIcon2.setData(null);
					_itemVo2 = null;
				}
				
				_itemVo1 = equipVo;
				
				
			}else{
				if(items[0] != 0){
					var itemVo1:ItemVo = PackManager.getIns().creatItem(items[0]);
					itemVo1.num = itemNums[0];
					_itemIcon1.setData(itemVo1);
					
					if(items.length >= 2 && items[1]!=0){
						var itemVo2:ItemVo = PackManager.getIns().creatItem(items[1]);
						itemVo2.num = itemNums[1];
						_itemIcon2.setData(itemVo2);
						
						_itemVo2 = itemVo2;
						
					}else{
						_itemIcon2.setData(null);
						
						_itemVo2 = null;
					}
					
					_itemVo1 = itemVo1;
				}
				
			}
		}
		
		
		//领取任务奖励
		private function getReward(e:MouseEvent):void
		{
			var itemArr:Array = [_itemVo1];
			if(_itemVo2){
				itemArr.push(_itemVo2);
			}
			if(PackManager.getIns().checkMaxRooM(itemArr)){
				switch(int(curMissionId/1000)-1){
					case MAIN_MISSION:
						mainMissionComplete();
						break;
					case DAILY_MISSION:
						dailyMissionComplete();
						break;
					case HIDE_MISSION:
						hideMissionComplete();
						break;
				}
				PlayerManager.getIns().checkAllAchieves();
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"背包空间不足！\n请留出空间后再领取");
			}
		}
		
		private function hideMissionComplete():void{
			enterBtn.visible = false;
			rewardBtn.visible = false;
			PlayerManager.getIns().checkAdd("hide_exp",curExp,10*10000);
			var levelUp:Boolean = PlayerManager.getIns().addExp(curExp);
			PlayerManager.getIns().checkAdd("hide_money",curMoney,50000);
			PlayerManager.getIns().checkAdd("hide_soul",curSoul,50000);
			PlayerManager.getIns().addMoney(curMoney);
			PlayerManager.getIns().addSoul(curSoul);
			addDropItem({type:"Weather",id:"Money",num:curMoney});
			addDropItem({type:"Weather",id:"Soul",num:curSoul});
			ViewFactory.getIns().getView(MainToolBar).update();
			PackManager.getIns().addItemIntoPack(_itemVo1);
			addDropItem(_itemVo1);
			if(_itemVo2){
				PackManager.getIns().addItemIntoPack(_itemVo2);
				addDropItem(_itemVo2);
			}
			guideShowHide(HIDE_MISSION);
			analysisDetail(levelUp);
			curMissionId = HideMissionManager.getIns().openNextHideMission(_curHideMissionData.id);
			ViewFactory.getIns().getView(MissionHint).update();
			DeformTipManager.getIns().checkMissionDeform();
			if(curMissionId == -1){
				curMissionIndex = 0;
			}
			update();
		}
		
		/**
		 *主线任务完成 
		 * 
		 */		
		private function mainMissionComplete() : void{
			enterBtn.visible = false;
			rewardBtn.visible = false;
			PlayerManager.getIns().checkAdd("main_exp",curExp,10*10000);
			var levelUp:Boolean = PlayerManager.getIns().addExp(curExp);
			PlayerManager.getIns().checkAdd("main_money",curMoney,50000);
			PlayerManager.getIns().checkAdd("main_soul",curSoul,50000);
			PlayerManager.getIns().addMoney(curMoney);
			PlayerManager.getIns().addSoul(curSoul);
			addDropItem({type:"Weather",id:"Money",num:curMoney});
			addDropItem({type:"Weather",id:"Soul",num:curSoul});
			ViewFactory.getIns().getView(MainToolBar).update();
			PackManager.getIns().addItemIntoPack(_itemVo1);
			addDropItem(_itemVo1);
			if(_itemVo2){
				PackManager.getIns().addItemIntoPack(_itemVo2);
				addDropItem(_itemVo2);
			}
			guideShowHide(MAIN_MISSION);
			analysisDetail(levelUp);
			PlayerManager.getIns().openNextMainMission();
			judgeOpenHideMission();
			ViewFactory.getIns().getView(MissionHint).update();
			DeformTipManager.getIns().checkMissionDeform();
			curMissionId = player.mainMissionVo.id;
			update();
		}
		
		private function judgeOpenHideMission():void{
			if(HideMissionManager.getIns().checkMoZhuLinOpen){
				HideMissionManager.getIns().addHideMission(HideMissionManager.MOZHULIN_ID);
			}
			if(HideMissionManager.getIns().checkTaiXuGuanOpen){
				HideMissionManager.getIns().addHideMission(HideMissionManager.TAIXUGUAM_ID);
			}
			if(HideMissionManager.getIns().checkWanEGuOpen){
				HideMissionManager.getIns().addHideMission(HideMissionManager.WANEGU_ID);
			}
		}
		
		
		/**
		 *奇遇任务完成 
		 * 
		 */		
		private function dailyMissionComplete() : void{
			this.mouseChildren = false;
			SaveManager.getIns().onSaveGame(dailyMissionComplete1, dailyMissionComplete2, 2);
		}
		
		

		private function dailyMissionComplete1() : void{
			PlayerManager.getIns().checkAdd("daily_exp",curExp,10*10000);
			var levelUp:Boolean = PlayerManager.getIns().addExp(curExp);
			PlayerManager.getIns().checkAdd("daily_money",curMoney,50000);
			PlayerManager.getIns().checkAdd("daily_soul",curSoul,50000);
			PlayerManager.getIns().addMoney(curMoney);
			PlayerManager.getIns().addSoul(curSoul);
			addDropItem({type:"Weather",id:"Money",num:curMoney});
			addDropItem({type:"Weather",id:"Soul",num:curSoul});
			ViewFactory.getIns().getView(MainToolBar).update();
			PackManager.getIns().addItemIntoPack(_itemVo1);
			addDropItem(_itemVo1);
			if(_itemVo2){
				PackManager.getIns().addItemIntoPack(_itemVo2);
				addDropItem(_itemVo2);
			}
			guideShowHide(DAILY_MISSION);
			analysisDetail(levelUp);
			DailyMissionManager.getIns().startGetNextDailyMission();
		}
		
		private function dailyMissionComplete2() : void{
			this.mouseChildren = true;
			enterBtn.visible = false;
			rewardBtn.visible = false;
			ViewFactory.getIns().getView(MissionHint).update();
			DeformTipManager.getIns().checkMissionDeform();
			curMissionId = 0;
			update();
		}
		
		private var _direct:int = 1;
		private function addDropItem(item:*) : void{
			
			var fodder:String = item.type+item.id;
			var name:String = ""
			var num:int;
			if(item.num){
				num = Math.max(1,item.num/2);
				if(num>4){
					num=4;
				}
			}else{
				num = 1;
			}
			for(var i:int=0;i<num;i++){
				TweenLite.delayedCall(i * .3,
					function():void{
						var dropEntity:GetItemIconEntity = new GetItemIconEntity(fodder, _direct);
						LayerManager.getIns().gameTipLayer.addChild(dropEntity);
						_direct = -_direct;
					}
				);
				
			}
			
		}
		
		private var _guideMC:MovieClip;
		
		private function guideShowClickThis():void{
			if(player.mainMissionVo.id < 1012){
				if(_guideMC == null){
					_guideMC = GuideManager.getIns().getGuideMCByName(GuideManager.ARROW, 
						
						310, 385);
					layer.addChild(_guideMC);
				}
			}else{
				if(_guideMC != null){
					if(_guideMC.parent != null){
						_guideMC.parent.removeChild(_guideMC);
					}
					_guideMC.stop();
					_guideMC = null;
				}
			}
		}
		
		private function guideShowHide(type:int) : void{
			switch(type){
				case MAIN_MISSION:
					_guideData = _curMainMissionData;
					break;
				case DAILY_MISSION:
					_guideData = _curDailyMissionData;
					break;
				case HIDE_MISSION:
					_guideData = _curHideMissionData;
					break;
			}
			
			if(_guideData.hasOwnProperty("newFunction") && _guideData.newFunction != "0"){
				this.hide();
			}
		}

		private function guideShowNewFunction():void{
			if(_guideData != null && _guideData.hasOwnProperty("newFunction") && _guideData.newFunction != "0"){
				GuideManager.getIns().missionGuideSetting(_guideData.newFunction);
			}
		}
		
		private function analysisDetail(levelUp:Boolean):void{
			var str:String = "";
			if(curExp>0){
				str += "EXP:" + curExp
			}
			if(curMoney){
				str += "，金钱：:" + curMoney
			}
			if(curSoul){
				str += "，战魂：" + curSoul
			}
			if(_itemVo1 != null){
				str += "，" + _itemVo1.name + "X" + _itemVo1.num;
			}
			if(_itemVo2 != null){
				str += "，" + _itemVo2.name + "X" + _itemVo2.num;
			}
			var obj:Object = {title:"获得奖励：", detail:str};
			(ViewFactory.getIns().initView(InfoView) as InfoView).setType(4, obj, 
				function () : void{
					if(levelUp){
						(ControlFactory.getIns().getControl(PlayerUIControl) as 
							
							PlayerUIControl).playerLevelUp(guideShowNewFunction);
					}else{
						guideShowNewFunction();
					}
					ViewFactory.getIns().initView(OneKeyEquipView).show();
				});
		}
		
		
		/**
		 *进入副本 
		 * @param e
		 * 
		 */		
		private function enterBattle(e:MouseEvent):void
		{
			GuideManager.getIns().destoryGuideMC();
			var missionArr:Array;
			switch(int(curMissionId/1000) - 1){
				case MAIN_MISSION:
					missionArr = _curMainMissionData.mission_rules_level.split("_");
					break;
				case DAILY_MISSION:
					missionArr = player.dailyMissionVo.missionDungeon.split("_");
					break;
				case HIDE_MISSION:
					missionArr = _curHideMissionData.mission_rules_level.split("_");
					break;
			}
			var name:String = missionArr[0];
			if(missionArr.length == 1){
				ViewFactory.getIns().initView(EscortView).show();
				this.hide();
			}else{
				if(missionArr.length<3){
					//普通副本
					var index:int;
					if(int(missionArr[1])<=3){
						index = 0;
					}else if(int(missionArr[1])<=6){
						index = 1;
					}else if(int(missionArr[1])<=9){
						index = 2;
					}else{
						index = 3;
					}
					(ViewFactory.getIns().initView(DungeonMenu) as DungeonMenu).nowLevel = 
						
						missionArr[0];
					(ViewFactory.getIns().initView(DungeonMenu) as DungeonMenu).nowIndex = index;
					(ViewFactory.getIns().initView(DungeonMenu) as DungeonMenu).show();
					
					this.hide();
				}else{
					//精英副本
					(ViewFactory.getIns().initView(EliteSelectView) as EliteSelectView).nowElite = 
						
						int(name.split("_")[0]);
					ViewFactory.getIns().initView(EliteSelectView).show();
					this.hide();
				}
			}
		}
		
		private function getItemTypeById(id:int):String{
			var type:String;
			if(id<1000){
				type = ItemTypeConst.BOOK;
			}else if(id<4000){
				type = ItemTypeConst.EQUIP;
			}else if(id<6000){
				type = ItemTypeConst.MATERIAL;
			}else if(id<9000){
				type = ItemTypeConst.PROP;
			}else {
				type = ItemTypeConst.SPECIAL;
			}
			return type;
		}
		
		private function showRewardBtn(show:Boolean):void{
			if(show){
				enterBtn.visible = false;
				rewardBtn.visible = true;
			}else{
				enterBtn.visible = true;
				rewardBtn.visible = false;
			}
		}
		
		
		private function get moveBar():Sprite
		{
			return layer["moveBar"];
		}
		
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		private function get missionName():TextField
		{
			return layer["missionName"];
		}
		
		private function get missionContent():TextField
		{
			return layer["missionContent"]["missionContent"];
		}
		
		private function get missionTextSP() : Sprite{
			return layer["missionContent"];
		}
		
		private function get missionObject():TextField
		{
			return layer["missionObject"];
		}
		
		private function get dungeonRank():MovieClip
		{
			return layer["dungeonRank"];
		}
		
		
		/**
		 * 
		 * 每日奇遇标题
		 * 
		 */		
		private function get dailyTitle():Sprite
		{
			return layer["dailyTitle"];
		}
		

		
		/**
		 * 
		 * 轶闻标题
		 * 
		 */		
		private function get hideTitle():Sprite
		{
			return layer["hideTitle"];
		}
		
		
		
		/**
		 * 
		 * 金钱或战魂的名称 元件
		 * 
		 */		
		private function get firstTxt():MovieClip
		{
			return layer["firstTxt"];
		}
		
		/**
		 * 
		 * 战魂的名称 元件
		 * 
		 */	
		private function get secondTxt():TextField
		{
			return layer["secondTxt"];
		}
		
		private function get moneyReward():TextField
		{
			return layer["moneyReward"];
		}
		
		private function get expReward():TextField
		{
			return layer["expReward"];
		}
		
		private function get soulReward():TextField
		{
			return layer["soulReward"];
		}
		
		
		/**
		 * 
		 * 等级不足去刷前面副本的提示文本 
		 * 
		 */		
		private function get missionTips():TextField
		{
			return layer["missionTips"];
		}
		
		
		/**
		 * 
		 * 论坛链接文本
		 * 
		 */		
		private function get urlMc():Sprite
		{
			return layer["urlMc"];
		}
		
		
		
		private function get enterBtn():SimpleButton
		{
			return layer["enterBtn"];
		}
		
		
		private function get rewardBtn():SimpleButton
		{
			return layer["rewardBtn"];
		}
		
		
		
		
		
		private function moveView(e:MouseEvent):void{
			layer.startDrag();
		}
		
		private function putView(e:MouseEvent):void{
			layer.stopDrag();
		}
		
		
		override public function show():void{
			if(layer == null) return;
			openTween();
			update();
			super.show();
		}
		
		private function openTween():void{
			layer.scaleX = layer.scaleY = 0;
			layer.visible = true;
			TweenMax.fromTo(layer,0.4,{scaleX:0,scaleY:0,x:pos.x,y:pos.y},{scaleX:1,scaleY:1,x:this.centerX,y:this.centerY});			
		}
		
		private function closeTween():void{
			TweenMax.to(layer,0.4,{scaleX:0,scaleY:0,x:pos.x,y:pos.y,onComplete:hide});			
		}
		
		private function get pos():Point{
			var p:Point = new Point();
			p.x = ViewFactory.getIns().getView(MainToolBar).layer["mission"].x  + 25 - this.x;
			p.y = ViewFactory.getIns().getView(MainToolBar).layer["mission"].y  + 25 - this.y;
			return p;
		}
		
		
		private function close(e:MouseEvent):void{
			closeTween();
			GuideManager.getIns().qiYuGuideSetting();
		}
		
		override public function hide():void{
			//curMissionType = MAIN_MISSION;
			if(mainMissionIcon != null){
				mainMissionIcon.destroy();
				mainMissionIcon = null;
			}
			if(dailyMissionIcon != null){
				dailyMissionIcon.destroy();
				dailyMissionIcon = null;
			}
			for (var i:int = 0 ; i< iconArr.length ; i++){
				if(iconArr[i] != null){
					iconArr[i].destroy();
					iconArr[i] = null;
				}
			}
			super.hide();
		}
		
		public function resetMissionType():void{
			curMissionId = 0;
		}
		
		override public function destroy():void{
			if(_itemIcon1 != null){
				_itemIcon1.destroy();
				_itemIcon1 = null;
			}
			if(_itemIcon2 != null){
				_itemIcon2.destroy();
				_itemIcon2 = null;
			}
			if(mainMissionIcon != null){
				mainMissionIcon.destroy();
				mainMissionIcon = null;
			}
			_itemVo1 = null;
			_itemVo2 = null;
			_curMainMissionData = null;
			_curHideMissionData = null;
			_curDailyMissionData = null;
			layer = null;
			super.destroy();
		}
	}
}