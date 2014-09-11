package com.test.game.Entitys.Skill
{
	import com.test.game.AgreeMent.Battle.IAttackAble;
	import com.test.game.Mvc.Vo.SkillVo;
	
	public class KuangWuSkillEntity extends SkillEntity
	{
		public function KuangWuSkillEntity(skillVo:SkillVo, source:IAttackAble, skillData:Object){
			super(skillVo, source, skillData);
		}
		
		
	}
}