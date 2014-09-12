package com.test.game.Entitys{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Const.CharacterType;
	import com.test.game.Const.DebugConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Entitys.Ai.BaseMainAi;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Data.SkillConfigurationVo;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.EnemyVo;
	import com.test.game.Mvc.control.character.CharacterMoveControl;
	import com.test.game.Utils.SkillUtils;

	public class MonsterEntity extends CharacterEntity{
		public var hitType:uint = 0;
		public var hasAppearEffect:Boolean = true;
		//怪物AI
		protected var _aiObj:Object;
		protected var _mainAi:BaseMainAi;
		protected var _isInRange:Boolean;
		private var _nowCount:int;
		private var _addStep:int = 0;
		private var _hasMainAI:Boolean = true;
		
		public function MonsterEntity(charVo:CharacterVo, hasMainAI:Boolean){
			this._aiObj = com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData((charVo as EnemyVo).ai));
			_hasMainAI = hasMainAI;
			super(charVo);
			this.isRectCollision = true;
			this.collisionIndex = CollisionFilterIndexConst.MONSTER;
			this.collisionListeners = [CollisionFilterIndexConst.PLAYER_SKILL, CollisionFilterIndexConst.ALL_SKILL];
		}
		
		override protected function initParams():void{
			super.initParams();
			
			//角色移动控制
			this._characterControl = new CharacterMoveControl(this);
			if(_hasMainAI){
				this._mainAi = new BaseMainAi(this, _aiObj);
			}
			initSkillParams();
		}
		
		private function initSkillParams():void{
			var obj:Object = SkillManager.getIns().getEnemyConfigurationData((charVo as EnemyVo).ID);
			charVo.skillConfigurationVo = new SkillConfigurationVo();
			charVo.skillConfigurationVo.assginMonsterData(obj);
		}
		
		protected function releaseCommonHit(count:int) : void{
			var allCount:Array = charVo.skillConfigurationVo.commonList[count].split("_");
			for(var i:int = 0; i < allCount.length; i++){
				SkillManager.getIns().createSkill(this, allCount[i]);
			}
			//SkillManager.getIns().createSkill(this, charVo.skillConfigurationVo.commonList[count]);
		}
		
		protected function checkFrameCommon(keyFrame:int, count:int) : void{
			if(keyFrame == 1){
				charVo.checkCommonOnlyHurt(count - 1);
			}
			for(var i:int = 0; i < charVo.skillConfigurationVo.commonFrameList.length; i++){
				if(keyFrame == charVo.skillConfigurationVo.commonFrameList[i]){
					this.releaseCommonHit(i);
				}
			}
		}
		
		protected function checkFrameSKill(keyFrame:int, skillID:int, reset:Boolean = false) : void{
			var count:int = skillID - ActionState.SKILLBASE - 1;
			_nowCount = count;
			//跳跃技能
			if(charVo.skillConfigurationVo.jumpSkillList[count] != 0){
				bodyAction.y = -charVo.skillConfigurationVo.jumpSkillList[count];
			}
			//空中斩下
			if(charVo.skillConfigurationVo.rollSkillList[count].length > 1 && keyFrame == 1){
				charVo.characterJudge.isRollStatus = true;
			}
			if(keyFrame == 1){
				charVo.checkOnlyHurt(count);
			}
			if(charVo.checkFrameSKill(keyFrame, count, skillID)){
				this.releaseSkill(count, reset);
			}
		}
		
		protected function releaseSkill(count:int, reset:Boolean = false) : void{
			if(charVo.skillConfigurationVo.skillCountList[count] == 0) {
				characterControl.setAttackStart();
				//技能是否无敌
				charVo.checkInvincible(count);
				//技能是否霸体
				//charVo.checkOnlyHurt(skillID);
			}
			
			if(charVo.skillConfigurationVo.skillList[count][charVo.skillConfigurationVo.skillCountList[count]] == null){
				DebugArea.getIns().showInfo("---" + charVo.name + "技能" + (count + 1) + "出现问题, 该技能计数到" + charVo.skillConfigurationVo.skillCountList[count] + "---", DebugConst.ERROR);
			}else{
				var allCount:Array = charVo.skillConfigurationVo.skillList[count][charVo.skillConfigurationVo.skillCountList[count]].split("_");
				for(var i:int = 0; i < allCount.length; i++){
					SkillManager.getIns().createSkill(this, allCount[i]);
				}
				if(charVo.skillConfigurationVo.skillCountList[count] < charVo.skillConfigurationVo.skillList[count].length){
					charVo.skillConfigurationVo.skillCountList[count]++;
				}
			}
		}
		
		protected function resetSkillParams(setColdTime:Boolean = true) : void{
			charVo.skillConfigurationVo.skillCountList = [0, 0, 0, 0, 0];
			//跳跃技能
			if(bodyAction.y < 0 && this.curAction != ActionState.HURT && charVo.skillConfigurationVo.jumpSkillList[_nowCount] != 0){
				characterControl.jumpStatus = true;
				characterControl.handJump = true;
			}
		}
		
		override public function step() : void{
			super.step();
			charVo.step();
			addStep();
			if(_mainAi != null){
				_mainAi.step();
			}
		}
		
		private function createAppear() : void{
			var appear:BaseSequenceActionBind = AnimationEffect.createAnimation(10016, ["MonsterAppear"], false, 
				function () : void{
					isLock = false;
					AnimationManager.getIns().removeEntity(appear);
					appear.destroy();
					appear = null;
				});
			appear.x = 0;
			appear.y = 15;
			this.addChild(appear);
			RenderEntityManager.getIns().removeEntity(appear);
			AnimationManager.getIns().addEntity(appear);
		}
		
		private function addStep():void{
			if(hasAppearEffect){
				if(_addStep < 5){
					_addStep++;
					if(_addStep == 1){
						createAppear();
					}
					if(_addStep == 5){
						SceneManager.getIns().nowScene.addChild(this);
					}
				}
			}else{
				if(_addStep < 1){
					_addStep++;
					if(_addStep == 1){
						SceneManager.getIns().nowScene.addChild(this);
					}
				}
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
							_characterControl.hurtJudge(ih);
						}else{
							EffectManager.getIns().createEvasion(pos);
						}
					}
				}
			}
			blockJudge(ih as SkillEntity);
		}
		
		override public function moveLeft() : void
		{
			if(canActivite() || characterJudge.isTemptation) return;
			if(!_isInRange)
				this.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
			setAction(ActionState.WALK);
			_characterControl.moveLeft();
		}
		
		override public function moveRight() : void
		{
			if(canActivite() || characterJudge.isTemptation) return;
			if(!_isInRange)
				this.faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
			setAction(ActionState.WALK);
			_characterControl.moveRight();
		}
		
		override public function moveUp() : void
		{
			if(canActivite() || characterJudge.isTemptation) return;
			setAction(ActionState.WALK);
			_characterControl.moveUp();
		}
		
		override public function moveDown() : void
		{
			if(canActivite() || characterJudge.isTemptation) return;
			setAction(ActionState.WALK);
			_characterControl.moveDown();
		}
		
		private function canActivite() : Boolean{
			var result:Boolean = false;
			if(isLock
				||this.curAction == ActionState.DEAD
				||this.curAction == ActionState.GROUNDDEAD
				||this.curAction == ActionState.HURT
				||this.curAction == ActionState.FALL
				||this.curAction == ActionState.HURTDOWN
				||this.curAction == ActionState.SKILL1
				||this.curAction == ActionState.SKILL2
				||this.curAction == ActionState.SKILL3
				||this.curAction == ActionState.SKILL4
				||this.curAction == ActionState.SKILL5){
				result = true;
			}
			return result;
		}
		
		override public function jump():void{
			if(isLock) return;
			super.jump();
		}
		
		override public function set isLock(value:Boolean) : void{
			charVo.characterJudge.isLock = value;
			if(this._mainAi != null){
				if(charVo.characterJudge.isLock){
					this._mainAi.lock();
				}else{
					this._mainAi.unLock();
				}
			}
		}
		
		override public function destroy():void{
			_aiObj = null;
			if(this._mainAi != null){
				this._mainAi.destroy();
				this._mainAi = null;
			}
			
			super.destroy();
		}
		
		public function get isInRange() : Boolean{
			return _isInRange;
		}
		public function set isInRange(value:Boolean) : void
		{
			_isInRange = value;
		}
		
		public function get mainAi() : BaseMainAi{
			return _mainAi;
		}
		
		/*public function get enemyData() : Object{
			return _enemyData;
		}*/
	}
}