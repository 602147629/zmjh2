package com.test.game.Mvc.control.character
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Const.BuffType;
	import com.test.game.Const.CharacterType;
	import com.test.game.Const.RoleFollowSkillConst;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Monsters.BaseMonsterEntity;
	import com.test.game.Entitys.Roles.KuangWuEntity;
	import com.test.game.Entitys.Roles.XiaoYaoEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Entitys.Test.StationShow;
	import com.test.game.Manager.AssessManager;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Modules.MainGame.MainUI.PlayerKillingRoleStateView;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Mvc.control.View.GameSceneControl;
	import com.test.game.Utils.SkillUtils;
	
	import flash.geom.Point;

	public class CharacterMoveControl extends BaseControl
	{
		private var _anti:Antiwear;
		private static const CATCH_OFFSET_X:int = 50;
		private static const CATCH_OFFSET_Y:int = 20;
		//角色信息
		public var character:CharacterEntity;
		private var _nowCloseToStation:StationShow;
		private var _nowInStation:StationShow;
		private var _preInStation:StationShow;
		//地图Y轴上限
		private var _mapLimitY:int;
		private var _fallDown:int;
		private var _isHorizontalDown:Boolean = false;
		private var _limitOffset:int = 30;
		//角色左边界
		private var _limitLeftX:int;
		//角色右边界
		private var _limitRightX:int;
		//跳跃次数
		private var _doubleJump:int = 0;
		//重力，影响下落速度
		private function get gravity() : Number{
			return _anti["gravity"];
		}
		//起跳速度
		private function get jumpSpeed() : Number{
			return  _anti["jumpSpeed"];
		}
		//当前body区域Y轴速度
		protected var _curJumpSpeed:Number = 0;
		//是否是跳起状态
		protected var _jumpStatus:Boolean = false;
		//是手动跳起还是被击飞
		protected var _handJump:Boolean = false;
		//霸体总时间，可以被伤害，不能倒地
		private var _fallTotalTime:int = 30;
		//霸体时间记录
		private var _fallNowTime:int;
		//抓取开始时玩家位置
		private var _judgePoint:Point;
		//抓取过程中怪物移动位移
		private var _catchPoint:Point;
		
		protected var _hurtFlyCount:int;
		
		private var _skillMove:Boolean;
		private var _skillUnHurt:Boolean;
		private var _skillMoveList:Array = new Array();
		
		private var _protectedCount:int;
		
		public function CharacterMoveControl(input:CharacterEntity)
		{
			character = input;
			_anti = new Antiwear(new binaryEncrypt());
			_anti["jumpSpeed"] = -20;
			_anti["gravity"] = 1.7;
			super();
		}
		
		public function moveControl() : void
		{
			inAir();
			xPositionJudge();
			zPositionJudge(); 
			limitRange();
			defeatJudge();
			jumpPressHit();
			rollAirJudge();
			deadJudge();
			protectedStep();
			/*positionJudge();
			jumpToStation();
			leaveStation();
			stationJudge();*/
		}
		
		private function protectedStep():void{
			if(character is PlayerEntity){
				if(!_handJump && _jumpStatus){
					if(_protectedCount >= character.charData.totalProperty.hp * .2){
						character.charData.addBuff(BuffType.BUFF_ONLY_HURT, 60);
						_protectedCount = 0;
					}
				}else{
					_protectedCount = 0;
				}
			}
		}
		
		private function deadJudge():void{
			if(character.charData.useProperty.hp <= 0 && 
				(character.curAction != ActionState.DEAD 
					&& character.curAction != ActionState.GROUNDDEAD 
					&& character.curAction != ActionState.HURT 
					&& character.curAction != ActionState.HURTDOWN)){
				if(_jumpStatus){
					character.setAction(ActionState.DEAD);
				}else{
					character.setAction(ActionState.GROUNDDEAD);
				}
				
			}
		}
		
		private var _nowPosX:int;
		private var _firstParams:Boolean;
		private var _jumpStep:int;
		private var _jumpDistance:int;
		private var _xDistance:int;
		private var _yDistance:int;
		private function rollAirJudge() : void{
			if(character.characterJudge.isRollStatus){
				if(!_firstParams){
					_firstParams = true;
					_jumpDistance = _jumpStep = character.charData.skillConfigurationVo.rollSkillList[character.curAction - ActionState.SKILLBASE - 1][0];
					_xDistance = character.charData.skillConfigurationVo.rollSkillList[character.curAction - ActionState.SKILLBASE - 1][1];
					_yDistance = character.charData.skillConfigurationVo.rollSkillList[character.curAction - ActionState.SKILLBASE - 1][2];
				}
				if(character.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
					_nowPosX = -_xDistance;
				}else if(character.faceHorizontalDirect == DirectConst.DIRECT_RIGHT){
					_nowPosX = _xDistance;
				}
				if(_jumpStep <= 0){
					character.characterJudge.isRollStatus = false;
					character.bodyAction.y = 0;
					_jumpStep = _jumpDistance;
				}else if(_jumpStep <= _jumpDistance / 3){
					character.bodyAction.y += _yDistance * 2;
					character.x += _nowPosX * .4;
				}else if(_jumpStep > _jumpDistance / 3){
					character.bodyAction.y -= _yDistance;
					character.x += _nowPosX;
				}
				_jumpStep--;
			}
		}
		
		
		//角色受到伤害倒地，起来后不能被攻击的状态
		private function defeatJudge() : void{
			if(!character.isLock && character.characterJudge.isInvincible && character.characterJudge.isStandUp){
				character.bodyAction.alpha = .7;
				if(character is BaseMonsterEntity){
					if((character as MonsterEntity).charData.characterType != CharacterType.BOSS_MONSTER
						&& (character as MonsterEntity).charData.characterType != CharacterType.ELITE_BOSS_MONSTER
						&& (character as MonsterEntity).charData.characterType != CharacterType.HERO_MONSTER){
						this._fallNowTime = this._fallTotalTime;
					}
				}
				this._fallNowTime++;
				if(this._fallNowTime >= this._fallTotalTime){
					if(character.characterJudge.inviclbleTime <= 0){
						character.characterJudge.isInvincible = false;
					}
					character.characterJudge.isStandUp = false;
					character.bodyAction.alpha = 1;
					this._fallNowTime = 0;
				}
			}
		}
		
		private var _preJumpStatus:Boolean;
		//技能开始记录跳跃状态
		public function setAttackStart() : void{
			_preJumpStatus = _jumpStatus;
			_jumpStatus = false;
		}
		
		//技能结束设置跳跃状态
		public function setAttackEnd() : void{
			_jumpStatus = _preJumpStatus;
		}
		
		private function limitRange() : void	
		{
			//if(character.charData.useProperty.hp <= 0) return;
			if(character.x < limitLeftX){
				character.x = limitLeftX;
			}else if(character.x > limitRightX && limitRightX != 0){
				character.x = limitRightX;
			}
			if(character.y < 300){
				character.y = 300;
			}
			if(character.y > GameConst.stage.stageHeight - 100){
				character.y = GameConst.stage.stageHeight - 100;
			}
			if(character.y + character.bodyAction.y < 0){
				character.bodyAction.y = -character.y - 50; 
			}
		}
		
		private function inAir() : void
		{
			if(character.bodyAction.y > 0){
				character.bodyAction.y = 0;
			}
			if(_jumpStatus){
				mapPostion();
				yPositionJudge();
				jumpAction();
				/*if(character.bodyAction.y < 0 && character.bodyAction.y > -35 && _curJumpSpeed > 0){
					if(character.checkDead()){
						character.setAction(ActionState.DEAD);
						character.isLock = true;
					}else{
						if(!_handJump){
							character.fallDown();
						}
					}
				}*/
				if(character.bodyAction.y > character.initBodyContainerY){
					character.bodyAction.y = character.initBodyContainerY;
					_curJumpSpeed = 0;
					_doubleJump = 0;
					if(character is PlayerEntity){
						if(MapManager.getIns().nowMap != null){
							MapManager.getIns().nowMap.y = 0;
						}
						if(SceneManager.getIns().nowScene != null){
							SceneManager.getIns().nowScene.y = 0;
						}
					}
					_jumpStatus = false;
					if(character.characterJudge.isCatchStatus || character.characterJudge.isFollowStatus){
						character.isLock = false;
					}
					else if(character.characterJudge.isFocusStatus){
					}else{
						if(_handJump){
							if(character is PlayerEntity){
								if(!character.speedEntity.isNormal){
									character.setAction(ActionState.RUN);
								}else{
									character.setAction(ActionState.WAIT);
								}
							}else{
								character.setAction(ActionState.WAIT);
							}
						}else{
							if(character.checkDead()){
								character.setAction(ActionState.DEAD);
								character.isLock = true;
							}else{
								if(!_handJump){
									character.fallDown();
								}
							}
						}
					}
				}
			}
		}
		
		//地图视角变化
		private function mapPostion():void
		{
			if(character is PlayerEntity){
				if(character.bodyAction.y != 0){
					if(MapManager.getIns().nowMap != null){
						MapManager.getIns().nowMap.y = -character.bodyAction.y * .3;
					}
					if(SceneManager.getIns().nowScene != null){
						SceneManager.getIns().nowScene.y = -character.bodyAction.y * .3;
					}
				}
			}
		}
		
		private function jumpAction() : void{
			if(_curJumpSpeed > 0 && _handJump){
				if(character.curAction == ActionState.WAIT || character.curAction == ActionState.WALK || character.curAction == ActionState.JUMP){
					character.setAction(ActionState.JUMPDOWN);
				}
			}
		}
		//空中位置判断
		private function yPositionJudge() : void{
			if(character.charData.configProperty.spd == 0)	return;
			//手动跳起
			//抓取判断
			//不是手动跳起并且不是僵直状态
			//吸取判断
			if(_handJump
				|| character.characterJudge.isCatchStatus 
				|| (!_handJump && !character.characterJudge.isUnMoveStatus)
				|| (!_handJump && character.characterJudge.isUnMoveStatus && character.characterJudge.isFocusStatus)){
				_curJumpSpeed += gravity;
				character.bodyAction.y += this._curJumpSpeed;
			}
			//受到攻击并且僵直
			else if(!_handJump && character.characterJudge.isUnMoveStatus){
				if(character.lastBeHurtSource != null && character.lastBeHurtSource.attackBackAxis != null){
					var status:uint = (character.lastBeHurtSource as SkillEntity).hurtMoveType;
					if(status == RoleFollowSkillConst.NONE){
						if(character.lastBeHurtSource.attackBackAxis[1] != 0){
							character.bodyAction.y += character.lastBeHurtSource.attackBackAxis[1];
						}else{
							_curJumpSpeed = -10;
							character.bodyAction.y -= 2;
						}
					}
					if(character.characterJudge.isFollowStatus){
						var role:CharacterEntity = (character.lastBeHurtSource as SkillEntity).hurtSource as CharacterEntity;
						if(role != null){
							character.bodyAction.y = role.bodyAction.y;
						}
					}
					if((character.lastBeHurtSource as SkillEntity).skillConfiguration.skillMoveY < 0){
						this.jumpStatus = true;
					}
				}
			}
		}
		
		private var _movefaceX:int;
		private function xPositionJudge() : void{
			if(character.charData.configProperty.spd == 0)	return;
			if(character.lastBeHurtSource != null){
				var skillObj:SkillEntity = character.lastBeHurtSource as SkillEntity;
			}
			if(character.characterJudge.isFollowStatus && skillObj != null){
				var role:CharacterEntity = skillObj.hurtSource as CharacterEntity;
				if(role != null){
					character.x = role.x;
				}
			}else if(character.characterJudge.isCatchStatus){
				character.x -= _catchPoint.x;
				if(Math.abs(_judgePoint.x - character.x) < CATCH_OFFSET_X + 30){
					character.characterJudge.isCatchStatus = false;
				}
			}else{
				//处于僵直状态
				if(character.characterJudge.isUnMoveStatus){
					if(skillObj != null && skillObj.attackBackAxis != null){
						if(skillObj.hurtMoveType == RoleFollowSkillConst.FOCUS){
							if(character.x - skillObj.x > 15){
								character.x -= Math.abs(skillObj.attackBackAxis[0]);
							}else if(skillObj.x - character.x > 15){
								character.x += Math.abs(skillObj.attackBackAxis[0]);
							}
						}else{
							if(skillObj.skillMoveType == 0){
								if(skillObj.x < character.x){
									_movefaceX = 1;
									character.x += Math.abs(skillObj.attackBackAxis[0]);
								}else{
									_movefaceX = -1
									character.x -= Math.abs(skillObj.attackBackAxis[0]);
								}
							}else{
								_movefaceX = 0
								character.x += skillObj.attackBackAxis[0];
							}
						}
					}
				}else{
					if(_jumpStatus && !_handJump){
						//有伤害技能来源的X轴位移
						if(skillObj != null){
							if(skillObj.attackBackAxis != null && skillObj.attackBackAxis[0] != 0){
								if(skillObj.skillMoveType == 0){
									if(skillObj.x < character.x){
										_movefaceX = 1;
										character.x += Math.abs(skillObj.attackBackAxis[0]);
									}else{
										_movefaceX = -1;
										character.x -= Math.abs(skillObj.attackBackAxis[0]);
									}
								}else{
									_movefaceX = 0;
									character.x += skillObj.attackBackAxis[0];
								}
							}else{
								if(_movefaceX == 0){
									//没有伤害技能来源的X轴位移
									if(skillObj.moveHorizontalDirect == DirectConst.DIRECT_LEFT){
										character.x -= character.speedX;
									}else if(skillObj.moveHorizontalDirect == DirectConst.DIRECT_RIGHT){
										character.x += character.speedX;
									}
								}else{
									if(_movefaceX == 1){
										character.x += character.speedX;
									}else{
										character.x -= character.speedX;
									}
								}
							}
						}
					}
				}
			}
		}
		
		private function zPositionJudge() : void{
			if(character.charData.configProperty.spd == 0)	return;
			if(character.characterJudge.isCatchStatus){
				character.y -= _catchPoint.y;
			}else if(character.characterJudge.isFocusStatus && character.lastBeHurtSource != null && character.lastBeHurtSource.attackBackAxis != null){
				if(character.shadowPos.y - (character.lastBeHurtSource as SkillEntity).shadowPos.y > 15){
					character.y -= Math.abs(character.lastBeHurtSource.attackBackAxis[1]);
				}else if((character.lastBeHurtSource as SkillEntity).shadowPos.y - character.shadowPos.y > 15){
					character.y += Math.abs(character.lastBeHurtSource.attackBackAxis[1]);
				}
			}else{
				if(character.characterJudge.isUnMoveStatus
					&& character.lastBeHurtSource != null
					&& character.lastBeHurtSource.attackBackAxis != null){
					character.y += character.lastBeHurtSource.attackBackAxis[2];
				}
			}
		}
		
		//开始空中压制
		private var _jumpPressJudge:Boolean;
		public function set jumpPressJudge(value:Boolean) : void{
			_jumpPressJudge = value;
		}
		public function get jumpPressJudge() : Boolean{
			return _jumpPressJudge;
		}
		
		
		//空中压制判断
		private function jumpPressHit() : void{
			if(_jumpPressJudge){
				if(character.bodyAction.y < 0){
					if(character.bodyAction.y + 50 < 0)
						character.bodyAction.y += 50;
					else
						character.bodyAction.y = 0;
					mapPostion();
				}else{
					_jumpPressJudge = false;
					_jumpStatus = false;
					character.bodyAction.y = 0;
					_curJumpSpeed = 0;
					_doubleJump = 0;
					if(character.characterJudge.isUnMoveStatus == false && !character.isLock && character.curAction != ActionState.HURT)
						character.setAction(ActionState.JUMPPRESSHITDOWN);
					else
						character.setAction(ActionState.HURT);
					if(character is PlayerEntity){
						if(MapManager.getIns().nowMap != null){
							MapManager.getIns().nowMap.y = 0;
						}
						if(SceneManager.getIns().nowScene != null){
							SceneManager.getIns().nowScene.y = 0;
						}
					}
				}
			}
		}
		
		//地面压制
		public function jumpPress() : void
		{
			if(character.characterJudge.isUnMoveStatus || (character.curAction == ActionState.HURT && _jumpStatus)) return;
			character.setAction(ActionState.JUMP);
			_doubleJump++;
			_jumpStatus = true;
			_handJump = true;
			character.lastBeHurtSource = null;
			character.bodyAction.y = -40;
			if(_doubleJump < 3)
				_curJumpSpeed = jumpSpeed;
		}
		
		public function buringJump() : void{
			if(character.curAction == ActionState.HURT
				|| character.curAction == ActionState.HURTDOWN
				|| character.curAction == ActionState.FALL){
				character.setAction(ActionState.JUMPDOWN);
				_doubleJump = 2;
				_jumpStatus = true;
				_handJump = true;
				character.lastBeHurtSource = null;
			}
		}
		
		public function resetJump() : void{
			_handJump = true;
		}
		
		private function unNeedHurtStatus(hurtNume:int) : Boolean{
			var result:Boolean = true;
			if(character.characterJudge.isOnlyHurt){
				result = false;
			}
			if(character.characterJudge.isUseAutoFight){
				result = false;
			}
			/*if(hurtNume == 0){
				if(character.characterJudge.immunityType != ImmunityConst.NONE_IMMUNITY){
					result = false;
				}
			}*/
			return result;
		}
		
		public function hurtJudge(ih:IHurtAble) : void{
			var skillEntity:SkillEntity = ih as SkillEntity;
			var hurtNum:int = SkillUtils.calculateSkillHurt(skillEntity, character);
			_protectedCount += hurtNum;
			if(unNeedHurtStatus(hurtNum)){
				if(character is PlayerEntity){
					SoundManager.getIns().hitSoundPlayer("PlayerBeHurtSound");
					if(character.charData.characterType == CharacterType.PLAYER){
						if(ViewFactory.getIns().getView(RoleStateView) != null){
							(ViewFactory.getIns().getView(RoleStateView) as RoleStateView).setRoleHurtHead(skillEntity.unActionFrame);
						}
					}else{
						if(ViewFactory.getIns().getView(PlayerKillingRoleStateView) != null){
							(ViewFactory.getIns().getView(PlayerKillingRoleStateView) as PlayerKillingRoleStateView).setRoleHurtHead(skillEntity.unActionFrame);
						}
					}
					SceneManager.getIns().shakeLayer();
				}
				_handJump = false;
				character.characterJudge.isUnMoveStatus = true;
				character.characterJudge.addUnMoveTime(skillEntity.unActionFrame);
				character.lastBeHurtSource = skillEntity;
				character.setAction(ActionState.HURT);
				var skillStatus:uint = skillEntity.hurtMoveType;
				switch(skillStatus){
					case RoleFollowSkillConst.FOCUS:
						character.characterJudge.isFocusStatus = true;
						character.characterJudge.isCatchStatus = false;
						character.characterJudge.isFollowStatus = false;
						break;
					case RoleFollowSkillConst.CATCH:
						character.characterJudge.isCatchStatus = true;
						character.characterJudge.isFocusStatus = false;
						character.characterJudge.isFollowStatus = false;
						catchJudge(skillEntity);
						break;
					case RoleFollowSkillConst.FOLLOW:
						character.characterJudge.isFollowStatus = true;
						character.characterJudge.isFocusStatus = false;
						character.characterJudge.isCatchStatus = false;
						hitFlyStatus();
						break;
					default:
						character.characterJudge.isFocusStatus = false;
						character.characterJudge.isCatchStatus = false;
						character.characterJudge.isFollowStatus = false;
						hitFlyStatus();
						break;
				}
			}
			
			addCombo(skillEntity);
			character.addHurtBuff(skillEntity);
			if(skillEntity.hurtSource is XiaoYaoEntity){
				SoundManager.getIns().hitSoundPlayer("XiaoYaoBeHurtSound");
			}else if(skillEntity.hurtSource is KuangWuEntity){
				SoundManager.getIns().hitSoundPlayer("KuangWuBeHurtSound");
			}
			if(hurtNum != 0){
				EffectManager.getIns().createHitEffect(character);
			}else{
				EffectManager.getIns().createInvincible(character);
			}
			if(character.checkDead()){
				if(!_jumpStatus){
					character.setAction(ActionState.GROUNDDEAD);
				}
				var gsc:GameSceneControl = (ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl);
				if(character is MonsterEntity){
					if(((character as MonsterEntity).charData.characterType == CharacterType.BOSS_MONSTER
						|| (character as MonsterEntity).charData.characterType == CharacterType.ELITE_BOSS_MONSTER)
						&&　gsc.checkAllBossDead()){
						gsc.bossDeath();
						DailyMissionManager.getIns().passLevelComplete(character);
					}else if((character as MonsterEntity).charData.characterType == CharacterType.HERO_MONSTER){
						gsc.bossDeath();
					}
				}else if(character is PlayerEntity){
					gsc.playerDeath();
				}
				character.isLock = true;
			}
		}
		
		private function addCombo(skillEntity:SkillEntity) : void{
			if(skillEntity.hurtSource is PlayerEntity){
				var player:PlayerEntity = skillEntity.hurtSource as PlayerEntity;
				if(SceneManager.getIns().sceneType == SceneManager.ESCORT_SCENE){
					if(player.charData.characterType == CharacterType.PLAYER){
						AssessManager.getIns().addCombo();
					}
				}else{
					AssessManager.getIns().addCombo();
				}
			}
		}
		
		private function hitFlyStatus() : void{
			//Y轴上有偏移，击飞效果
			if(character.charData.configProperty.spd != 0 && character.lastBeHurtSource.attackBackAxis != null
				&& character.lastBeHurtSource.attackBackAxis[1] != 0){
				character.isLock = true;
				_jumpStatus = true;
				_curJumpSpeed = character.lastBeHurtSource.attackBackAxis[1];
			}
		}
		
		//抓取判断
		private function catchJudge(ih:IHurtAble) : void{
			//玩家位置
			_judgePoint = new Point(((character.lastBeHurtSource as SkillEntity).hurtSource as CharacterEntity).x, ((character.lastBeHurtSource as SkillEntity).hurtSource as CharacterEntity).y);
			var offsetX:Number;
			if(Math.abs(character.x - _judgePoint.x) <= CATCH_OFFSET_X){
				offsetX = 0;
			}else if(character.x > _judgePoint.x){
				offsetX = character.x - _judgePoint.x - CATCH_OFFSET_X;
			}else if(character.x < _judgePoint.x){
				offsetX = character.x - _judgePoint.x + CATCH_OFFSET_X;
			}
			//抓取过程中x轴每帧移动距离
			offsetX = offsetX / (ih as SkillEntity).durationFrame;
			
			var offsetY:Number;
			if(Math.abs(character.y - _judgePoint.y) < CATCH_OFFSET_Y){
				offsetY = 0;
			}else{
				offsetY = character.y - _judgePoint.y;
			}
			//抓取过程中y轴每帧移动距离
			offsetY = offsetY / (ih as SkillEntity).durationFrame;
			_catchPoint = new Point(offsetX, offsetY);
		}
		
		public function jump() : void
		{
			if(character.characterJudge.isUnMoveStatus || (character.curAction == ActionState.HURT && _jumpStatus)) return;
			if(_doubleJump == 0)
				character.setAction(ActionState.JUMP);
			else if(_doubleJump == 1)
				character.setAction(ActionState.DOUBLEJUMP);
			_doubleJump++;
			_jumpStatus = true;
			_handJump = true;
			character.lastBeHurtSource = null;
			if(_doubleJump < 3)
				_curJumpSpeed = jumpSpeed;
		}
		
		
		public function moveLeft() : void
		{
			if(character.shadowPos.x > _limitLeftX){
				//基础
				character.x -= character.speedX;
				//接近平台
				/*if(_nowCloseToStation != null && isCloseStation() && !_jumpStatus){
					//在范围之外
					if(character.stationPos.x - character.stationRect.width * .5 > _nowCloseToStation.x + _nowCloseToStation.width || character.stationPos.x + character.stationRect.width * .5 < _nowCloseToStation.x)
						character.x -= character.speedX;
					if(_nowInStation != null && _nowInStation.y < _nowCloseToStation.y)
						character.x -= character.speedX;
					
					//偏移计算
					if(Math.abs((character.stationPos.x - character.stationRect.width * .5) - (_nowCloseToStation.x + _nowCloseToStation.width)) <= character.speedX)
						character.x = _nowCloseToStation.x + _nowCloseToStation.width + character.stationRect.width * .5 + 1;
				}else if(_nowInStation != null && !jumpStatus){
					if(character.stationPos.x - character.stationRect.width * .5 > _nowInStation.x)
						character.x -= character.speedX;
				}else{
					character.x -= character.speedX;
				}*/
			}
		}
		
		public function moveRight() : void
		{
			if(character.shadowPos.x < _limitRightX){
				//基础
				character.x += character.speedX;
				//接近平台
				/*if(_nowCloseToStation != null && isCloseStation() && !_jumpStatus){
					//在范围之外
					if(character.stationPos.x - character.stationRect.width * .5 > _nowCloseToStation.x + _nowCloseToStation.width || character.stationPos.x + character.stationRect.width * .5 < _nowCloseToStation.x)
						character.x += character.speedX;
					if(_nowInStation != null && _nowInStation.y < _nowCloseToStation.y)
						character.x += character.speedX;
					
					//偏移计算
					if(Math.abs((character.stationPos.x + character.stationRect.width * .5) - _nowCloseToStation.x) <= character.speedX)
						character.x = _nowCloseToStation.x  - character.stationRect.width * .5 - 1;
				}else if(_nowInStation != null && !jumpStatus){
					if(character.stationPos.x + character.stationRect.width * .5 < _nowInStation.x + _nowInStation.width)
						character.x += character.speedX;
				}else{
					character.x += character.speedX;
				}*/
			}
		}
		
		public function moveUp() : void
		{
			if(character.shadowPos.y > _mapLimitY){
				//基础
				character.y -= character.speedY;
				
				/*if(_nowCloseToStation != null && !_jumpStatus){
					if(character.stationPos.y + character.stationRect.height  > _nowCloseToStation.y + _nowCloseToStation.getDistance){
						if(character.stationPos.x - character.stationRect.width * .5 > _nowCloseToStation.x + _nowCloseToStation.width || character.stationPos.x + character.stationRect.width * .5 < _nowCloseToStation.x)
							character.y -= character.speedY;
					}else{
						character.y -= character.speedY;
					}
				}else if(_nowInStation != null && !jumpStatus){
					if(character.stationPos.y > _nowInStation.y)
						character.y -= character.speedY;
				}
				else{
					character.y -= character.speedY;
				}*/
			}
		}
		
		public function moveDown() : void
		{
			if(character.shadowPos.y < GameConst.stage.stageHeight - 50){
				//基础
				character.y += character.speedY;
				
				/*if(_nowCloseToStation != null && !_jumpStatus){
					if(character.stationPos.y < _nowCloseToStation.y - 1){
						if(character.stationPos.x - character.stationRect.width * .5 > _nowCloseToStation.x + _nowCloseToStation.width || character.stationPos.x + character.stationRect.width * .5 < _nowCloseToStation.x)
							character.y += character.speedY;
					}else{
						character.y += character.speedY;
					}
				}else if(_nowInStation != null && !jumpStatus){
					if(character.stationPos.y + character.stationRect.height < _nowInStation.y + _nowInStation.height)
						character.y += character.speedY;
				}else{
					character.y += character.speedY;
				}*/
				/*if(_nowInStation != null){
				if(character.shadowPos.y > _nowInStation.y + _nowInStation.height){
					_fallDown = _nowInStation.offsetY;
				}
				}*/
			}
		}
		
		private function isCloseStation() : Boolean
		{
			var result:Boolean = false;
			if(character.stationPos.y - character.stationRect.height * .5 < _nowCloseToStation.y + _nowCloseToStation.getDistance && character.stationPos.y + character.stationRect.height * .5 > _nowCloseToStation.y - 1){
				result = true;
			}
			
			return result;
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
		
		public function get doubleJump() : int{
			return _doubleJump;
		}
		public function get limitLeftX() : int
		{
			return _limitLeftX;
		}
		public function set limitLeftX(value:int) : void
		{
			_limitLeftX = value + _limitOffset;
		}
		
		public function get limitRightX() : int
		{
			return _limitRightX;
		}
		public function set limitRightX(value:int) : void
		{
			_limitRightX = value - _limitOffset;
		}
		
		public function get jumpStatus() : Boolean{
			return _jumpStatus;
		}
		public function set jumpStatus(value:Boolean) : void{
			_jumpStatus = value
		}
		
		public function set handJump(value:Boolean) : void{
			_handJump = true;
		}
		
		public function get isJumpDown() : Boolean{
			_hurtFlyCount++;
			if(_curJumpSpeed > 0 && _hurtFlyCount >= 5){
				return true;
			}else{
				return false;
			}
		}
		
		public function destroy() : void{
			character = null;
			_nowCloseToStation = null;
			_nowInStation = null;
			_preInStation = null;
			if(_skillMoveList){
				_skillMoveList.length = 0;
				_skillMoveList = null;
			}
		}
	}
}