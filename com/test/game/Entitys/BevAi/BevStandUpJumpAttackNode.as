package com.test.game.Entitys.BevAi
{
	import com.superkaka.game.Const.ActionState;
	import com.test.game.BevTree.BevActionNode;
	import com.test.game.BevTree.BevNode;
	import com.test.game.Const.CharacterType;
	
	public class BevStandUpJumpAttackNode extends BevActionNode
	{
		private var _monsterTypeTime:int;
		private var _intervalTime:int = 1;
		private var _stepTime:int;
		private var _skillTime:int;
		private var _stepJudge:Boolean;
		private var _jumpDistance:int;
		public function BevStandUpJumpAttackNode(name:String)
		{
			super(name);
		}
		
		override public function setParams(...args):BevNode{
			super.setParams(args[0]);
			_jumpDistance = params[1];
			return this;
		}
		
		override public function doJudge() : Boolean{
			var result:Boolean = true;
			if(_stepJudge){
				_skillTime++;
				if(_skillTime >= 60 && entity.curAction != ActionState.SKILL1){
					entity.characterControl.jumpStatus = true;
					entity.characterControl.handJump = true;
					_stepJudge = false;
					_stepTime = 0;
					_skillTime = 0;
				}
			}
			return result;
		}
		
		override public function doExecute():void{
			super.doExecute();
			if(entity == null || target == null) return;
			if(_stepTime == 0){
				_stepJudge = true;
				entity.setAction(ActionState.WAIT);
				if(entity.charData.characterType == CharacterType.NORMAL_MONSTER){
					_monsterTypeTime = 30;
				}else{
					_monsterTypeTime = 15;
				}
			}
			_stepTime++;
			if(_stepTime == 1){
				if(entity.curAction != ActionState.HIT1 
					&& entity.curAction != ActionState.SKILL1
					&& entity.curAction != ActionState.SKILL2
					&& entity.curAction != ActionState.SKILL3){
					entity.bodyAction.y = -_jumpDistance;
					entity.setAction(ActionState.SKILL1);
				}
			}
		}
	}
}