package com.test.game.Mvc.Data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class BaseData extends EventDispatcher
	{
		public function BaseData(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}