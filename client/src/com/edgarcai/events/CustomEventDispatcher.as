package com.edgarcai.events 
{
	import flash.events.*;
	
	/**
	 * ...
	 * @author edgarcai
	 */
	public class CustomEventDispatcher extends EventDispatcher 
	{
		public static var CHECKDATAERROR:String = "checkdataerror";		
		public function checkDataError():void 
		{
			dispatchEvent(new Event(CustomEventDispatcher.CHECKDATAERROR));
		}
		
	}

}