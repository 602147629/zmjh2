package com.test.game.Entitys.Monsters{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.test.game.AgreeMent.Battle.IBeHurtAble;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Const.CharacterType;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.BloodBar;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.EnemyVo;
	
	public class BaseMonsterEntity extends MonsterEntity{
		protected var tq:TestQuad;
		private var _bloodBar:BloodBar;
		private var _bossEffectBack:BaseSequenceActionBind;
		private var _bossEffectFront:BaseSequenceActionBind;
		public function BaseMonsterEntity(charVo:CharacterVo, hasMainAI:Boolean = true){
			super(charVo, hasMainAI);
		}
		
		override protected function initSequenceAction():void{
			this.bodyAction = new BaseSequenceActionBind(this.charVo);
			this.bodyAction.setAction(ActionState.WAIT);
			
			super.initSequenceAction();
			
			createCollisionRect();
		}
		
		protected function createCollisionRect() : void{
			tq = new TestQuad();
			tq.x = -tq.width/2;
			tq.y = -tq.height/2;
			tq.visible = false;
			this.bodyAction.addChild(tq);
			this.collisionBody = this.tq;
		}
		
		private function initBossEffect() : void{
			if(this.charVo.characterType == CharacterType.BOSS_MONSTER
				|| this.charVo.characterType == CharacterType.ELITE_BOSS_MONSTER
				|| this.charVo.characterType == CharacterType.HERO_MONSTER
				|| this.charVo.characterType == CharacterType.SPECIAL_BOSS_MONSTER){
				_bossEffectBack = AnimationEffect.createAnimation(10006, ["BossEffectBack"], false);
				_bossEffectBack.y = 80;
				this.addChildAt(_bossEffectBack, 1);
				_bossEffectFront = AnimationEffect.createAnimation(10006, ["BossEffectFront"], false);
				_bossEffectFront.y = 80;
				this.addChild(_bossEffectFront);
			}
		}
		
		protected function resetShadow():void{
			if(this.charVo.characterType == CharacterType.BOSS_MONSTER
				|| this.charVo.characterType == CharacterType.ELITE_BOSS_MONSTER
				|| this.charVo.characterType == CharacterType.HERO_MONSTER
				|| this.charVo.characterType == CharacterType.SPECIAL_BOSS_MONSTER){
				if(this.bodyAction.scaleXValue != 1.1){
					this.bodyAction.scaleXValue = 1.1;
					this.bodyAction.scaleYValue = 1.1;
				}
				_bossEffectFront.y = _bossEffectBack.y = shadow.y = bodyAction.height * .45 * 1.1;
			}else{
				if(this.curAction == ActionState.WAIT 
					|| this.curAction == ActionState.WALK){
					shadow.y = bodyAction.height * .35;
				}
			}
		}
		
		private function initBlood():void{
			if(this.charVo.characterType == CharacterType.NORMAL_MONSTER
				|| this.charVo.characterType == CharacterType.ELITE_MONSTER){
				_bloodBar = new BloodBar(this.bodyAction);
			}
		}
		
		//调节色相
		private function initHue() : void{
			if(this.charVo.characterType == CharacterType.ELITE_MONSTER){
				this.bodyAction.getActionByIndex(0).hue = (charVo as EnemyVo).hue;
			}
		}
		
		override protected function initParams():void{
			super.initParams();
			
			initBossEffect();
			initHue();
			initBlood();
		}
		
		override protected function initShadow():void{
			super.initShadow();
		}
		
		override public function setAction(actionState:uint,resetWhenSameAction:Boolean = false):void{
			if(actionState == ActionState.SKILL1){
				resetSkillParams();
			}
			super.setAction(actionState,resetWhenSameAction);
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
		
		protected function groundDeadMove():void{
			if(this.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
				this.x += this.speedX;
			}else if(this.faceHorizontalDirect == DirectConst.DIRECT_RIGHT){
				this.x -= this.speedY;
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
					//resetShadow();
					break;
			}
		}
		
		/**
		 * 是否在空中被打到
		 * 
		 */		
		protected function isAirHurt():void{
			if(this.bodyAction.y < 0){
				this.characterControl.jumpStatus = true;
			}
		}
		
		override public function step():void{
			super.step();
			HpChange();
			resetShadow();
		}
		
		private function HpChange():void{
			if(this.charVo.characterType == CharacterType.NORMAL_MONSTER || this.charVo.characterType == CharacterType.ELITE_MONSTER){
				_bloodBar.changeBar(charVo.useProperty.hp / charVo.totalProperty.hp);
			}
		}
		
		override public function attackTarget(value:IBeHurtAble):void{
			super.attackTarget(value);
			
			this.setAction(ActionState.SKILL1);
		}
		
		override public function destroy():void{
			if(this.tq){
				this.tq.destroy();
				this.tq = null;
			}
			if(this._bloodBar){
				this._bloodBar.destroy();
				this._bloodBar = null
			}
			if(this._bossEffectBack){
				this._bossEffectBack.destroy();
				this._bossEffectBack = null;
			}
			if(this._bossEffectFront){
				this._bossEffectFront.destroy();
				this._bossEffectFront = null;
			}
			
			super.destroy();
		}
		
		public function hideBloodBar() : void{
			_bloodBar.hide();
		}
		
		public function showBloodBar() : void{
			_bloodBar.show();
		}
	}
}