package com.test.game.Event
{
	import com.superkaka.Tools.CommonEvent;
	
	public class SkillEvent extends CommonEvent
	{
		public static const SKILL_DESTROY:String = "skill_destroy";
		public static const HURT_DESTROY:String = "hurt_destroy";
		
		public function SkillEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}