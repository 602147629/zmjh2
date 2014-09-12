package com.test.game.Mvc.control.logic{
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.AgreeMent.Battle.IBeHurtAble;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	
	public class SkillsCollisionControl extends BaseControl{
		public function SkillsCollisionControl(){
			super();
		}
		
		public function collosion(ih:IBeHurtAble,ia:IHurtAble):void{
			ih.hurtBy(ia);
		}
		
	}
}