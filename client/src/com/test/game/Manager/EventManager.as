package com.test.game.Manager{
	import com.superkaka.Tools.AEventDispatcher;
	import com.superkaka.Tools.Singleton;
	
	public class EventManager extends Singleton{
		private var _event:AEventDispatcher;
		
		public function EventManager(){
			super();
			_event = new AEventDispatcher();
		}
		
		
		public static function getIns():EventManager{
			return Singleton.getIns(EventManager);
		}
		
		
		public function get EventDispather():AEventDispatcher{
			return _event;
		}
		
	}
}