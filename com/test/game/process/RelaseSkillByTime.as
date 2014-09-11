package com.test.game.process
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Manager.RoleManager;

	public class RelaseSkillByTime
	{
		private var _nowAction:uint;
		private var _nowFrame:int;
		private var _nowTime:int;
		public function RelaseSkillByTime(input:String)
		{
			var arr:Array = input.split("|");
			_nowAction = arr[0];
			_nowTime = arr[1];
			_nowFrame = _nowTime - 30;
		}
		
		public function judge(entity:MonsterEntity) : Boolean{
			var result:Boolean = false;
			_nowFrame++;
			if(_nowFrame == _nowTime
				&& entity.isLock == false
				&& entity.curAction != ActionState.HURT
				&& entity.curAction != ActionState.DEAD
				&& entity.curAction != ActionState.GROUNDDEAD
				&& entity.curAction != ActionState.HIT1 
				&& entity.curAction != ActionState.SKILL1
				&& entity.curAction != ActionState.SKILL2
				&& entity.curAction != ActionState.SKILL3
				&& entity.curAction != ActionState.SKILL4
				&& entity.curAction != ActionState.SKILL5){
				entity.setAction(_nowAction);
				RoleManager.getIns().seekTarget(entity);
				if(RoleManager.getIns().target.x < entity.x){
					entity.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
				}else{
					entity.faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
				}
			}else if(_nowFrame > _nowTime){
				_nowFrame = 0;
			}
			return result;
		}
	}
}