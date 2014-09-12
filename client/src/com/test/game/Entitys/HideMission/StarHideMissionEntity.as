package com.test.game.Entitys.HideMission
{
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Effect.BloodBar;
	import com.test.game.Effect.ShakeEffect;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Manager.HideMission.TaiXuHideMissionManager;
	import com.test.game.Utils.SkillUtils;
	
	import flash.geom.Point;

	public class StarHideMissionEntity extends TaiXuBaseHideMissionEntity
	{
		private var _hp:int;
		private var _allHp:int;
		private var _bloodBar:BloodBar;
		public function StarHideMissionEntity(fodderArr:Array, collisionSkill:String="", collisionY:int=50, isClear:Boolean=false)
		{
			super(fodderArr, collisionSkill, collisionY, isClear);
			
			_stepInterval = 60;
			_bloodBar = new BloodBar(this, 25, 10);
		}
		
		public function setHp(hp:int) : void{
			_allHp = _hp = hp;
		}
		override public function hurtBy(ih:IHurtAble):void{
			if(!_isOver && _collisionSkill != ""){
				var skillEntity:SkillEntity = ih as SkillEntity;
				var attackId:int = ih.getAttackId();
				if(beAttackedIdVec.indexOf(attackId) == -1){
					this.beAttackedIdVec.push(attackId);
					var attack:CharacterEntity = ih.hurtSource as CharacterEntity;
					_hp -= SkillUtils.calculateMissionHurt(ih as SkillEntity, this, new Point(this.x + 40, this.y + 100));
					EffectManager.getIns().createUnMove(new Point(this.x + 50, this.y + 100));
					var shake:ShakeEffect = new ShakeEffect([this], 1, .2);
					_bloodBar.changeBar(_hp / _allHp);
					if(_hp <= 0){
						_isOver = true;
						TaiXuHideMissionManager.getIns().setHideMissionComplete(HideMissionManager.TAIXUGUAM_ID);
					}
				}
			}
		}
		
		override public function step() : void{
			if(_isClear){
				if(_isOver && !_stepStop){
					if(_stepTime < 10){
						this.y += 17;
						_stepTime++;
					}else{
						if(_stepTime < _stepInterval){
							if(_stepTime % 5 == 0){
								this.visible = true;
							}
							if(_stepTime % 10 == 0 && _stepTime != 0){
								this.visible = false;
							}
							_stepTime++;
						}else{
							_stepStop = true
							this.visible = false;
						}
					}
				}
			}
		}
	}
}