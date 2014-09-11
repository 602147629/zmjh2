package com.test.game.Entitys.Skill
{
	import com.superkaka.game.ResourceOperation.BitmapDataPool;
	import com.test.game.AgreeMent.Battle.IAttackAble;
	import com.test.game.Mvc.Vo.SkillVo;
	
	public class FunnyBossOneSkillEntity extends SkillEntity
	{
		public function FunnyBossOneSkillEntity(skillVo:SkillVo, source:IAttackAble, skillData:Object)
		{
			super(skillVo, source, skillData);
		}
		
		override protected function initSequenceAction():void{
			super.initSequenceAction();
			
			if(skillVo.sequenceId == 40026){
				if(BitmapDataPool.hasRegisteredData("FunnyBossOneSkill2_3")){
					var index:int = Math.random() * 23 + 1;
					BitmapDataPool.registerData("FunnyBossOneSkill2_3_" + index, false);
					this.bodyAction.replaceAssets(0, "FunnyBossOneSkill2_3_" + index);
				}
			}
		}
	}
}