package open4399Tools
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import open4399Tools.events.Open4399ToolsEvent;

	public class Open4399ToolsService
	{
		private static var _open4399Tools:*;
		private static var v_url:String = "http://stat.api.4399.com/flash_ctrl_version.xml?ran=";
		private static var url:String = "http://cdn.comment.4399pk.com/control/open4399tools_AS3.swf";
		
		public function Open4399ToolsService():void
		{			
			//创建URL连接
			var request:URLRequest = new URLRequest(v_url + getTimer());  			
			var loader:URLLoader = new URLLoader();			
			loader.addEventListener(Event.COMPLETE,onXmlComplete);  
			loader.addEventListener(IOErrorEvent.IO_ERROR,onXmlIOError); 
			loader.load(request);
		}
				
		protected function onXmlComplete(event:Event):void
		{
			event.target.removeEventListener(IOErrorEvent.IO_ERROR,onXmlIOError);
			event.target.removeEventListener(Event.COMPLETE,onXmlComplete);  
			
			var xmlRes:XML = XML(event.target.data);
			if(xmlRes!=null)
			{
				if(String(xmlRes.info.(hasOwnProperty('@resName') && @resName == 'tools_as3')).length)
				{
					url = xmlRes.info.(hasOwnProperty('@resName') && @resName == 'tools_as3');
				}
			} 
			
			onSwfLoad();
			
		}		
		
		protected  function onXmlIOError(event:IOErrorEvent):void
		{
			event.target.removeEventListener(IOErrorEvent.IO_ERROR,onXmlIOError);
			event.target.removeEventListener(Event.COMPLETE,onXmlComplete);
			onSwfLoad();
		}
		 
		
		protected  function onSwfLoad():void{
			//创建URL连接
			var request:URLRequest = new URLRequest(url);  			
			var loader:Loader = new Loader();			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete); 
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onLoadError);
			
			try{
				loader.load(request);
			}catch(e:Error){
				trace(e.message);
			} 
		}
		
		protected  function onLoadError(event:*):void
		{
			event.target.removeEventListener(Event.COMPLETE,onLoadComplete);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onLoadError);
			//派发事件
			Open4399ToolsApi.getInstance().dispatchEvent(new Open4399ToolsEvent(Open4399ToolsEvent.CHECK_BAD_WORDS_ERROR));
		}
		
		protected  function onLoadComplete(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE,onLoadComplete);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			event.target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onLoadError);
			
			var loaderInfo:LoaderInfo = LoaderInfo(event.target); 
			_open4399Tools = loaderInfo.content
		    _open4399Tools.eventClass = Open4399ToolsEvent;
			
			_open4399Tools.addEventListener(Open4399ToolsEvent.CHECK_BAD_WORDS,Open4399ToolsApi.getInstance().dispatchEvent);
			_open4399Tools.addEventListener(Open4399ToolsEvent.CHECK_BAD_WORDS_ERROR,Open4399ToolsApi.getInstance().dispatchEvent);
			//派发加载完毕事件
			Open4399ToolsApi.getInstance().dispatchEvent(new Open4399ToolsEvent(Open4399ToolsEvent.SERVICE_INIT));
				
		}		
        
		//敏感词
		public function get badWordsService():*
		{     
			if(_open4399Tools){ 
				 return _open4399Tools.badWordsService;
			}
			return null;
		} 
	}
}