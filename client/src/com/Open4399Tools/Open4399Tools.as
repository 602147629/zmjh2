package com.Open4399Tools
{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.Singleton;
	
	import open4399Tools.Open4399ToolsApi;
	import open4399Tools.events.Open4399ToolsEvent;

	public class Open4399Tools extends Singleton
	{
		public function Open4399Tools(){
			
		}
		
		public static function getIns():Open4399Tools{
			return Singleton.getIns(Open4399Tools);
		}
		
		public var open4399ToolsApi:Open4399ToolsApi = Open4399ToolsApi.getInstance();
		public function init() : void{
			open4399ToolsApi.addEventListener(Open4399ToolsEvent.SERVICE_INIT, onServiceInitComplete);
			open4399ToolsApi.addEventListener(Open4399ToolsEvent.CHECK_BAD_WORDS_ERROR, onCheckBadWordsError);
			open4399ToolsApi.addEventListener(Open4399ToolsEvent.CHECK_BAD_WORDS, onCheckBadWords);
			open4399ToolsApi.init();
		}
		
		private var _callback:Function;
		public function checkBadWords(words:String, callback:Function) : void{
			open4399ToolsApi.checkBadWords(words); 
			_callback = callback;
		}
		
		private function onCheckBadWords(e:Open4399ToolsEvent):void{ 
			/**      
			 * e.data为json格式     
			 * 如：{"code":10000,"data":0,"message":"Success."} 
			 * // 返回成功，不带敏感词 
		     */  
			var obj:Object = com.adobe.serialization.json.JSON.decode(e.data);
			if(_callback != null){
				_callback(obj.code);
			}
			trace("返回结果："+e.data); 
		} 

		
		private function onServiceInitComplete(event:Open4399ToolsEvent):void{ 
			//在工具类初始化完成后，进行接口的调用工作。
			trace("初始化成功！");
		}   
		
		private function onCheckBadWordsError(e:Open4399ToolsEvent):void{ 
			trace("接口调用出问题了！"); 
		}

	}
}