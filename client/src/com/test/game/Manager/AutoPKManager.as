package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AutoFightConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Mvc.BmdView.AutoPKSceneView;
	
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	public class AutoPKManager extends Singleton
	{
		private static const DIRECT_UP:uint = 0;
		private static const DIRECT_DOWN:uint = 1;
		private static const DIRECT_LEFT:uint = 2;
		private static const DIRECT_RIGHT:uint = 3;
		//开始自动战斗
		private var _startAutoPK:Boolean = false;
		public function get startAutoPK() : Boolean{
			return _startAutoPK;
		}
		//自动战斗类型
		private var _autoType:int = 0;
		public function get autoType() : int{
			return _autoType;
		}
		public function set autoType(value:int) : void{
			_autoType = value;
		}
		
		public function set startAutoPK(value:Boolean) : void{
			playerReset();
			keyReset();
			_startAutoPK = value;
		}
		//长按按键的键值数组
		private var _keyPressCodeList:Array = new Array();
		//普通按键的键值数组
		private var _keyCodeList:Array = new Array();
		//移动方向的帧数判断
		private var _playerMoveStep:int = 0;
		//当前移动方向索引
		private var _playerDirect:int = 0;
		private function get playerDirect() : int{
			return _playerDirect;
		}
		private function set playerDirect(value:int) : void{
			if(otherPlayer.bodyAction.y == 0){
				_playerPreDirect = _playerDirect;
				_playerDirect = value;
				playerPressKeyDown(_playerDirectList[playerDirect]);
			}
		}
		//前一个移动方向索引
		private var _playerPreDirect:int = 0;
		//方向按键数组
		private var _playerDirectList:Array = [Keyboard.W, Keyboard.S, Keyboard.A, Keyboard.D];
		//开始跑动
		private var _playerRunStart:Boolean = false;
		//开始走动
		private var _playerWalkStart:Boolean = false;
		//判断方向的间隔
		private var _changeDirect:int = 0;
		//开始普通四连攻击
		private var _playerCommonHitStart:Boolean = false;
		//普通四连攻击帧数判断
		private var _playerCommonHitStep:int = 0;
		//技能按键数组
		private var _playerSkillList:Array = [Keyboard.H, Keyboard.U, Keyboard.I, Keyboard.O, Keyboard.L];
		//当前释放技能索引
		private var _playerSkillIndex:int = 0;
		//技能释放帧数判断
		private var _playerSkillStep:int = 0;
		//开始空中攻击
		private var _playerJumpHitStart:Boolean = false;
		//空中攻击帧数判断
		private var _playerJumpHitStep:int = 0;
		//Boss技能释放帧数判断
		private var _playerBossSkillStep:int = 0;
		
		private var _targetPos:Point = new Point();
		public function AutoPKManager()
		{
			super();
		}
		
		public static function getIns():AutoPKManager{
			return Singleton.getIns(AutoPKManager);
		}
		
		private function get otherPlayer() : PlayerEntity{
			if(BmdViewFactory.getIns().getView(AutoPKSceneView) != null){
				return (BmdViewFactory.getIns().getView(AutoPKSceneView) as AutoPKSceneView).otherPlayer;
			}else{
				return null;
			}
		}
		
		private function get targetPlayer() : PlayerEntity{
			if(BmdViewFactory.getIns().getView(AutoPKSceneView) != null){
				return (BmdViewFactory.getIns().getView(AutoPKSceneView) as AutoPKSceneView).myPlayer;
			}else{
				return null;
			}
		}
		
		private var _stepTime:int;
		public function step() : void{
			if(_startAutoPK){
				if(otherPlayer != null){
					renderTargetPlayer();
					_stepTime++;
					playerAutoAi();
					playerPressKeyUp();
					playerKeyUp();
					playerSkill();
					playerRun();
					playerWalk();
					playerCommonHit();
					playerJumpHit();
					playerVertical();
				}
			}
		}
		
		private function renderTargetPlayer():void{
			if(_stepTime % 30 == 0){
				_targetPos = targetPlayer.pos;
			}
		}
		
		private function judgeBoss():void{
			if(_autoType == AutoFightConst.AUTO_TYPE_NORMAL){
				if(otherPlayer.x > 3300){
					startAutoPK = false;
					(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).renderAutoFightBtn();
					(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).autoFightBtn.mouseEnabled = false;
					GreyEffect.change((ViewFactory.getIns().getView(RoleStateView) as RoleStateView).autoFight);
				}
			}
		}
		
		private function playerVertical():void{
			if(targetPlayer != null){
				if(otherPlayer.curAction == ActionState.WALK
					|| otherPlayer.curAction == ActionState.RUN
					|| otherPlayer.curAction == ActionState.RUNHIT
					|| otherPlayer.curAction == ActionState.JUMP
					|| otherPlayer.curAction == ActionState.JUMPDOWN
					|| otherPlayer.curAction == ActionState.JUMPHIT
					|| otherPlayer.curAction == ActionState.HIT1
					|| otherPlayer.curAction == ActionState.HIT2
					|| otherPlayer.curAction == ActionState.HIT3
					|| otherPlayer.curAction == ActionState.HIT4){
					if(otherPlayer.y - _targetPos.y > 30){
						otherPlayer.moveUp();
					}
					if(_targetPos.y - otherPlayer.y > 30){
						otherPlayer.moveDown();
					}
				}
			}
		}
		
		private var _canStartStep:int;
		private function playerAutoAi():void{
			if(targetPlayer != null){
				if(canStartHit()){
					_canStartStep++;
					if(_canStartStep > 15){
						_playerCommonHitStart = true;
					}else{
						_playerRunStart = false;
						keyReset();
					}
				}else{
					_canStartStep = 0;
					setPlayerDirect();
					_playerRunStart = true;
					_playerCommonHitStart = false;
				}
			}
		}
		
		private function canStartHit():Boolean{
			var result:Boolean = false;
			if(Math.abs(otherPlayer.x - _targetPos.x) < 100){
				result = true;
			}
			
			return result;
		}
		
		//释放Boss技能
		private function playerBossSkill():void{
			if(targetPlayer != null){
				_playerBossSkillStep++;
				if(Math.abs(otherPlayer.x - _targetPos.x) < 200){
					if(_playerBossSkillStep >= 20 * 30){
						playerKeyDown(Keyboard.Q);
						_playerBossSkillStep = 0;
					}
				}
			}
		}
		
		//主角释放技能
		private function playerSkill():void{
			if(targetPlayer != null){
				if(Math.abs(otherPlayer.x - _targetPos.x) < 100){
					_playerSkillStep++;
					if(_canStartStep > 30
						&& _playerSkillStep >= 30
						&& otherPlayer.curAction != ActionState.HURT
						&& otherPlayer.curAction != ActionState.HURTDOWN
						&& otherPlayer.curAction != ActionState.JUMPHIT
						&& otherPlayer.curAction != ActionState.JUMPPRESSHITDOWN
						&& otherPlayer.curAction != ActionState.JUMPPRESSHITUP
						&& otherPlayer.curAction != ActionState.PRESSHIT
						&& otherPlayer.curAction != ActionState.RUNHIT
						&& otherPlayer.curAction != ActionState.WAIT){
						playerKeyDown(_playerSkillList[_playerSkillIndex]);
						_playerSkillIndex++;
						if(_playerSkillIndex >= _playerSkillList.length){
							_playerSkillIndex = 0;
						}
						_playerSkillStep = 0;
					}
				}
			}
		}
		
		//释放怒气
		private function playerBuring():void{
			if(targetPlayer != null){
				playerKeyDown(Keyboard.SPACE);
			}
		}
		
		//判断主角的方向
		private function setPlayerDirect() : void{
			_changeDirect++;
			if(_changeDirect >= 10){
				if(otherPlayer.x > _targetPos.x + 20){
					playerDirect = DIRECT_LEFT;
				}else if(otherPlayer.x < _targetPos.x - 20){
					playerDirect = DIRECT_RIGHT;
				}
				_changeDirect = 0;
			}
		}
		
		//主角跑动
		private function playerRun() : void{
			if(_playerRunStart){
				if(otherPlayer.curAction != ActionState.RUN){
					if(_playerMoveStep == 0){
						playerKeyDown(_playerDirectList[playerDirect]);
					}else if(_playerMoveStep == 3){
						playerPressKeyDown(_playerDirectList[playerDirect]);
						_playerRunStart = false;
						_playerMoveStep = -1;
					}
					_playerMoveStep++;
				}else{
					playerPressKeyDown(_playerDirectList[playerDirect]);
				}
			}
		}
		
		//主角走动
		private function playerWalk() : void{
			if(_playerWalkStart){
				if(otherPlayer.curAction != ActionState.WALK){
					if(_playerMoveStep == 0){
						playerPressKeyDown(_playerDirectList[playerDirect]);
						_playerWalkStart = false;
						_playerMoveStep = -1;
					}
					_playerMoveStep++;
				}else{
					playerPressKeyDown(_playerDirectList[playerDirect]);
				}
			}
		}
		
		//主角四连普通攻击
		private function playerCommonHit() : void{
			if(_playerCommonHitStart && !_playerJumpHitStart){
				if(otherPlayer.curAction != ActionState.JUMP
					&& otherPlayer.curAction != ActionState.DOUBLEJUMP){
					if(otherPlayer.curAction == ActionState.HIT4){
						_playerCommonHitStart = false;
						if(_autoType == AutoFightConst.AUTO_TYPE_NORMAL){
							_playerJumpHitStart = true;
						}
					}else{
						playerKeyDown(Keyboard.J);
					}
				}
			}
		}
		
		//主角空中攻击
		private function playerJumpHit() : void{
			if(_playerJumpHitStart){
				if(otherPlayer.curAction != ActionState.JUMP
					&& otherPlayer.curAction != ActionState.DOUBLEJUMP
					&& otherPlayer.curAction != ActionState.JUMPPRESSHITDOWN
					&& otherPlayer.curAction != ActionState.JUMPPRESSHITUP
					&& otherPlayer.curAction != ActionState.HIT4){
					playerKeyDown(Keyboard.K);
				}else{
					if(otherPlayer.curAction != ActionState.HIT4){
						_playerJumpHitStep++;
					}
					if(_playerJumpHitStep == 3){
						playerKeyDown(Keyboard.J);
					}else if(_playerJumpHitStep == 7){
						playerKeyDown(Keyboard.K);
					}else if(_playerJumpHitStep == 9){
						playerKeyDown(Keyboard.S);
						playerKeyDown(Keyboard.J);
						_playerJumpHitStart = false;
						_playerJumpHitStep = 0;
					}
				}
			}
		}
		
		public function playerReset() : void{
			if(_startAutoPK){
				_playerCommonHitStart = false;
				_playerJumpHitStart = false;
				_playerJumpHitStep = 0;
				_playerWalkStart = false;
				_playerMoveStep = 0;
				_playerRunStart = false;
				_playerMoveStep = 0;
			}
		}
		
		private function keyReset() : void{
			if(otherPlayer != null){
				otherPlayer.keyBoard.keyUp(Keyboard.A);
				otherPlayer.keyBoard.keyUp(Keyboard.S);
				otherPlayer.keyBoard.keyUp(Keyboard.W);
				otherPlayer.keyBoard.keyUp(Keyboard.D);
				otherPlayer.keyBoard.keyUp(Keyboard.J);
				otherPlayer.keyBoard.keyUp(Keyboard.K);
				otherPlayer.keyBoard.keyUp(Keyboard.H);
				otherPlayer.keyBoard.keyUp(Keyboard.U);
				otherPlayer.keyBoard.keyUp(Keyboard.I);
				otherPlayer.keyBoard.keyUp(Keyboard.O);
				otherPlayer.keyBoard.keyUp(Keyboard.L);
				otherPlayer.keyBoard.keyUp(Keyboard.Q);
			}
		}
		
		
		private function playerKeyDown(keyCode:uint) : void{
			otherPlayer.keyBoard.keyDown(keyCode);
			_keyCodeList.push(keyCode);
		}
		
		private function playerPressKeyDown(keyCode:uint) : void{
			otherPlayer.keyBoard.keyDown(keyCode);
			if(keyCode != _playerDirectList[_playerPreDirect]){
				_keyPressCodeList.push(_playerDirectList[_playerPreDirect]);
			}
		}
		
		private function playerPressKeyUp() : void{
			for(var i:int = 0; i < _keyPressCodeList.length; i++){
				otherPlayer.keyBoard.keyUp(_keyPressCodeList[i]);
			}
			_keyPressCodeList.length = 0;
		}
		
		private function playerKeyUp() : void{
			for(var i:int = 0; i < _keyCodeList.length; i++){
				otherPlayer.keyBoard.keyUp(_keyCodeList[i]);
			}
			_keyCodeList.length = 0;
		}
		
		public function clear() : void{
			startAutoPK = false;
		}
	}
}