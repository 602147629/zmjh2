package com.test.game.AgreeMent.Battle{
	

	
	/**
	 * 可以被伤害的物体 
	 * @author zhz
	 * 
	 */	
	public interface IBeHurtAble{
		//被攻击过技能id的数组
		function set beAttackedIdVec(vec:Vector.<int>):void;
		function get beAttackedIdVec():Vector.<int>;
		
		//当前被攻击的来源对象
		function set lastBeHurtSource(ia:IHurtAble):void;
		function get lastBeHurtSource():IHurtAble;
		
		function isYourFather():Boolean;//是否无敌
		
		function hurtBy(ih:IHurtAble):void;//被某个对象攻击
	}
}