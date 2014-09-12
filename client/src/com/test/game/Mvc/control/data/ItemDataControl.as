package com.test.game.Mvc.control.data{
	import com.superkaka.mvc.ProxyFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Mvc.Proxy.ItemDataProxy;
	
	public class ItemDataControl extends BaseControl{
		public function ItemDataControl(){
			super();
			
			
		}
		
		/**
		 * 获取协议json 
		 * @return 
		 * 
		 */		
		public function getItemDataJson():Object{
			var ip:ItemDataProxy = ProxyFactory.getIns().initProxy(ItemDataProxy) as ItemDataProxy;
			return ip.getItemDataJson();
		}
	}
}

