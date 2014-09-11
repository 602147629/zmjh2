package com.test.game.Manager
{	
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.DebugConst;
	import com.test.game.Const.EquipmentType;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Const.MidConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Modules.MainGame.BagView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Role.RoleDetailView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.boss.BossView;
	import com.test.game.Mvc.Configuration.Book;
	import com.test.game.Mvc.Configuration.BossCard;
	import com.test.game.Mvc.Configuration.BossCardUp;
	import com.test.game.Mvc.Configuration.Elite;
	import com.test.game.Mvc.Configuration.Equipment;
	import com.test.game.Mvc.Configuration.Fashion;
	import com.test.game.Mvc.Configuration.Material;
	import com.test.game.Mvc.Configuration.Prop;
	import com.test.game.Mvc.Configuration.Special;
	import com.test.game.Mvc.Configuration.Strengthen;
	import com.test.game.Mvc.Vo.EliteDungeonPassVo;
	import com.test.game.Mvc.Vo.EquipInfo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PackVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.events.Event;
	
	public class PackManager extends Singleton
	{
		
		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function PackManager()
		{
			super();
		}
		
		public static function getIns():PackManager{
			return Singleton.getIns(PackManager);
		}
		
		public function get pack():PackVo{
			return player.pack;
		}
		
		
		
		public function getItemTypeById(id:int):String{
			var type:String;
			if(id<1000){
				type = ItemTypeConst.BOOK;
			}else if(id<4000){
				type = ItemTypeConst.EQUIP;
			}else if(id<6000){
				type = ItemTypeConst.MATERIAL;
			}else if(id<7000){
				type = ItemTypeConst.PROP;
			}else if(id<7500){
				type = ItemTypeConst.FASHION;
			}else if(id<9000){
				type = ItemTypeConst.TITLE;
			}else if(id<10000){
				type = ItemTypeConst.SPECIAL;
			}else{
				type = ItemTypeConst.BOSS;
			}
			return type;
		}

		


		
		/**
		 * 
		 * 生成物品
		 * 
		 */
		public function creatItem(id:int) : ItemVo
		{
			var item:ItemVo = new ItemVo();
			switch(getItemTypeById(id)){
				case ItemTypeConst.EQUIP:
					item.equipConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.EQUIPMENT,id) as Equipment;
					item.strengthen = ConfigurationManager.getIns().getObjectByID(AssetsConst.STRENGTHEN,NumberConst.getIns().zero) as Strengthen;
					item.type = ItemTypeConst.EQUIP;
					item.name = item.equipConfig.name;
					break;
				case ItemTypeConst.FASHION:
					item.fashionConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.FASHION,id) as Fashion;
					item.time = TimeManager.getIns().curTimeStr;
					item.type = ItemTypeConst.FASHION;
					item.name = item.fashionConfig.name;
					break;
				case ItemTypeConst.MATERIAL:
					item.materialConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.MATERIAL,id) as Material;
					item.type = ItemTypeConst.MATERIAL;
					item.name = item.materialConfig.name;
					item.sale_money =  item.materialConfig.sale_money;
					break;
				case ItemTypeConst.SPECIAL:
					item.specialConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.SPECIAL,id) as Special;
					item.type = ItemTypeConst.SPECIAL;
					item.name = item.specialConfig.name;
					item.sale_money =  item.specialConfig.sale_money;
					break;
				case ItemTypeConst.BOOK:
					item.bookConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.BOOK,id) as Book;
					item.type = ItemTypeConst.BOOK;
					item.name = item.bookConfig.name;
					item.sale_money =  item.bookConfig.sale_money;
					break;
				case ItemTypeConst.PROP:
					item.propConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.PROP,id) as Prop;
					item.type = ItemTypeConst.PROP;
					item.name = item.propConfig.name;
					break;
				case ItemTypeConst.TITLE:
					item.type = ItemTypeConst.TITLE;
					break;
			}
			item.id = id;
			item.lv = NumberConst.getIns().zero;
			item.isEquiped = false;
			//equip.mId = 0;
			return item;
		}
		
		
		/**
		 * 
		 * 生成BOSS卡片
		 * 
		 */
		public function creatBossData(bossId:int, lv:int = 1) : ItemVo
		{
			var boss:ItemVo = new ItemVo();
			var specialId:int = bossId - 1000 + 10000;
			boss.specialConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.SPECIAL,specialId) as Special;
			boss.bossConfig = ConfigurationManager.getIns().getObjectByID(AssetsConst.BOSS,bossId) as BossCard;
			boss.bossUp = ConfigurationManager.getIns().getObjectByID(AssetsConst.BOSS_UP,lv) as BossCardUp;
			boss.type = ItemTypeConst.BOSS;
			boss.name = boss.bossConfig.name;
			boss.id = bossId - 1000 + 10000;
			boss.lv = lv;
			boss.sale_money = boss.specialConfig.sale_money;
			boss.isEquiped = false;
			return boss;
		}
		
		public function creatBossDataBySpecial(specialBossID:int) : ItemVo{
			var bossId:int = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SPECIAL, "id", specialBossID).bid;
			var lv:int = int((specialBossID - 10000) / 100) + 1;
			return creatBossData(bossId, lv);
		}
		
		/**
		 * 获取当前可以收集的Boss卡牌
		 */
		public function get curBossCardData():Vector.<ItemVo>{
			var curBosses:Vector.<ItemVo> = new Vector.<ItemVo>;

			for(var i:int = 0; i<player.eliteDungeon.eliteDungeonPass.length;i++){
				var eliteDungeon:EliteDungeonPassVo = player.eliteDungeon.eliteDungeonPass[i];
				if(eliteDungeon.lv!=-1){
					var elite:Elite = ConfigurationManager.getIns().getObjectByProperty(
						AssetsConst.ELITE,"level_id",eliteDungeon.name) as Elite;
					var bossId:int = int(elite.special)-8000;
					var bossVo:ItemVo = creatBossData(bossId);
					curBosses.push(bossVo);
				}

			}
			sortMidByItemId(curBosses);
			return curBosses;
		}
		
		/**
		 * 召唤Boss卡牌
		 * @param ItemVo 
		 */	
		public function summonBossCard(data:ItemVo):void{

			var pieceId:int = data.id - 10000 + 9000;
			
			if(PackManager.getIns().searchItemNum(pieceId) < NumberConst.getIns().summonBossCost){
				var wanNengCost:int = NumberConst.getIns().summonBossCost - PackManager.getIns().searchItemNum(pieceId);
				if(PackManager.getIns().searchItemNum(pieceId)>0){
					reduceItem(pieceId,PackManager.getIns().searchItemNum(pieceId));
				}
				reduceItem(NumberConst.getIns().wanNengId,wanNengCost);
			}else{
				reduceItem(pieceId,NumberConst.getIns().summonBossCost);
			}
			
			addItemIntoPack(data);
		
			(ViewFactory.getIns().getView(BossView) as BossView).renderSummon(false);
		}
		
		/**
		 * 升级Boss卡牌
		 * @param ItemVo 
		 * 
		 */	
		public function upgradeBossCard(data:ItemVo):void{
			
			var materials:Array = data.bossUp.up_material.split("|");
			var materialNumList:Array = data.bossUp.up_number.split("|");
			
			for(var i:int = 0;i<materials.length;i++){
				PackManager.getIns().reduceItem(materials[i],materialNumList[i]);
			}

			if(data.bossUp.up_card!=0){
				PackManager.getIns().reduceUpgradeBoss(data);
			}
			
			PlayerManager.getIns().reduceMoney(data.bossUp.up_money);
			PlayerManager.getIns().reduceSoul(data.bossUp.up_soul);
				
			var bossUp:BossCardUp = ConfigurationManager.getIns().getObjectByID(AssetsConst.BOSS_UP,data.lv+1) as BossCardUp;
			data.lv += 1;
			data.bossUp = bossUp;
			
			ViewFactory.getIns().getView(MainToolBar).update();
			ViewFactory.getIns().getView(BossView).update();
			PlayerManager.getIns().updatePropertys();
			
		}
		
		/**
		 * 返回一组数量最多的物品（不包括上限值）
		 * @param itemID
		 * 
		 */		
		public function searchMaxNumItem(itemID:int) : ItemVo
		{
			var resultItem:ItemVo;
			var itemArr:Array = searchItem(itemID);
			var tempArr:Array = new Array();
			for(var i:int=0;i<itemArr.length;i++){
				if(itemArr[i].num < NumberConst.getIns().itemNumMax){
					tempArr.push(itemArr[i]);
				}
			}
			
			if(tempArr.length>0){
				resultItem	= tempArr[0];
			}
			
			for(var j:int=0;j<tempArr.length;j++){
				if(tempArr[j].num > resultItem.num){
					resultItem = tempArr[j];
				}
			}

			return resultItem;
		}

			
		
		/**
		 * 返回一组数量最少的物品（包括上限值） 
		 * @param itemID
		 * 
		 */		
		public function searchMinNumItem(itemID:int) : ItemVo
		{
			var resultItem:ItemVo;
			var itemArr:Array = searchItem(itemID);
			
			
			if(itemArr.length>0){
				resultItem	= itemArr[0];
			}
			
			for(var i:int=0;i<itemArr.length;i++){
				if(itemArr[i].num < resultItem.num){
					resultItem = itemArr[i];
				}
			}
			return resultItem;
		}
		
		

		
		/**
		 * 搜索背包中的物品 
		 * @param itemID 
		 * 
		 */		
		public function searchItem(itemID:int) : Array
		{
			var itemArr:Array = new Array();
			for each(var item:ItemVo in player.pack.allWithoutEquiped)
			{
				if (item.id == itemID )
				{
					itemArr.push(item);
				}
			}
			return itemArr;
		}
		
		
		/**
		 * 返回物品在背包中的数量 
		 * @param itemID
		 * 
		 */		
		public function searchItemNum(itemID:int) : int
		{
			var itemArr:Array = searchItem(itemID);
			var num:int = 0;
			if(itemArr.length != 0){
				for(var i:int=0;i<itemArr.length;i++){
					num += itemArr[i].num;
				}
			}else{
				num=0;
			}
			return num;
		}
		
		
		/**
		 * 返回时装的数量 
		 * @param itemID
		 * 
		 */		
		public function searchFashionNum(itemID:int) : int
		{
			var itemArr:Array = new Array();
			for each(var item:ItemVo in player.pack.fashion)
			{
				if (item.id == itemID )
				{
					itemArr.push(item);
				}
			}
			var num:int = 0;
			if(itemArr.length != 0){
				for(var i:int=0;i<itemArr.length;i++){
					num += itemArr[i].num;
				}
			}
			return num;
		}
		
		
		/**
		 * 根据类型搜索背包中的装备 
		 * @param itemID
		 * 
		 */		
		public function searchPackEquipByType(type:String) : ItemVo
		{
			var Vo:ItemVo;
			for each(var item:ItemVo in player.pack.allWithoutEquiped)
			{
				if (item.type == ItemTypeConst.EQUIP && item.equipConfig.type == type)
				{
					Vo = item;
				}
			}
			return Vo;
		}
		
		

		
		/**
		 * 搜索装备中的物品 
		 * @param itemID
		 * @return 
		 * 
		 */		
		public function searchEquip(itemID:int) : ItemVo
		{
			var Vo:ItemVo;
			for each(var item:ItemVo in player.pack.equip)
			{
				if (item.id == itemID && item.mid == MidConst.EQUIP_POSITION)
				{
					Vo = item;
					break;
				}
			}
			return Vo;
		}
		
		
		/**
		 * 搜索装备中的时装 
		 * @param itemID
		 * @return 
		 * 
		 */		
		public function searchEquipedFashion(itemID:int) : ItemVo
		{
			var Vo:ItemVo;
			for each(var item:ItemVo in player.pack.fashion)
			{
				if (item.id == itemID && item.mid == MidConst.FASHION_POSITION)
				{
					Vo = item;
					break;
				}
			}
			return Vo;
		}
		
		/**
			一键装备
		 */	
		public function oneKeyEquip():void{
			var info:EquipInfo = player.equipInfo;
			if (info.weapon == -1)
			{
				var weapon:ItemVo = searchPackEquipByType(EquipmentType.WEAPON);
				if(weapon){
					EquipedManager.getIns().upEquip(weapon);
				}
			}
			
			
			if (info.head == -1)
			{
				var head:ItemVo = searchPackEquipByType(EquipmentType.HEAD);
				if(head){
					EquipedManager.getIns().upEquip(head);
				}
			}

			
			if (info.neck == -1)
			{
				var neck:ItemVo = searchPackEquipByType(EquipmentType.NECK);
				if(neck){
					EquipedManager.getIns().upEquip(neck);
				}
			}

			
			if (info.clothes == -1)
			{
				var clothes:ItemVo = searchPackEquipByType(EquipmentType.CLOTHES);
				if(clothes){
					EquipedManager.getIns().upEquip(clothes);
				}
			}

			
			if (info.shoulder == -1)
			{
				var shoulder:ItemVo = searchPackEquipByType(EquipmentType.SHOULDER);
				if(shoulder){
					EquipedManager.getIns().upEquip(shoulder);
				}
			}

			if (info.shoes == -1)
			{
				var shoes:ItemVo = searchPackEquipByType(EquipmentType.SHOES);
				if(shoes){
					EquipedManager.getIns().upEquip(shoes);
				}
			}
			PlayerManager.getIns().updatePropertys();

		}
		
		/**
		 * 搜索升级消耗boss卡牌
		 * @param itemID
		 */		
		public function searchUpgradeBossCard(itemVo:ItemVo) : ItemVo
		{
			var Vo:ItemVo;
			for each(var item:ItemVo in player.pack.boss)
			{
				if (item.id == itemVo.id 
					&& item.lv == itemVo.lv 
					&& item.mid != itemVo.mid)
				{
					Vo = item;
					break;
				}
			}
			return Vo;
		}
		
		
		/**
		 * 搜索材料boss卡牌
		 * @param itemID
		 * 
		 */		
		public function searchMaterialBossCard(itemID:int,lv:int) : Boolean
		{
		    var result:Boolean = false;
			var count:int=0;
			for each(var item:ItemVo in player.pack.boss)
			{
				if (item.id == itemID && item.lv == lv)
				{
					count++;
				}
			}
			
			if(count>=2){
				result = true;
			}
			return result;
		}
		
		
		/**
		 * 搜索附体的boss卡牌
		 * @param itemID
		 * 
		 */		
		public function searchAttachedBossCard(itemID:int) : ItemVo
		{
			var Vo:ItemVo;
			for each(var item:ItemVo in player.pack.boss)
			{
				if (item.id == itemID && 
					(item.mid == MidConst.ATTACH_FRONT_POSITION || 
						item.mid == MidConst.ATTACH_MIDDLE_POSITION ||
						item.mid == MidConst.ATTACH_BACK_POSITION))
				{
					Vo = item;
					break;
				}
			}
			return Vo;
		}
		
		/**
		 * 搜索支援的boss卡牌
		 * @param itemID
		 * 
		 */		
		public function searchAssistedBossCard(itemID:int) : ItemVo
		{
			var Vo:ItemVo;
			for each(var item:ItemVo in player.pack.boss)
			{
				if (item.id == itemID && item.mid == MidConst.ASSIST_POSIOTION)
				{
					Vo = item;
					break;
				}
			}
			return Vo;
		}

		/**
		 *  计算物品添加进背包是否增加格子
		 */		
		private function isRoomAdd(id:int):Boolean{
			var add:Boolean;
			switch(getItemTypeById(id)){
				case ItemTypeConst.EQUIP:
					add = true;
					break;
				case ItemTypeConst.BOOK:
					add = true;
					break;
				case ItemTypeConst.BOSS:
					add = true;
					break;
				case ItemTypeConst.MATERIAL:
				case ItemTypeConst.PROP:
				case ItemTypeConst.SPECIAL:
					if(searchItemNum(id)==0){
						add = true;
					}else{
						add = false;
					}
					break;
			}
			return add;
		}
		


		
		/**
		 * 从背包移除物品
		 * @param mid
		 * 
		 */		
		public function removeItemFromPack(mid:int) : void
		{
			player.pack.packUsed -= 1;
			var index:int = searchEquipIndexByMId(mid);
			if (index == -1){
				DebugArea.getIns().showInfo("包裹中没有该物品，mid为" + mid, DebugConst.ERROR);
				//throw new Error("包裹中没有该物品");
			}
			player.pack.allWithoutEquiped.splice(index, 1);
		}
		
		
		
		private function searchEquipIndexByMId(mId:int) : int
		{
			var index:int = -1;
			
			for (var i:int = 0, len:int = player.pack.allWithoutEquiped.length; i < len; i++)
			{
				if (player.pack.allWithoutEquiped[i].mid == mId)
				{
					index = i;
					break;
				}
			}
			return index;
		}
		
		//按照物品id排序
		public function sortMidByItemId(vector:Vector.<ItemVo>):Vector.<ItemVo>{
			
			var newVector:Vector.<ItemVo> = new Vector.<ItemVo>;
			newVector=vector.sort(compare);
			for(var i:int=0;i<newVector.length;i++){
				newVector[i].mid=i;
			}
			
			return newVector;
			
			function compare(x:ItemVo,y:ItemVo):Number{
				var result:Number;
				if(x.id > y.id){
					result = 1;
				}else if(x.id < y.id){
					result = -1;
				}else{
					if(x.type == ItemTypeConst.BOSS){
						if(x.lv > y.lv){
							result = 1;
						}else if(x.lv < y.lv){
							result = -1;
						}else{
							result = 0;
						}
					}else{
						if(x.num > y.num){
							result = -1;
						}else if(x.num < y.num){
							result = 1;
						}else{
							result = 0;
						}
					}
				}
				
				return result;
			}
		}
		
		
		
		
		//按照物品id排序
		public function sortCidByItemId(vector:Vector.<ItemVo>):Vector.<ItemVo>{
			
			var newVector:Vector.<ItemVo> = new Vector.<ItemVo>;
			newVector=vector.sort(compare);
			for(var i:int=0;i<newVector.length;i++){
				newVector[i].cid=i;
			}
			
			return newVector;
			
			function compare(x:ItemVo,y:ItemVo):Number{
				var result:Number;
				if(x.id > y.id){
					result = 1;
				}else if(x.id < y.id){
					result = -1;
				}else{
					if(x.lv > y.lv){
						result = 1;
					}else if(x.lv < y.lv){
						result = -1;
					}else{
						result = 0;
					}
				}
				
				return result;
			}
		}
		
		//全部物品背包排序
		public function sortByMId(vector:Vector.<ItemVo>):Vector.<ItemVo>{
			
			var newVector:Vector.<ItemVo> = new Vector.<ItemVo>;
			newVector=vector.sort(compare);
			
			return newVector;
			
			function compare(x:ItemVo,y:ItemVo):Number{
				var result:Number;
				if(x.mid > y.mid){
					result = 1;
				}else if(x.mid < y.mid){
					result = -1;
				}else{
					result = 0;
				}
				
				return result;
			}
		}
		
		//boss卡片背包排序
		public function sortByCId(vector:Vector.<ItemVo>):Vector.<ItemVo>{
			
			var newVector:Vector.<ItemVo> = new Vector.<ItemVo>;
			newVector=vector.sort(compare);
			
			return newVector;
			
			function compare(x:ItemVo,y:ItemVo):Number{
				var result:Number;
				if(x.cid > y.cid){
					result = 1;
				}else if(x.cid < y.cid){
					result = -1;
				}else{
					result = 0;
				}
				
				return result;
			}
		}
		
		
		
		/**
		 * 卸下装备 
		 * @param downItem: 卸下的装备
		 * @param itemVo: 卸下的装备
		 * 
		 */		
		public function putDownEquipment(downItem:ItemVo) : void
		{	
			if(checkMaxRooM([downItem])){
				EquipedManager.getIns().downEquip(downItem);
				var itemVo:ItemVo = searchEquip(downItem.id);
				itemVo.mid = firstEmptyMid;
				itemVo.isEquiped = false;
				PlayerManager.getIns().updatePropertys();
				(ViewFactory.getIns().getView(RoleDetailView) as RoleDetailView).update();
				GuideManager.getIns().oneKeyEquipJudge();
				
				if(ViewFactory.getIns().getView(BagView)==null){
					(ViewFactory.getIns().initView(BagView) as BagView).callBack =
						function ():void{
							ViewFactory.getIns().initView(BagView).show();
							ViewFactory.getIns().initView(BagView).update();
						};
				}else{
					ViewFactory.getIns().initView(BagView).show();
					ViewFactory.getIns().initView(BagView).update();
				}
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"背包空间不足！\n请留出空间后再卸下");
			}
		}
		
		
		/**
		 * 卸下时装
		 * @param downItem: 卸下的时装
		 * @param itemVo: 卸下的时装
		 * 
		 */		
		public function putDownFashion(downItem:ItemVo) : void
		{	
			if(checkMaxRooM([downItem])){
				EquipedManager.getIns().downFashion();
				downItem.mid = firstEmptyMid;
				PlayerManager.getIns().updatePropertys();
				(ViewFactory.getIns().getView(RoleDetailView) as RoleDetailView).update();
				
				if(ViewFactory.getIns().getView(BagView)==null){
					(ViewFactory.getIns().initView(BagView) as BagView).callBack =
						function ():void{
							ViewFactory.getIns().initView(BagView).show();
							ViewFactory.getIns().initView(BagView).update();
						};
				}else{
					ViewFactory.getIns().initView(BagView).show();
					ViewFactory.getIns().initView(BagView).update();
				}
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"背包空间不足！\n请留出空间后再卸下");
			}
		}
		
		
		/**
		 *检查增加的背包格是否大于最大背包格 
		 */	
		public function checkMaxRoomByNum(add:int):Boolean{
			var result:Boolean = true;
			if(player.pack.packUsed+add>player.pack.packMaxRoom){
				result = false;
			}else{
				result = true;
			}
			return result;
		}
		
		/**
		 *检查增加的背包格是否大于最大背包格 
		 * @param itemArr 增加的物品数组
		 * @param isDispose 是否是一次性物品
		 */	
		public function checkMaxRooM(itemArr:Array,isDispose:Boolean = false):Boolean{
			var result:Boolean = true;
			var num:int = 0;
			if(itemArr.length != 0){
				for(var i:int=0;i<itemArr.length;i++){
					num+=roomAdd(itemArr[i]);
				}
				if(isDispose){
					num --;
				}
				
				if(player.pack.packUsed+num>player.pack.packMaxRoom){
					result = false;
				}else{
					result = true;
				}
			}

			return result;
		}
		
		/**
		 *  计算物品添加进背包增加的格子数
		 */		
		private function roomAdd(item:ItemVo):int{
			var addNum:int;
			switch(item.type){
				case ItemTypeConst.EQUIP:
				case ItemTypeConst.BOOK:
				case ItemTypeConst.BOSS:
				case ItemTypeConst.FASHION:
					addNum = NumberConst.getIns().one;
					break;
				case ItemTypeConst.MATERIAL:
				case ItemTypeConst.SPECIAL:
				case ItemTypeConst.PROP:
					var num:int = searchItemNum(item.id);
					if(num == 0){
						addNum = NumberConst.getIns().one;
					}else{
						var r:int = num%NumberConst.getIns().itemNumMax;
						addNum = int((r + item.num)/NumberConst.getIns().itemNumMax);	
					}
					break;
				
			}
			return addNum;
		}
		
		
		/**
		 * 添加物品进背包 
		 * @param equip
		 * 
		 */		
		public function addItemIntoPack(item:ItemVo) : void
		{
			switch(item.type){
				
				case ItemTypeConst.MATERIAL:
				case ItemTypeConst.SPECIAL:
					addItem(item.id,item.num);
					break;
				case ItemTypeConst.PROP:
					if(item.propConfig.type=="礼包"){
						item.num = NumberConst.getIns().one;
						item.mid = PackManager.getIns().firstEmptyMid;
						player.pack[item.type].push(item);
						player.pack.packUsed ++;
					}else{
						addItem(item.id,item.num);	
					}
					break;
				case ItemTypeConst.EQUIP:
				case ItemTypeConst.FASHION:
				case ItemTypeConst.BOOK:
				case ItemTypeConst.BOSS:
					item.num = NumberConst.getIns().one;
					item.mid = PackManager.getIns().firstEmptyMid;
					player.pack[item.type].push(item);
					player.pack.packUsed ++;
					break;
			}
			PackManager.getIns().updatePackBoxs();
			
		}
		
		
		/**
		 * 添加物品
		 * itemId 物品id
		 * 
		 */	
		public function addItem(id:int,num:int):void{
			
			var item:ItemVo = searchMaxNumItem(id);
			if(item == null){
				item = creatItem(id);
				item.mid = PackManager.getIns().firstEmptyMid;
				player.pack[item.type].push(item);
				player.pack.packUsed ++;
				addItem(id,num-1);
				checkBagFull();
			}else if(item.num + num <= NumberConst.getIns().itemNumMax){
				item.num += num;
			}else if(item.num + num > NumberConst.getIns().itemNumMax){
				var diff:int = item.num + num - NumberConst.getIns().itemNumMax; 
				item.num = NumberConst.getIns().itemNumMax;
/*				var newItem:ItemVo = creatItem(itemId);
				newItem.mid = PackManager.getIns().firstEmptyMid;
				player.pack[item.type].push(newItem);
				player.pack.packUsed ++;*/
				addItem(id,diff);
			}
		}
		
		/**
		 * 移除物品
		 * itemId 物品id
		 * 
		 */	
		public function reduceItem(id:int,num:int):void{
			var item:ItemVo = searchMinNumItem(id);
			if(item == null) return;
			if(item.num > num){
				item.num-=num;
			}else if(item.num <= num){
				var diff:int = num - item.num;
				player.pack[item.type].splice(
					searchItemIndexById(item),1);
				player.pack.packUsed -= 1;
				item = null;
				if(diff != 0){
					reduceItem(id,diff);
				}
				checkBagFull();
			}
		}
		
		
		/**
		 * 移除物品
		 * itemId 物品id
		 * 
		 */	
		public function reduceItemByItemVo(item:ItemVo,num:int):void{
			if(item.num >num){
				item.num-=num;
			}else if(item.num == num){
				
				switch(item.type){
					case ItemTypeConst.MATERIAL:
						player.pack.material.splice(
							searchItemIndexByMid(item.mid,ItemTypeConst.MATERIAL),1);
						break;
					case ItemTypeConst.PROP:
						player.pack.prop.splice(
							searchItemIndexByMid(item.mid,ItemTypeConst.PROP),1);
						break;
					case ItemTypeConst.BOOK:
						player.pack.book.splice(
							searchItemIndexByMid(item.mid,ItemTypeConst.BOOK),1);
						break;
					case ItemTypeConst.SPECIAL:
						player.pack.special.splice(
							searchItemIndexByMid(item.mid,ItemTypeConst.SPECIAL),1);
						break;
					case ItemTypeConst.FASHION:
						player.pack.fashion.splice(
							searchItemIndexByMid(item.mid,ItemTypeConst.FASHION),1);
						break;
					case ItemTypeConst.BOSS:
						if(item.mid == MidConst.ATTACH_FRONT_POSITION || item.mid == MidConst.ATTACH_MIDDLE_POSITION ||item.mid == MidConst.ATTACH_BACK_POSITION ){
							AttachManager.getIns().downAttach(item);
						}else if(item.mid == MidConst.ASSIST_POSIOTION){
							AssistManager.getIns().downAssist(item);
						}
						player.pack.boss.splice(
							searchItemIndexByMid(item.mid,ItemTypeConst.BOSS),1);
						break;
					
				}
				player.pack.packUsed -= 1;
				PackManager.getIns().updatePackBoxs();
				item = null;

			}
		}
		
		/**
		 * 移除特定等级的BOSS卡(升级使用)
		 * id bossid lv 等级
		 * 
		 */	
		public function reduceUpgradeBoss(itemVo:ItemVo):void{
			var item:ItemVo = searchUpgradeBossCard(itemVo);

			if(item.mid == MidConst.ATTACH_FRONT_POSITION || item.mid == MidConst.ATTACH_MIDDLE_POSITION ||item.mid == MidConst.ATTACH_BACK_POSITION ){
				AttachManager.getIns().downAttach(item);
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("消耗掉附体栏中的卡牌");
			}else if(item.mid == MidConst.ASSIST_POSIOTION){
				AssistManager.getIns().downAssist(item);
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice("消耗掉援护栏中的卡牌");
			}
			
			reduceItemByItemVo(item,1)
			
		}

		

		
		private function searchItemIndexById(item:ItemVo) : int
		{
			var index:int = -1;
			
			for (var i:int = 0; i < player.pack[item.type].length; i++)
			{
				if (player.pack[item.type][i] == item)
				{
					index = i;
					break;
				}
			}
			return index;
		}

		
		
		private function searchItemIndexByMid(mid:int,type:String) : int
		{
			var index:int = -1;
			
			for (var i:int = 0; i < player.pack[type].length; i++)
			{
				if (player.pack[type][i].mid == mid)
				{
					index = i;
					break;
				}
			}
			return index;
		}

		
		/**
		 * 卖出物品
		 * @param itemVo: 卖出的装备
		 * 
		 */			
		public function sellItem(itemVo:ItemVo, num:int) : void
		{
			
			if(itemVo.type == ItemTypeConst.EQUIP ){
				return;
			}else if(searchItemIndexByMid(itemVo.mid, itemVo.type)!=-1){
				reduceItemByItemVo(itemVo, num);
				var sellPrice:int;
				if(itemVo.type == ItemTypeConst.BOSS){
					sellPrice = itemVo.sale_money + (itemVo.lv - 1) * NumberConst.getIns().bossUpPrice;
				}else{
					sellPrice = itemVo.sale_money * num;
				}
				PlayerManager.getIns().checkAdd("item_sell_money", sellPrice, 5*10000);
				PlayerManager.getIns().addMoney(sellPrice);
			}
		}
		
		
		//卸下BOSS
		public function putDownBoss(itemData:ItemVo):void{
			
			itemData.mid = PackManager.getIns().firstEmptyMid;
			itemData.isEquiped = false;
			PlayerManager.getIns().updatePropertys();
			PackManager.getIns().updatePackBoxs();
		}
		
		
		//获得当前mid最小的那件装备位置
		public function getUnEquipItem() : ItemVo{
			var resultItem:ItemVo;
			var result:int = 1000000;
			for each(var item:ItemVo in player.pack.equip){
				if(item.mid != -1){
					if(item.mid < result){
						result = item.mid;
						resultItem = item;
					}
				}
			}
			
			return resultItem;
		}
		
		
		//刷新背包格子数据
		public function updatePackBoxs():void{
			var item:int;
			var packBoxs:Array = new Array();
			var allWithoutEquiped:Array = player.pack.allWithouthEquiped;
			for (var i:int = 0; i < player.pack.packMaxRoom; i++){
				if(hasItemByMid(i, allWithoutEquiped)){
					item = i;
				}else{
					item = -1;
				}
				allWithoutEquiped.splice(allWithoutEquiped.indexOf(i), 1);
				packBoxs.push(item);
			}
			player.pack.packBoxs = packBoxs;
		}
		
		private function hasItemByMid(mid:int, allWithoutEquiped:Array):Boolean{
			var hasItem:Boolean = false;
			for each(var equipMid:int in allWithoutEquiped){
				if(equipMid == mid){
					hasItem = true;
					break;
				}
			}
			return hasItem;
		}
		
		//获取背包中最大序号
		private function get MaxMid():int{
			var max:int;
			for each(var item:ItemVo in player.pack.allWithoutEquiped){
				if(item.mid>max){
					max = item.mid;
				}
			}
			return max;
		}
		
		//获取背包中第一个空格的序号
		public function get firstEmptyMid():int{
			var index:int;
			for (var i:int=0;i<player.pack.packMaxRoom;i++){
				if(player.pack.packBoxs[i]==-1){
					index = i;
					break;
				}
			}
			return index;
		}
		
		//是否有附体的Boss卡片
		public function hasAttachBoss() : Boolean{
			var result:Boolean;
			for each(var item:ItemVo in player.pack.boss){
				if (item.mid == MidConst.ATTACH_FRONT_POSITION || item.mid == MidConst.ATTACH_MIDDLE_POSITION ||item.mid == MidConst.ATTACH_BACK_POSITION ){
					result = true;
					break;
				}
			}
			return result;
		}
		
		//物品上限检测
		public function checkPackNumMax():void{
			checkItemNumMax("material");
			checkItemNumMax("special");
			checkItemNumMax("prop");
			
		}
		
		/**
		 *检测某种类型的物品中是否有超过上限的 
		 * @param type
		 * 
		 */		
		private function checkItemNumMax(type:String):void{
			var max:int = NumberConst.getIns().itemNumMax;
			for each(var item:ItemVo in pack[type]){
				var newItemNum:int = item.num%max;
				var count:int = int(item.num/max);
				if(item.num > NumberConst.getIns().itemNumMax){
					item.num = max;
					if(newItemNum==0){
						for(var i:int = 0;i<count-1;i++){
							addMoreItem(item,max,type);
						}
					}else{
						for(var j:int = 0;j<count;j++){
							if(j == count-1){
								addMoreItem(item,newItemNum,type);
							}else{
								addMoreItem(item,max,type);
							}
						}
					}
				}
			}
		}
		
		/**
		 *添加拆分的物品进背包 
		 * @param item
		 * @param num
		 * @param type
		 * 
		 */		
		private function addMoreItem(item:ItemVo,num:int,type:String):void{
			var newMaterial:ItemVo = item.copy();
			newMaterial.num = num;
			newMaterial.mid = pack.packUsed;
			pack[type].push(newMaterial);
			pack.packUsed++;
		}
		
		/**
		 *检查背包是否已满 
		 * 
		 */		
		public function checkBagFull():void{
			EventManager.getIns().dispatchEvent(new Event(EventConst.CHECK_BAG_FULL));
		}
		
		/**
		 *开启背包格锁定
		 * 
		 */		
		public function openBagRoomLock():void{
			player.pack.packMaxRoom+=NumberConst.getIns().one;
			(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
				"开启一格背包！");
		}


	}
}