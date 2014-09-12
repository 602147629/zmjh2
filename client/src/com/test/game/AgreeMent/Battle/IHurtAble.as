package com.test.game.AgreeMent.Battle{

	
	/**
	 * 具有伤害的物体 
	 * @author zhz
	 * 
	 */	
	public interface IHurtAble{
		function getAttackId():int;//获取单次伤害的id
		
		//伤害来源物体
		function set hurtSource(value:IAttackAble):void;
		function get hurtSource():IAttackAble;
		//伤害
		function set hurt(value:int):void;
		function get hurt():int;
		//击飞点
		function set attackBackAxis(value:Array):void;
		function get attackBackAxis():Array;
	}
}