package com.test.game.Entitys.Conjure
{
	import com.superkaka.game.Const.ActionState;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	public class ChiNanConjureEntity extends ConjureEntity
	{
		public function ChiNanConjureEntity(charVo:CharacterVo, data:Object)
		{
			super(charVo, data);
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.SKILL2:
					checkFrameSKill(keyFrame, this.curAction);
					break;
				case ActionState.WAIT:
					if(keyFrame == 3){
						this.setAction(ActionState.SKILL2);
						this.belong.charData.characterJudge.temptationTime = 1;
						SkillManager.getIns().destroySkillByST(this.belong, 66);
					}
					break;
			}
		}
	}
}