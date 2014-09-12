package com.test.game.Entitys.HideMission
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.test.game.AgreeMent.Battle.IBeHurtAble;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Effect.BloodBar;
	import com.test.game.Effect.ShakeEffect;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Manager.HideMission.MoZhuHideMissionManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Utils.SkillUtils;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class ActionMissionEntity extends SequenceActionEntity implements IBeHurtAble
	{
		public var shadow:BaseNativeEntity;
		private var tq:TestQuad;
		private var _charVo:CharacterVo;
		private var _hp:int;
		private var _allHp:int;
		private var _beAttackedIdVec:Vector.<int>;
		private var _bloodBar:BloodBar;
		private var _isOver:Boolean = false;
		private var _action:BaseSequenceActionBind;
		public function ActionMissionEntity(hp:int, charVo:CharacterVo){
			_allHp = _hp = hp;
			_charVo = charVo;
			
			super();
			this._beAttackedIdVec = new Vector.<int>();
			this.isRectCollision = true;
			this.collisionIndex = CollisionFilterIndexConst.MONSTER;
			this.collisionListeners = [CollisionFilterIndexConst.PLAYER_SKILL];
		}
		
		override protected function initSequenceAction():void{
			_bloodBar = new BloodBar(this, -35, -60);
			
			initCollision();
			initAction();
			initShadow();
			
			this.collisionBody = tq;
		}
		
		private function initCollision() : void{
			tq = new TestQuad();
			tq.x = tq.width/2;
			tq.y = tq.height/2;
			tq.visible = false;
			this.addChild(tq);
		}
		
		private function initAction():void{
			_action = AnimationEffect.createAnimation(_charVo.id, _charVo.assetsArray, _charVo.isDouble);
			this.addChild(_action);
		}
		
		public function get beAttackedIdVec():Vector.<int>{
			return _beAttackedIdVec;
		}
		
		public function set beAttackedIdVec(value:Vector.<int>):void{
			_beAttackedIdVec = value;
		}
		
		protected function initShadow():void{
			this.shadow = new BaseNativeEntity();
			this.shadow.data.bitmapData = AUtils.getNewObj("shadow") as BitmapData;	
			this.shadow.registerPoint = new Point(this.shadow.data.bitmapData.rect.width/2, this.shadow.data.bitmapData.rect.height/2)
			this.shadow.y = 50;
			this.shadow.visible = true;
			this.addChildAt(this.shadow, 0);
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
		
		override public function get collisionPos():int{
			return this.shadowPos.y;
		}
		
		public function set lastBeHurtSource(ia:IHurtAble):void{
			
		}
		
		public function get lastBeHurtSource():IHurtAble
		{
			return null;
		}
		
		private var _stepInterval:int = 50;
		private var _stepTime:int;
		private var _moveConst:int = 1;
		override public function step() : void{
			if(isYourFather()){
				if(_stepTime < _stepInterval){
					if(_stepTime % 5 == 0){
						this.visible = true;
					}
					if(_stepTime % 10 == 0 && _stepTime != 0){
						this.visible = false;
					}
					_stepTime++;
				}else{
					this.destroy();
				}
			}else{
				if(this.x >= 700){
					_moveConst = -1;
				}else if(this.x <= 300){
					_moveConst = 1;
				}
				this.x += _moveConst * 2;
				this.y = _moveConst * Math.sqrt(2500 * (1 - Math.pow((this.x - 500), 2) / 40000)) + 400;
			}
		}
		
		public function isYourFather():Boolean{
			return _isOver;
		}
		
		public function hurtBy(ih:IHurtAble):void{
			if(!isYourFather()){
				var attackId:int = ih.getAttackId();
				if(beAttackedIdVec.indexOf(attackId) == -1){
					this.beAttackedIdVec.push(attackId);
					calculateHp(ih as SkillEntity);
				}
			}
		}
		
		private function calculateHp(skill:SkillEntity):void{
			var attack:CharacterEntity = skill.hurtSource as CharacterEntity;
			_hp -= SkillUtils.calculateMissionHurt(skill, this, new Point(this.x - 10, attack.y));
			EffectManager.getIns().createUnMove(new Point(this.x - 10, attack.y));
			var shake:ShakeEffect = new ShakeEffect([this], 1, .2);
			_bloodBar.changeBar(_hp / _allHp);
			if(_hp <= 0){
				_isOver = true;
				MoZhuHideMissionManager.getIns().setHideMissionComplete();
			}
		}
		
		override public function destroy():void{
			this.collisionBody = null;
			super.destroy();
		}
	}
}