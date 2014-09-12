package com.test.game.Entitys.BevAi
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.test.game.BevTree.BevActionNode;
	import com.test.game.BevTree.BevNode;
	import com.test.game.Manager.DigitalManager;
	import com.test.game.Manager.RoleManager;
	
	public class BevContinueAttackNode extends BevActionNode
	{
		private var _stepTime:int;
		private var _intervalTime:int = 1;
		private var _attackAll:Array = new Array();
		private var _attackList:Array = new Array();
		private var _nowAttack:int;
		private var _monsterTypeTime:int;
		public function BevContinueAttackNode(name:String){
			super(name);
		}
		
		override public function setParams(...args):BevNode{
			super.setParams(args[0]);
			_attackAll.push(params[1].split("_"));
			
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
		private var _afterHit:int;
		override public function doExecute():void
		{
			super.doExecute();
			if(entity == null || target == null) return;
			if(!entity.characterJudge.isStartAttack){
				entity.characterJudge.isStartAttack = true;
				entity.setAction(ActionState.WAIT);
				_stepTime = 0;
				_nowAction = 0;
				_afterHit = 0;
				_attackList = _attackAll[_nowAttack];
				_nowAttack++;
				if(_nowAttack >= _attackAll.length){
					_nowAttack = 0;
				}
				random = (DigitalManager.getIns().getRandom() * 4);
			}
			
			_stepTime++;
			if(_stepTime == 15){
				if(canActivity){
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
						_afterHit++;
						entity.hitType = hitType;
						if(_afterHit < 30){
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
						}else{
							entity.characterJudge.isStartAttack = false;
						}
					}else{
						_stepTime = _intervalTime * 15 - 1;
					}
				}
			}
		}
		
		private function get hitType() : int{
			var result:int = 0;
			var index:int = _nowAttack;
			index++;
			if(index >= _attackAll.length){
				index = 0;
			}
			switch(int(_attackAll[index][0])){
				case 20:
					result = 0;
					break;
				case 31:
					result = 1;
					break;
				case 32:
					result = 2;
					break;
				case 33:
					result = 3;
					break;
				case 34:
					result = 4;
					break;
				case 35:
					result = 5;
					break;
			}
			return result;
		}
		
		override public function destroy():void{
			super.destroy();
		}
	}
}