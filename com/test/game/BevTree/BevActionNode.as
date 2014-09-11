package com.test.game.BevTree
{
	import com.superkaka.game.Const.ActionState;

	public class BevActionNode extends BevNode
	{
		public function BevActionNode(name:String)
		{
			super(name);
		}
		
		override public function doJudge():Boolean
		{
			return true;
		}
		
		override public function destroy():void{
			super.destroy();
		}
		
		protected function get canActivity() : Boolean{
			var result:Boolean = false;
			if(entity.curAction != ActionState.HURT
				&& entity.curAction != ActionState.DEAD
				&& entity.curAction != ActionState.GROUNDDEAD
				&& entity.curAction != ActionState.HIT1
				&& entity.curAction != ActionState.SKILL1
				&& entity.curAction != ActionState.SKILL2
				&& entity.curAction != ActionState.SKILL3
				&& entity.curAction != ActionState.SKILL4
				&& entity.curAction != ActionState.SKILL5
				&& entity.curAction != ActionState.SKILLOVER2
				&& !entity.characterJudge.isStandUp
				&& !entity.characterControl.jumpStatus){
				result = true;
			}
			return result;
		}
	}
}