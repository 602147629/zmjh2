package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class URLManager extends Singleton
	{
		public function URLManager()
		{
			super();
		}
		
		public static function getIns():URLManager{
			return Singleton.getIns(URLManager);
		}
		
		// 首页地址
		private var _index : String;
		public function get index () : String
		{
			return _index;
		}
		
		// 平台时间
		private var _timeURL:String;
		public function get timeURL() : String
		{
			return _timeURL;
		}
		
		// 论坛地址
		private var _forumURL:String;
		public  function get forumURL() : String
		{
			return _forumURL;
		}
		
		// 反馈地址
		private var _bugURL:String;
		public function get bugURL() : String
		{
			return _bugURL;
		}
		
		// 主站中秋活动
		private var _midAutumnURL:String;
		public function get midAutumnURL() : String
		{
			return _midAutumnURL;
		}
		
		private var _scoreURL:String
		public function get scoreURL() : String
		{
			return _scoreURL;
		}
		private var _nationalURL:String
		public function get nationalURL() : String
		{
			return _nationalURL;
		}
		
		
		
		// 充值帮助地址
		private var _payHelpURL:String;
		public  function get payHelpURL() : String
		{
			return _payHelpURL;
		}
		
		private var _integrationURL:String;
		
		private var _duanwuIntegrationURL:String;
		
		private var _tenYearsURL:String;
		
		private var _tanabataURL:String;
		
		private var _dataURL:String;
		
		private var _videoURL:String;
		
		private var _fiveYearsURL:String;
		
		private var _qiXiURL:String;
		
		private var _zhongQiuURL:String;
		
		// 解析地址
		public function init() : void
		{
			_payHelpURL = "http://my.4399.com/forums-thread-id-30307652-tagid-81116-view-me.html";
			_timeURL = "http://save.api.4399.com/?ac=get_time";
			_forumURL = "http://my.4399.com/forums-mtag-tagid-81862.html";
			_bugURL = "http://my.4399.com/forums-thread-tagid-81862-id-33551128.html";
			_integrationURL = "http://my.4399.com/jifen/product-id-856";
			_duanwuIntegrationURL = "http://my.4399.com/forums-thread-tagid-81862-id-41422111.html";
			_tanabataURL = "http://my.4399.com/forums-thread-tagid-81862-id-36402647.html";
			_dataURL = "http://app.my.4399.com/r.php?app=feedback";
			_midAutumnURL = "http://huodong.4399.com/2013/zhongqiu/";
			_scoreURL = "http://my.4399.com/forums-thread-tagid-81862-id-37202401.html";
			_nationalURL = "http://huodong.4399.com/2013/huanqiu/";
			_videoURL = "http://v.4399pk.com/zmjh2/";
			_tenYearsURL = "http://huodong2.4399.com/2014/4399_10years/";
			_fiveYearsURL = "http://my.4399.com/events/2014/fiveyear/login";
			_qiXiURL = "http://my.4399.com/forums-thread-tagid-81862-id-42686220.html";
			_zhongQiuURL = "http://my.4399.com/forums-thread-tagid-81862-id-43607694.html";
		}
		
		public function openVideoURL() : void{
			sendURL(_videoURL);
		}
		
		public function openForumURL() : void
		{
			sendURL(_forumURL);
		}
		
		public function openDebugURL() : void
		{
			sendURL(_bugURL);
		}
		
		public function openIntegrationURL() : void
		{
			sendURL(_integrationURL);
		}
		
		public function openDuwuIntegrationURL() : void
		{
			sendURL(_duanwuIntegrationURL);
		}
		
		public function openTanabataURL() : void
		{
			sendURL(_tanabataURL);
		}
		
		public function openDataURL() : void
		{
			sendURL(_dataURL);
		}
		
		public function openMidAutumnURL() : void
		{
			sendURL(_midAutumnURL);
		}
		
		public function openScoreURL() : void
		{
			sendURL(_scoreURL);
		}
		
		public function openNationURL() : void
		{
			sendURL(_nationalURL);
		}
		
		public function openPayHelp() : void
		{
			sendURL(_payHelpURL);
		}
		
		public function openTenYearsURL() : void{
			sendURL(_tenYearsURL);
		}
		
		public function openFiveYearsURL() : void{
			sendURL(_fiveYearsURL);
		}
		
		public function openQiXiURL() : void{
			sendURL(_qiXiURL);
		}
		
		public function openZhongQiuURL() : void{
			sendURL(_zhongQiuURL);
		}
		
		public function sendURL(url:String) : void{
			var broswer:String = ExternalInterface.call("function getBrowser(){return navigator.userAgent}") as String;
			if (broswer && (broswer.indexOf("Firefox") != -1 || broswer.indexOf("MSIE") != -1)){
				ExternalInterface.call('window.open("' + url + '","_blank")');
			}else{
				navigateToURL(new URLRequest(url), "_blank");
			}
		}
	}
}