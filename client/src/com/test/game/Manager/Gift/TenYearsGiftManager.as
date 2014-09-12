package com.test.game.Manager.Gift
{
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.GiftManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Modules.MainGame.Gift.TenYearsView;
	import com.test.game.Modules.MainGame.Info.CongratulationView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public class TenYearsGiftManager extends Singleton
	{
		private static const URLNAME:String = "http://huodong2.4399.com/2014/4399_10years/api.php?";
		//private static const URLNAME:String = "http://t.huodong.4399.com/2014/4399_10years/api.php?";
		
		public static function getIns():TenYearsGiftManager{
			return Singleton.getIns(TenYearsGiftManager);
		}
		
		public function TenYearsGiftManager(){
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
			
		}
		
		protected function urlErrorHandler(e:IOErrorEvent):void{
			DebugArea.getIns().showInfo("---十周年礼包返回失败---");
			ViewFactory.getIns().getView(TenYearsView).update();
		}
		
		protected function urlCompleteHandler(e:Event):void{
			DebugArea.getIns().showInfo("---十周年礼包返回成功:" + e.target.data + "---");
			ViewFactory.getIns().getView(TenYearsView).hide();
			var arr:Array = e.target.data.split("|");
			if(arr.length == NumberConst.getIns().one){
				if(int(arr[0]) == NumberConst.getIns().one){
					getGift();
				}
			}else{
				var result:String;
				switch(arr[1]){
					//未登录
					case "003":
						result = "游戏未登录，请重新登录";
						break;
					//兑换码无效
					case "004":
						result = "兑换码无效";
						break;
					//参数有误
					case "005":
						result = "兑换失败";
						break;
					//未知错误
					case "006":
						result = "兑换失败";
						break;
				}
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(result);
			}
		}
		
		private function getGift() : void{
			SaveManager.getIns().onSaveGame(
				function():void{
					GiftManager.getIns().addGift(NumberConst.getIns().tenYearsGiftId, false);
				},
				function():void{
					//var giftStr:String = "领取4399十周年庆专属礼包成功，请到道具栏打开礼包哦！";
					(ViewFactory.getIns().initView(CongratulationView) as CongratulationView).startPlay(NumberConst.getIns().tenYearsGiftId);
					ViewFactory.getIns().getView(TipViewWithoutCancel).hide();
				});
		}
		
		public function sendData(code:String) : void{
			var str:String = URLNAME
					+ "game=" + NumberConst.getIns().tenYearsGameID
					+ "&code=" + code;
			var urlRequest:URLRequest = new URLRequest(str);
			urlRequest.method = URLRequestMethod.POST;
			_urlLoader.load(urlRequest);
		}
	}
}