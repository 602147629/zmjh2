package com.test.game.Mvc.control.data
{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.game.Loader.AssetsItem;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.ConfigurationManager;
	
	public class DataControl extends BaseControl
	{
		public function DataControl()
		{
			super();
		}
		
		/**
		 * 获取属性Tip json 
		 * @return 
		 * 
		 */		
        public static function getPropertyTipsJson():Object{
			return com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData(AssetsConst.PROPERTY_TIPS));
		}
		
		
		/**
		 * 获取玩家存档json 
		 * @return 
		 * 
		 */		
		public function getPlayerDataJson():Object{
			var ai:AssetsItem = AssetsManager.getIns().getAssetsItem(AssetsUrl.PLAYER_DATA);
			return com.adobe.serialization.json.JSON.decode(ai.data);
		}
		
		/**
		 * 获取人物 json 
		 * @return 
		 * 
		 */		
		public function getCharacterDataJson():Object{
			return com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData(AssetsConst.CHARACTERS));
		}
		
		/**
		 * 获取装备 json 
		 * @return 
		 * 
		 */		
		public function getEquipDataJson():Object{
			return com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData(AssetsConst.EQUIPMENT));
		}
	}
}