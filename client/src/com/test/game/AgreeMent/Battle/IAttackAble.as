package com.test.game.AgreeMent.Battle{
	
	/**
	 * 可以发出具有伤害属性的物体
	 * @author zhz
	 * 
	 */	
	public interface IAttackAble{
		//对可以被攻击的对象发动攻击
		function attackTarget(value:IBeHurtAble):void;
		
	}
}