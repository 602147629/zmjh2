package com.test.game.Entitys{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.test.game.AgreeMent.Battle.IAttackAble;
	import com.test.game.AgreeMent.Battle.IBeHurtAble;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Const.GlowFilterConst;
	import com.test.game.Const.OccupationConst;
	import com.test.game.Const.SkillType;
	import com.test.game.Entitys.Judge.CharacterJudge;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Entitys.Test.StationShow;
	import com.test.game.Manager.DigitalManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.SpeedVo;
	import com.test.game.Mvc.control.character.CharacterMoveControl;
	
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	

	public class CharacterEntity extends SequenceActionEntity implements IAttackAble,IBeHurtAble{
		private var _beAttackedIdVec:Vector.<int>;//被攻击过的id数组(防止重复攻击用)
		private var _lastBeHurtSource:IHurtAble;//最后一次被攻击的伤害来源
		
		public var shadow:BaseNativeEntity;
		public var initBodyContainerY:Number;//初始化后body的y坐标
		public var stationList:Vector.<StationShow>;
		public var stationRect:StationShow;
		
		protected var charVo:CharacterVo;//数据
		//角色操作控制
		protected var _characterControl:CharacterMoveControl;
		
		private var _nowGlowFilterIndex:uint;
		public function CharacterEntity(charVo:CharacterVo){
			this.charVo = charVo;
			this._beAttackedIdVec = new Vector.<int>();
			super();
			
			initParams();
		}
		
		protected function initParams():void{
			
		}
		
		override protected function initSequenceAction():void{
			super.initSequenceAction();
			
			//打印中心点
			//this.bodyAction.isDrawCenter = true;
			this.initBodyContainerY = this.bodyAction.y;
		}
		
		override protected function initCallBack():void{
			super.initCallBack();
			
			this.initShadow();
			//this.initRect();
		}
		
		private function initRect() : void
		{
			stationRect = new StationShow(60, 20);
			stationRect.data.x = -stationRect.width/2;
			stationRect.data.y = -stationRect.height/2;
			stationRect.y = 50;
			stationRect.visible = false;
			this.bodyAction.addChild(stationRect);
		}
		
		private var _skillOffset:int;
		/**
		 * 初始化影子 
		 * 
		 */		
		protected function initShadow():void{
			this.shadow = new BaseNativeEntity();
			this.shadow.data.bitmapData = AUtils.getNewObj("shadow") as BitmapData;	
			this.shadow.registerPoint = new Point(this.shadow.data.bitmapData.rect.width/2, this.shadow.data.bitmapData.rect.height/2)
			this.shadow.y = 50;
			this.shadow.x = 3;
			this.addChildAt(this.shadow, 0);
		}
		
		//无敌不受伤害
		public function isYourFather():Boolean{
			return characterJudge.isInvincible;
		}
		
		//倒地还会受到某些技能的伤害
		public function isFallDownSkill(ih:IHurtAble) : Boolean{
			var result:Boolean = false;
			if((ih as SkillEntity).fallDownHurt == 0 && characterJudge.isFallDown == true){
				result = true;
			}
			return result;
		}
		
		//死亡不受伤害
		protected function isDead() : Boolean{
			if(this.curAction == ActionState.DEAD || this.curAction == ActionState.GROUNDDEAD || charVo.useProperty.hp <= 0)
				return true;
			else
				return false;
		}
		
		public function hurtBy(ih:IHurtAble):void{
			if(this.isDead()|| this.isYourFather() || this.isFallDownSkill(ih)){
				return;
			}else{
				_characterControl.hurtJudge(ih);
			}
		}
		
		//挡住技能判断
		protected function blockJudge(skill:SkillEntity):void{
			if(skill.skillProperty == SkillType.BLOCK){
				if(skill.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
					if(this.x > skill.x){
						this.x = skill.x - 10;
					}
				}else{
					if(this.x < skill.x){
						this.x = skill.x + 10;
					}
				}
			}
		}
		
		//敌方技能造成的buff
		public function addHurtBuff(skill:SkillEntity) : void{
			if(skill.skillConfiguration.target_buff_type != "0"){
				var buffTypeList:Array = skill.skillConfiguration.target_buff_type.split("|");
				var buffValueList:Array = skill.skillConfiguration.target_buff_value.split("|");
				
				for(var i:int = 0; i < buffTypeList.length; i++){
					if(int(buffTypeList[i]) != 0){
						//魅惑特效
						if(int(buffTypeList[i]) == 12){
							if(this is PlayerEntity){
								SkillManager.getIns().createSkill(this, 66);
							}else{
								SkillManager.getIns().createSkill(this, 105);
							}
						}
						charData.addBuff(buffTypeList[i], buffValueList[i]);
					}
				}
			}
		}
		
		public function attackTarget(value:IBeHurtAble):void{
			
		}
		
		override public function setAction(actionState:uint,resetWhenSameAction:Boolean = false):void{
			super.setAction(actionState,resetWhenSameAction);
			speedControl(actionState);
			fallDownJudge(actionState);
		}
		
		private function fallDownJudge(actionState:uint):void{
			if(actionState != ActionState.FALL){
				characterJudge.isFallDown = false;
			}
		}
		
		protected function speedControl(actionState:uint) : void{
			if(speedEntity != null){
				if(actionState == ActionState.RUN)	
					speedEntity.setRun();
				else if(actionState != ActionState.JUMP && actionState != ActionState.JUMPDOWN && actionState != ActionState.DOUBLEJUMP)
					speedEntity.setNormal();
			}
		}
		
		override public function step():void{
			super.step();
			if(_characterControl != null) _characterControl.moveControl();
			lightStep();
			temptationStep();
		}
		
		private var _temptationCount:int;
		private var _temptationType:int;
		private function temptationStep() : void{
			if(characterJudge.isTemptation && charVo.useProperty.hp > 0){
				_temptationCount++;
				if(_temptationCount % 15 == 0){
					_temptationType = DigitalManager.getIns().getRandom() * 6;
				}
				if(curAction != ActionState.HURT
					&& curAction != ActionState.HURTDOWN
					&& curAction != ActionState.GROUNDDEAD
					&& curAction != ActionState.FALL
					&& curAction != ActionState.DEAD){
					this.setAction(ActionState.WALK);
					switch(_temptationType){
						case 0:
							faceHorizontalDirect = DirectConst.DIRECT_LEFT;
							_characterControl.moveLeft();
							_characterControl.moveUp();
							break;
						case 1:
							faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
							_characterControl.moveRight();
							_characterControl.moveUp();
							break;
						case 2:
							faceHorizontalDirect = DirectConst.DIRECT_LEFT;
							_characterControl.moveLeft();
							_characterControl.moveDown();
							break;
						case 3:
							faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
							_characterControl.moveRight();
							_characterControl.moveDown();
							break;
						case 4:
							faceHorizontalDirect = DirectConst.DIRECT_RIGHT;
							_characterControl.moveRight();
							break;
						case 5:
							faceHorizontalDirect = DirectConst.DIRECT_LEFT;
							_characterControl.moveLeft();
							break;
					}
				}
			}
		}
		
		private function lightStep():void{
			if(characterJudge != null){
				if(characterJudge.isOnlyHurt){
					if(_nowGlowFilterIndex == GlowFilterConst.NONE || _nowGlowFilterIndex == GlowFilterConst.WHITE_LIGHT){
						setGlowFilter(GlowFilterConst.YELLOW_LIGHT);
					}
				}else{
					buringGlowFilterJudge();
				}
			}
		}		
		
		//释放无双发光判断
		private function buringGlowFilterJudge() : void{
			if(this is PlayerEntity){
				if(charVo.startAngerDown){
					switch((this as PlayerEntity).player.occupation){
						case OccupationConst.KUANGWU:
							if(_nowGlowFilterIndex != GlowFilterConst.YELLOW_LIGHT){
								setGlowFilter(GlowFilterConst.YELLOW_LIGHT);
							}
							break
						case OccupationConst.XIAOYAO:
							if(_nowGlowFilterIndex != GlowFilterConst.WHITE_LIGHT){
								setGlowFilter(GlowFilterConst.WHITE_LIGHT);
							}
							break;
					}
				}else{
					if(_nowGlowFilterIndex != GlowFilterConst.NONE){
						setGlowFilter();
					}
				}
			}else{
				if(_nowGlowFilterIndex != GlowFilterConst.NONE){
					setGlowFilter();
				}
			}
		}
		
		//角色受到伤害落下
		public function fallDown() : void{
			this.setAction(ActionState.FALL);
			isLock = true;
			characterJudge.isFallDown = true;
		}
		
		//角色受到伤害站起
		protected function standUp() : void{
			this.setAction(ActionState.WAIT);
			isLock = false;
			characterJudge.isFallDown = false;
			characterJudge.isInvincible = true;
			characterJudge.isStandUp = true;
		}
		
		//怪物僵直判断
		protected function unMoveHurt() : void
		{
			characterJudge.unMoveTime--;
			//空中僵直
			if(this.bodyAction.y != 0){
				if(this.characterControl.isJumpDown){
				}else{
					this.setAction(ActionState.HURT);
				}
				if(characterJudge.unMoveTime <= 0){
					characterJudge.isUnMoveStatus = false;
				}
			}
			//地面僵直
			else{
				if(characterJudge.unMoveTime <= 0){
					this.setAction(ActionState.WAIT);
					this.isLock = false;
					characterJudge.isUnMoveStatus = false;
				}else{
					this.curAction = ActionState.WAIT;
					this.setAction(ActionState.HURT);
				}
			}
		}
		
		public function jump():void{
			_characterControl.jump();
		}
		
		public function moveLeft() : void{
			_characterControl.moveLeft();
		}
		
		public function moveRight() : void{
			_characterControl.moveRight();
		}
		
		public function moveUp() : void{
			_characterControl.moveUp();
		}
		
		public function moveDown() : void{
			_characterControl.moveDown();
		}
		
		public function checkDead() : Boolean
		{
			return charVo.checkDead();
		}
		
		public function changeHp(count:int) : void{
			charVo.changeHp(count);
		}
		public function changeMp(count:int) : void{
			charVo.changeMp(count);
		}
		
		//设置发光
		public function setGlowFilter(color:int = GlowFilterConst.NONE) : void{
			_nowGlowFilterIndex = color;
			if(this is PlayerEntity){
				if(color == GlowFilterConst.NONE){
					this.bodyAction.glowFilter = null;
				}else{
					this.bodyAction.glowFilter = new GlowFilter(color);
				}
			}else if(this is MonsterEntity){
				if(color == GlowFilterConst.NONE){
					this.bodyAction.getActionByIndex(0).glowFilter = null;
				}else{
					this.bodyAction.getActionByIndex(0).glowFilter = new GlowFilter(color);
				}
			}
		}
		
		override public function destroy():void{
			this._lastBeHurtSource = null;
			this.shadow = null;
			if(this._beAttackedIdVec){
				this._beAttackedIdVec.length = 0;
				this._beAttackedIdVec = null;
			}
			if(this.stationList){
				this.stationList.length = 0;
				this.stationList = null;
			}
			if(this.stationRect){
				this.stationRect.destroy();
				this.stationRect = null;
			}
			if(this._characterControl){
				this._characterControl.destroy();
				this._characterControl = null;
			}
			if(this.charVo){
				this.charVo.destroy();
				this.charVo = null;
			}
			
			super.destroy();
		}

		public function get beAttackedIdVec():Vector.<int>{
			return _beAttackedIdVec;
		}

		public function set beAttackedIdVec(value:Vector.<int>):void{
			_beAttackedIdVec = value;
		}

		public function get lastBeHurtSource():IHurtAble{
			return _lastBeHurtSource;
		}

		public function set lastBeHurtSource(value:IHurtAble):void{
			_lastBeHurtSource = value;
		}
		
		private var bodyPosTemp:Point = new Point();
		/**
		 * 返回身体区域坐标 
		 * @return 
		 * 
		 */		
		public function get bodyPos():Point{
			bodyPosTemp.x = this.x + this.bodyAction.x;
			bodyPosTemp.y = this.y + this.bodyAction.y;
			return bodyPosTemp;
		}
		
		
		private var shadowPosTemp:Point = new Point();
		/**
		 * 返回影子区域坐标
		 * @return 
		 * 
		 */		
		public function get shadowPos():Point{
			shadowPosTemp.x = this.x + this.shadow.x;
			shadowPosTemp.y = this.y + this.shadow.y;
			return shadowPosTemp;
		}

		private var stationRectPos:Point = new Point();
		
		public function get stationPos() : Point{
			stationRectPos.x = this.x + this.stationRect.x;
			stationRectPos.y = this.y + this.stationRect.y;
			return stationRectPos;
		}
		
		public function get speedX() : int{
			return charVo.speedEntity.speedX;
		}
		/*public function set speedX(value:int) : void{
			this._speedEntity.speedX = value;
		}*/
		
		public function get speedY() : int{
			return charVo.speedEntity.speedY;
		}
		/*public function set speedY(value:int) : void{
			this._speedEntity.speedY = value;
		}*/
		
		public function get charData() : CharacterVo{
			return charVo;
		}
		
		override public function get collisionPos():int{
			return this.shadowPos.y;
		}
		
		public function get characterControl() : CharacterMoveControl{
			return _characterControl;
		}
		
		public function get characterJudge() : CharacterJudge{
			return charVo.characterJudge;
		}
		
		public function get speedEntity() : SpeedVo{
			return charVo.speedEntity;
		}
		
		public function get isLock() : Boolean{
			return charVo.characterJudge.isLock;
		}
		public function set isLock(value:Boolean) : void{
			charVo.characterJudge.isLock = value;
		}
		
		public function get isTemptation() : Boolean{
			return charVo.characterJudge.isTemptation;
		}
	}
}