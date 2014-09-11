package com.test.game.Entitys.BevAi
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.test.game.BevTree.BevActionNode;
	import com.test.game.BevTree.BevNode;
	import com.test.game.Manager.RoleManager;
	
	public class BevStandUpAttackNode extends BevActionNode
	{
		private var _stepTime:int;
		private var _skillTime:int;
		private var _stepJudge:Boolean;
		private var _attackList:int;
		public function BevStandUpAttackNode(name:String){
			super(name);
		}
		
		override public function setParams(...args):BevNode{
			super.setParams(args[0]);
			_attackList = params[1];
			return this;
		}
		
		override public function doJudge():Boolean{
			var result:Boolean = true;
			if(_stepJudge){
				_skillTime++;
				if(_skillTime >= 60 && entity.curAction != ActionState.SKILL1){
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
				if(RoleManager.getIns().target.x < entity.x){
					entity.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
				}else{
					entity.faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
				}
			}
			_stepTime++;
			if(_stepTime == 1){
				if(entity.curAction != ActionState.HIT1 
					&& entity.curAction != ActionState.SKILL1
					&& entity.curAction != ActionState.SKILL2
					&& entity.curAction != ActionState.SKILLOVER2
					&& entity.curAction != ActionState.SKILL3){
					entity.setAction(_attackList);
				}
			}
		}
	}
}