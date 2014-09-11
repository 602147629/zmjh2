package com.test.game.Manager
{
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class StatisticsManager extends Singleton
	{
		private static const URLNAME:String = "http://stat.api.4399.com/archive_statistics/log.js?";
		public function StatisticsManager()
		{
			super();
			
			initURL();
		}
		
		public static function getIns():StatisticsManager{
			return Singleton.getIns(StatisticsManager);
		}
		
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		private var _urlLoader:URLLoader;
		private function initURL() : void
		{
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			_urlLoader.addEventListener(Event.COMPLETE, urlCompleteHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlErrorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlErrorHandler);
		}
		
		protected function urlErrorHandler(e:IOErrorEvent):void{
			
		}
		
		protected function urlCompleteHandler(e:Event):void{
			
		}
		
		public function sendData() : void{
			var str:String = URLNAME
							+ "game_id=" + NumberConst.getIns().apiGameID
							+ "&uid=" + GameConst.UID
							+ "&index=" + PlayerManager.getIns().saveIndex
							+ "&a=" + playerLevel
							+ "&b=" + playerOcc
							+ "&c=" + dungeonCount
							+ "&d=" + dungeonJiCount
							+ "&e=" + hideDungeonCount
							+ "&f=" + eliteDungeonCount;
			var urlRequest:URLRequest = new URLRequest(str);
			urlRequest.method = URLRequestMethod.POST;
			
			_urlLoader.load(urlRequest);
		}
		
		//玩家等级
		private function get playerLevel() : int{
			var result:int = 0;
			var level:int = player.character.lv;
			if(level >= 1 && level <= 20){
				result = 1;
			}else if(level >= 21 && level <= 30){
				result = 2;
			}else if(level >= 31 && level <= 40){
				result = 3;
			}else if(level >= 41 && level <= 50){
				result = 4;
			}
			return result;
		}
		
		//主角职业
		private function get playerOcc() : int{
			var result:int = 0;
			result = player.occupation;
			return result;
		}
		
		//普通关卡过关数量
		private function get dungeonCount() : int{ 
			var result:int = 0;
			var count:int = 0;
			var arr:Array = new Array();
			for(var i:int = 0; i < player.dungeonPass.length; i++){
				arr = player.dungeonPass[i].name.split("_");
				if(int(arr[1]) < 10 && player.dungeonPass[i].lv > 0){
					count++;
				}
			}
			if(count > 0 && count <= 9){
				result = 1;
			}else if(count >= 10 && count <= 18){
				result = 2;
			}else if(count >= 19 && count <= 27){
				result = 3;
			}else if(count >= 28 && count <= 36){
				result = 4;
			}
			return result;
		}
		
		//普通关卡极评价数量
		private function get dungeonJiCount() : int{ 
			var result:int = 0;
			var count:int = 0;
			var arr:Array = new Array();
			for(var i:int = 0; i < player.dungeonPass.length; i++){
				arr = player.dungeonPass[i].name.split("_");
				if(int(arr[1]) < 10 && player.dungeonPass[i].lv == 5){
					count++;
				}
			}
			if(count > 0 && count <= 9){
				result = 1;
			}else if(count >= 10 && count <= 18){
				result = 2;
			}else if(count >= 19 && count <= 27){
				result = 3;
			}else if(count >= 28 && count <= 36){
				result = 4;
			}
			return result;
		}
		
		//隐藏关卡过关数量
		private function get hideDungeonCount() : int{ 
			var result:int = 0;
			var count:int = 0;
			var arr:Array = new Array();
			for(var i:int = 0; i < player.dungeonPass.length; i++){
				arr = player.dungeonPass[i].name.split("_");
				if(int(arr[1]) > 9 && player.dungeonPass[i].lv > 0){
					count++;
				}
			}
			if(count > 0 && count <= 3){
				result = 1;
			}else if(count >= 4 && count <= 6){
				result = 2;
			}else if(count >= 7 && count <= 9){
				result = 3;
			}else if(count >= 10 && count <= 12){
				result = 4;
			}
			return result;
		}
		
		//精英关卡过关数量
		private function get eliteDungeonCount() : int{ 
			var result:int = 0;
			var count:int = 0;
			for(var i:int = 0; i < player.eliteDungeon.eliteDungeonPass.length; i++){
				if(player.eliteDungeon.eliteDungeonPass[i].lv > 0){
					count++;
				}
			}
			if(count > 0 && count <= 4){
				result = 1;
			}else if(count >= 5 && count <= 8){
				result = 2;
			}else if(count >= 9 && count <= 12){
				result = 3;
			}else if(count >= 13 && count <= 16){
				result = 4;
			}
			return result;
		}
	}
}