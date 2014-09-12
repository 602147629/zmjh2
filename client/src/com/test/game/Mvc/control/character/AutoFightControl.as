package com.test.game.Mvc.control.character
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Const.AutoFightConst;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.AutoFightManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Mvc.Vo.EnemyVo;
	
	import flash.ui.Keyboard;
	
	public class AutoFightControl extends BaseControl
	{
		protected static const DIRECT_UP:uint = 0;
		protected static const DIRECT_DOWN:uint = 1;
		protected static const DIRECT_LEFT:uint = 2;
		protected static const DIRECT_RIGHT:uint = 3;
		//自动战斗类型
		protected var _autoType:int = 0;
		public function get autoType() : int{
			return _autoType;
		}
		public function set autoType(value:int) : void{
			_autoType = value;
		}
		//开始自动战斗
		protected var _startAutoFight:Boolean = false;
		public function get startAutoFight() : Boolean{
			return _startAutoFight;
		}
		public function set startAutoFight(value:Boolean) : void{
			if(_startAutoFight == value) return;
			playerReset();
			keyReset();
			_startAutoFight = value;
		}
		//长按按键的键值数组
		protected var _keyPressCodeList:Array = new Array();
		//普通按键的键值数组
		protected var _keyCodeList:Array = new Array();
		//当前指向的怪物
		protected var _target:CharacterEntity;
		//移动方向的帧数判断
		protected var _playerMoveStep:int = 0;
		//当前移动方向索引
		protected var _playerDirect:int = 0;
		protected function get playerDirect() : int{
			return _playerDirect;
		}
		protected function set playerDirect(value:int) : void{
			if(myPlayer.bodyAction.y == 0){
				_playerPreDirect = _playerDirect;
				_playerDirect = value;
				playerPressKeyDown(_playerDirectList[playerDirect]);
			}
		}
		//前一个移动方向索引
		protected var _playerPreDirect:int = 0;
		//方向按键数组
		protected var _playerDirectList:Array = [Keyboard.W, Keyboard.S, Keyboard.A, Keyboard.D];
		//开始跑动
		protected var _playerRunStart:Boolean = false;
		//开始走动
		protected var _playerWalkStart:Boolean = false;
		//判断方向的间隔
		protected var _changeDirect:int = 0;
		//开始普通四连攻击
		protected var _playerCommonHitStart:Boolean = false;
		//普通四连攻击帧数判断
		protected var _playerCommonHitStep:int = 0;
		//技能按键数组
		protected var _playerSkillList:Array = [Keyboard.H, Keyboard.U, Keyboard.I, Keyboard.O, Keyboard.L];
		//当前释放技能索引
		protected var _playerSkillIndex:int = 0;
		//技能释放帧数判断
		protected var _playerSkillStep:int = 0;
		//开始空中攻击
		protected var _playerJumpHitStart:Boolean = false;
		//空中攻击帧数判断
		protected var _playerJumpHitStep:int = 0;
		//Boss技能释放帧数判断
		protected var _playerBossSkillStep:int = 0;
		
		protected var _myPlayer:PlayerEntity;
		protected function get myPlayer() : PlayerEntity{
			return _myPlayer;
		}
		
		protected function get monsters() : Vector.<MonsterEntity>{
			if(SceneManager.getIns().nowScene != null){
				return SceneManager.getIns().monsters;
			}else{
				return null;
			}
		}
		
		protected var isReleaseBuring:Boolean = true;
		protected var isReleaseBoss:Boolean = true;
		
		public function AutoFightControl(player:PlayerEntity){
			super();
			_myPlayer = player;
		}
		
		protected var _stepTime:int;
		public function step() : void{
			if(judgeFightStart){
				if(myPlayer != null){
					_stepTime++;
					playerAutoAi();
					playerPressKeyUp();
					playerKeyUp();
					playerSkill();
					playerRun();
					playerWalk();
					playerCommonHit();
					playerJumpHit();
					playerBuring();
					playerBossSkill();
					playerVertical();
					if(_stepTime == 30){
						judgeMonster();
						judgeEverySecond();
						_stepTime = 0;
					}
				}
			}else{
				otherMoveStep();
			}
		}
		
		protected function otherMoveStep():void{
			
		}
		
		protected function get judgeFightStart() : Boolean{
			var result:Boolean = false;
			result = _startAutoFight;
			return result;
		}
		
		protected function judgeEverySecond():void{
			
		}
		
		protected function judgeMonster():void{
			_target = null;
			checkTarget();
		}
		
		protected function playerVertical():void{
			if(_target != null){
				if(myPlayer.curAction == ActionState.WALK
					|| myPlayer.curAction == ActionState.RUN
					|| myPlayer.curAction == ActionState.RUNHIT
					|| myPlayer.curAction == ActionState.JUMP
					|| myPlayer.curAction == ActionState.JUMPDOWN
					|| myPlayer.curAction == ActionState.JUMPHIT
					|| myPlayer.curAction == ActionState.HIT1
					|| myPlayer.curAction == ActionState.HIT2
					|| myPlayer.curAction == ActionState.HIT3
					|| myPlayer.curAction == ActionState.HIT4){
					if(myPlayer.y - _target.y > 30){
						myPlayer.moveUp();
					}
					if(_target.y - myPlayer.y > 30){
						myPlayer.moveDown();
					}
				}
			}
		}
		
		protected function playerAutoAi():void{
			seekFightTarget();
			if(_target != null){
				setPlayerDirect();
				if(canFightJudge){
					_playerCommonHitStart = true;
				}else{
					_playerRunStart = true;
					_playerCommonHitStart = false;
				}
			}else{
				_playerRunStart = true;
				if(LevelManager.getIns().isStart){
					playerDirect = AutoFightManager.getIns().DIRECT_LEFT;
				}else{
					playerDirect =  AutoFightManager.getIns().DIRECT_RIGHT;
				}
				_playerCommonHitStart = false;
			}
		}
		
		//释放Boss技能
		private function playerBossSkill():void{
			if(isReleaseBoss){
				if(_target != null){
					_playerBossSkillStep++;
					if(Math.abs(myPlayer.x - _target.x) < 200){
						if(_playerBossSkillStep >= 20 * 30){
							playerKeyDown(Keyboard.Q);
							_playerBossSkillStep = 0;
						}
					}
				}
			}
		}
		
		//主角释放技能
		protected function playerSkill():void{
			if(_target != null){
				if(Math.abs(myPlayer.x - _target.x) < 200){
					_playerSkillStep++;
					if(_playerSkillStep >= (_autoType == AutoFightConst.AUTO_TYPE_NORMAL?5:3) * 30
						&& myPlayer.curAction != ActionState.HURT
						&& myPlayer.curAction != ActionState.HURTDOWN
						&& myPlayer.curAction != ActionState.JUMPHIT
						&& myPlayer.curAction != ActionState.JUMPPRESSHITDOWN
						&& myPlayer.curAction != ActionState.JUMPPRESSHITUP
						&& myPlayer.curAction != ActionState.PRESSHIT
						&& myPlayer.curAction != ActionState.RUNHIT
						&& myPlayer.curAction != ActionState.WAIT){
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
		protected function playerBuring():void{
			if(isReleaseBuring && _target != null &&　monsters != null && monsters.length > 3){
				playerKeyDown(Keyboard.SPACE);
			}
		}
		
		//寻找怪物
		public function seekFightTarget() : void{
			if(_target == null){
				if(monsters != null && monsters.length > 0){
					checkTarget();
				}
			}else{
				if(_target.charData == null
					|| _target.charData.useProperty.hp <= 0){
					_target = null;
				}
			}
		}
		
		protected function checkTarget() : void{
			var monsterID:int;
			var isSpecial:Boolean = false;
			for(var i:int = 0; i < monsters.length; i++){
				if(monsters[i].charData.useProperty.hp > 0){
					//树精
					monsterID = (monsters[i].charData as EnemyVo).ID;
					if(monsterID == 1104 || monsterID == 2104 || monsterID == 3104){
						if(Math.abs(monsters[i].x - myPlayer.x) < 120){ 
							_target = monsters[i];
							isSpecial = true;
							break;
						}
					}
				}
			}
			//非树精
			if(!isSpecial){
				for(var j:int = 0; j < monsters.length; j++){
					if(monsters[j].charData.useProperty.hp > 0){
						_target = monsters[j];
						break;
					}
				}
			}
		}
		
		//判断怪物在主角的两侧数量，聚怪
		protected function get canFightJudge():Boolean{
			var result:Boolean = false;
			var intervalLittle:int = 1000;
			if(_autoType == AutoFightConst.AUTO_TYPE_ACE){
				var leftSide:int = 0;
				var rightSide:int = 0;
				for(var i:int = 0; i < monsters.length; i++){
					if(monsters[i].charData.useProperty.hp > 0){
						if(myPlayer.x - monsters[i].x > 20){
							leftSide++;
						}else if(myPlayer.x - monsters[i].x < -10){
							rightSide++;
						}
						var interval:int = Math.abs(myPlayer.x - monsters[i].x);
						intervalLittle = (intervalLittle < interval?intervalLittle:interval);
					}
				}
				//
				if((leftSide == 0 || rightSide == 0)){
					result = true;
				}else{
					if(leftSide > rightSide){
						playerDirect =  AutoFightManager.getIns().DIRECT_RIGHT;
					}else{
						playerDirect =  AutoFightManager.getIns().DIRECT_LEFT;
					}
				}
				if(intervalLittle > 150){
					result = false;
				}
			}else{
				intervalLittle = Math.abs(myPlayer.x - _target.x);
				if(myPlayer.x < _target.x){
					playerDirect =  AutoFightManager.getIns().DIRECT_RIGHT;
				}else{
					playerDirect =  AutoFightManager.getIns().DIRECT_LEFT;
				}
				if(intervalLittle < 150){
					result = true;
				}else{
					result = false;
				}
			}
			return result;
		}
		
		//判断主角的方向
		protected function setPlayerDirect() : void{
			_changeDirect++;
			if(_changeDirect >= 10){
				if(myPlayer.x > _target.x + 20){
					playerDirect =  AutoFightManager.getIns().DIRECT_LEFT;
				}else if(myPlayer.x < _target.x - 20){
					playerDirect =  AutoFightManager.getIns().DIRECT_RIGHT;
				}
				_changeDirect = 0;
			}
		}
		
		//主角跑动
		protected function playerRun() : void{
			if(_playerRunStart){
				if(myPlayer.curAction != ActionState.RUN){
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
		protected function playerWalk() : void{
			if(_playerWalkStart){
				if(myPlayer.curAction != ActionState.WALK){
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
		protected function playerCommonHit() : void{
			if(_playerCommonHitStart && !_playerJumpHitStart){
				if(myPlayer.curAction != ActionState.JUMP
					&& myPlayer.curAction != ActionState.DOUBLEJUMP){
					if(myPlayer.curAction == ActionState.HIT4){
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
		protected function playerJumpHit() : void{
			if(_playerJumpHitStart){
				if(myPlayer.curAction != ActionState.JUMP
					&& myPlayer.curAction != ActionState.DOUBLEJUMP
					&& myPlayer.curAction != ActionState.JUMPPRESSHITDOWN
					&& myPlayer.curAction != ActionState.JUMPPRESSHITUP
					&& myPlayer.curAction != ActionState.HIT4){
					playerKeyDown(Keyboard.K);
				}else{
					if(myPlayer.curAction != ActionState.HIT4){
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
			if(_startAutoFight){
				_playerCommonHitStart = false;
				_playerJumpHitStart = false;
				_playerJumpHitStep = 0;
				_playerWalkStart = false;
				_playerMoveStep = 0;
				_playerRunStart = false;
				_playerMoveStep = 0;
			}
		}
		
		protected function keyReset() : void{
			if(myPlayer != null){
				myPlayer.keyBoard.keyUp(Keyboard.A);
				myPlayer.keyBoard.keyUp(Keyboard.S);
				myPlayer.keyBoard.keyUp(Keyboard.W);
				myPlayer.keyBoard.keyUp(Keyboard.D);
				myPlayer.keyBoard.keyUp(Keyboard.J);
				myPlayer.keyBoard.keyUp(Keyboard.K);
				myPlayer.keyBoard.keyUp(Keyboard.H);
				myPlayer.keyBoard.keyUp(Keyboard.U);
				myPlayer.keyBoard.keyUp(Keyboard.I);
				myPlayer.keyBoard.keyUp(Keyboard.O);
				myPlayer.keyBoard.keyUp(Keyboard.L);
				myPlayer.keyBoard.keyUp(Keyboard.Q);
			}
		}
		
		
		protected function playerKeyDown(keyCode:uint) : void{
			myPlayer.keyBoard.keyDown(keyCode);
			_keyCodeList.push(keyCode);
		}
		
		protected function playerPressKeyDown(keyCode:uint) : void{
			myPlayer.keyBoard.keyDown(keyCode);
			if(keyCode != _playerDirectList[_playerPreDirect]){
				_keyPressCodeList.push(_playerDirectList[_playerPreDirect]);
			}
		}
		
		protected function playerPressKeyUp() : void{
			for(var i:int = 0; i < _keyPressCodeList.length; i++){
				myPlayer.keyBoard.keyUp(_keyPressCodeList[i]);
			}
			_keyPressCodeList.length = 0;
		}
		
		protected function playerKeyUp() : void{
			for(var i:int = 0; i < _keyCodeList.length; i++){
				myPlayer.keyBoard.keyUp(_keyCodeList[i]);
			}
			_keyCodeList.length = 0;
		}
		
		public function clear() : void{
			startAutoFight = false;
		}
	}
}