package com.test.game.Manager.Integral
{
	import com.adobe.crypto.MD5;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.TimeManager;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class LandIntegralManager extends Singleton
	{
		private static const URLNAME:String = "http://my.4399.com/services/game-4399api";
		private static const KEYS:String = "2d2dfa46e848c848b2357359d9548ce6";
		private static const uri:String = "/services/game-4399api";
		public function LandIntegralManager()
		{
			super();
			initURL();
		}
		
		public static function getIns():LandIntegralManager{
			return Singleton.getIns(LandIntegralManager);
		}
		
		private var _urlLoader:URLLoader;
		private function initURL() : void{
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_urlLoader.addEventListener(Event.COMPLETE, urlCompleteHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlErrorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlErrorHandler);
		}
		
		protected function urlErrorHandler(e:IOErrorEvent):void{
			DebugArea.getIns().showInfo("---玩游戏获取积分返回失败---");
		}
		
		protected function urlCompleteHandler(e:Event):void{
			DebugArea.getIns().showInfo("---玩游戏获取积分返回成功:" + e.target.data + "---");
		}
		
		public function sendData(type:String) : void{
			var date:Date = TimeManager.getIns().returnTimeNow();
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.desc = type;
			urlVariables.gameId = NumberConst.getIns().gameId;
			urlVariables.time = int(date.time / 1000);
			urlVariables.uid = GameConst.UID;
			var str:String = urlVariables.desc + "|" + urlVariables.gameId + "|" + urlVariables.time + "|" + urlVariables.uid + "|" + uri + "|" + KEYS;
			var syn:String = MD5.hash(str);
			urlVariables.syn = syn;
			
			var urlRequest:URLRequest = new URLRequest(URLNAME);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVariables;
			_urlLoader.load(urlRequest);
		}
	}
}