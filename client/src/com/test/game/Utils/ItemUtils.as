package com.test.game.Utils
{
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Mvc.Configuration.Equipment;
	import com.test.game.Mvc.Configuration.Material;
	
	public class ItemUtils
	{
		public function ItemUtils():void{
			
		}
		
		public static function getEquipConfigById(id:int) : Equipment{
			var config:Equipment = new Equipment();
			var json:Object = ConfigurationManager.getIns().getAllData(AssetsConst.EQUIPMENT);
			for each(var item:Object in json["RECORDS"]){
				if(item["id"]==id.toString()){
					config.assign(item);
				}
			}
			return config;
		}
		
		public static function getMaterialConfigById(id:int) : Material{
			var config:Material = new Material();
			var json:Object = ConfigurationManager.getIns().getAllData(AssetsConst.MATERIAL);
			for each(var item:Object in json["RECORDS"]){
				if(item["id"]==id.toString()){
					config.assign(item);
				}
			}
			return config;
		}
		
		

	}
}

