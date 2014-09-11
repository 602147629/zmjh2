package com.test.game.Event
{
	import com.superkaka.Tools.CommonEvent;
	
	public class CharacterEvent extends CommonEvent
	{
		public static const CHARACTER_DEAD_EVENT:String = "character_dead_event";
		public static const MONSTER_CLEAR_EVENT:String = "monster_clear_event";
		
		public function CharacterEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, data, bubbles, cancelable);
		}
	}
}