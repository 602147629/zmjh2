package com.test.game.Utils
{
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.test.game.Const.HurtHpConst;
	import com.test.game.Const.ImmunityConst;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Conjure.ConjureEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Manager.DigitalManager;
	import com.test.game.Manager.WeatherManager;
	import com.test.game.Manager.Effect.EffectManager;
	
	import flash.geom.Point;

	public class SkillUtils
	{
		public function SkillUtils(){
			
		}
		
		public static function calculateSkillHurt(skill:SkillEntity, character:CharacterEntity) : int{
			var allHurt:int;
			var attack:CharacterEntity = skill.hurtSource as CharacterEntity;
			var defend:CharacterEntity = character;
			
			//回血效果
			if(defend.charData.getBuffValue(10) > 0){
				if(skill.skillConfiguration.skillProperty == 0){
					return 0;
				}
			}
			
			//外功
			var atkHurt:int = SkillUtils.calculateSkillAtkHurt(skill, defend);
			EffectManager.getIns().createHurtNum(atkHurt, defend.bodyPos, HurtHpConst.ATK_HP);
			//内功
			var atsHurt:int = SkillUtils.calculateSkillAtsHurt(skill, defend);
			EffectManager.getIns().createHurtNum(atsHurt, defend.bodyPos, HurtHpConst.ATS_HP);
			//混沌
			var chaosHurt:int = SkillUtils.calculateSkillChaosHurt(skill, defend);
			EffectManager.getIns().createHurtNum(chaosHurt, defend.bodyPos, HurtHpConst.CHAOS_HP);
			//百分比掉血
			var hpPercentHurt:int = SkillUtils.calculateSkillHpRate(skill, defend);
			EffectManager.getIns().createHurtNum(hpPercentHurt, defend.bodyPos, HurtHpConst.CHAOS_HP);
			
			//总伤害
			allHurt = atkHurt + atsHurt + chaosHurt + hpPercentHurt;
			if(attack.charData != null){
				//吸血效果
				if(attack.charData.getBuffValue(3) > 0){
					var hpCount:int = allHurt * attack.charData.getBuffValue(3);
					attack.changeHp(-hpCount);
					EffectManager.getIns().createHurtNum(hpCount, attack.bodyPos, HurtHpConst.REGAIN_HP);
				}
				//附加内功伤害
				if(attack.charData.getBuffValue(6) > 0){
					if(character.characterJudge.immunityType != ImmunityConst.ATS_IMMUNITY){
						var index:int = int(((skill.skillConfiguration.nid).toString()).substr(1, 1));
						if(index == 0){
							var atsBuffHurt:int = (attack.charData.useProperty.ats - defend.charData.useProperty.adf) * (1 + attack.charData.useProperty.hurt_deepen - character.charData.useProperty.hurt_reduce) * attack.charData.getBuffValue(6);
							EffectManager.getIns().createHurtNum(atsBuffHurt, defend.bodyPos, HurtHpConst.ATS_HP);
							allHurt += atsBuffHurt;
						}
					}
				}
				//回蓝效果
				if(attack.charData.getBuffValue(7) > 0){
					if(allHurt > 0){
						var count:int = attack.charData.totalProperty.mp * attack.charData.getBuffValue(7);
						attack.changeMp(-count);
						EffectManager.getIns().createHurtNum(count, attack.bodyPos, HurtHpConst.CHAOS_HP);
					}
				}
			}
			//角色受到的伤害值计算
			if(defend is PlayerEntity){
				defend.charData.allHurtCount += allHurt;
			}
			if(attack is PlayerEntity){
				attack.charData.angerCount++;
				WeatherManager.getIns().showWeatherEffect(defend.bodyPos);
				//attack.charData.bossCount++;
			}
			if(attack is ConjureEntity){
				defend.charData.playerUIControl.conjureAngerAndBoss();
			}
			
			defend.changeHp(allHurt);
			
			return allHurt;
		}
		
		//外功
		private static function calculateSkillAtkHurt(skill:SkillEntity, character:CharacterEntity) : int{
			var result:int = 0;
			var attack:CharacterEntity = skill.hurtSource as CharacterEntity;
			if(character.characterJudge.immunityType != ImmunityConst.ATK_IMMUNITY){
				if(attack.charData != null){
					if(skill.skillConfiguration.atk_rate != 0 && skill.skillConfiguration.atk_rate != null){
						result = (skill.skillConfiguration.atk_hurt + (attack.charData.useProperty.atk - character.charData.useProperty.def) * skill.skillConfiguration.atk_rate)
							* (1 + attack.charData.useProperty.hurt_deepen - character.charData.useProperty.hurt_reduce);
						if(character.characterJudge.hurtReduceType == ImmunityConst.ATK_IMMUNITY){
							result = result * (1 - character.characterJudge.hurtReduceNum);
						}
					}
					if(result > 0 && critJudge(skill, character)){
						EffectManager.getIns().createCrit(character.bodyPos);
						result *= 2;
					}
				}
				if(result <= 0 && skill.skillConfiguration.atk_rate != 0){
					result = 1;
				}
			}
			return result;
		}
		
		//内功
		private static function calculateSkillAtsHurt(skill:SkillEntity, character:CharacterEntity) : int{
			var result:int = 0;
			var attack:CharacterEntity = skill.hurtSource as CharacterEntity;
			if(character.characterJudge.immunityType != ImmunityConst.ATS_IMMUNITY){
				if(attack.charData != null){
					if(skill.skillConfiguration.ats_rate != 0 && skill.skillConfiguration.ats_rate != null){
						result = (skill.skillConfiguration.ats_hurt + (attack.charData.useProperty.ats - character.charData.useProperty.adf) * skill.skillConfiguration.ats_rate)
							* (1 + attack.charData.useProperty.hurt_deepen - character.charData.useProperty.hurt_reduce);
						if(character.characterJudge.hurtReduceType == ImmunityConst.ATS_IMMUNITY){
							result = result * (1 - character.characterJudge.hurtReduceNum);
						}
					}
					if(result > 0 && critJudge(skill, character)){
						EffectManager.getIns().createCrit(character.bodyPos);
						result *= 2;
					}
				}
				if(result <= 0 && skill.skillConfiguration.ats_rate != 0){
					result = 1;
				}
			}
			return result;
		}
		
		//混乱
		private static function calculateSkillChaosHurt(skill:SkillEntity, character:CharacterEntity) : int{
			var result:int = 0;
			var attack:CharacterEntity = skill.hurtSource as CharacterEntity;
			if(character.characterJudge.immunityType != ImmunityConst.CHAOS_IMMUNITY){
				if(attack.charData != null){
					if(skill.skillConfiguration.chaos_hurt != null && skill.skillConfiguration.chaos_hurt != 0){
						result = skill.skillConfiguration.chaos_hurt * (1 + attack.charData.useProperty.hurt_deepen - character.charData.useProperty.hurt_reduce);
						if(character.characterJudge.hurtReduceType == ImmunityConst.CHAOS_IMMUNITY){
							result = result * (1 - character.characterJudge.hurtReduceNum);
						}
					}
					if(result > 0 && critJudge(skill, character)){
						EffectManager.getIns().createCrit(character.bodyPos);
						result *= 2;
					}
				}
				if(result <= 0 && skill.skillConfiguration.chaos_hurt != 0){
					result = 1;
				}
			}
			return result;
		}
		
		//百分比掉血
		private static function calculateSkillHpRate(skill:SkillEntity, character:CharacterEntity) : int{
			var result:int = 0;
			var attack:CharacterEntity = skill.hurtSource as CharacterEntity;
			if(attack.charData != null){
				if(skill.skillConfiguration.hp_rate != null && skill.skillConfiguration.hp_rate != 0){
					result = skill.skillConfiguration.hp_rate * character.charData.totalProperty.hp;
				}
				
				if(result <= 0 && skill.skillConfiguration.hp_rate != 0){
					result = 1;
				}
			}
			return result;
		}
		
		//闪避判断
		public static function dodgeJudge(skill:SkillEntity, role:CharacterEntity) : Boolean{
			var result:Boolean = false;
			var attack:CharacterEntity = skill.hurtSource as CharacterEntity;
			var random:Number = DigitalManager.getIns().getRandom();
			if(attack.charData != null){
				var last:Number = role.charData.useProperty.evasion - attack.charData.useProperty.hit;
				if(random < last){
					result = true;
				}
			}
			return result;
		}
		
		//暴击判断
		public static function critJudge(skill:SkillEntity, role:CharacterEntity) : Boolean{
			var result:Boolean = false;
			var random:Number = DigitalManager.getIns().getRandom();
			var attack:CharacterEntity = skill.hurtSource as CharacterEntity;
			if(attack.charData != null){
				var last:Number = attack.charData.useProperty.crit - role.charData.useProperty.toughness;
				if(random < last){
					result = true;
				}
			}
			return result;
		}
		
		public static function calculateMissionHurt(skill:SkillEntity, bne:BaseNativeEntity, pos:Point) : int{
			var result:int;
			var attack:CharacterEntity = skill.hurtSource as CharacterEntity;
			var atkHurt:int = (skill.skillConfiguration.atk_hurt + (attack.charData.useProperty.atk) * skill.skillConfiguration.atk_rate)
				* (1 + attack.charData.useProperty.hurt_deepen);
			EffectManager.getIns().createHurtNum(atkHurt, pos, HurtHpConst.ATK_HP);
			var atsHurt:int = (skill.skillConfiguration.ats_hurt + (attack.charData.useProperty.ats) * skill.skillConfiguration.ats_rate)
				* (1 + attack.charData.useProperty.hurt_deepen);
			EffectManager.getIns().createHurtNum(atsHurt, pos, HurtHpConst.ATS_HP);
			var chaosHurt:int = result = skill.skillConfiguration.chaos_hurt * (1 + attack.charData.useProperty.hurt_deepen);
			EffectManager.getIns().createHurtNum(chaosHurt, pos, HurtHpConst.CHAOS_HP);
			result = atkHurt + atsHurt + chaosHurt;
			return result;
		}
	}
}