package com.test.game.Manager.Skill{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Base.BaseSequenceBmdAction;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.DebugConst;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Conjure.ConjureEntity;
	import com.test.game.Entitys.Monsters.FunnyBossOneEntity;
	import com.test.game.Entitys.Roles.KuangWuEntity;
	import com.test.game.Entitys.Roles.XiaoYaoEntity;
	import com.test.game.Entitys.Skill.FunnyBossOneSkillEntity;
	import com.test.game.Entitys.Skill.KuangWuSkillEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Entitys.Skill.XiaoYaoSkillEntity;
	import com.test.game.Entitys.Weather.ThunderEntity;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Mvc.Vo.ConjureVo;
	import com.test.game.Mvc.Vo.SkillVo;
	
	public class SkillManager extends Singleton{
		private var _skills:Vector.<SkillEntity>;//技能数组
		//技能配置表
		public var playerSkillList:Array;
		//角色技能配置表
		public var playerConfigurationList:Array;
		
		public var enemySkillList:Array;
		public var enemyConfiguration:Array;
		
		public var skillInfo:Array;
		
		public function SkillManager(){
			super();
			this._skills = new Vector.<SkillEntity>();
		}
		
		public static function getIns():SkillManager{
			return Singleton.getIns(SkillManager);
		}
		
		public function initSkillData() : void{
			playerSkillList = ConfigurationManager.getIns().getAllData(AssetsConst.PLAYER_SKILL);
			
			playerConfigurationList = com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData(AssetsConst.PLAYER_CONFIGURATION)).RECORDS;
			
			enemySkillList = ConfigurationManager.getIns().getAllData(AssetsConst.ENEMY_SKILL);
			
			enemyConfiguration = com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData(AssetsConst.ENEMY_CONFIGURATION)).RECORDS;
			
			skillInfo = getSkillInfo(PlayerManager.getIns().player.occupation);
		}
		
		public function getSkillInfo(roleType:int) : Array{
			var baseInfo:Array = ConfigurationManager.getIns().getAllData(AssetsConst.CHARACTER_SKILL);
			var result:Array = new Array();
			for each(var item:Object in baseInfo){
				if(int(item.id / 1000) == roleType){
					result.push(item);
				}
			}
			return result;
		}
		
		public function getSkillUpInfo() : Array{
			var baseUpInfo:Array = ConfigurationManager.getIns().getAllData(AssetsConst.SKILL_UP);
			var result:Array = new Array();
			var roleType:int = PlayerManager.getIns().player.occupation;
			for each(var item:Object in baseUpInfo){
				if(int(item.id / 1000) == roleType){
					result.push(item);
				}
			}
			return result;
		}
		
		
		
		public function getPlayerConfigurationData(playerId:int) : Object{
			var result:Object;
			for each(var obj:Object in playerConfigurationList){
				if(obj.player_id == playerId){
					result = obj;
					break;
				}
			}
			if(result == null){
				DebugArea.getIns().showInfo("角色ID:" + playerId + " --- 没有该角色的技能配置信息！", DebugConst.ERROR);
				throw new Error("角色ID:" + playerId + " --- 没有该角色的技能配置信息！");
			}
			return result;
		}
		
		public function getEnemyConfigurationData(enemyId:int) : Object{
			var result:Object;
			for each(var obj:Object in enemyConfiguration){
				if(obj.enemy_id == enemyId){
					result = obj;
					break;
				}
			}
			if(result == null){
				DebugArea.getIns().showInfo("角色ID:" + enemyId + " --- 没有该角色的技能配置信息！", DebugConst.ERROR);
				throw new Error("角色ID:" + enemyId + " --- 没有该角色的技能配置信息！");
			}
			return result;
		}
		
		private function getPlayerSkillData(skillMark:int) : Object
		{
			var result:Object;
			for each(var obj:Object in playerSkillList){
				if(obj.id == skillMark){
					result = obj;
					break;
				}
			}
			if(result == null){
				DebugArea.getIns().showInfo("技能ID:" + skillMark + " --- 没有该技能的配置信息！", DebugConst.ERROR);
				//throw new Error("技能ID:" + skillMark + " --- 没有该技能的配置信息！");
			}
			return result;
		}
		
		private function getEnemySkillData(skillMark:int) : Object
		{
			var result:Object;
			for each(var obj:Object in enemySkillList){
				if(obj.id == skillMark){
					result = obj;
					break;
				}
			}
			if(result == null){
				DebugArea.getIns().showInfo("技能ID:" + skillMark + " --- 没有该技能的配置信息！", DebugConst.ERROR);
				//throw new Error("技能ID:" + skillMark + " --- 没有该技能的配置信息！");
			}
			return result;
		}
		
		public function createPosSkill(posX:int, posY:int, posZ:int, skillObj:CharacterEntity, skillMark:int) : SkillEntity{
			var skill:SkillEntity = createSkill(skillObj, skillMark);
			skill.setBodyPosition(posX, posY, posZ);
			return skill;
		}
		
		public function createSkill(skillObj:CharacterEntity, skillMark:int) : SkillEntity{
			var data:Object;
			var skillVo:SkillVo;
			//角色技能
			if(skillObj is PlayerEntity){
				data = getPlayerSkillData(skillMark);
				if(skillObj.charData.fashionInfo.fashionId == -1 || skillObj.charData.fashionInfo.showFashion == 0){
					skillVo = new SkillVo(data.sid, [data.source], data.isDouble==0?false:true);
				}else{
					if(skillObj is KuangWuEntity){
						if(data.sid <= 2008){
							skillVo = new SkillVo(data.sid, [data.source + "Fashion01"], data.isDouble==0?false:true);
						}else{
							skillVo = new SkillVo(data.sid, [data.source], data.isDouble==0?false:true);
						}
					}else if(skillObj is XiaoYaoEntity){
						if(data.sid <= 2107){
							skillVo = new SkillVo(data.sid, [data.source + "Fashion01"], data.isDouble==0?false:true);
						}else{
							skillVo = new SkillVo(data.sid, [data.source], data.isDouble==0?false:true);
						}
					}
				}
			}
			//怪物技能
			else if(skillObj is MonsterEntity){
				var last:int = skillMark / 100;
				data = getEnemySkillData(skillMark);
				if(last == 309 && data.source != "NoSkill"){
					var seq:BaseSequenceBmdAction = skillObj.bodyAction.getActionByIndex(0);
					var index:String = seq.bmdName.substr(seq.bmdName.length - 3);
					skillVo = new SkillVo(data.sid, [data.source + index], data.isDouble==0?false:true);
				}else{
					skillVo = new SkillVo(data.sid, [data.source], data.isDouble==0?false:true);
				}
			}
			//召唤生物技能
			else if(skillObj is ConjureEntity){
				data = getEnemySkillData(skillMark);
				var last1:int = skillMark / 100;
				//贪得无厌
				if(last1 == 309 && data.source != "NoSkill"){
					var seq1:BaseSequenceBmdAction = skillObj.bodyAction.getActionByIndex(0);
					var index1:String = seq1.bmdName.substr(seq1.bmdName.length - 3);
					skillVo = new SkillVo(data.sid, [data.source + index1], data.isDouble==0?false:true);
				}else{
					skillVo = new SkillVo(data.sid, [data.source], data.isDouble==0?false:true);
				}
			}else if(skillObj is ThunderEntity){
				data = getPlayerSkillData(skillMark);
				skillVo = new SkillVo(data.sid, [data.source], data.isDouble==0?false:true);
			}
			
			var skill:SkillEntity;
			if(skillObj is KuangWuEntity){
				skill = new KuangWuSkillEntity(skillVo, skillObj, data);
			}else if(skillObj is XiaoYaoEntity){
				skill = new XiaoYaoSkillEntity(skillVo, skillObj, data);
			}else if(skillObj is FunnyBossOneEntity){
				skill = new FunnyBossOneSkillEntity(skillVo, skillObj, data);
			}else{
				if(skillObj is ConjureEntity){
					var con:ConjureEntity = skillObj as ConjureEntity;
					if((con.charData as ConjureVo).ID == 2303){
						skill = new SkillEntity(skillVo, con.belong, data);
					}else{
						skill = new SkillEntity(skillVo, con, data);
					}
				}else{
					skill = new SkillEntity(skillVo, skillObj, data);
				}
			}
			skill.setConfiguration();
			addSkill(skill);
			return skill;
		}
		
		public function addSkill(skillEntity:SkillEntity):void{
			if(SceneManager.getIns().nowScene != null){
				SceneManager.getIns().nowScene.addChild(skillEntity);
			}
			PhysicsWorld.getIns().addEntity(skillEntity);
			this._skills.push(skillEntity);
		}
		
		public function destroySkill(skillEntity:SkillEntity):void{
			var idx:int = this._skills.indexOf(skillEntity);
			if(idx != -1){
				skillEntity.destroy();
				this._skills.splice(idx,1);
			}
		}
		
		public function destroySkillByST(belong:CharacterEntity, skillID:int) : void{
			for(var i:int = 0; i < _skills.length; i++){
				if(_skills[i].skillConfiguration.id == skillID
					&& _skills[i].hurtSource == belong){
					destroySkill(_skills[i]);
					break;
				}
			}
		}
		
		public function unHurt() : void{
			for each(var skill:SkillEntity in this._skills){
				skill.isHurt = false;
			}
		}
		
		public function isHurt() : void{
			for each(var skill:SkillEntity in this._skills){
				skill.isHurt = true;
			}
		}
		
	}
}