package com.test.game.Manager.Gift
{
	import com.adobe.serialization.json.JSON;
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
	
	public class ContinueLandManager extends Singleton
	{
		private static const URLNAME:String = "http://my.4399.com/events/2014/fiveyear/login-counter";
		private static const KEYS:String = "919e2199989011d08e1c37f03017a27b";
		private static const uri:String = "/events/2014/fiveyear/login-counter";
		
		public static function getIns():ContinueLandManager{
			return Singleton.getIns(ContinueLandManager);
		}
		
		public function ContinueLandManager()
		{
			super();
			initURL();
		}
		
		private var _urlLoader:URLLoader;
		private function initURL() : void{
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_urlLoader.addEventListener(Event.COMPLETE, urlCompleteHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlErrorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlSecurityErrorHandler);
		}
		
		protected function urlSecurityErrorHandler(e:SecurityErrorEvent) : void{
			DebugArea.getIns().showInfo("---社区5周年活动返失败---");
		}
		
		protected function urlErrorHandler(e:IOErrorEvent):void{
			DebugArea.getIns().showInfo("---社区5周年活动返失败---");
		}
		
		protected function urlCompleteHandler(e:Event):void{
			DebugArea.getIns().showInfo("---社区5周年活动返回成功:" + e.target.data + "---");
			var obj:Object = com.adobe.serialization.json.JSON.decode(e.target.data);
			var resultCode:int = obj.code;
			var resultStr:String;
			switch(resultCode){
				//未知错误
				case 1:
					resultStr = "未知错误";
					break;
				//参数错误
				case 2:
					resultStr = "参数错误";
					break;
				//没有权限
				case 3:
					resultStr = "没有权限";
					break;
				//Token过期
				case 61:
					resultStr = "Token过期";
					break;
				//Token错误
				case 62:
					resultStr = "Token错误";
					break;
				//需要APP_ID
				case 63:
					resultStr = "需要APP_ID";
					break;
				//不认识的APP_ID
				case 64:
					resultStr = "不认识的APP_ID";
					break;
				//请求方式错误
				case 65:
					resultStr = "请求方式错误";
					break;
				//操作成功
				case 100:
					resultStr = "操作成功";
					break;
			}
			DebugArea.getIns().showInfo(resultStr);
		}
		
		public function sendData() : void{
			var fiveYears:int = TimeManager.getIns().disDayNum(NumberConst.getIns().fiveYearsGiftDate,TimeManager.getIns().returnTimeNowStr().split(" ")[0]);
			if(fiveYears > 0 || fiveYears < -6) return;
			
			var date:Date = TimeManager.getIns().returnTimeNow();
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.game_id = 3;
			urlVariables.app_id = 38;
			urlVariables.uid = GameConst.UID;
			urlVariables.time = int(date.time / 1000);
			var str:String = urlVariables.app_id + "||" + urlVariables.game_id + "||" + urlVariables.time + "||" + urlVariables.uid + "||" + uri + "||" + KEYS;
			var token:String = MD5.hash(str);
			urlVariables.token = token;
			
			var urlRequest:URLRequest = new URLRequest(URLNAME);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVariables;
			_urlLoader.load(urlRequest);
		}
		
	}
}