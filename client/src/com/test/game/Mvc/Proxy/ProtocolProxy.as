package com.test.game.Mvc.Proxy{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.mvc.Base.BaseProxy;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.ConfigurationManager;
	
	public class ProtocolProxy extends BaseProxy{
		
		public function ProtocolProxy(){
			super();
		}
		
		public function getProtocolJson():Object{
			//var ai:AssetsItem = AssetsManager.getIns().getAssetsItem(AssetsUrl.PROTOCOL);
			var data:String = ConfigurationManager.getIns().getJsonData(AssetsConst.PROTOCOL);
			return com.adobe.serialization.json.JSON.decode(data);
		}
		
		
	}
}