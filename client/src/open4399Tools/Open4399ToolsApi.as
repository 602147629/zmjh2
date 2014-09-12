package open4399Tools
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Open4399ToolsApi
	{
	    private static var _instance:Open4399ToolsApi = new Open4399ToolsApi();
		private var open4399ToolsService:Open4399ToolsService = null;
		private var _eventDispatcher:EventDispatcher = new EventDispatcher();	 
		
		public function Open4399ToolsApi()
		{  
			if(_instance){
				throw new Error("Cannot create instance! Please use getInstance() instead.");
			}
		}
		
		public static function getInstance():Open4399ToolsApi
		{ 
			return _instance;
		} 
		
		public function init():void{ 
			if(open4399ToolsService==null)
				open4399ToolsService = new Open4399ToolsService();  
		}
		
		public function checkBadWords(words:String):void
		{  
			if(open4399ToolsService==null)
			{
				trace("请先调用init()方法进行初始化工具类");
				return;
			}
			 open4399ToolsService.badWordsService.checkBadWords(words);
		}
		
		public function dispatchEvent(event:Event):void
		{
			_eventDispatcher.dispatchEvent(event);
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_eventDispatcher.addEventListener(type,listener,useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
	
		public function resetApi():void
		{
			_instance = null;
		}
	}
}