package com.test.game.Entitys.Daily
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.AgreeMent.Battle.IBeHurtAble;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Const.HurtHpConst;
	import com.test.game.Effect.BloodBar;
	import com.test.game.Effect.DailyMissionFontEffect;
	import com.test.game.Effect.ShakeEffect;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.Effect.EffectManager;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class ObstacleEntity extends SequenceActionEntity implements IBeHurtAble
	{
		private var _hp:int;
		private var _allHp:int;
		private var _beAttackedIdVec:Vector.<int>;
		private var _bloodBar:BloodBar;
		public function ObstacleEntity(hp:int)
		{
			super();
			_allHp = _hp = hp;
			this._beAttackedIdVec = new Vector.<int>();
			this.name = "Obstacle";
			this.isRectCollision = true;
			this.collisionIndex = CollisionFilterIndexConst.MONSTER;
			this.collisionListeners = [CollisionFilterIndexConst.PLAYER_SKILL];
			
			RenderEntityManager.getIns().addEntity(this);
			PhysicsWorld.getIns().addEntity(this);
		}
		
		override protected function initSequenceAction():void{
			initImage();
			_bloodBar = new BloodBar(this, 50, 100);
			this.collisionBody = this;
		}
		
		private function initImage():void{
			this.data.bitmapData = AUtils.getNewObj("Obstacle_1") as BitmapData;
		}
		
		public function setImage(fodder:String) : void{
			this.data.bitmapData = AUtils.getNewObj(fodder) as BitmapData;
		}
		
		public function get beAttackedIdVec():Vector.<int>{
			return _beAttackedIdVec;
		}
		
		public function set beAttackedIdVec(value:Vector.<int>):void{
			_beAttackedIdVec = value;
		}
		
		public function set lastBeHurtSource(ia:IHurtAble):void
		{
		}
		
		public function get lastBeHurtSource():IHurtAble
		{
			return null;
		}
		
		private var _stepInterval:int = 50;
		private var _stepTime:int;
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
			}
		}
		
		public function isYourFather():Boolean{
			return DailyMissionManager.getIns().judgeDailyComplete;
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
			var result:int;
			var attack:CharacterEntity = skill.hurtSource as CharacterEntity;
			var atkHurt:int = (skill.skillConfiguration.atk_hurt + (attack.charData.useProperty.atk) * skill.skillConfiguration.atk_rate)
				* (1 + attack.charData.useProperty.hurt_deepen);
			EffectManager.getIns().createHurtNum(atkHurt, new Point(this.x + 65, attack.y), HurtHpConst.ATK_HP);
			var atsHurt:int = (skill.skillConfiguration.ats_hurt + (attack.charData.useProperty.ats) * skill.skillConfiguration.ats_rate)
				* (1 + attack.charData.useProperty.hurt_deepen);
			EffectManager.getIns().createHurtNum(atsHurt, new Point(this.x + 65, attack.y), HurtHpConst.ATS_HP);
			var chaosHurt:int = result = skill.skillConfiguration.chaos_hurt * (1 + attack.charData.useProperty.hurt_deepen);
			EffectManager.getIns().createHurtNum(chaosHurt, new Point(this.x + 65, attack.y), HurtHpConst.CHAOS_HP);
			
			_hp -= (atkHurt + atsHurt + chaosHurt);
			
			EffectManager.getIns().createUnMove(new Point(this.x + 65, attack.y + 20));
			var shake:ShakeEffect = new ShakeEffect([this], 1, .2);
			_bloodBar.changeBar(_hp / _allHp);
			if(_hp <= 0){
				DailyMissionManager.getIns().setDailyComplete();
				this.data.bitmapData = AUtils.getNewObj("Obstacle_2") as BitmapData;
				var fontFind:DailyMissionFontEffect = new DailyMissionFontEffect();
				fontFind.initOtherFontEffect(this, "ObstacleClear");
				//var fontFind:DailyMissionFontEffect = new DailyMissionFontEffect(this, "ObstacleClear");
			}
		}
		
		override public function destroy():void{
			this.collisionBody = null;
			if(_bloodBar != null){
				_bloodBar.destroy();
				_bloodBar = null;
			}
			if(_beAttackedIdVec != null){
				_beAttackedIdVec.length = 0;
				_beAttackedIdVec = null;
			}
			super.destroy();
		}
	}
}