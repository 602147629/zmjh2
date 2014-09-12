package com.test.game.Const
{
	public class ItemTypeConst
	{
		public static const EQUIPED:String = "equiped";//装备
		public static const UNEQUIP:String = "unequip";//装备
		public static const EQUIP:String = "equip";//装备
		public static const PROP:String = "prop";//道具
		public static const MATERIAL:String = "material";//材料
		public static const WEATHER_PIECE:String = "weather_piece";//天气碎片
		public static const SPECIAL:String = "special";//特别
		public static const TITLE:String = "title";//特别
		public static const BOOK:String = "book";//特别
		public static const All:String = "all";//特别
		public static const FASHION:String = "fashion";//时装
		public static const BOSS:String = "boss";//
		public static const BAGUA:String = "bagua";//材料
		
		public static function getTypeName(type:String):String{
			var typeName:String;
			switch(type){
				case EQUIP:
					typeName = "装备";
					break;
				case MATERIAL:
					typeName = "材料";
					break;
				case SPECIAL:
					typeName = "特殊";
					break;
				case BOOK:
					typeName = "制作书";
					break;
				case PROP:
					typeName = "道具";
					break;
				case BOSS:
					typeName = "卡牌";
					break;
				case FASHION:
					typeName = "时装";
					break;
				case BAGUA:
					typeName = "八卦牌";
					break;
				case TITLE:
					typeName = "称号";
					break;
			}
			return typeName;
		}

	}
}