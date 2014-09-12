package open4399Tools.events
{
	import flash.events.Event;
	
	public class Open4399ToolsEvent extends Event
	{
		//初始化
		public static const SERVICE_INIT:String = "init_service"; 
		//检查敏感词
		public static const CHECK_BAD_WORDS:String = "check_bad_words"; 
		public static const CHECK_BAD_WORDS_ERROR:String = "check_bad_words_error";
		
		private var _data:*;
		
		public function Open4399ToolsEvent(type:String,eventData:*=null)
		{
			super(type);
			_data = eventData;
		}
		
		public function get data():*{
			return _data;
		}
		
		override public function clone():Event{
			return new Open4399ToolsEvent(type,_data);
		}
	}
}