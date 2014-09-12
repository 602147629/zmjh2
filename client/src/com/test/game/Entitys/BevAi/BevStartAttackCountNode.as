package com.test.game.Entitys.BevAi
{
	import com.superkaka.game.Const.ActionState;
	import com.test.game.BevTree.BevActionNode;
	import com.test.game.BevTree.BevNode;
	import com.test.game.Const.CharacterType;
	import com.test.game.Manager.DigitalManager;
	
	public class BevStartAttackCountNode extends BevActionNode
	{
		private var _stepTime:int;
		private var _intervalTime:int = 1;
		private var _attackAll:Array = new Array();
		private var _attackInterval:int;
		private var _monsterTypeTime:int;
		public function BevStartAttackCountNode(name:String)
		{
			super(name);
		}
		
		override public function setParams(...args):BevNode{
			super.setParams(args[0]);
			_attackInterval = params[1];
			for(var i:int = 2; i < params.length; i++){
				_attackAll.push(params[i].split("_"));
			}
			/*if(params.length >= 3){
				_attackAll.push(params[2].split("_"));
			}
			if(params.length >= 4){
				_attackAll.push(params[3].split("_"));
			}*/
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
					if(_nowAction >= _attackInterval){
						entity.setAction(ActionState.SKILL1);
						_nowAction = -1;
					}else{
						entity.setAction(ActionState.HIT1);
					}
					_nowAction++;
				}
			}else{
				if((entity.curAction == ActionState.WAIT || entity.curAction == ActionState.WALK) && _stepTime > _intervalTime * 30){
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
					}
				}
			}
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}