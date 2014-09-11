package com.test.game.Mvc.Proxy{
	import com.superkaka.game.Loader.AssetsItem;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.mvc.Base.BaseProxy;
	
	public class ItemDataProxy extends BaseProxy{
		
		public function ItemDataProxy(){
			super();
		}
		
		
		
		public function getItemDataJson():Object{
			//var ai:AssetsItem = AssetsManager.getIns().getAssetsItem(AssetsUrl.ITEM_LIST);
			
			//return com.adobe.serialization.json.JSON.decode(ai.data);
			return new Object;
		}
		
		
	}
}

