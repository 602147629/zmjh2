package com.test.game.Mvc.control.key
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Manager.Keyboard.KeyboardInput;
	import com.superkaka.game.Manager.Keyboard.PlayerKeyboardControl;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Modules.MainGame.Map.BaseMapView;

	public class PlayerControl extends BaseControl
	{
		public function PlayerControl()
		{
			super();
			_moveStatus = new <uint>[ActionState.HURT, ActionState.JUMP, ActionState.HIT1, ActionState.ROLL, ActionState.CONTINUEHIT1, ActionState.CONTINUEHIT2];
			_skillStatus = new <uint>[ActionState.HIT1, ActionState.CONTINUEHIT1, ActionState.CONTINUEHIT2, ActionState.ROLL];
		}
		
		public static function getIns():PlayerControl{
			return Singleton.getIns(PlayerControl);
		}
		
		private var _playerKeyboard:PlayerKeyboardControl;
		private var _mapView:BaseMapView;
		private var _player:PlayerEntity;
		private var _moveStatus:Vector.<uint>;
		private var _skillStatus:Vector.<uint>;
		public function controlPlayer(player:PlayerEntity,playerId:uint):void{
			if(player.lock) return;
			
			var isAction:Boolean = false;
			
			_player = player;
			if(_playerKeyboard == null) _playerKeyboard = PlayerKeyboardControl.getIns();
			if(_mapView == null)	_mapView = ViewFactory.getIns().getView(BaseMapView) as BaseMapView;
			_player.stationList = _mapView.stationList;
			
			if(canNotEnterWalkStatus()){
				if(_player.curAction != ActionState.RUN){
					if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.LEFT,playerId,KeyboardInput.KEYDOWN)){
						_player.setAction(ActionState.WALK);
					}
					if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.RIGHT,playerId,KeyboardInput.KEYDOWN)){
						_player.setAction(ActionState.WALK);
					}
					if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.DOWN,playerId,KeyboardInput.KEYDOWN)){
						_player.setAction(ActionState.WALK);
					}
					if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.UP,playerId,KeyboardInput.KEYDOWN)){
						_player.setAction(ActionState.WALK);
					}
				}
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.RIGHT,playerId,KeyboardInput.DOUBLE_CLICK) || _playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.LEFT,playerId,KeyboardInput.DOUBLE_CLICK)){
					_player.setAction(ActionState.RUN);
				}
			}
			
			//判断移动
			if(_player.curAction == ActionState.WALK || _player.curAction == ActionState.RUN || _player.curAction == ActionState.JUMP){
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.RIGHT,playerId,KeyboardInput.KEYDOWN)){
					_player.faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
					_player.moveHorizontalDirect = DirectConst.DIRECT_RIGHT;
					isAction = true;
				}
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.LEFT,playerId,KeyboardInput.KEYDOWN)){
					_player.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
					_player.moveHorizontalDirect = DirectConst.DIRECT_LEFT;
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
			
			if(_player.curAction != ActionState.HURT)
			{
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.NORMAL_HIT,playerId,KeyboardInput.JUST_KEYDOWN)){
					switch(_player.comboTime)
					{
						case 0:
							_player.setAction(ActionState.HIT1);
							break;
						case 1:
							_player.setAction(ActionState.CONTINUEHIT1);
							isAction = false;
							break;
						case 2:
							_player.setAction(ActionState.CONTINUEHIT2);
							isAction = false;
							break;
					}
				}
			}
			
			if(canNotChangeSkillStatus())
			{
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.SKILL_1,playerId,KeyboardInput.KEYDOWN)){
					_player.setAction(ActionState.ROLL);
					isAction = true;
				}
			}
			
			if(canNotChangeSkillStatus())
			{
				if(_playerKeyboard.getPlayerKeyBoardByPlayer(_player.keyBoard,PlayerKeyboardControl.JUMP,playerId,KeyboardInput.JUST_KEYDOWN)){
					_player.jump();
					isAction = true;
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
		
		//这些状态下不能进行行动操作
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
		
		//释放技能时不能有其他操作
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
		
		public function destroy() : void
		{
			
		}
	}
}