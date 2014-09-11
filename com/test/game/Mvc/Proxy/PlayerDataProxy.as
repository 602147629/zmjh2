package com.test.game.Mvc.Proxy
{
	import com.superkaka.game.Loader.AssetsItem;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.mvc.Base.BaseProxy;
	
	public class PlayerDataProxy extends BaseProxy
	{
		public function PlayerDataProxy()
		{
			super();
		}
		
		
		public function getPlayerDataJson():Object{
			//var ai:AssetsItem = AssetsManager.getIns().getAssetsItem(AssetsUrl.PLAYER_DATA);
			
			//return com.adobe.serialization.json.JSON.decode(ai.data);
			return new Object();
		}
		
	}
}