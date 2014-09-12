package com.test.game.Entitys.Monsters
{
	import com.superkaka.game.Base.BaseSequenceBmdAction;
	import com.superkaka.game.Const.ActionState;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Const.CharacterType;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Utils.SkillUtils;
	
	public class TanDeWuYanEntity extends BaseMonsterEntity
	{
		public function TanDeWuYanEntity(charVo:CharacterVo, hasMainAI:Boolean=true)
		{
			super(charVo, hasMainAI);
		}
		
		override protected function createCollisionRect() : void{
			tq = new TestQuad(70, 120);
			tq.x = -tq.width/2;
			tq.y = -tq.height/2;
			tq.visible = false;
			this.bodyAction.addChild(tq);
			this.collisionBody = this.tq;
		}
		
		public function replaceAssets(index:String) : void{
			bodyAction.scaleXValue = 1;
			bodyAction.scaleYValue = 1;
			bodyAction.replaceAssets(0, "TanDeWuYan_" + index);
			bodyAction.scaleXValue = 1.1;
			bodyAction.scaleYValue = 1.1;
		}
		
		override public function setAction(actionState:uint,resetWhenSameAction:Boolean = false):void{
			if(actionState == ActionState.SKILL3){
				var seq:BaseSequenceBmdAction = bodyAction.getActionByIndex(0);
				if(seq.bmdName.indexOf("01") != -1){
					replaceAssets("02");
				}
			}
			super.setAction(actionState,resetWhenSameAction);
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT1:
					checkFrameCommon(keyFrame, 1);
					//hitType = 0;
					break;
				case ActionState.SKILL1:
				case ActionState.SKILL2:
				case ActionState.SKILL3:
				case ActionState.SKILL4:
				case ActionState.SKILL5:
					checkFrameSKill(keyFrame, this.curAction);
					//hitType = 1;
					break;
				case ActionState.DEAD:
					if(this.mainAi != null){
						this.mainAi.lock();
						charVo.useProperty.hp = 0;
						changeHp(0);
					}
					break;
				case ActionState.GROUNDDEAD:
					if(this.mainAi != null){
						this.mainAi.lock();
						charVo.useProperty.hp = 0;
						changeHp(0);
					}
					if(keyFrame < 6){
						groundDeadMove();
					}
					break;
			}
		}
		
		override protected function doWhenActionOver(...args) : void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT1:
					resetSkillParams();
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.SKILL1:
				case ActionState.SKILL2:
				case ActionState.SKILL3:
				case ActionState.SKILL4:
				case ActionState.SKILL5:
					_characterControl.setAttackEnd();
					this.resetSkillParams();
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.HURT:
					unMoveHurt();
					isAirHurt();
					resetSkillParams();
					break;
				case ActionState.DEAD:
				case ActionState.GROUNDDEAD:
					this.dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_DEAD_EVENT));
					//this.destroy();
					break;
				case ActionState.FALL:
					isAirHurt();
					if(curRenderIndex == 30){
						standUp();
						unMoveHurt();
						resetSkillParams();
					}
					break;
				default:
					if(this.curAction == ActionState.NONE)
						this.setAction(ActionState.WAIT);
					this.setAction(this.curAction, true);
					resetShadow();
					break;
			}
		}
		
		override public function hurtBy(ih:IHurtAble):void{
			if((this.isDead() && this.charVo.characterType != CharacterType.BOSS_MONSTER && this.charVo.characterType != CharacterType.ELITE_BOSS_MONSTER && !this.characterControl.jumpStatus)
				|| this.isFallDownSkill(ih)
				|| this.isDead() && (this.charVo.characterType == CharacterType.BOSS_MONSTER || this.charVo.characterType == CharacterType.ELITE_BOSS_MONSTER)){
				return;
			}else{
				var attackId:int = ih.getAttackId();
				if(beAttackedIdVec.indexOf(attackId) == -1){
					beAttackedIdVec.push(attackId);
					if(this.isYourFather()){
						EffectManager.getIns().createInvincible(this);
					}else{
						var skill:SkillEntity = ih as SkillEntity;
						if(!SkillUtils.dodgeJudge(skill, this) || skill.skillConfiguration.chaos_hurt != 0){
							if(skill.hitName.indexOf("XiaoHuoMoSkill1_2") != -1){
								charVo.removeOneBuff();
							}
							_characterControl.hurtJudge(ih);
						}else{
							EffectManager.getIns().createEvasion(pos);
						}
					}
				}
			}
			blockJudge(ih as SkillEntity);
		}
		
		override public function step():void{
			super.step();
			statusChange();
		}
		
		private function statusChange() : void{
			if(charData != null){
				if(charData.buffStatus.length == 0 && curAction != ActionState.SKILL3){
					var seq:BaseSequenceBmdAction = bodyAction.getActionByIndex(0);
					if(seq.bmdName.indexOf("02") != -1){
						replaceAssets("01");
					}
				}
			}
		}
	}
}