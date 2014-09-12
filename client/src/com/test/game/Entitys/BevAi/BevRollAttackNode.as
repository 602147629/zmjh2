package com.test.game.Entitys.BevAi
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.test.game.BevTree.BevActionNode;
	import com.test.game.BevTree.BevNode;
	import com.test.game.Manager.DigitalManager;
	
	public class BevRollAttackNode extends BevActionNode
	{
		private var _stepTime:int;
		private var _intervalTime:int = 1;
		private var _attackList:Array = new Array();
		private var _jumpDistance:int;
		private var _jumpStep:int;
		private var _startJump:Boolean;
		private var _xDistance:int;
		private var _yDistance:int;
		public function BevRollAttackNode(name:String)
		{
			super(name);
		}
		
		override public function setParams(...args):BevNode{
			super.setParams(args[0]);
			_jumpStep = _jumpDistance = params[1];
			_xDistance = params[2];
			_yDistance = params[3]
			_attackList = params[4].split("_");
			return this;
		}
		
		override public function doJudge():Boolean{
			var result:Boolean = true;
			
			return result;
		}
		
		private var random:int;
		private var _nowAction:int;
		private var _nowPosX:int;
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
			if(_startJump){
				if(entity.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
					_nowPosX = -_xDistance;
				}else if(entity.faceHorizontalDirect == DirectConst.DIRECT_RIGHT){
					_nowPosX = _xDistance;
				}
				if(_jumpStep <= 0){
					_startJump = false;
				}else if(_jumpStep <= _jumpDistance / 3){
					entity.bodyAction.y += _yDistance * 2;
					entity.x += _nowPosX * .4;
				}else if(_jumpStep > _jumpDistance / 3){
					entity.bodyAction.y -= _yDistance;
					entity.x += _nowPosX;
				}
				_jumpStep--;
			}
			_stepTime++;
			if(_stepTime == _intervalTime * 30){
				if(entity.curAction != ActionState.HIT1 
					&& entity.curAction != ActionState.SKILL1
					&& entity.curAction != ActionState.SKILL2
					&& entity.curAction != ActionState.SKILL3
					&& entity.curAction != ActionState.SKILL4
					&& entity.curAction != ActionState.SKILL5
					&& !entity.characterJudge.isStandUp){
					_startJump = true;
					entity.setAction(_attackList[_nowAction]);
				}
			}else{
				if((entity.curAction == ActionState.WAIT || entity.curAction == ActionState.WALK) && _stepTime > _intervalTime * 30){
					_nowAction++;
					if(_nowAction > _attackList.length){
						if(_stepTime > _intervalTime * 30 + 30 && _stepTime < (_intervalTime + 1) * 30 + 30){
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
							entity.bodyAction.y = 0;
							_jumpStep = _jumpDistance;
						}
					}else{
						_stepTime = _intervalTime * 30 - 1;
					}
				}
			}
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}