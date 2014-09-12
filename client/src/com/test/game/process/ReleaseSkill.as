package com.test.game.process
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Manager.RoleManager;
	
	public class ReleaseSkill
	{
		private var _nowAction:uint;
		private var _nowFrame:int;
		public function ReleaseSkill(input:uint){
			_nowAction = input;
		}
		
		private var _isRelease:Boolean;
		private var _isOver:Boolean;
		public function judge(entity:MonsterEntity) : Boolean{
			var result:Boolean = false;
			_nowFrame++;
			if(_nowFrame == 30
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
				_isRelease = true;
			}
			if(_isOver || (_isRelease && entity.curAction != ActionState.SKILL1)){
				_isOver = true;
				result = true;
			}
			if(!_isRelease && _nowFrame > 30){
				_nowFrame = 0;
			}
			return result;
		}
	}
}