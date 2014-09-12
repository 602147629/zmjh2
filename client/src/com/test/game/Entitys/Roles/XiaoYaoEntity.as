package com.test.game.Entitys.Roles
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Const.BuffType;
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Effect.SwordEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Event.SkillEvent;
	import com.test.game.Manager.DigitalManager;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.control.character.XiaoYaoMoveControl;
	
	import flash.geom.Point;
	
	public class XiaoYaoEntity extends PlayerEntity
	{
		private var _skill7Entity:SkillEntity;
		private var _skill8Count:int;
		private var _skill9Count:int;
		private var _skill9MaxCount:int;
		//是否连续释放技能9
		private var _skill9Judge:Boolean;
		//是否点击技能9
		public var skill9Continue:Boolean;
		public var tq:TestQuad;
		public var isNormalHit:Boolean;
		public var airHitTime:int;
		public var runHitTime:int;
		public var swordList:Vector.<BaseNativeEntity>;
		private var _xPos:Array = new Array(45, 40, 55, 30);
		private var _yPos:Array = new Array(0, 20, 10, -10);
		
		public function XiaoYaoEntity(charVo:CharacterVo)
		{
			super(charVo);
			
			this.isRectCollision = true;
			this.collisionListeners = [CollisionFilterIndexConst.MONSTER_SKILL, CollisionFilterIndexConst.ALL_SKILL];
		}
		
		override protected function initSequenceAction():void{
			
			this.bodyAction = new BaseSequenceActionBind(this.charVo);
			this.setAction(ActionState.WAIT);
			this.bodyAction.renderSpeed = 1;
			
			super.initSequenceAction();
			tq = new TestQuad();
			tq.x = -tq.width/2;
			tq.y = -tq.height/2;
			tq.visible = false;
			this.bodyAction.addChild(tq);
			this.collisionBody = this.tq;
			
			//this.bodyAction.glowFilter = new GlowFilter(0x000000);
		}
		
		override protected function initParams():void{
			super.initParams();
			this._characterControl = new XiaoYaoMoveControl(this);
		}
		
		
		override protected function initShadow():void{
			super.initShadow();
			this.shadow.y = 60;
		}
		
		override public function setAction(actionState:uint,resetWhenSameAction:Boolean = false):void{
			skillHurtJudge(actionState);
			super.setAction(actionState,resetWhenSameAction);
		}
		
		private var _skillHurtList:Vector.<uint> = Vector.<uint>([ActionState.JUMPHIT, ActionState.JUMPPRESSHITDOWN, ActionState.SKILL1, ActionState.SKILL2, ActionState.SKILL3, ActionState.SKILL4, ActionState.SKILL5, ActionState.SKILL6, ActionState.SKILL7, ActionState.SKILL8, ActionState.SKILL9]);
		//在空中释放技能的时候受到伤害的判断
		private function skillHurtJudge(actionState:uint):void{
			if(actionState == ActionState.HURT || actionState == ActionState.HURTDOWN){
				for each(var action:uint in _skillHurtList){
					if(this.curAction == action){
						_characterControl.setAttackEnd();
						this.resetSkillParams();
						break;
					}
				}
			}
		}		
		
		override public function hurtBy(ih:IHurtAble):void{
			super.hurtBy(ih);
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT1:
					if(keyFrame == 3){
						releaseSword();
						releaseCommonHit(1);
					}else if(keyFrame > 3 && isNormalHit){
						comboTime = 1;
					}
					break;
				case ActionState.HIT2:
					if(keyFrame == 3){
						releaseSword();
						this.releaseCommonHit(2);
					}else if(keyFrame > 3 && isNormalHit){
						comboTime = 2;
					}
					break;
				case ActionState.HIT3:
					if(keyFrame == 3){
						releaseSword();
						this.releaseCommonHit(3);
					}else if(keyFrame > 3 && isNormalHit){
						comboTime = 3;
					}
					break;
				case ActionState.HIT4:
					if(keyFrame == 3){
						releaseSword();
						this.releaseCommonHit(4);
					}
					break;
				case ActionState.RUNHIT:
					if(keyFrame == 1){
						runHitTime = 45;
						this.releaseRunHit();
					}
					break;
				case ActionState.JUMPPRESSHITUP:
					if(keyFrame == 1){
						this.characterControl.jumpPressJudge = true;
						if(this.characterControl.doubleJump == 0)
							this.characterControl.jumpPress();
						this.releaseJumpPressHit(1);
					}
					break;
				case ActionState.JUMPPRESSHITDOWN:
					if(keyFrame == 1){
						this.releaseJumpPressHit(2);
					}
					break;
				case ActionState.JUMPHIT:
					if(keyFrame == 3){
						releaseSwordAir();
						airHitTime = 20;
						this.releaseJumpHit();
					}
					break;
				case ActionState.SKILL1:
				case ActionState.SKILL2:
				case ActionState.SKILL3:
				case ActionState.SKILL4:
				case ActionState.SKILL10:
					checkFrameSKill(keyFrame, this.curAction);
					break;
				case ActionState.SKILL5:
					releaseSkill5(keyFrame, curRenderIndex);
					break;
				case ActionState.SKILL6:
					useBlur = true;
					checkFrameSKill(keyFrame, this.curAction);
					break;
				case ActionState.SKILL7:
					releaseSkill7(keyFrame, curRenderIndex);
					break;
				case ActionState.SKILL8:
					if(keyFrame == 2){
						this.releaseSkill(8 - 1, true);
						this._skill8Count++;
					}
					break;
				case ActionState.SKILLLAST8:
					if(keyFrame == 2){
						SkillManager.getIns().createSkill(this, 47);
					}
					break;
				case ActionState.SKILL9:
					if(this._skill9Count == 0){
						checkFrameSKill(keyFrame, this.curAction);
					}
					if(this._skill9Count >= 5 && this.skill9Continue){
						_skill9Judge = true;
					}
					break;
				case ActionState.GROUNDDEAD:
					if(keyFrame < 6){
						groundDeadMove();
					}
					break;
				case ActionState.BOSSSKILL:
					if(keyFrame == 1){
						this.releaseBossSkill();
					}
					break;
			}
		}
		
		override protected function doWhenActionOver(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			comboJudge();
			switch(this.curAction){
				//普通攻击1
				case ActionState.HIT1:
					if(comboTime == 1){
						this.setAction(ActionState.HIT2);
					}else{
						this.setAction(ActionState.WAIT);
						comboTime = 0;
					}
					break;
				//普通攻击2
				case ActionState.HIT2:
					if(comboTime == 2){
						this.setAction(ActionState.HIT3);
					}else{
						this.setAction(ActionState.WAIT);
						comboTime = 0;
					}
					break;
				//普通攻击3
				case ActionState.HIT3:
					if(comboTime == 3){
						this.setAction(ActionState.HIT4);
					}else{
						this.setAction(ActionState.WAIT);
						comboTime = 0;
					}
					break;
				//普通攻击4
				case ActionState.HIT4:
				case ActionState.RUNHIT:
				case ActionState.STAND:
					this.setAction(ActionState.WAIT);
					break;
				//二段跳跃
				case ActionState.DOUBLEJUMP:
					this.setAction(ActionState.JUMPDOWN);
					break;
				//受伤
				case ActionState.HURT:
				case ActionState.HURTDOWN:
					this._skill8Count = 0;
					useBlur = false;
					unMoveHurt();
					break;
				//倒地
				case ActionState.FALL:
					if(curRenderIndex == 15){
						standUp();
						unMoveHurt();
					}
					break;
				case ActionState.SKILL1:
					createSword();
				case ActionState.JUMPPRESSHITDOWN:
				case ActionState.JUMPHIT:
				case ActionState.BOSSSKILL:
				case ActionState.SKILL2:
				case ActionState.SKILL3:
				case ActionState.SKILL4:
				case ActionState.SKILL5:
				case ActionState.SKILL7:
				case ActionState.SKILL10:
					_characterControl.setAttackEnd();
					this.resetSkillParams();
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.SKILL6:
					useBlur = false;
					judgeSkillFallDownStatus();
					_characterControl.setAttackEnd();
					this.resetSkillParams();
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.SKILL8:
					if(_skill8Count >= 4){
						this.setAction(ActionState.SKILLOVER8);
					}else{
						this.setAction(ActionState.SKILL8, true);
					}
					break;
				case ActionState.SKILLLAST8:
					if(this._skill8Count > 1){
						this._skill8Count--;
						this.setAction(ActionState.SKILLLAST8, true);
					}else{
						_characterControl.setAttackEnd();
						this.resetSkillParams();
						this.setAction(ActionState.WAIT);
						this._skill8Count = 0;
					}
					break;
				case ActionState.SKILLOVER8:
					this.setAction(ActionState.SKILLLAST8);
					break;
				case ActionState.SKILL9:
					_skill9Count++;
					if(_skill9Count < 10){
						this.setAction(ActionState.SKILL9, true);
					}else{
						_skill9MaxCount++;
						if(_skill9MaxCount < 3){
							if(!this._skill9Judge){
								_characterControl.setAttackEnd();
								this.resetSkillParams();
								this.setAction(ActionState.WAIT);
								_skill9MaxCount = 0;
							}else{
								this.resetSkillParams(false);
								this.setAction(ActionState.SKILL9, true);
							}
						}else{
							_characterControl.setAttackEnd();
							this.resetSkillParams();
							this.setAction(ActionState.WAIT);
							_skill9MaxCount = 0;
						}
						this._skill9Judge = false;
						this._skill9Count = 0;
					}
					this.skill9Continue = false;
					break;
				//死亡
				case ActionState.DEAD:
				case ActionState.GROUNDDEAD:
					this.dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_DEAD_EVENT));
					break;
				default : 
					this.setAction(this.curAction, true);
					this.standJudge();
					break;
			}
		}
		
		//创建剑气
		private function createSword() : void{
			if(swordList != null){
				for(var j:int = 0; j < swordList.length; j++){
					(swordList[j] as SwordEntity).destroy();
				}
				swordList.length = 0;
			}
			swordList = EffectManager.getIns().createSwordEffect(this);
		}
		
		//实时剑气位置
		public function swordPos() : void{
			var direct:int = 1;
			for(var i:int = 0; i < swordList.length; i++){
				if((swordList[i] as SwordEntity).role.faceHorizontalDirect == DirectConst.DIRECT_RIGHT){
					direct = -1;
				}else if((swordList[i] as SwordEntity).role.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
					direct = 1;
				}else{
					(swordList[i] as SwordEntity).role.faceHorizontalDirect == DirectConst.DIRECT_RIGHT;
					direct = -1;
				}
				swordList[i].x = (swordList[i] as SwordEntity).role.bodyPos.x;
				swordList[i].y = (swordList[i] as SwordEntity).role.bodyPos.y;
				(swordList[i] as SwordEntity).bodyAction.x = direct * _xPos[i];
				(swordList[i] as SwordEntity).bodyAction.y = _yPos[i];
			}
		}
		
		//清除一道剑气
		public function pushSword() : void{
			destroySword(swordList[swordList.length - 1]);
		}
		public function destroySword(sword:BaseNativeEntity):void{
			var idx:int = this.swordList.indexOf(sword);
			if(idx != -1){
				if(sword.parent != null){
					sword.parent.removeChild(sword);
				}
				sword.destroy();
				this.swordList.splice(idx,1);
			}
		}
		//地面剑气
		private function releaseSword() : void{
			if(swordList != null && swordList.length > 0){
				SkillManager.getIns().createSkill(this, 50);
			}
		}
		//空中剑气
		private function releaseSwordAir() : void{
			if(swordList != null && swordList.length > 0){
				SkillManager.getIns().createSkill(this, 54);
			}
		}
		
		private function releaseSkill5(keyFrame:int, curRenderIndex:int):void{
			if(keyFrame == 1){
				this.setSkillColdTime();
				_characterControl.setAttackStart();
				//技能是否无敌
				charVo.checkInvincible(4);
				//技能是否霸体
				charVo.checkOnlyHurt(4);
				getConfirmPos();
				var skill:SkillEntity = SkillManager.getIns().createSkill(this, 53);
				skill.scaleXValue = .7;
			}
			if(curRenderIndex % 2 == 0 && curRenderIndex <= 60){
				releaseWave();
				if(_confirmPosX.length == 0){
					getConfirmPos();
				}
			}
			
			var point:Point = new Point(DigitalManager.getIns().getRandom() * _circleX * 2 - _circleX, DigitalManager.getIns().getRandom() * _circleY * 2 - _circleY + _offsetY);
			if(curRenderIndex <= 30 && curRenderIndex % 5 == 0){
				createSkill5(point);
			}else if(curRenderIndex > 30 && curRenderIndex <= 60 && curRenderIndex % 2 == 0){
				createSkill5(point);
			}
		}
		
		private var _circleX:int = 30;
		private var _circleY:int = 80;
		private var _offsetY:int = -30;
		private var _confirmPosX:Array = new Array();
		private var _confirmPosY:Array = new Array();
		private function getConfirmPos() : void{
			_confirmPosX.length = 0;
			_confirmPosY.length = 0;
			_confirmPosX.push(-_circleX, _circleX);
			_confirmPosY.push(_offsetY, _offsetY);
			var count:int = _circleX * 2 / 7;
			var posX:int;
			var posY:int;
			for(var i:int = 1; i < 4; i++){
				posX = _circleX - count * i;
				posY = Math.sqrt((1 - Math.pow(posX, 2) / (_circleX * _circleX)) * _circleY * _circleY);
				_confirmPosX.push(posX, posX);
				_confirmPosX.push(-posX, -posX);
				_confirmPosY.push(posY + _offsetY, -posY + _offsetY);
				_confirmPosY.push(posY + _offsetY, -posY + _offsetY);
			}
		}
		
		private function getPos() : void{
			_confirmPosX.length = 0;
			_confirmPosY.length = 0;
			_confirmPosX.push(_circleX);
			_confirmPosY.push(_offsetY);
			var posX:int;
			var posY:int;
			var count:int = _circleX * 2 / 7;
			var i:int;
			for(i = 1; i < 4; i++){
				posX = _circleX - count * i;
				posY = Math.sqrt((1 - Math.pow(posX, 2) / (_circleX * _circleX)) * _circleY * _circleY);
				_confirmPosX.push(posX);
				_confirmPosY.push(posY + _offsetY);
			}
			
			for(i = 3; i > 0; i--){
				posX = _circleX - count * i;
				posY = Math.sqrt((1 - Math.pow(posX, 2) / (_circleX * _circleX)) * _circleY * _circleY);
				_confirmPosX.push(-posX);
				_confirmPosY.push(posY + _offsetY);
			}
			_confirmPosX.push(-_circleX);
			_confirmPosY.push(_offsetY);
			for(i = 1; i < 4; i++){
				posX = _circleX - count * i;
				posY = Math.sqrt((1 - Math.pow(posX, 2) / (_circleX * _circleX)) * _circleY * _circleY);
				_confirmPosX.push(-posX);
				_confirmPosY.push(-posY + _offsetY);
			}
			
			for(i = 3; i > 0; i--){
				posX = _circleX - count * i;
				posY = Math.sqrt((1 - Math.pow(posX, 2) / (_circleX * _circleX)) * _circleY * _circleY);
				_confirmPosX.push(posX);
				_confirmPosY.push(-posY + _offsetY);
			}
		}
		
		private function releaseWave() : void{
			var index:int = _confirmPosX.length - 1;
			var postion:Point = new Point(_confirmPosX[index], _confirmPosY[index]);
			_confirmPosX.splice(index, 1);
			_confirmPosY.splice(index, 1);
			createSkill5(postion);
		}
		
		private function createSkill5(postion:Point):void{
			var face:int = (this.faceHorizontalDirect == DirectConst.DIRECT_LEFT?-1:1);
			SkillManager.getIns().createPosSkill(this.x + postion.x + face * 85, postion.y + 10, this.y + this.bodyAction.y, this, 51);
			SkillManager.getIns().createPosSkill(this.x + postion.x + face * 85, postion.y + 10, this.y + this.bodyAction.y, this, 52);
		}
		
		private function releaseSkill7(keyFrame:int, curRenderIndex:int):void{
			if(keyFrame == 3){
				if(_skill7Entity == null){
					this.setSkillColdTime();
					_characterControl.setAttackStart();
					_skill7Entity = SkillManager.getIns().createSkill(this, 44);
					_skill7Entity.addEventListener(SkillEvent.SKILL_DESTROY, skill7Destroy)
				}else if(_skill7Entity != null){
					SkillManager.getIns().createSkill(this, 45);
					_characterControl.setAttackStart();
					this.pos = _skill7Entity.pos;
					_skill7Entity.destroy();
					_skill7Entity = null;
				}
			}
		}
		
		private function skill7Destroy(e:SkillEvent) : void{
			_skill7Entity.removeEventListener(SkillEvent.SKILL_DESTROY, skill7Destroy);
			_skill7Entity = null;
		}
		
		public function get skill7Entity() : SkillEntity{
			return _skill7Entity;
		}
		
		override protected function releaseSkill(skillID:int, reset:Boolean = false) : void{
			if(charVo.skillConfigurationVo.skillCountList[skillID] == 0) {
				if(skillID == 8){
					if(_skill9MaxCount == 0){
						characterControl.setAttackStart();
						setSkillColdTime();
					}
				}else{
					characterControl.setAttackStart();
					setSkillColdTime();
				}
				//技能是否无敌
				charVo.checkInvincible(skillID);
				//技能是否霸体
				charVo.checkOnlyHurt(skillID);
			}
			if(reset)	charVo.skillConfigurationVo.skillCountList[skillID] = 0;
			SkillManager.getIns().createSkill(this, charVo.skillConfigurationVo.skillList[skillID][charVo.skillConfigurationVo.skillCountList[skillID]]);
			charVo.skillConfigurationVo.skillCountList[skillID]++;
		}
		
		override public function releaseBuring() : void{
			if(charData.angerCount >= 10 * 10 && !charData.startAngerDown){
				charData.addBuff(BuffType.BUFF_EVASION, NumberConst.getIns().xiaoYaoEvesionRate, true);
				charData.addBuff(BuffType.BUFF_DEEPEN_HURT, NumberConst.getIns().xiaoYaoHurtDeepenRate, true);
				charData.startAngerDown = true;
				initBuringEffect();
			}
		}
		
		override protected function comboJudge():void{
			super.comboJudge();
		}
		
		override public function step():void{
			if(airHitTime > 0){
				airHitTime--;
			}
			if(runHitTime > 0){
				runHitTime--;
			}
			super.step();
		}
		
		override public function destroy():void{
			this.tq = null;
			
			super.destroy();
		}
	}
}