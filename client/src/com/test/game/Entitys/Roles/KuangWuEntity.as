package com.test.game.Entitys.Roles
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Const.ActionState;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Const.BuffConst;
	import com.test.game.Const.BuffType;
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.control.character.KuangWuMoveControl;
	
	
	public class KuangWuEntity extends PlayerEntity{
		private var _skill10Count:int;
		
		public var tq:TestQuad;
		public var isNormalHit:Boolean;
		public var airHitTime:int;
		public var runHitTime:int;
		private var _kuangWuStandCount:int = 0;
		
		public function KuangWuEntity(charVo:CharacterVo){
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
			
			/*this.bodyAction.scaleXValue = 2;
			this.bodyAction.scaleYValue = 2;
			this.alpha = 0.5;*/
			
//			this.bodyAction.glowFilter = new GlowFilter(0x000000);
		}
		
		override protected function initParams():void{
			super.initParams();
			this._characterControl = new KuangWuMoveControl(this);
		}
		
		
		override protected function initShadow():void{
			super.initShadow();
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
						break
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
				case ActionState.STAND:
					if(curRenderIndex == 9){
						if(_kuangWuStandCount < 3){
							this.setAction(ActionState.STAND, true);
						}
						_kuangWuStandCount++;
					}
					break;
				case ActionState.HIT1:
					if(keyFrame == 2){
						releaseCommonHit(1);
					}else if(keyFrame > 2 && isNormalHit){
						comboTime = 1;
					}
					break;
				case ActionState.HIT2:
					if(keyFrame == 2){
						this.releaseCommonHit(2);
					}else if(keyFrame > 2 && isNormalHit){
						comboTime = 2;
					}
					break;
				case ActionState.HIT3:
					if(keyFrame == 2){
						this.releaseCommonHit(1);
					}else if(keyFrame > 2 && isNormalHit){
						comboTime = 3;
					}
					break;
				case ActionState.HIT4:
					if(keyFrame == 2)
						this.releaseCommonHit(3);
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
						if(this.characterControl.doubleJump == 0){
							this.characterControl.jumpPress();
						}
						this.releaseJumpPressHit(1);
					}
					break;
				case ActionState.JUMPPRESSHITDOWN:
					if(keyFrame == 1){
						this.releaseJumpPressHit(2);
					}
					break;
				case ActionState.JUMPHIT:
					if(keyFrame == 1){
						airHitTime = 20;
						this.releaseJumpHit();
					}
					break;
				case ActionState.SKILL1:
				case ActionState.SKILL2:
				case ActionState.SKILL3:
				case ActionState.SKILL4:
				case ActionState.SKILL5:
				case ActionState.SKILL6:
				case ActionState.SKILL7:
				case ActionState.SKILL8:
				case ActionState.SKILL9:
					checkFrameSKill(keyFrame, this.curAction);
					break;
				case ActionState.SKILL10:
					if(keyFrame == 2){
						this.releaseSkill(10 - 1, true);
						this._skill10Count++;
					}
					break;
				case ActionState.SKILLOVER10:
					if(keyFrame == 3){
						this.releaseSkill(10 - 1);
					}else if(keyFrame == 4){
						this.releaseSkill(10 - 1);
					}else if(keyFrame == 6){
						this.releaseSkill(10 - 1);
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
					unMoveHurt();
					break;
				//倒地
				case ActionState.FALL:
					if(curRenderIndex == 15){
						standUp();
						unMoveHurt();
					}
					break;
				case ActionState.JUMPPRESSHITDOWN:
				case ActionState.JUMPHIT:
				case ActionState.BOSSSKILL:
				case ActionState.SKILL1:
				case ActionState.SKILL2:
				case ActionState.SKILL3:
				case ActionState.SKILL4:
				case ActionState.SKILL5:
				case ActionState.SKILL6:
				case ActionState.SKILL7:
				case ActionState.SKILL8:
				case ActionState.SKILL9:
					_characterControl.setAttackEnd();
					this.resetSkillParams();
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.SKILL10:
					if(_skill10Count >= 6){
						this.setAction(ActionState.SKILLOVER10);
					}else{
						this.setAction(ActionState.SKILL10, true);
					}
					break;
				case ActionState.SKILLOVER10:
					_characterControl.setAttackEnd();
					this.resetSkillParams();
					this.setAction(ActionState.WAIT);
					this._skill10Count = 0;
					break;
				//死亡
				case ActionState.DEAD:
				case ActionState.GROUNDDEAD:
					this.dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_DEAD_EVENT));
					break;
				default : 
					this.setAction(this.curAction, true);
					this.standJudge();
					_kuangWuStandCount = 0;
					break;
			}
		}
		
		override public function releaseBuring() : void{
			if(charData.angerCount >= 10 * 10 && !charData.startAngerDown){
				charData.addBuff(BuffType.BUFF_SPEED, NumberConst.getIns().kuangWuSpeedRate, true);
				charData.addBuff(BuffType.BUFF_CRIT, NumberConst.getIns().kuangWuCritRate, true);
				charData.addOnlyHurt(10 * 2 * 30);
				charData.startAngerDown = true;
				initBuringEffect();
			}
		}
		
		override protected function comboJudge():void{
			super.comboJudge();
		}
		
		override public function step():void{
			super.step();
			if(airHitTime > 0){
				airHitTime--;
			}
			if(runHitTime > 0){
				runHitTime--;
			}
		}
		
		override public function destroy():void{
			this.tq = null;
			
			super.destroy();
		}
		
	}
}