package com.test.game.Manager
{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Loader.AssetsItem;
	import com.superkaka.game.Loader.AssetsManager;
	
	public class JsonManager extends Singleton
	{
		public function JsonManager()
		{
			super();
		}
		
		public static function getIns():JsonManager{
			return Singleton.getIns(JsonManager);
		}

		public function getJsonData(assetsUrl:Object) : Array
		{
			var ai:AssetsItem = AssetsManager.getIns().getAssetsItem(assetsUrl);
			var obj:Object = com.adobe.serialization.json.JSON.decode(ai.data);
			
			return obj.RECORDS;
		}
		
	}
}