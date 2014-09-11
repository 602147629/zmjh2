package com.test.game.Entitys.BevAi
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.test.game.BevTree.BevActionNode;
	import com.test.game.BevTree.BevNode;
	import com.test.game.Manager.DigitalManager;
	import com.test.game.Manager.RoleManager;
	
	public class BevSFXCAttackNode extends BevActionNode
	{
		private var _stepTime:int;
		private var _intervalTime:int = 1;
		private var _attackList:Array = new Array();
		private var _monsterTypeTime:int;
		public function BevSFXCAttackNode(name:String){
			super(name);
		}
		
		override public function setParams(...args):BevNode{
			super.setParams(args[0]);
			_attackList = params[1].split("_");
			return this;
		}
		
		override public function doJudge():Boolean
		{
			var result:Boolean = true;
			
			return result;
		}
		
		private var random:int;
		private var _nowAction:int;
		override public function doExecute():void
		{
			super.doExecute();
			if(entity == null || target == null) return;
			if(!entity.characterJudge.isStartAttack){
				entity.characterJudge.isStartAttack = true;
				entity.setAction(ActionState.WAIT);
				_stepTime = 0;
				_nowAction = 0;
				random = (DigitalManager.getIns().getRandom() * 4);
			}
			
			_stepTime++;
			if(_stepTime == 15){
				if(entity.curAction != ActionState.HIT1 
					&& entity.curAction != ActionState.SKILL1
					&& entity.curAction != ActionState.SKILL2
					&& entity.curAction != ActionState.SKILL3
					&& entity.curAction != ActionState.SKILL4
					&& entity.curAction != ActionState.SKILL5
					&& !entity.characterJudge.isStandUp){
					if(RoleManager.getIns().target.x < entity.x){
						entity.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
					}else{
						entity.faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
					}
					entity.setAction(_attackList[_nowAction]);
				}
			}else{
				if((entity.curAction == ActionState.WAIT || entity.curAction == ActionState.WALK) && _stepTime > _intervalTime * 30){
					_nowAction++;
					if(_nowAction >= _attackList.length){
						if(_stepTime > _intervalTime * 15 + 30 && _stepTime < (_intervalTime + 1) * 30 + 30){
							switch(random){
								case 0:
									entity.moveRight();
									break;
								case 1:
									entity.moveLeft();
									break;
								case 2:
									entity.moveUp();
									break;
								case 3:
									entity.moveDown();
									break;
							}
						}else if(_stepTime > (_intervalTime + 1) * 30 + 30){
							entity.characterJudge.isStartAttack = false;
						}
					}else{
						_stepTime = _intervalTime * 15 - 1;
					}
				}
			}
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}