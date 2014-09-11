package com.test.game.Mvc.control.key.role
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Manager.Keyboard.KeyboardInput;
	import com.superkaka.game.Manager.Keyboard.PlayerKeyboardControl;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Const.SkillHandConst;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Roles.XiaoYaoEntity;
	import com.test.game.Manager.KeyboardManager;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	
	import flash.ui.Keyboard;
	
	public class XiaoYaoSimpleActionControl extends BaseControl
	{
		private var _playerKeyboard:PlayerKeyboardControl;
		private var _mapView:BaseMapView;
		private var _player:XiaoYaoEntity;
		private var _moveStatus:Vector.<uint>;
		private var _skillStatus:Vector.<uint>;
		private var _unReleaseSkillStatus:Vector.<uint>;
		private var _releaseSkillStatus:Vector.<uint>;
		public function XiaoYaoSimpleActionControl()
		{
			super();
			_moveStatus = new <uint>[ActionState.RUNHIT, ActionState.JUMPHIT, ActionState.JUMPPRESSHITUP, ActionState.JUMPPRESSHITDOWN, ActionState.HURT, ActionState.HURTDOWN, ActionState.JUMP, ActionState.DOUBLEJUMP, ActionState.JUMPDOWN, ActionState.HIT1, ActionState.HIT2, ActionState.HIT3, ActionState.HIT4, ActionState.SKILL1, ActionState.SKILL2, ActionState.SKILL3, ActionState.SKILL4, ActionState.SKILL5, ActionState.SKILL6, ActionState.SKILL7, ActionState.SKILL8, ActionState.SKILL9, ActionState.SKILL10, ActionState.SKILLOVER8, ActionState.SKILLLAST8, ActionState.BOSSSKILL];
			_skillStatus = new <uint>[ActionState.RUNHIT, ActionState.JUMPHIT, ActionState.JUMPPRESSHITUP, ActionState.JUMPPRESSHITDOWN, ActionState.HURT, ActionState.HURTDOWN, ActionState.SKILL1, ActionState.SKILL2, ActionState.SKILL3, ActionState.SKILL4, ActionState.SKILL5, ActionState.SKILL6, ActionState.SKILL7, ActionState.SKILL8, ActionState.SKILL9, ActionState.SKILL10, ActionState.SKILLOVER8, ActionState.SKILLLAST8, ActionState.BOSSSKILL];
			_unReleaseSkillStatus = new <uint>[ActionState.RUNHIT, ActionState.JUMPHIT, ActionState.JUMPPRESSHITUP, ActionState.JUMPPRESSHITDOWN, ActionState.SKILL1, ActionState.SKILL2, ActionState.SKILL3, ActionState.SKILL4, ActionState.SKILL5, ActionState.SKILL6, ActionState.SKILL7, ActionState.SKILL8, ActionState.SKILL9, ActionState.SKILL10, ActionState.SKILLOVER8, ActionState.SKILLLAST8, ActionState.BOSSSKILL];
			_releaseSkillStatus = new <uint>[ActionState.HURT, ActionState.HURTDOWN, ActionState.FALL];
		}
		
		public static function getIns():XiaoYaoSimpleActionControl{
			return Singleton.getIns(XiaoYaoSimpleActionControl);
		}
		
		public function controlPlayer(player:PlayerEntity,playerId:uint):void{
			_player = player as XiaoYaoEntity;
			if(_player.charData.useProperty.hp <= 0){
				return;
			}
			if(_playerKeyboard == null)
				_playerKeyboard = KeyboardManager.getIns().getPlayerKeyBoard;
			
			KeyboardManager.getIns().setButton(_player.player);
			
			//怒气释放
			if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.BURING,playerId,KeyboardInput.JUST_KEYDOWN)){
				_player.releaseBuring();
			}
			//Boss技能
			if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.BOSS_SKILL,playerId,KeyboardInput.KEYDOWN)){
				_player.releaseBossSkill();
			}
			
			if(_player.isTemptation)	return;
			
			if(_player.isLock){
				if(!canNotReleaseSkillStatus()){
					checkReleaseSkill(playerId);
				}
				return;
			}
			var isAction:Boolean = false;
			/*if(_mapView == null)	_mapView = ViewFactory.getIns().getView(BaseMapView) as BaseMapView;
			_player.stationList = _mapView.stationList;*/
			
			//设置动作
			if(canNotEnterWalkStatus()){
				if(_player.curAction != ActionState.RUN && _player.curAction != ActionState.JUMP && _player.curAction != ActionState.DOUBLEJUMP && _player.curAction != ActionState.JUMPDOWN){
					if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.LEFT,playerId,KeyboardInput.KEYDOWN)){
						_player.setAction(ActionState.RUN);
					}
					if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.RIGHT,playerId,KeyboardInput.KEYDOWN)){
						_player.setAction(ActionState.RUN);
					}
					if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.DOWN,playerId,KeyboardInput.KEYDOWN)){
						_player.setAction(ActionState.RUN);
					}
					if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.UP,playerId,KeyboardInput.KEYDOWN)){
						_player.setAction(ActionState.RUN);
					}
				}
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.RIGHT,playerId,KeyboardInput.DOUBLE_CLICK)
					|| _playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.LEFT,playerId,KeyboardInput.DOUBLE_CLICK)
					|| _playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.UP,playerId,KeyboardInput.DOUBLE_CLICK)
					|| _playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.DOWN,playerId,KeyboardInput.DOUBLE_CLICK)){
					_player.setAction(ActionState.RUN);
				}
			}
			
			//判断移动
			if(_player.curAction == ActionState.WALK || _player.curAction == ActionState.RUN || _player.curAction == ActionState.JUMP || _player.curAction == ActionState.DOUBLEJUMP || _player.curAction == ActionState.JUMPDOWN){
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.RIGHT,playerId,KeyboardInput.KEYDOWN)){
					_player.faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
					_player.moveHorizontalDirect = DirectConst.DIRECT_RIGHT;
					_player.commonHitFace = DirectConst.DIRECT_RIGHT;
					isAction = true;
				}
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.LEFT,playerId,KeyboardInput.KEYDOWN)){
					_player.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
					_player.moveHorizontalDirect = DirectConst.DIRECT_LEFT;
					_player.commonHitFace = DirectConst.DIRECT_LEFT;
					isAction = true;
				}
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.DOWN,playerId,KeyboardInput.KEYDOWN)){
					_player.faceVerticalDirect = DirectConst.DIRECT_DOWN;
					_player.moveVerticalDirect = DirectConst.DIRECT_DOWN;
					isAction = true;
				}else if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.UP,playerId,KeyboardInput.KEYDOWN)){
					_player.faceVerticalDirect = DirectConst.DIRECT_UP;
					_player.moveVerticalDirect = DirectConst.DIRECT_UP;
					isAction = true;
				}
				
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.RIGHT,playerId,KeyboardInput.KEYUP) && _playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.LEFT,playerId,KeyboardInput.KEYUP)){
					_player.moveHorizontalDirect = DirectConst.DIRECT_NONE;
				}
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.DOWN,playerId,KeyboardInput.KEYUP) && _playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.UP,playerId,KeyboardInput.KEYUP)){
					_player.moveVerticalDirect = DirectConst.DIRECT_NONE;
				}
			}
			
			//空中压制和地面压制
			if(canNotChangeSkillStatus() && _playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.SIMPLEMODEE,playerId,KeyboardInput.KEYDOWN)){
				if(_player.characterControl.doubleJump != 0){
					if(_player.curAction != ActionState.JUMPPRESSHITUP && _player.curAction != ActionState.JUMPPRESSHITDOWN){
						_player.setAction(ActionState.JUMPPRESSHITUP);
					}
				}else{
					if(_player.runHitTime <= 0){
						_player.isNormalHit = false;
						_player.setAction(ActionState.RUNHIT);
					}
				}
			}else{
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.NORMAL_HIT,playerId,KeyboardInput.KEYDOWN)){
					if(canNotChangeSkillStatus()){
						//在地面
						if(_player.characterControl.doubleJump == 0){
							//跑动中按攻击键前冲
							/*if(_player.curAction == ActionState.RUN && _player.runHitTime <= 0){
								_player.isNormalHit = false;
								_player.setAction(ActionState.RUNHIT);
							}else{*/
								//普通4连击
								_player.isNormalHit = true; 
								switch(_player.comboTime){
									case 0:
										_player.setAction(ActionState.HIT1);
										break;
									case 1:
									case 2:
									case 3:
										isAction = false;
										break;
								}
								if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.LEFT,playerId,KeyboardInput.KEYDOWN)){
									_player.commonHitFace = DirectConst.DIRECT_LEFT;
									_player.commonHitFace = DirectConst.DIRECT_LEFT;
								}
								if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.RIGHT,playerId,KeyboardInput.KEYDOWN)){
									_player.commonHitFace = DirectConst.DIRECT_RIGHT;
									_player.commonHitFace = DirectConst.DIRECT_RIGHT;
								}
							//}
						}else{
							//空中普通攻击
							if(_player.airHitTime <= 0)
								_player.setAction(ActionState.JUMPHIT);
						}
					}
				}else{
					_player.isNormalHit = false;
				}
			}
			
			
			if(canNotUnReleaseSkillStatus()){
				//10个技能
				for(var i:int = 1; i <= 10; i++){
					if(_player.skillReleaseJudge(ActionState["SKILL" + i]) || (!_player.skillReleaseJudge(ActionState["SKILL" + i]) && canNotReleaseSkillStatus())){
						if(i == 2 || i == 7 || i == 4 || i == 8){
							if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl["SKILL_" + i],playerId,KeyboardInput.KEYDOWN) && _player.characterControl.doubleJump == 0 && !_player.skillColdTimeJudge(ActionState["SKILL" + i]) && !_player.skillMpJudge(ActionState["SKILL" + i])){
								_player.setAction(ActionState["SKILL" + i]);
								isAction = false;
							}
						}else{
							if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl["SKILL_" + i],playerId,KeyboardInput.KEYDOWN) && !_player.skillColdTimeJudge(ActionState["SKILL" + i]) && !_player.skillMpJudge(ActionState["SKILL" + i])){
								_player.setAction(ActionState["SKILL" + i]);
								isAction = false;
							}
						}
					}
				}
				
				//跳跃
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.JUMP,playerId,KeyboardInput.JUST_KEYDOWN)){
					_player.jump();
					isAction = true;
				}
				
				//第7个技能释放
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.SKILL_7,playerId,KeyboardInput.KEYDOWN) && _player.skill7Entity != null){
					_player.setAction(ActionState.SKILL7);
					isAction = false;
				}
			}
			
			//第8个技能释放
			if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.SKILL_8,playerId,KeyboardInput.KEYUP) && _player.curAction == ActionState.SKILL8){
				_player.setAction(ActionState.SKILLOVER8);
				isAction = false;
			}
			
			//第9个技能持续按下
			if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.SKILL_9,playerId,KeyboardInput.JUST_KEYDOWN)){
				_player.skill9Continue = true;
			}
			
			if(true){
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.LEFT,playerId,KeyboardInput.KEYDOWN)){
					_player.skillMove = SkillHandConst.HAND_MOVE_LEFT;
				}
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.RIGHT,playerId,KeyboardInput.KEYDOWN)){
					_player.skillMove = SkillHandConst.HAND_MOVE_RIGHT;
				}
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.DOWN,playerId,KeyboardInput.KEYDOWN)){
					_player.skillMove = SkillHandConst.HAND_MOVE_DOWN;
				}
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.UP,playerId,KeyboardInput.KEYDOWN)){
					_player.skillMove = SkillHandConst.HAND_MOVE_UP;
				}
				
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.RIGHT,playerId,KeyboardInput.KEYUP)
					&& _playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.LEFT,playerId,KeyboardInput.KEYUP)
					&& _playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.DOWN,playerId,KeyboardInput.KEYUP)
					&& _playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.UP,playerId,KeyboardInput.KEYUP)){
					_player.skillMove = SkillHandConst.HAND_MOVE_NONE;
				}
			}
			
			
			if(isAction){
				if(_player.moveHorizontalDirect == DirectConst.DIRECT_LEFT){
					_player.moveLeft();
				}else if(_player.moveHorizontalDirect == DirectConst.DIRECT_RIGHT){
					_player.moveRight();
				}
				if(_player.moveVerticalDirect == DirectConst.DIRECT_DOWN){
					_player.moveDown();
				}else if(_player.moveVerticalDirect == DirectConst.DIRECT_UP){
					_player.moveUp();
				}
			}else{
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.LEFT,playerId,KeyboardInput.KEYUP) && 
					_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.UP,playerId,KeyboardInput.KEYUP) && 
					_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.RIGHT,playerId,KeyboardInput.KEYUP) && 
					_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.DOWN,playerId,KeyboardInput.KEYUP)){
					if(_player.curAction == ActionState.WALK || _player.curAction == ActionState.RUN){
						_player.setAction(ActionState.WAIT);
					}
				}
			}
		}
		
		public function checkReleaseSkill(playerId:int) : void{
			if(canNotUnReleaseSkillStatus()){
				//10个技能
				for(var i:int = 1; i <= 10; i++){
					if(_player.skillReleaseJudge(ActionState["SKILL" + i]) || (!_player.skillReleaseJudge(ActionState["SKILL" + i]) && canNotReleaseSkillStatus())){
						if(i == 2 || i == 7 || i == 4 || i == 8){
							if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl["SKILL_" + i],playerId,KeyboardInput.KEYDOWN) && _player.characterControl.doubleJump == 0 && !_player.skillColdTimeJudge(ActionState["SKILL" + i]) && !_player.skillMpJudge(ActionState["SKILL" + i])){
								_player.setAction(ActionState["SKILL" + i]);
							}
						}else{
							if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl["SKILL_" + i],playerId,KeyboardInput.KEYDOWN) && !_player.skillColdTimeJudge(ActionState["SKILL" + i]) && !_player.skillMpJudge(ActionState["SKILL" + i])){
								_player.setAction(ActionState["SKILL" + i]);
							}
						}
					}
				}
			}
		}
		
		public function controlKeyUp(player:PlayerEntity) : void{
			_player = player as XiaoYaoEntity;
			if(_player.charData.useProperty.hp <= 0){
				return;
			}
			
			_player.keyBoard.keyUp(Keyboard.A);
			_player.keyBoard.keyUp(Keyboard.S);
			_player.keyBoard.keyUp(Keyboard.W);
			_player.keyBoard.keyUp(Keyboard.D);
			_player.keyBoard.keyUp(Keyboard.J);
			_player.keyBoard.keyUp(Keyboard.K);
			_player.keyBoard.keyUp(Keyboard.H);
			_player.keyBoard.keyUp(Keyboard.U);
			_player.keyBoard.keyUp(Keyboard.I);
			_player.keyBoard.keyUp(Keyboard.O);
			_player.keyBoard.keyUp(Keyboard.L);
			_player.keyBoard.keyUp(Keyboard.Q);
		}
		
		
		//这些动作下不能上下左右的操作
		private function canNotEnterWalkStatus() : Boolean
		{
			var result:Boolean = true;
			for each(var status:uint in _moveStatus)
			{
				if(_player.curAction == status)
					result = false;
			}
			return result;
		}
		
		//这些动作下不能有其他操作
		private function canNotChangeSkillStatus() : Boolean
		{
			var result:Boolean = true;
			for each(var status:uint in _skillStatus)
			{
				if(_player.curAction == status)
					result = false;
			}
			return result;
		}
		
		private function canNotUnReleaseSkillStatus() : Boolean{
			var result:Boolean = true;
			for each(var status:uint in _unReleaseSkillStatus){
				if(_player.curAction == status){
					result = false;
				}
			}
			return result;
		}
		
		private function canNotReleaseSkillStatus() : Boolean{
			var result:Boolean = true;
			for each(var status:uint in _releaseSkillStatus){
				if(_player.curAction == status){
					result = false;
				}
			}
			return result;
		}
		
		public function destroy() : void{
			_moveStatus.length = 0;
			_moveStatus = null;
			_skillStatus.length = 0;
			_skillStatus = null;
			_playerKeyboard = null;
			_mapView = null;
			_player = null;
		}
	}
}