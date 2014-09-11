package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EquipmentType;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Const.MidConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Modules.MainGame.Guide.OneKeyEquipView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Strengthen.StrengthenView;
	import com.test.game.Mvc.Configuration.Strengthen;
	import com.test.game.Mvc.Vo.EquipInfo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	public class EquipedManager extends Singleton
	{
		
		
		
		public function EquipedManager()
		{
			super();
		}
		
		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		private var _equipInfo:EquipInfo;
		
		
		public static function getIns():EquipedManager{
			return Singleton.getIns(EquipedManager);
		}
		
		
		public function get EquipedVos() : Vector.<ItemVo>
		{
			var equips:Vector.<ItemVo> = new Vector.<ItemVo>();
			var info:EquipInfo = player.equipInfo;
			var model:ItemVo;
			if (info.weapon != -1)
			{
				model = PackManager.getIns().searchEquip(info.weapon);
				equips.push(model);
			}
			else
			{
				equips.push(null);
			}
			
			
			if (info.head != -1)
			{
				model = PackManager.getIns().searchEquip(info.head);
				equips.push(model);
			}
			else
			{
				equips.push(null);
			}
			
			
			if (info.neck != -1)
			{
				model = PackManager.getIns().searchEquip(info.neck);
				equips.push(model);
			}
			else
			{
				equips.push(null);
			}
			
			
			if (info.clothes != -1)
			{
				model = PackManager.getIns().searchEquip(info.clothes);
				equips.push(model);
			}
			else
			{
				equips.push(null);
			}
			
			if (info.shoulder != -1)
			{
				model = PackManager.getIns().searchEquip(info.shoulder);
				equips.push(model);
			}
			else
			{
				equips.push(null);
			}
			
			if (info.shoes != -1)
			{
				model = PackManager.getIns().searchEquip(info.shoes);
				equips.push(model);
			}
			else
			{
				equips.push(null);
			}
			
			return equips;
		}
		
		
		public function get EquipedFashionVo() : ItemVo
		{

			var fashion:ItemVo;
			if (player.fashionInfo.fashionId != -1)
			{
				fashion = PackManager.getIns().searchEquipedFashion(player.fashionInfo.fashionId);
			}
			else
			{
				fashion = null;
			}
			
			return fashion;
		}

		public function checkEquipVos():Boolean{
			var result:Boolean = false;
			for each(var item:ItemVo in EquipedVos){
				if(item!=null){
					result = true;
					break;
				}
			}
			return result;
		}
		
		
		/**
		 * 装备 
		 * @param roleModel
		 * @param equip
		 * 
		 */
		public function upEquip(upEquip:ItemVo) : void
		{
			var downEquipId:int;
			player.pack.packUsed -= 1;	
			switch (upEquip.equipConfig.type)
			{
				case EquipmentType.WEAPON:
					downEquipId = player.equipInfo.weapon;
					player.equipInfo.weapon = upEquip.id;
					break;
				case EquipmentType.HEAD:
					downEquipId = player.equipInfo.head;
					player.equipInfo.head = upEquip.id;
					break;
				
				case EquipmentType.CLOTHES:
					downEquipId = player.equipInfo.clothes;
					player.equipInfo.clothes = upEquip.id;
					break;
				case EquipmentType.NECK:
					downEquipId = player.equipInfo.neck;
					player.equipInfo.neck = upEquip.id;
					break;
				case EquipmentType.SHOULDER:
					downEquipId = player.equipInfo.shoulder;
					player.equipInfo.shoulder = upEquip.id;
					break;
				case EquipmentType.SHOES:
					downEquipId = player.equipInfo.shoes;
					player.equipInfo.shoes = upEquip.id;
					break;
			}

			/// 卸下装备
			if (downEquipId != -1)
			{
				var downEquip:ItemVo = PackManager.getIns().searchEquip(downEquipId);
				downEquip.mid = upEquip.mid;
				downEquip.isEquiped =false
				player.pack.packUsed += 1;
			}
			
			upEquip.isEquiped = true;
			upEquip.mid = MidConst.EQUIP_POSITION;
				
			
			ViewFactory.getIns().initView(OneKeyEquipView).show();
			
			
		}
		
		/**
		 * 卸下装备 
		 * @param roleModel: 当前角色
		 * @param downEquip: 卸下的装备
		 * 
		 */		
		public function downEquip(downEquip:ItemVo) : void
		{
			switch (downEquip.equipConfig.type)
			{
				case EquipmentType.WEAPON:
					player.equipInfo.weapon = -1;
					break;
				case EquipmentType.HEAD:
					player.equipInfo.head = -1;
					break;
				case EquipmentType.CLOTHES:
					player.equipInfo.clothes = -1;
					break;
				case EquipmentType.NECK:
					player.equipInfo.neck = -1;
					break;
				case EquipmentType.SHOULDER:
					player.equipInfo.shoulder = -1;
					break;
				case EquipmentType.SHOES:
					player.equipInfo.shoes = -1;
					break;
			}
			player.pack.packUsed += 1;
		}
		
		/**
		 * 卖出装备 
		 * @param roleModel
		 * @param downEquip
		 * 
		 */		
		public function sellEquipment(sellEquip:ItemVo) : void
		{
			PackManager.getIns().reduceItem(sellEquip.id,NumberConst.getIns().one);
		
			// 金币
			var sell_money:int = sellEquip.equipConfig.sale_money;
			player.money += sell_money;
		}
		
		
		
		
		/**
		 * 装备时装
		 * @param roleModel
		 * @param equip
		 * 
		 */
		public function upFashion(upFashion:ItemVo) : void
		{
			var downFashionId:int;
			player.pack.packUsed -= 1;	
			downFashionId = player.fashionInfo.fashionId;
			player.fashionInfo.fashionId = upFashion.id;
			
			/// 卸下装备
			if (downFashionId != -1)
			{
				var downFashion:ItemVo = PackManager.getIns().searchEquipedFashion(downFashionId);
				downFashion.mid = upFashion.mid;
				player.pack.packUsed += 1;
			}
			
			upFashion.mid = MidConst.FASHION_POSITION;
			
			
			ViewFactory.getIns().initView(OneKeyEquipView).show();
			
			
		}
		
		/**
		 * 卸下时装 
		 * 
		 */		
		public function downFashion() : void
		{
			player.fashionInfo.fashionId = -1;
			player.pack.packUsed += 1;
		}
		
		
		
		/**
		 * 强化装备
		 * @param Equip
		 * 
		 */		
		public function strengtnenEquip(Equip:ItemVo) : void
		{
			var strengthenData:Strengthen = ConfigurationManager.getIns().getObjectByID(AssetsConst.STRENGTHEN,Equip.lv+1) as Strengthen;
			Equip.lv+=1;
			Equip.strengthen = strengthenData;
			PackManager.getIns().reduceItem(strengthenData.stoneId,strengthenData.stoneNum);
			PlayerManager.getIns().reduceMoney(strengthenData.money_add);
			ViewFactory.getIns().getView(MainToolBar).update();
			ViewFactory.getIns().getView(StrengthenView).update();
			PlayerManager.getIns().updatePropertys();
			
		}
		
		
		/**
		 * 打造装备
		 * @param Equip
		 * 
		 */		
		public function forgeEquip(Equip:ItemVo) : void
		{
			var materials:Array = Equip.equipConfig.need_material.split("|");
			var materialNumList:Array = Equip.equipConfig.material_number.split("|");
			
			var newEquip:ItemVo = PackManager.getIns().creatItem(Equip.equipConfig.need_equipment);
			
			PlayerManager.getIns().reduceSoul(Equip.equipConfig.need_soul)
			
			PackManager.getIns().reduceItem(materials[0],materialNumList[0]);
			PackManager.getIns().reduceItem(materials[1],materialNumList[1]);
			PackManager.getIns().reduceItem(Equip.equipConfig.need_book,NumberConst.getIns().one);
			
			Equip.id = newEquip.id;
			Equip.name = newEquip.name;
			var chargeArr:Array = Equip.equipConfig.chargeLvArr;
			Equip.equipConfig = newEquip.equipConfig;
			Equip.equipConfig.chargeLvArr = chargeArr;
			changeEquipInfo(newEquip);
			
			ViewFactory.getIns().getView(MainToolBar).update();
			ViewFactory.getIns().getView(StrengthenView).update();
			PlayerManager.getIns().updatePropertys();
			
		}
		
		
		/**
		 * 充能装备
		 * @param Equip
		 * 
		 */		
		public function chargeEquip(Equip:ItemVo,index:int) : void
		{
			var chargeLvArr:Array = Equip.equipConfig.chargeLvArr;
			chargeLvArr[index] = int(chargeLvArr[index]) + 1;
			Equip.equipConfig.chargeLvArr = chargeLvArr;
			ViewFactory.getIns().getView(MainToolBar).update();
			ViewFactory.getIns().getView(StrengthenView).update();
			PlayerManager.getIns().updatePropertys();
			
		}
		
		private function changeEquipInfo(upEquip:ItemVo) : void
		{
			switch (upEquip.equipConfig.type)
			{
				case EquipmentType.WEAPON:
					player.equipInfo.weapon = upEquip.id;
					break;
				case EquipmentType.HEAD:
					player.equipInfo.head = upEquip.id;
					break;
				case EquipmentType.CLOTHES:
					player.equipInfo.clothes = upEquip.id;
					break;
				case EquipmentType.NECK:
					player.equipInfo.neck = upEquip.id;
					break;
				case EquipmentType.SHOULDER:
					player.equipInfo.shoulder = upEquip.id;
					break;
				case EquipmentType.SHOES:
					player.equipInfo.shoes = upEquip.id;
					break;
			}
		}
		
		
		public function getPropertyName(item:ItemVo):Array{
			var propertyShort:String;
			var propertyName:String;
			switch(item.equipConfig.type){
				case EquipmentType.WEAPON:
					propertyShort = "atk";
					propertyName = "外功";
					break;
				case EquipmentType.HEAD:
					propertyShort = "ats";
					propertyName = "内功";
					break;
				case EquipmentType.NECK:
					propertyShort = "hp";
					propertyName = "体力";
					break;
				case EquipmentType.CLOTHES:
					propertyShort = "def";
					propertyName = "根骨";
					break;
				case EquipmentType.SHOULDER:
					propertyShort = "adf";
					propertyName = "罡气";
					break;
				case EquipmentType.SHOES:
					propertyShort = "mp";
					propertyName = "元气";
					break;
			}
			
			return [propertyShort,propertyName];
		}
		
		
	
	}
}