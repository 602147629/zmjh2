package com.test.game.Entitys{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Manager.Keyboard.KeyboardInput;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.CharacterType;
	import com.test.game.Const.OccupationConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.BloodBar;
	import com.test.game.Entitys.Conjure.ConjureEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.AutoFightManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.StoryManager;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Manager.Enemy.EnemyManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Data.SkillConfigurationVo;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.ConjureVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.character.AutoFightControl;
	import com.test.game.UI.PlayerNameTip;
	import com.test.game.Utils.SkillUtils;
	import com.test.game.cartoon.BuringCartoon;

	public class PlayerEntity extends CharacterEntity{
		
		private var _anti:Antiwear;
		private var _player:PlayerVo;//用户数据
		private var _keyBoard:KeyboardInput;
		private var _standCount:int;//待机
		protected var useBlur:Boolean;
		private var _buringEffectFront:BaseSequenceActionBind;
		private var _buringEffectBack:BaseSequenceActionBind;
		private var _autoFightEffect:BaseSequenceActionBind;
		private var _titleEffect:BaseSequenceActionBind;
		
		//手动控制技能移动
		public var skillMove:uint;
		public var comboTime:int;
		public var commonHitFace:uint = DirectConst.DIRECT_NONE;
		public var playerName:String;
		public var playerNameTip:PlayerNameTip;
		
		private var _mainCon:ConjureEntity;
		private var _minorCon:ConjureEntity;
		private var _conjureInfo:Object;
		public var autoFightControl:AutoFightControl;
		public var showBloorBar:Boolean = false;
		private var _bloodBar:BloodBar;
		
		public function PlayerEntity(charVo:CharacterVo){
			super(charVo);
			
			this.isRectCollision = true;
			this.collisionIndex = CollisionFilterIndexConst.PLAYER;
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["allHurtCount"] = 0;
		}
		
		override public function setAction(actionState:uint,resetWhenSameAction:Boolean = false):void{
			super.setAction(actionState,resetWhenSameAction);
		}
		
		//技能冷却时间判断
		public function skillColdTimeJudge(actionState:uint):Boolean{
			return charVo.skillColdTimeJudge(actionState);
		}
		
		//技能消耗mp判断
		public function skillMpJudge(actionState:uint) : Boolean{
			return charVo.skillMpJudge(actionState);
		}
		
		//技能随时释放
		public function skillReleaseJudge(actionState:uint) : Boolean{
			return charVo.skillReleaseJudge(actionState);
		}
		
		override protected function initParams():void{
			super.initParams();
		}
		
		private function initTitle() : void{
			if(this.charVo.characterType == CharacterType.PLAYER
				&& player.titleInfo != null 
				&& player.titleInfo.titleNow != -1
				&& player.titleInfo.titleShow == 1){
				_titleEffect = AnimationEffect.createAnimation(10030, ["Title_" + (player.titleInfo.titleNow - 7500)], false);
				this.addChild(_titleEffect);
			}
		}
		
		public function initBlood():void{
			_bloodBar = new BloodBar(this.bodyAction, -30, -90);
			showBloorBar = true;
			
		}
		
		public function initBuringEffect():void{
			SoundManager.getIns().fightSoundPlayer("ReleaseSkillSound");
			judgeBuringStatus();
			judgeFallDownStatus();
			SceneManager.getIns().slowDown();
			if(_player.occupation == OccupationConst.KUANGWU){
				SkillManager.getIns().createSkill(this, 60);
			}else if(_player.occupation == OccupationConst.XIAOYAO){
				SkillManager.getIns().createSkill(this, 61);
			}
			_buringEffectFront = AnimationEffect.createAnimation(10007, ["PlayerBuringFront"], false,
				function () : void{
					AnimationManager.getIns().removeEntity(_buringEffectFront);
					_buringEffectFront.destroy();
					_buringEffectFront = null;
				});
			this.addChild(_buringEffectFront);
			RenderEntityManager.getIns().removeEntity(_buringEffectFront);
			AnimationManager.getIns().addEntity(_buringEffectFront);
			
			_buringEffectBack = AnimationEffect.createAnimation(10013, ["PlayerBuringBack"], false,
				function () : void{
					AnimationManager.getIns().removeEntity(_buringEffectBack);
					_buringEffectBack.destroy();
					_buringEffectBack = null;
				});
			this.addChildAt(_buringEffectBack, 0);
			RenderEntityManager.getIns().removeEntity(_buringEffectBack);
			AnimationManager.getIns().addEntity(_buringEffectBack);
			
			var buring:BuringCartoon = new BuringCartoon(playerName);
		}
		
		private function initAutoFightEffect() : void{
			_autoFightEffect = AnimationEffect.createAnimation(10025, ["AutoFightEffect"], false);
			RenderEntityManager.getIns().removeEntity(_autoFightEffect);
		}
		
		public function setAutoFightStatus(value:Boolean) : void{
			if(_autoFightEffect == null){
				initAutoFightEffect();
			}
			characterJudge.isUseAutoFight = value;
			if(value){
				this.addChild(_autoFightEffect);
				RenderEntityManager.getIns().addEntity(_autoFightEffect);
			}else{
				if(_autoFightEffect.parent != null){
					_autoFightEffect.parent.removeChild(_autoFightEffect);
				}
				RenderEntityManager.getIns().removeEntity(_autoFightEffect);
			}
		}
		
		
		//空中释放无双
		private function judgeBuringStatus() : void{
			if(this.bodyAction.y < 0){
				characterControl.buringJump();
				characterJudge.isUnMoveStatus = false;
				characterJudge.unMoveTime = 0;
				characterJudge.isLock = false;
			}
		}
		//地面释放无双
		private function judgeFallDownStatus() : void{
			if(this.curAction == ActionState.FALL){
				setAction(ActionState.WAIT);
				characterJudge.isUnMoveStatus = false;
				characterJudge.unMoveTime = 0;
				characterJudge.isLock = false;
			}
		}
		
		protected function judgeSkillFallDownStatus() : void{
			if(this.bodyAction.y < 0){
				characterControl.resetJump();
			}
			characterJudge.isUnMoveStatus = false;
			characterJudge.unMoveTime = 0;
			characterJudge.isLock = false;
		}
		
		public function initPlayerParams(conjureLv:int) : void{
			initConjure(conjureLv);
			initSkillParams();
			initTitle();
		}
		
		public function initPlayerName(name:String, type:int) : void{
			playerNameTip = new PlayerNameTip(name, type);
			playerNameTip.y = -70;
			this.bodyAction.addChild(playerNameTip);
		}
		
		private function initConjure(conjureLv:int):void{
			if(_player.assistInfo == -1)	return;
			var obj:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SPECIAL, "id", _player.assistInfo);
			_conjureInfo = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.BOSS, "id", obj.bid);
			var last:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.ENEMY, "ID", _conjureInfo.sid);
			_mainCon = RoleManager.getIns().createConjure(EnemyManager.getIns().getEnemyData(last.ID), conjureLv, this);
			_mainCon.setAction(ActionState.WALK);
			
			if(last.ID == 2209){
				_minorCon = RoleManager.getIns().createConjure(EnemyManager.getIns().getEnemyData(2219), conjureLv, this);
				_minorCon.setAction(ActionState.WALK);
			}
		}
		
		private function initSkillParams() : void{
			var obj:Object = SkillManager.getIns().getPlayerConfigurationData(_player.occupation);
			charVo.skillConfigurationVo = new SkillConfigurationVo();
			charVo.skillConfigurationVo.assginPlayerData(obj, _player);
		}
		
		protected function checkFrameSKill(keyFrame:int, skillID:int, reset:Boolean = false) : void{
			var count:int = skillID - ActionState.SKILLBASE - 1;
			if(charVo.checkFrameSKill(keyFrame, count, skillID)){
				this.releaseSkill(count, reset);
			}
		}
		
		override public function step():void{
			super.step();
			blurShow();
			charVo.step();
			autoFightStep();
			hpChange();
			titleStep();
		}
		
		private function titleStep() : void{
			if(_titleEffect != null){
				_titleEffect.y = -60 + this.bodyAction.y;
			}
		}
		
		private function hpChange():void{
			if(showBloorBar && _bloodBar != null){
				_bloodBar.changeBar(charVo.useProperty.hp / charVo.totalProperty.hp);
			}
		}
		
		private function autoFightStep() : void{
			if(autoFightControl != null){
				autoFightControl.step();
			}
		}
		
		override public function hurtBy(ih:IHurtAble):void{
			if(this.isDead() || this.isYourFather() || this.isFallDownSkill(ih) || StoryManager.getIns().isStoryStart){
				return;
			}else{
				var attackId:int = ih.getAttackId();
				if(beAttackedIdVec.indexOf(attackId) == -1){
					this.beAttackedIdVec.push(attackId);
					if(this.isYourFather()){
						EffectManager.getIns().createInvincible(this);
					}else{
						AutoFightManager.getIns().playerReset();
						var skill:SkillEntity = ih as SkillEntity;
						if(skill.isHurt){
							//闪避判断
							if(!SkillUtils.dodgeJudge(skill, this) || skill.skillConfiguration.chaos_hurt != 0){
								_characterControl.hurtJudge(ih);
							}else{
								EffectManager.getIns().createEvasion(pos);
							}
						}
					}
				}
			}
			blockJudge(ih as SkillEntity);
		}
		
		private var blurStep:int;
		//残影特效
		private function blurShow() : void{
			if(useBlur || charVo.startAngerDown){
				blurStep++;
				if(blurStep % 2 != 0) return;
				EffectManager.getIns().createBlurEffect(this.bodyAction, bodyPos);
			}
		}
		
		protected function groundDeadMove():void{
			if(this.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
				this.x += this.speedX;
			}else if(this.faceHorizontalDirect == DirectConst.DIRECT_RIGHT){
				this.x -= this.speedY;
			}
		}
		
		override public function moveLeft() : void{
			if(characterJudge.isTemptation || characterJudge.isUnMoveStatus || (curAction == ActionState.HURT && characterControl.jumpStatus)) return;
			_characterControl.moveLeft();
		}
		
		override public function moveRight() : void{
			if(characterJudge.isTemptation || characterJudge.isUnMoveStatus || (curAction == ActionState.HURT && characterControl.jumpStatus)) return;
			_characterControl.moveRight();
		}
		
		override public function moveUp() : void{
			if(characterJudge.isTemptation || characterJudge.isUnMoveStatus || (curAction == ActionState.HURT && characterControl.jumpStatus)) return;
			_characterControl.moveUp();
		}
		
		override public function moveDown() : void{
			if(characterJudge.isTemptation || characterJudge.isUnMoveStatus || (curAction == ActionState.HURT && characterControl.jumpStatus)) return;
			_characterControl.moveDown();
		}
		
		override public function jump() : void{
			comboTime = 0;
			super.jump();
		}
		
		private function commonHitSound() : void{
			SoundManager.getIns().fightSoundPlayer(playerName + "HitSound");
		}
		
		protected function jumpPressHitSound() : void{
			SoundManager.getIns().fightSoundPlayer("JumpPressHitSound");
		}
		
		//普通攻击
		protected function releaseCommonHit(count:int) : void{
			SkillManager.getIns().createSkill(this, charVo.skillConfigurationVo.commonHit[count - 1]);
			commonHitSound();
		}
		
		//压制
		protected function releaseJumpPressHit(count:int) : void{
			characterControl.setAttackStart();
			SkillManager.getIns().createSkill(this, charVo.skillConfigurationVo.jumpPressHit[count - 1]);
			if(count == 2){
				jumpPressHitSound();
			}
		}
		
		//空中普通攻击
		protected function releaseJumpHit() : void{
			characterControl.setAttackStart();
			SkillManager.getIns().createSkill(this, charVo.skillConfigurationVo.jumpHit[0]);
			commonHitSound();
		}
		
		//前冲
		protected function releaseRunHit() : void{
			SkillManager.getIns().createSkill(this, charVo.skillConfigurationVo.runHit[0]);
			SoundManager.getIns().fightSoundPlayer("RunHitSound");
		}
		
		//释放技能
		protected function releaseSkill(skillID:int, reset:Boolean = false) : void{
			if(charVo.skillConfigurationVo.skillCountList[skillID] == 0) {
				setSkillColdTime();
				characterControl.setAttackStart();
				//技能是否无敌
				charVo.checkInvincible(skillID);
				//技能是否霸体
				charVo.checkOnlyHurt(skillID);
				if(charVo.checkReleaseSkill(skillID)){
					judgeSkillFallDownStatus();
				}
			}
			
			if(reset)	charVo.skillConfigurationVo.skillCountList[skillID] = 0;
			SkillManager.getIns().createSkill(this, charVo.skillConfigurationVo.skillList[skillID][charVo.skillConfigurationVo.skillCountList[skillID]]);
			charVo.skillConfigurationVo.skillCountList[skillID]++;
		}
		
		//设置技能冷却时间和元气消耗
		public function setSkillColdTime() : void{
			var count:int = this.curAction - ActionState.SKILLBASE - 1;
			count = (count >= 10?count-10:count);
			charVo.setSkillColdDown(count);
		}
		
		protected function resetSkillParams(setColdTime:Boolean = true) : void{
			charVo.resetSkillParams();
		}
		
		public function releaseBuring() : void{
			
		}
		
		public function releaseBossSkill() : void{
			if(_player.assistInfo == -1)	return;
			if(charVo.bossCount >= _conjureInfo.skill_energy * 5 * 5 && _mainCon.curAction != ActionState.SKILL1 && _mainCon.curAction != ActionState.SKILL2 && _mainCon.curAction != ActionState.SKILL3 && _mainCon.curAction != ActionState.WAIT){
				mainConSetting();
				minorConSetting();
				charVo.bossCount -= _conjureInfo.skill_energy * 5 * 5;
			}
		}
		
		private function mainConSetting() : void{
			//风流道人
			if((_mainCon.charData as ConjureVo).ID == 2106){
				_mainCon.x = pos.x;
			}else{
				_mainCon.x = pos.x - 75 + this.faceHorizontalDirect * 150;
			}
			//痴男
			if((_mainCon.charData as ConjureVo).ID == 2209){
				_mainCon.y = pos.y - 50;
			}else{
				_mainCon.y = pos.y;
			}
			_mainCon.faceHorizontalDirect = this.faceHorizontalDirect;
			_mainCon.setAction(ActionState.WAIT);
			RoleManager.getIns().addConjure(_mainCon);
		}
		
		private function minorConSetting() : void{
			if(_minorCon != null){
				var face:int = (this.faceHorizontalDirect == DirectConst.DIRECT_LEFT?-1:1);
				_minorCon.x = pos.x + face * 65;
				_minorCon.y = pos.y + 50;
				_minorCon.faceHorizontalDirect = this.faceHorizontalDirect;
				_minorCon.setAction(ActionState.WAIT);
				RoleManager.getIns().addConjure(_minorCon);
			}
		}
		
		//怪物僵直判断
		override protected function unMoveHurt() : void
		{
			charVo.characterJudge.unMoveTime--;
			//空中僵直
			if(this.bodyAction.y != 0){
				if(this.characterControl.isJumpDown){
					this.setAction(ActionState.HURTDOWN);
				}else{
					this.setAction(ActionState.HURT);
				}
				if(charVo.characterJudge.unMoveTime <= 0){
					characterJudge.isUnMoveStatus = false;
				}
				this.characterControl.jumpStatus = true;
			}
			//地面僵直
			else{
				if(charVo.characterJudge.unMoveTime <= 0){
					this.setAction(ActionState.WAIT);
					this.isLock = false;
					characterJudge.isUnMoveStatus = false;
				}else{
					this.setAction(ActionState.HURT);
				}
			}
		}
		
		//角色待机动作效果
		protected function standJudge() : void{
			if(this.curAction == ActionState.WAIT){
				_standCount++;
				if(_standCount > 5){
					this.setAction(ActionState.STAND);
					_standCount = 0;
				}
			}
		}
		
		//连击判断
		protected function comboJudge():void{
			if(this.curAction != ActionState.HIT1 && this.curAction != ActionState.HIT2 && this.curAction != ActionState.HIT3){
				this.comboTime = 0;
			}else{
				commonHitOver();
			}
		}
		
		public function relive() : void{
			charVo.relive();
			setAction(ActionState.WAIT);
			isLock = false;
			SkillManager.getIns().createSkill(this, 59);
		}
		
		
		private function commonHitOver() : void{
			faceHorizontalDirect = commonHitFace;
			moveHorizontalDirect = commonHitFace;
		}
		
		override public function destroy():void{
			if(_buringEffectFront != null){
				_buringEffectFront.destroy();
				_buringEffectFront = null;
			}
			if(_buringEffectBack != null){
				_buringEffectBack.destroy();
				_buringEffectBack = null;
			}
			if(_autoFightEffect != null){
				_autoFightEffect.destroy();
				_autoFightEffect = null;
			}
			if(_titleEffect != null){
				_titleEffect.destroy();
				_titleEffect = null;
			}
			if(this._keyBoard){
				this._keyBoard.destroy();
			}
			this._keyBoard = null;
			this._player = null;
			if(_mainCon){
				_mainCon.destroy();
				_mainCon = null;
			}
			if(_minorCon){
				_minorCon.destroy();
				_minorCon = null;
			}
			if(playerNameTip != null){
				playerNameTip.destroy();
				playerNameTip = null;
			}
			if(this._bloodBar){
				this._bloodBar.destroy();
				this._bloodBar = null
			}
			
			super.destroy();
		}

		public function get player():PlayerVo{
			return _player;
		}

		public function set player(value:PlayerVo):void{
			_player = value;
		}

		public function get keyBoard():KeyboardInput{
			return _keyBoard;
		}

		public function set keyBoard(value:KeyboardInput):void{
			_keyBoard = value;
		}
		
		public function get mainConjure() : ConjureEntity{
			return _mainCon;
		}
		public function set mainConjure(value:ConjureEntity) : void{
			_mainCon = value;
		}
		public function get minorConjure() : ConjureEntity{
			return _minorCon;
		}
		public function set minorConjure(value:ConjureEntity) : void{
			_minorCon = value;
		}
	}
}