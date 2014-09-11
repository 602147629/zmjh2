package com.test.game.Mvc.control.data{
	import com.superkaka.mvc.ProxyFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Mvc.Proxy.ProtocolProxy;
	
	public class ProtocalControl extends BaseControl{
		public function ProtocalControl(){
			super();
			
			
		}
		
		/**
		 * 获取协议json 
		 * @return 
		 * 
		 */		
		public function getProtocolJson():Object{
			var pp:ProtocolProxy = ProxyFactory.getIns().initProxy(ProtocolProxy) as ProtocolProxy;
			return pp.getProtocolJson();
		}
	}
}