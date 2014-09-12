package com.test.game.Mvc.control.data
{
	import com.superkaka.mvc.ProxyFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Mvc.Proxy.PlayerDataProxy;
	
	public class PlayerDataControl extends BaseControl
	{
		public function PlayerDataControl()
		{
			super();
		}
		
		/**
		 * 获取协议json 
		 * @return 
		 * 
		 */		
		public function getPlayerDataJson():Object{
			var pp:PlayerDataProxy = ProxyFactory.getIns().initProxy(PlayerDataProxy) as PlayerDataProxy;
			return pp.getPlayerDataJson();
		}
	}
}