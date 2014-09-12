package com.test.game.Mvc.control.character
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Entitys.Test.StationShow;

	public class CharacterControl extends BaseControl
	{
		public var character:CharacterEntity;
		private var _nowCloseToStation:StationShow;
		private var _nowInStation:StationShow;
		private var _preInStation:StationShow;
		private var _mapLimitY:int;
		private var _fallDown:int;
		private var _isHorizontalDown:Boolean = false;
		private var _limitLeftX:int;
		private var _limitRightX:int;
		private var _doubleJump:int = 0;
		private var _jumpSpeed:Number = -20;//起跳速度
		private var _curJumpSpeed:Number = 0;//当前body区域Y轴速度
		private var _gravity:Number = 1.5;//重力，影响下落速度
		private var _jumpStatus:Boolean = false;
		
		public function CharacterControl()
		{
			super();
		}
		
		public function moveControl() : void
		{
			flyInAir();
			jumpToStation();
			leaveStation();
			stationJudge();
			positionJudge();
			limitRange();
		}
		
		private function limitRange() : void	
		{
			if(character.x < limitLeftX){
				character.x = limitLeftX;
			}else if(character.x > limitRightX){
				character.x = limitRightX;
			}
		}
		
		private function stationJudge():void
		{
			if(character.stationList == null) return;
			for(var i:int = 0; i < character.stationList.length; i++)
			{
				if(_nowInStation != null && _nowInStation == character.stationList[i]) continue;
				else
				{
					if(distanceJudge(character.stationList[i]))
					{
						_nowCloseToStation = character.stationList[i];
						break;
					}
				}
			}
			if(i == character.stationList.length)
				_nowCloseToStation = null;
		}
		
		/**
		 * 计算距离
		 * @param item
		 * @return 
		 * 
		 */		
		protected function distanceJudge(item:StationShow) : Boolean
		{
			var result:Boolean = false;
			if(Math.abs(character.stationPos.x - (item.x + item.width * .5)) <= item.width * .5 + character.stationRect.width * .5 + character.speedX && Math.abs(character.stationPos.y - (item.y + item.getDistance * .5)) <= item.getDistance * .5 + character.stationRect.height * .5 + character.speedY)
			{
				result = true;
			}
			return result;
		}
		
		private function leaveStation():void
		{
			if(_nowInStation != null)
			{
				if(character.stationPos.x + character.stationRect.width * .5 < _nowInStation.x + character.speedX || character.stationPos.x - character.stationRect.width * .5 > _nowInStation.x + _nowInStation.width  - character.speedX || character.stationPos.y - character.stationRect.height * .5 > _nowInStation.y + _nowInStation.height)
				{
					if(!_jumpStatus)
					{
						_isHorizontalDown = true;
						_fallDown = _nowInStation.offsetY;
						_preInStation = _nowInStation;
						_nowInStation = _nowCloseToStation;
					}
				}
			}
		}
		
		public function jumpToStation() : void
		{
			if(_jumpStatus)
			{
				if((_nowInStation == null && _nowCloseToStation != null) || (_nowInStation != null && _nowCloseToStation != null && _nowInStation != _nowCloseToStation))
				{

					if(character.stationPos.x + character.stationRect.width * .5 >= _nowCloseToStation.x 
						&& character.stationPos.x - character.stationRect.width * .5 <= _nowCloseToStation.x + _nowCloseToStation.width 
						&& character.stationPos.y + character.stationRect.height * .5 < _nowCloseToStation.y + _nowCloseToStation.height
						&& character.stationPos.y - character.stationRect.height * .5 > _nowCloseToStation.y)
					{
						_preInStation = _nowInStation;
						_nowInStation = _nowCloseToStation;
					}
				}
			}
		}
		
		private function positionJudge():void
		{
			verticalJudge();
			horizontalJudge();
		}
		private function verticalJudge() : void
		{
			if(_nowInStation != null)
				_mapLimitY = 350 - _nowInStation.offsetY;
			else
				_mapLimitY = 350;
			if(character.shadowPos.y < _mapLimitY)
			{
				character.y += character.speedY;
				nowStationJudge();
				_fallDown = 0;
			}
			//y轴掉下位移
			/*else if(_fallDown > 0)
			{
				if(_nowInStation != null && _nowCloseToStation != null)
					_fallDown -= _nowCloseToStation.offsetY;
				character.y += character.speedY;
				_fallDown -= character.speedY;
			}*/
		}
		
		private function horizontalJudge() : void
		{
			if(_nowCloseToStation != null && _isHorizontalDown)
			{
				if(Math.abs((character.stationPos.x - character.stationRect.width * .5) - (_nowCloseToStation.x + _nowCloseToStation.width)) <= character.speedX)
					character.x = _nowCloseToStation.x + _nowCloseToStation.width + character.stationRect.width * .5 + 1;
				if(Math.abs((character.stationPos.x + character.stationRect.width * .5) - _nowCloseToStation.x) <= character.speedX)
					character.x = _nowCloseToStation.x  - character.stationRect.width * .5 - 1;
				_isHorizontalDown = false;
			}
		}
		
		protected function moveJudge() : void
		{
			if(_nowCloseToStation != null)
			{
				if(Math.abs((character.stationPos.x - character.stationRect.width * .5) - (_nowCloseToStation.x + _nowCloseToStation.width)) <= character.speedX * 3)
					character.x = _nowCloseToStation.x + _nowCloseToStation.width + character.stationRect.width * .5 + 1;
				if(Math.abs((character.stationPos.x + character.stationRect.width * .5) - _nowCloseToStation.x) <= character.speedX * 3)
					character.x = _nowCloseToStation.x  - character.stationRect.width * .5 - 1;
			}
		}
		
		private function nowStationJudge() : void
		{
			if(character.stationList == null) return;
			for(var i:int = 0; i < character.stationList.length; i++)
			{
				if(distanceInJudge(character.stationList[i]))
				{
					_nowInStation = character.stationList[i];
				}
			}
		}
		
		private function distanceInJudge(item:StationShow) : Boolean
		{
			var result:Boolean = false;
			if(Math.abs(character.stationPos.x - (item.x + item.width * .5)) < item.width * .5
				&& Math.abs(character.stationPos.y - (item.y + item.height * .5)) < item.height * .5)
			{
				result = true;
			}
			return result;
		}
		
		
		public function moveLeft() : void
		{
			if(character.shadowPos.x > _limitLeftX)
			{
				//接近平台
				if(_nowCloseToStation != null && isCloseStation() && !_jumpStatus)
				{
					//在范围之外
					if(character.stationPos.x - character.stationRect.width * .5 > _nowCloseToStation.x + _nowCloseToStation.width || character.stationPos.x + character.stationRect.width * .5 < _nowCloseToStation.x)
						character.x -= character.speedX;
					if(_nowInStation != null && _nowInStation.y < _nowCloseToStation.y)
						character.x -= character.speedX;
					
					//偏移计算
					if(Math.abs((character.stationPos.x - character.stationRect.width * .5) - (_nowCloseToStation.x + _nowCloseToStation.width)) <= character.speedX)
						character.x = _nowCloseToStation.x + _nowCloseToStation.width + character.stationRect.width * .5 + 1;
				}
				else if(_nowInStation != null && !jumpStatus)
				{
					if(character.stationPos.x - character.stationRect.width * .5 > _nowInStation.x)
						character.x -= character.speedX;
				}
				else 
				{
					character.x -= character.speedX;
				}
			}
		}
		
		public function moveRight() : void
		{
			if(character.shadowPos.x < _limitRightX)
			{
				//接近平台
				if(_nowCloseToStation != null && isCloseStation() && !_jumpStatus)
				{
					//在范围之外
					if(character.stationPos.x - character.stationRect.width * .5 > _nowCloseToStation.x + _nowCloseToStation.width || character.stationPos.x + character.stationRect.width * .5 < _nowCloseToStation.x)
						character.x += character.speedX;
					if(_nowInStation != null && _nowInStation.y < _nowCloseToStation.y)
						character.x += character.speedX;
					
					//偏移计算
					if(Math.abs((character.stationPos.x + character.stationRect.width * .5) - _nowCloseToStation.x) <= character.speedX)
						character.x = _nowCloseToStation.x  - character.stationRect.width * .5 - 1;
				}
				else if(_nowInStation != null && !jumpStatus)
				{
					if(character.stationPos.x + character.stationRect.width * .5 < _nowInStation.x + _nowInStation.width)
						character.x += character.speedX;
				}
				else
				{
					character.x += character.speedX;
				}
			}
		}
		
		public function moveUp() : void
		{
			if(character.shadowPos.y > _mapLimitY)
			{
				if(_nowCloseToStation != null && !_jumpStatus)
				{
					if(character.stationPos.y + character.stationRect.height  > _nowCloseToStation.y + _nowCloseToStation.getDistance){
						if(character.stationPos.x - character.stationRect.width * .5 > _nowCloseToStation.x + _nowCloseToStation.width || character.stationPos.x + character.stationRect.width * .5 < _nowCloseToStation.x)
							character.y -= character.speedY;
					}else{
						character.y -= character.speedY;
					}
				}
				else if(_nowInStation != null && !jumpStatus)
				{
					if(character.stationPos.y > _nowInStation.y)
						character.y -= character.speedY;
				}
				else
					character.y -= character.speedY;
			}
		}
		
		public function moveDown() : void
		{
			if(character.shadowPos.y < 590)
			{
				if(_nowCloseToStation != null && !_jumpStatus){
					if(character.stationPos.y < _nowCloseToStation.y - 1){
						if(character.stationPos.x - character.stationRect.width * .5 > _nowCloseToStation.x + _nowCloseToStation.width || character.stationPos.x + character.stationRect.width * .5 < _nowCloseToStation.x)
							character.y += character.speedY;
					}
					else
					{
						character.y += character.speedY;
					}
				}
				else if(_nowInStation != null && !jumpStatus)
				{
					if(character.stationPos.y + character.stationRect.height < _nowInStation.y + _nowInStation.height)
						character.y += character.speedY;
				}
				else{
					character.y += character.speedY;
				}
				/*if(_nowInStation != null)
				{
					if(character.shadowPos.y > _nowInStation.y + _nowInStation.height)
					{
						_fallDown = _nowInStation.offsetY;
					}
				}*/
			}
		}
		
		private function isCloseStation() : Boolean
		{
			var result:Boolean = false;
			if(character.stationPos.y - character.stationRect.height * .5 < _nowCloseToStation.y + _nowCloseToStation.getDistance && character.stationPos.y + character.stationRect.height * .5 > _nowCloseToStation.y - 1)
			{
				result = true;
			}
			/*if(character.stationPos.y + character.stationRect.height * .5 > _nowCloseToStation.y)
			{
				result = true;
			}*/
			
			return result;
		}
		
		public function fly():void{
			_jumpStatus = true;
			if(character.lastBeHurtSource != null)
				_curJumpSpeed = character.lastBeHurtSource.attackBackPoint.y;
		}
		
		protected function flyInAir() : void
		{
			if(_jumpStatus && !character.isHurt)
			{
				_curJumpSpeed += _gravity;
				character.bodyAction.y += this._curJumpSpeed;
				if(character.lastBeHurtSource != null)
				{
					if(character.lastBeHurtSource.attackBackPoint != null)
						character.x += character.lastBeHurtSource.attackBackPoint.x;
					else
					{
						if(character.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
							character.x += character.speedX;
						}else if(character.faceHorizontalDirect == DirectConst.DIRECT_RIGHT){
							character.x -= character.speedX;
						}
					}
				}
				if(character.bodyAction.y > character.initBodyContainerY){
					character.bodyAction.y = character.initBodyContainerY;
					_curJumpSpeed = 0;
					_doubleJump = 0;
					//落地
					
					_jumpStatus = false;
					if(character.checkDead())
						character.setAction(ActionState.DEAD);
					else
					{
						if(character.speedX == CharacterEntity.RUN_SPEED)
							character.setAction(ActionState.RUN);
						else
							character.setAction(ActionState.WAIT);
					}
				}
			}
			character.isHurt = false;
		}
		
		public function hurtJudge(ih:IHurtAble) : void
		{
			var attackId:int = ih.getAttackId();
			if(character.beAttackedIdVec.indexOf(attackId) == -1){
				character.isHurt = true;
				character.lastBeHurtSource = ih;
				character.beAttackedIdVec.push(attackId);
				character.setAction(ActionState.HURT);
				//Y轴上有偏移，击飞效果
				if(character.lastBeHurtSource.attackBackPoint != null)
				{
					if(character.lastBeHurtSource.attackBackPoint.y != 0)
						fly();
					else
						character.x += character.lastBeHurtSource.attackBackPoint.x;
				}
				else if(_jumpStatus == true)
					combineFly();
				character.changeHp(character.lastBeHurtSource.hurt);
				if(character.checkDead() && !_jumpStatus)
				{
					character.setAction(ActionState.DEAD);
				}
			}
		}
		
		private function combineFly() : void
		{
			this._curJumpSpeed = _jumpSpeed;
		}
		
		public function jump() : void
		{
			if(character.isHurt || (character.curAction == ActionState.HURT && _jumpStatus)) return;
			character.setAction(ActionState.JUMP);
			_doubleJump++;
			_jumpStatus = true;
			character.lastBeHurtSource = null;
			if(_doubleJump < 3)
				_curJumpSpeed = _jumpSpeed;
		}
		
		public function get limitLeftX() : int
		{
			return _limitLeftX;
		}
		public function set limitLeftX(value:int) : void
		{
			_limitLeftX = value;
		}
		
		public function get limitRightX() : int
		{
			return _limitRightX;
		}
		public function set limitRightX(value:int) : void
		{
			_limitRightX = value;
		}
		
		public function get jumpStatus() : Boolean
		{
			return _jumpStatus;
		}
	}
}