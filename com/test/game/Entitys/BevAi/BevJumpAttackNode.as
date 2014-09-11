package com.test.game.Entitys.BevAi
{
	import com.superkaka.game.Const.ActionState;
	import com.test.game.BevTree.BevActionNode;
	import com.test.game.BevTree.BevNode;
	import com.test.game.Const.CharacterType;
	import com.test.game.Manager.DigitalManager;
	
	public class BevJumpAttackNode extends BevActionNode
	{
		private var _stepTime:int;
		private var _intervalTime:int = 1;
		private var _attackList:Array = new Array();
		private var _jumpDistance:int;
		private var _monsterTypeTime:int;
		public function BevJumpAttackNode(name:String)
		{
			super(name);
		}
		
		override public function setParams(...args):BevNode{
			super.setParams(args[0]);
			_jumpDistance = params[1];
			_attackList = params[2].split("_");
			return this;
		}
		
		override public function doJudge():Boolean{
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
				if(entity.charData.characterType == CharacterType.NORMAL_MONSTER){
					_monsterTypeTime = 30;
				}else{
					_monsterTypeTime = 15;
				}
			}
			
			_stepTime++;
			if(_stepTime == _intervalTime * _monsterTypeTime){
				if(canActivity){
					entity.bodyAction.y = -_jumpDistance;
					if(entity.charData.characterType != CharacterType.NORMAL_MONSTER){
						if(entity.hitType == 1){
							entity.setAction(ActionState.SKILL1);
						}else if(entity.hitType == 2){
							entity.setAction(ActionState.SKILL2);
						}else if(entity.hitType == 3){
							entity.setAction(ActionState.SKILL3);
						}else if(entity.hitType == 4){
							entity.setAction(ActionState.SKILL4);
						}else if(entity.hitType == 5){
							entity.setAction(ActionState.SKILL5);
						}else{
							entity.setAction(ActionState.HIT1);
						}
					}else{
						entity.setAction(_attackList[_nowAction]);
					}
				}
			}else{
				if((entity.curAction == ActionState.WAIT || entity.curAction == ActionState.WALK) && _stepTime > _intervalTime * 30){
					_nowAction++;
					if(_nowAction > _attackList.length){
						if(_stepTime > _intervalTime * _monsterTypeTime + 30 && _stepTime < (_intervalTime + 1) * 30 + 30){
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
						}else{
							entity.characterControl.jumpStatus = true;
							entity.characterControl.handJump = true;
						}
					}else{
						_stepTime = _intervalTime * _monsterTypeTime - 1;
					}
				}
			}
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}