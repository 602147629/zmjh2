package com.test.game.Event
{
	
	import flash.events.Event;
	
	public class ServerEvent extends Event
	{
		public var targetData:*;
		
		public var result:Boolean;
		
		public function ServerEvent(type:String, data:*, result:Boolean = true)
		{
			targetData = data;
			this.result = result;
			
			super(type);
		}
	}
}