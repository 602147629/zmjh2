package com.test.game.net.http
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	public class Http {
		private var _ul : URLLoader;
		public function get ul () : URLLoader {
			return _ul;
		}
		
		private var _url : String;
		public function set url (_url : String) : void {
			this._url = _url;
		}
		
		private var _request : URLRequest;
		public function get request() : URLRequest {
			return _request;
		}
		public function set request(_request : URLRequest) : void {
			this._request = _request;
		} 
		
		public var onComplete : Function = new Function();
		public var onError : Function = new Function();
		public var onProgress : Function = new Function();
		
		public static var onVersion:Function;
		
		public function Http () {
			_ul = new URLLoader();
			_ul.addEventListener(Event.COMPLETE, complete);
			_ul.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
			_ul.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_ul.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		public function loads (url : String = '') : void {
			if (url == '' && _url == '')
			{
				throw new Error('无效的url！');
			}
			
			if (url) _url = url;
			
			request = new URLRequest(_url);
			_ul.load(request);
		}
		
		private function progressHandler(e : ProgressEvent) : void {
			onProgress(e.bytesTotal, e.bytesLoaded);
		}
		
		
		private function openHandler(e : Event) : void {
			//trace('open');
		}
		
		private function complete (e : Event) : void {
			onComplete(_ul.data);
		}
		
		private function httpStatus(e : HTTPStatusEvent) : void {
			//trace(e.status);
		}
		
		private function ioErrorHandler(e : IOErrorEvent) : void {
			trace('Http IOErrorEvent');
			trace('recall');
			_ul.close();
			_ul.load(request);
		}
		
		private function securityErrorHandler(e : SecurityErrorEvent) : void {
			trace('Http SecurityErrorEvent');
			trace('recall');
			_ul.close();
			_ul.load(request);
		}
	}
}