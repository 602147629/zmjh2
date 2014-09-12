package com.test.game.Modules.MainGame
{
	import com.Open4399Tools.Open4399Tools;
	import com.greensock.TweenMax;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.BuffConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.GuideConst;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.EquipedManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GiftManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.LogManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Modules.MainGame.Activity.MidAutumnView;
	import com.test.game.Modules.MainGame.Info.CongratulationView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.Role.RoleDetailView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PackVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ChangePage;
	import com.test.game.UI.ItemIcon;
	import com.test.game.UI.TabBar;
	import com.test.game.UI.Grid.BagAutoGrid;
	import com.test.game.UI.Grid.BagGrid;
	import com.test.game.Utils.AllUtils;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.text.TextField;

	
	public class BagView extends BaseView
	{

		public static const TABS:Array = ["all", "equip", "material","special", "prop"];
		public static const ALL_TAB:String = "all";		
		public static const EQUIP_TAB:String = "equip";	
		public static const MATERIAL_TAB:String = "material";
		public static const SPECIAL_TAB:String = "special";
		public static const PROP_TAB:String = "prop";

		
		private var _uiLibrary:Array;
		
		private var _allGrid:BagGrid;
		private var _equipGrid:BagAutoGrid;
		private var _materialGrid:BagAutoGrid;
		private var _specialGrid:BagAutoGrid;
		private var _propGrid:BagAutoGrid;

		
		
		private var _allChangePage:ChangePage;
		private var _equipChangePage:ChangePage;
		private var _materialChangePage:ChangePage;
		private var _specialChangePage:ChangePage;
		private var _propChangePage:ChangePage;

		
		private var changeNameSp:Sprite;
		
		private var _tabBar:TabBar;	
		
		// 当前标签
		private var _curTab:String;
		
		public var callBack:Function;
		
		private var _useEnable:Boolean = true;
		
		public function BagView()
		{

			super();
		}
		
		
		override public function init() : void{
			super.init();
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.BAGVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function renderView(...args):void{
			LoadManager.getIns().hideProgress();
			layer = AssetsManager.getIns().getAssetObject("BagView") as Sprite;
			this.addChild(layer);
			layer.visible = false;
			
			this.isClose = true;
			
			_uiLibrary=[];
			

			renderPages();
			renderGrids();
			initTabBar();
			initEvent();
	
			if(callBack !=null){
				callBack();
			}
			show();

		}
		
		private function initEvent():void{
			sortBtn.addEventListener(MouseEvent.CLICK,sortByItemid);
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			moveBar.addEventListener(MouseEvent.MOUSE_DOWN,moveView);
			moveBar.addEventListener(MouseEvent.MOUSE_UP,putView);
			EventManager.getIns().addEventListener(EventConst.BAG_SELECT_CHANGE,showSelected);
			EventManager.getIns().addEventListener(EventConst.BAG_UNLOCK,useWanNengKey);
		}
		
		private function showSelected(e:CommonEvent):void
		{
			switch(_curTab){
				case ALL_TAB:
					_allGrid.clearItemArrSelected();
					break;
				case EQUIP_TAB:
					_equipGrid.clearItemArrSelected();
					break;
				case MATERIAL_TAB:
					_materialGrid.clearItemArrSelected();
					break;
				case SPECIAL_TAB:
					_specialGrid.clearItemArrSelected();
					break;
				case PROP_TAB:
					_propGrid.clearItemArrSelected();
					break;
			}
			e.data[1].showSelected();
		}		
	
		private function renderPages():void{
			renderAllChangePage();
			renderEquipChangePage();
			renderMaterialChangePage();
			renderSpecialChangePage();
			renderPropChangePage();
		}
		
		private function renderGrids():void{

			renderAllItems();
			renderEquipItems();
			renderMaterialItems();
			renderSpecialItems();
			renderPropItems();
			PackManager.getIns().updatePackBoxs();
			capacity.text = pack.packUsed.toString() +"/"+ pack.packMaxRoom.toString();
		}

		private function renderAllItems():void{
			if(!_allGrid){
				_allGrid = new BagGrid(ItemIcon,6, 6, 50, 50, 1, 1);
				_allGrid["layerName"] = ALL_TAB;
				_allGrid.name = "grid";
				_allGrid.x = 56;
				_allGrid.y = 96;
				layer.addChild(_allGrid);
				_uiLibrary.push(_allGrid);
			}
			_allGrid.setData(pack.allWithoutEquiped
				,_allChangePage);
			
		}
		
		private function renderAllChangePage():void{
			_allChangePage = new ChangePage();
			_allChangePage.x = 240;
			_allChangePage.y = 406;
			_allChangePage["layerName"] = ALL_TAB;
			layer.addChild(_allChangePage);
			_uiLibrary.push(_allChangePage);
		}
		
		

		
		
		private function renderEquipItems():void{
			
			if(!_equipGrid){
				_equipGrid = new BagAutoGrid(ItemIcon,6, 6, 50, 50,  1, 1);
				_equipGrid["layerName"] = EQUIP_TAB;
				_equipGrid.name = "grid";
				_equipGrid.x = 56;
				_equipGrid.y = 96;
				layer.addChild(_equipGrid);
				_uiLibrary.push(_equipGrid);
			}
			
			_equipGrid.setData(PackManager.getIns().sortByMId(pack.equipTab)
				,_equipChangePage);
		}
		
		
		private function renderEquipChangePage():void{
			_equipChangePage = new ChangePage();
			_equipChangePage.x = 240;
			_equipChangePage.y = 406;
			_equipChangePage["layerName"] = EQUIP_TAB;
			layer.addChild(_equipChangePage);
			_uiLibrary.push(_equipChangePage);
		}
		
		
		private function renderSpecialItems():void
		{
			if(!_specialGrid){
				_specialGrid = new BagAutoGrid(ItemIcon,6, 6, 50, 50,  1, 1);
				_specialGrid["layerName"] = SPECIAL_TAB;
				_specialGrid.name = "grid";
				_specialGrid.x = 56;
				_specialGrid.y = 96;
				layer.addChild(_specialGrid);
				_uiLibrary.push(_specialGrid);
			}
			
			_specialGrid.setData(PackManager.getIns().sortByMId(pack.specialTab)
				,_specialChangePage);
		}	
		
		private function renderSpecialChangePage():void{
			_specialChangePage = new ChangePage();
			_specialChangePage.x = 240;
			_specialChangePage.y = 406;
			_specialChangePage["layerName"] = SPECIAL_TAB;
			layer.addChild(_specialChangePage);
			_uiLibrary.push(_specialChangePage);
		}
		
		private function renderPropItems():void{
			
			if(!_propGrid){
				_propGrid = new BagAutoGrid(ItemIcon, 6, 6, 50, 50, 1, 1);
				_propGrid["layerName"] = PROP_TAB;
				_propGrid.name = "grid";
				_propGrid.x = 56;
				_propGrid.y = 96;
				layer.addChild(_propGrid);
				_uiLibrary.push(_propGrid);
			}
			_propGrid.setData(PackManager.getIns().sortByMId(pack.propTab),_propChangePage);
		}
		

		private function renderPropChangePage():void{
			_propChangePage = new ChangePage();
			_propChangePage.x = 240;
			_propChangePage.y = 406;
			_propChangePage["layerName"] = PROP_TAB;
			layer.addChild(_propChangePage);
			_uiLibrary.push(_propChangePage);
		}
		
		
		private function renderMaterialItems():void{
			if(!_materialGrid){
				_materialGrid = new BagAutoGrid(ItemIcon, 6, 6, 50, 50,  1, 1);
				_materialGrid["layerName"] = MATERIAL_TAB;
				_materialGrid.name = "grid";
				_materialGrid.x = 56;
				_materialGrid.y = 96;
				layer.addChild(_materialGrid);
				_uiLibrary.push(_materialGrid);
			}
			
			_materialGrid.setData(PackManager.getIns().sortByMId(pack.materialTab)
				,_materialChangePage);
		}
		
		private function renderMaterialChangePage():void{
			_materialChangePage = new ChangePage();
			_materialChangePage.x = 240;
			_materialChangePage.y = 406;
			_materialChangePage["layerName"] = MATERIAL_TAB;
			layer.addChild(_materialChangePage);
			_uiLibrary.push(_materialChangePage);
		}
		

		
		private function initTabBar():void{
			var arr:Array = [allTab, equipTab,materialTab,specialTab,propTab];
			_tabBar = new TabBar(arr);
			_tabBar.addEventListener(EventConst.TYPE_SELECT_CHANGE, onTabChange);
			_tabBar.selectIndex = 0;
		}
		
		
		
		private function onTabChange(e:CommonEvent) : void
		{
			_curTab = TABS[e.data as int];
			checkTab();
		}
		
		private function checkTab():void{
			for each(var item:* in _uiLibrary)
			{
				if (item["layerName"] == _curTab)
				{
					item.visible = true;
					if(item.name == "grid"){
						item.clearItemArrSelected();	
					}
				}
				else
				{
					item.visible = false;
				}
			}
		}
		
		// 刷新
		override public function update() : void
		{
			renderGrids();
			_curTab = ALL_TAB;
			_tabBar.selectIndex = 0;
			checkTab();
			PackManager.getIns().checkBagFull();
			_useEnable = true;
		}
		

		//穿上装备
		public function putOnEquip(itemData:ItemVo,show:Boolean = true):void{
			if(ViewFactory.getIns().getView(RoleDetailView)==null){
				(ViewFactory.getIns().initView(RoleDetailView) as RoleDetailView).callBack =
					function ():void{
						finalPutOn(itemData,show);
					};
			}else{
				finalPutOn(itemData,show);
			}

		}
		
		private function finalPutOn(itemData:ItemVo,show:Boolean = true):void{
			GuideManager.getIns().bagGuideSetting();
			EquipedManager.getIns().upEquip(itemData);
			PlayerManager.getIns().updatePropertys();
			if(show){
				ViewFactory.getIns().initView(RoleDetailView).show();
			}
			(ViewFactory.getIns().getView(RoleDetailView) as RoleDetailView).update();
			//GuideManager.getIns().oneKeyEquipJudge();
			update();
		}
		

		
	
		/**
		 * 穿上时装
		 * @param itemData
		 * @param show
		 * 
		 */
		public function putOnFashion(itemData:ItemVo,show:Boolean = true):void{
			if(ViewFactory.getIns().getView(RoleDetailView)==null){
				(ViewFactory.getIns().initView(RoleDetailView) as RoleDetailView).callBack =
					function ():void{
						finalPutOnFashion(itemData,show);
					};
			}else{
				finalPutOnFashion(itemData,show);
			}
			
		}
		
		/**
		 *穿上时装功能 
		 * @param itemData
		 * @param show
		 * 
		 */
		private function finalPutOnFashion(itemData:ItemVo,show:Boolean = true):void{
			EquipedManager.getIns().upFashion(itemData);
			PlayerManager.getIns().updatePropertys();
			if(show){
				ViewFactory.getIns().initView(RoleDetailView).show();
			}
			(ViewFactory.getIns().getView(RoleDetailView) as RoleDetailView).update();
			update();
		}
		
		
		//出售物品
		public function sellItem(itemData:ItemVo,num:int):void{
			var sellStr:String;
			var sellPrice:int;
			if(itemData.type == ItemTypeConst.BOSS){
				sellPrice = itemData.sale_money+(itemData.lv-1)*NumberConst.getIns().bossUpPrice;
			}else{
				sellPrice = itemData.sale_money*num;
			}
			
			if(num==1){
				sellStr = "是否以"+sellPrice+"金币出售\n一件"+itemData.name;
			}else{
				sellStr = "是否以"+sellPrice+"金币出售\n全部"+itemData.name;
			}
			
			(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice(sellStr,
				function () : void{
					PackManager.getIns().sellItem(itemData,num);
					ViewFactory.getIns().getView(MainToolBar).update();
					update();
				});

		}
		

		
		
		
		//使用物品
		public function useProp(itemData:ItemVo):void{
			if(_useEnable){
				_useEnable = false;
				if(itemData.id >= NumberConst.getIns().levelGiftId_20 
					&& itemData.id <= NumberConst.getIns().levelGiftId_200){
					checkLevelGift(itemData);
				}else{
					switch(itemData.id){
						case NumberConst.getIns().resetSkillBookId:
							(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
								"是否消耗重修之书重置全部经脉并返还所有潜能点？",useResetSkillBook,resetUseEnable);
							break;
						case NumberConst.getIns().wanNengKeyId:
							(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
								"是否使用万能钥匙开启一格背包？",useWanNengKey,resetUseEnable);
							break;
						case NumberConst.getIns().gaoShouCard:
							if(player.autoFightInfo.autoFightCount > NumberConst.getIns().zero){
								(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
									"您当前的高手卡效果还未用完，请消耗完再使用",resetUseEnable);
							}else if(player.mainMissionVo.id<=NumberConst.getIns().enableGaoShouCardMissionId){
								(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
									"高手卡在完成10级任务后才可使用~",resetUseEnable);
							}else{
								(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
									"是否使用高手卡？",useGaoShouCard,resetUseEnable);
							}
							
							break;
						
						case NumberConst.getIns().rpCard:
							if(player.autoFightInfo.rpCardCount > NumberConst.getIns().zero){
								(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
									"您当前的人品卡效果还未用完，请消耗完再使用",resetUseEnable);
							}else{
								(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
									"是否使用人品卡？",useRpCard,resetUseEnable);
							}
							
							break;
						
						case NumberConst.getIns().doubleCard:
							if(player.autoFightInfo.doubleCardCount > NumberConst.getIns().zero){
								(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
									"您当前的双倍卡效果还未用完，请消耗完再使用",resetUseEnable);
							}else{
								(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
									"是否使用双倍卡？",useDoubleCard,resetUseEnable);
							}
							
							break;
						case NumberConst.getIns().changeNameCard:
							(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
								"是否使用改名卡改变角色名字？",useChangeNameCard,resetUseEnable);
							break;
						case NumberConst.getIns().weatherSelectID:
							(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
								"请在关卡中使用天气控制器",resetUseEnable);
							break;
						case NumberConst.getIns().expId:
							(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
								"是否使用经验卡？", useExpCard, resetUseEnable);
							break;
						case NumberConst.getIns().highExpId:
							(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
								"是否使用高级经验卡？", useHighExpCard, resetUseEnable);
							break;
						case NumberConst.getIns().moonCakeId:
							useMoonCake();
							break;
						default:
							GiftManager.getIns().useGift(itemData.id);
							update();
							break;
					}
				
				}
			}

		}
		
		private function resetUseEnable():void{
			_useEnable = true;
		}
		
		//使用月饼
		private function useMoonCake() : void{
			var zhongQiu:int = TimeManager.getIns().disDayNum(NumberConst.getIns().moonCakeGiftDate, TimeManager.getIns().returnTimeNowStr().split(" ")[0]);
			if(zhongQiu <= 0 && zhongQiu >= -NumberConst.getIns().moonCakeDay){
				ViewFactory.getIns().initView(MidAutumnView).show();
				resetUseEnable();
				hide();
			}else{
				(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
					"不在活动时间内，无法使用",resetUseEnable);
			}
		}
		
		//使用经验卡
		private function useExpCard() : void{
			PlayerManager.getIns().addExp(NumberConst.getIns().twentyThousand);
			PackManager.getIns().reduceItem(NumberConst.getIns().expId,NumberConst.getIns().one);
			update();
			ViewFactory.getIns().getView(RoleStateView).update();
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).upDataLevel(player.character.lv);
			if(ViewFactory.getIns().getView(RoleDetailView) != null){
				if(ViewFactory.getIns().getView(RoleDetailView).isClose == false){
					ViewFactory.getIns().getView(RoleDetailView).update();
				}
			}
		}
		
		//使用高级经验卡
		private function useHighExpCard() : void{
			PlayerManager.getIns().addExp(NumberConst.getIns().twentyThousand * NumberConst.getIns().ten);
			PackManager.getIns().reduceItem(NumberConst.getIns().highExpId,NumberConst.getIns().one);
			update();
			ViewFactory.getIns().getView(RoleStateView).update();
			(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).upDataLevel(player.character.lv);
			if(ViewFactory.getIns().getView(RoleDetailView) != null){
				if(ViewFactory.getIns().getView(RoleDetailView).isClose == false){
					ViewFactory.getIns().getView(RoleDetailView).update();
				}
			}
		}
		
		/**
		 *使用高手卡
		 * 
		 */
		private function useGaoShouCard():void
		{
			player.autoFightInfo.autoFightCount = NumberConst.getIns().cardNum;
			(ViewFactory.getIns().initView(CongratulationView) as CongratulationView).startPlay(BuffConst.BUFF_GAOSHOU);
			/*(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
				"已使用高手卡，获得30次高手自动战斗！");*/
			PackManager.getIns().reduceItem(NumberConst.getIns().gaoShouCard,NumberConst.getIns().one);
			update();
		}
		
		
		/**
		 *使用人品卡
		 * 
		 */
		private function useRpCard():void
		{
			player.autoFightInfo.rpCardCount = NumberConst.getIns().cardNum;
			(ViewFactory.getIns().initView(CongratulationView) as CongratulationView).startPlay(BuffConst.BUFF_RENPIN);
			/*(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
				"已使用人品卡，获得30次战斗的人品加成！");*/
			PackManager.getIns().reduceItem(NumberConst.getIns().rpCard,NumberConst.getIns().one);
			update();
		}
		
		
		/**
		 *使用双倍经验卡
		 * 
		 */
		private function useDoubleCard():void
		{
			player.autoFightInfo.doubleCardCount = NumberConst.getIns().cardNum;
			(ViewFactory.getIns().initView(CongratulationView) as CongratulationView).startPlay(BuffConst.BUFF_SHUANGBEI);
			/*(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
				"已使用双倍卡，获得30次双倍经验金币战魂战斗！");*/
			PackManager.getIns().reduceItem(NumberConst.getIns().doubleCard,NumberConst.getIns().one);
			update();
		}
		
		/**
		 *使用改名卡
		 * 
		 */
		private function useChangeNameCard():void
		{	
			showChangeNameSp();
		}
		
		private function showChangeNameSp():void{

			changeNameSp= AssetsManager.getIns().getAssetObject("ChangeName") as Sprite;
			changeNameSp.x = 50;
			changeNameSp.y = 150;
			(changeNameSp["ConfirmBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, comfireSelect);
			(changeNameSp["PlayerName"] as TextField).addEventListener(TextEvent.TEXT_INPUT, nameInputEvent);
			this.addChild(changeNameSp);
			
			var _bg:BaseNativeEntity = new BaseNativeEntity();
			_bg.data.bitmapData = AUtils.getNewObj("UIBg") as BitmapData;
			_bg.x = -352;
			_bg.y = -185;
			changeNameSp.addChildAt(_bg, 0);
		}
		
		private function comfireSelect(e:MouseEvent) : void{
			if((changeNameSp["PlayerName"] as TextField).text != ""){
				var str:String = "确定使用新名字： " + (changeNameSp["PlayerName"] as TextField).text;
				if(GameConst.localLogin){
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice(str, saveName);
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice(str, checkBadWords);
				}
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("昵称不能为空",resetUseEnable);
			}
		}
		
		
		private function checkBadWords() : void{
			Open4399Tools.getIns().checkBadWords((changeNameSp["PlayerName"] as TextField).text, saveName);
		}
		
		private function saveName(code:int = 10000) : void{
			if(code == 10000){
				if(changeNameSp.parent != null){
					changeNameSp.parent.removeChild(changeNameSp);
				}
				player.name = (changeNameSp["PlayerName"] as TextField).text;
				PackManager.getIns().reduceItem(NumberConst.getIns().changeNameCard,NumberConst.getIns().one);
				player.logVo.nameChange++;
				(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).update();
				update();
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("昵称带有敏感用词，请重新命名",resetUseEnable);
			}
		}
		
		private function nameInputEvent(e:TextEvent):void{
			if((AllUtils.getStringBytesLength((changeNameSp["PlayerName"] as TextField).text,"gb2312") 
				+ AllUtils.getStringBytesLength(e.text,'gb2312')) > (changeNameSp["PlayerName"] as TextField).maxChars){   
				e.preventDefault();   
				return;    
			}   
		} 
		
		
		/**
		 *使用重修之书
		 * 
		 */
		private function useResetSkillBook():void
		{
			PlayerManager.getIns().resetJingMai();
			(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
				"已重置全部经脉并返还所有潜能点！\n额外获得一点潜能点！");
			PackManager.getIns().reduceItem(NumberConst.getIns().resetSkillBookId,NumberConst.getIns().one);
			PlayerManager.getIns().updatePropertys();
			update();
		}
		
		/**
		 *使用万能钥匙 
		 */
		private function useWanNengKey(e:CommonEvent = null):void
		{
			PackManager.getIns().openBagRoomLock();
			PackManager.getIns().reduceItem(NumberConst.getIns().wanNengKeyId,NumberConst.getIns().one);

			update();
		}
		
		
		/**
		 *检测等级礼包是否可以使用 
		 * @param itemVo
		 * 
		 */		
		private function checkLevelGift(itemVo:ItemVo):void{
			var level:int = (itemVo.id - 6000) * 10;
			if(PlayerManager.getIns().player.character.lv<level){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"角色等级不足！\n请提升至"+level+"级后再使用",resetUseEnable);
			}else{
				LogManager.getIns().addGiftLog(itemVo.id,"lvGift");
				GiftManager.getIns().useGift(itemVo.id);
				update();
			}
		}
		
		
		//整理背包 重新排序
		private function sortByItemid(e:MouseEvent):void{
			if(_allGrid){
				PackManager.getIns().sortMidByItemId(pack.allWithoutEquiped);
				renderGrids();
			}
		}
		
		override public function tweenLiteRight():void{
			TweenMax.fromTo(this,0.3,{x:300},{x:428});
		}
		
		override public function tweenLiteCenter():void{
			TweenMax.fromTo(this,0.3,{x:428},{x:300});
		}
		
		
		
		override public function show():void{
			if(layer == null) return;
			
			if(!ViewFactory.getIns().getView(RoleDetailView) || ViewFactory.getIns().getView(RoleDetailView).isClose){
				this.x = 300;
			}else if(this.isClose){
				tweenLiteRight();
				ViewFactory.getIns().getView(RoleDetailView).tweenLiteLeft();
			}
			this.y=34;
			openTween();
			update();
			
			super.show();
			GuideManager.getIns().bagGuideSetting(GuideConst.OPEN);
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		private function get pack():PackVo{
			return PlayerManager.getIns().player.pack;
		}
		
		override public function hide():void{
			super.hide();
			GuideManager.getIns().bagGuideSetting(GuideConst.CLOSE);
		}
		
		public function onlyHide() : void{
			super.hide();
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
			p.x = ViewFactory.getIns().getView(MainToolBar).layer["bag"].x  + 25 - this.x;
			p.y = ViewFactory.getIns().getView(MainToolBar).layer["bag"].y  + 25 - this.y;
			return p;
		}
		
		
		private function close(e:MouseEvent):void{
			if(ViewFactory.getIns().getView(RoleDetailView) && !ViewFactory.getIns().getView(RoleDetailView).isClose){
				ViewFactory.getIns().getView(RoleDetailView).hide();
			}
			closeTween();
			
		}
		
		private function moveView(e:MouseEvent):void{
			this.startDrag();
		}
		
		private function putView(e:MouseEvent):void{
			this.stopDrag();
		}

		public function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		public function get moveBar():Sprite
		{
			return layer["moveBar"];
		}

		
		public function get allTab():MovieClip
		{
			return layer["allTab"];
		}
		
		public function get equipTab():MovieClip
		{
			return layer["equipTab"];
		}
		
		public function get propTab():MovieClip
		{
			return layer["propTab"];
		}
		
		public function get materialTab():MovieClip
		{
			return layer["materialTab"];
		}
		
		public function get specialTab():MovieClip
		{
			return layer["specialTab"];
		}
		
		public function get capacity():TextField{
			return layer["capacity"];
		}
		
		public function get sortBtn():SimpleButton{
			return layer["sortBtn"];
		}
		


		
		override public function destroy():void{
			sortBtn.removeEventListener(MouseEvent.CLICK,sortByItemid);
			closeBtn.removeEventListener(MouseEvent.CLICK,close);
			moveBar.removeEventListener(MouseEvent.MOUSE_DOWN,moveView);
			moveBar.removeEventListener(MouseEvent.MOUSE_UP,putView);
			EventManager.getIns().removeEventListener(EventConst.BAG_SELECT_CHANGE,showSelected);
			if(_allChangePage != null){
				_allChangePage.destroy();
				_allChangePage = null;
			}
			if(_equipChangePage != null){
				_equipChangePage.destroy();
				_equipChangePage = null;
			}
			if(_materialChangePage != null){
				_materialChangePage.destroy();
				_materialChangePage = null;
			}
			if(_specialChangePage != null){
				_specialChangePage.destroy();
				_specialChangePage = null;
			}
			if(_propChangePage != null){
				_propChangePage.destroy();
				_propChangePage = null;
			}
			if(_equipGrid != null){
				_equipGrid.destroy();
				_equipGrid = null;
			}
			if(_materialGrid != null){
				_materialGrid.destroy();
				_materialGrid = null;
			}
			if(_specialGrid != null){
				_specialGrid.destroy();
				_specialGrid = null;
			}
			if(_propGrid != null){
				_propGrid.destroy();
				_propGrid = null;
			}
			if(_uiLibrary != null){
				_uiLibrary.length = 0;
				_uiLibrary = null;
			}
			if(_tabBar != null){
				_tabBar.destroy();
				_tabBar = null;
			}
			super.destroy();
		}
		
	}
}