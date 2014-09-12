package com.test.game.process
{
	public class ProcessConst
	{
		public static var FIGHT:String = "fight";
		public static var WORD:String = "word";
		public static var JUDGE:String = "judge";
		public static var TRANSFER:String = "transfer";
		public static var AI:String = "ai";
		public static var STATUS:String = "status";
		
		public static var ONLY_HURT:String = "onlyHurt";
		public static var INVINCIBLE:String = "invincible";
		public static var NOTHING:String = "nothing";
		
		public static var funcStatues:Object;
		
		funcStatues = {
			"NoneCallback" : NoneCallback,
			"DialogBase" : DialogBase,
			"ActionBase" : ActionBase,
			"MonsterMove" : MonsterMove,
			"ReleaseSkill" : ReleaseSkill,
			"HpConditionLower" : HpConditionLower,
			"HpConditionHigher" : HpConditionHigher,
			"HpConditionCompare" : HpConditionCompare,
			"RelaseSkillByTime" : RelaseSkillByTime,
			"BaseThingEntity" : BaseThingEntity
		}
	}
}