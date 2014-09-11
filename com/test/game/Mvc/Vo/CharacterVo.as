package com.test.game.Mvc.Vo{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Vo.SequenceVo;
	import com.test.game.Const.BuffType;
	import com.test.game.Const.CharacterType;
	import com.test.game.Const.NumberConst;
	import com.test.game.Entitys.Judge.CharacterJudge;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Configuration.Character;
	import com.test.game.Mvc.Configuration.CharactersUp;
	import com.test.game.Mvc.Data.SkillConfigurationVo;
	import com.test.game.Mvc.control.View.PlayerUIControl;
	
	
	public class CharacterVo extends SequenceVo{
		
		private var _anti:Antiwear;
		
		private var _characterConfig:Character;
		private var _playerUIControl:PlayerUIControl;
		//buff列表
		public var buffStatus:Vector.<BuffVo>;
		//曝气buff
		public var buringBuffStatus:Vector.<BuffVo>;
		//角色移动速度的控制
		public var speedEntity:SpeedVo;
		//技能配置数据
		public var skillConfigurationVo:SkillConfigurationVo;
		public var bossRegainCount:int = 1;
		public var characterType:int;
		public var characterBarIndex:int = 0;
		public var characterJudge:CharacterJudge;
		public var fashionInfo:FashionVo;
		
		public function get characterConfig():Character{
			return _characterConfig;
		}
		
		public function set characterConfig(value:Character):void{
			_characterConfig = value;
		}
		/**
		 * 人物自身属性
		 */
		private var _configProperty:BasePropertyVo;
		public function get configProperty():BasePropertyVo{
			return _configProperty;
		}
		public function set configProperty(value:BasePropertyVo):void{
			_configProperty = value;
		}
		
		/**
		 * 等级提升属性
		 */		
		private var _levelUpProperty:BasePropertyVo;
		public function get levelUpProperty():BasePropertyVo{
			return _levelUpProperty;
		}
		public function set levelUpProperty(value:BasePropertyVo) : void{
			_levelUpProperty = value;
		}
		
		
		/**
		 * 装备附加属性 
		 */
		private var _equipProperty:BasePropertyVo;
		public function get equipProperty():BasePropertyVo{
			return _equipProperty;
		}
		public function set equipProperty(value:BasePropertyVo):void{
			_equipProperty = value;
		}
		
		private var _heroUpgradeProperty:BasePropertyVo;
		public function get heroUpgradeProperty() : BasePropertyVo{
			return _heroUpgradeProperty;
		}
		public function set heroUpgradeProperty(value:BasePropertyVo) : void{
			_heroUpgradeProperty = value;
		}
		
		public function CharacterVo(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_characterConfig = new Character();
			_configProperty = new BasePropertyVo();
			_equipProperty = new BasePropertyVo();
			_levelUpProperty = new BasePropertyVo();
			_attachProperty = new BasePropertyVo();
			_baGuaProperty = new BasePropertyVo();
			_fashionProperty = new BasePropertyVo();
			_jingMaiProperty = new BasePropertyVo();
			_titleProperty = new BasePropertyVo();
			_heroUpgradeProperty = new BasePropertyVo(); 
			totalProperty = new BasePropertyVo();
			buffStatus = new Vector.<BuffVo>();
			buringBuffStatus = new Vector.<BuffVo>();
			characterJudge = new CharacterJudge();
			speedEntity = new SpeedVo();
			
			_playerUIControl = (ControlFactory.getIns().getControl(PlayerUIControl) as PlayerUIControl);
		}
		
		public function resetSkillParams(setColdTime:Boolean = true) : void{
			skillConfigurationVo.skillCountList = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		}
		
		//技能是否无敌
		public function checkInvincible(skillID:int) : void{
			if(skillConfigurationVo.invincibleList[skillID] != 0 && characterJudge.inviclbleTime >= 0){
				characterJudge.isInvincible = true;
				if(characterJudge.inviclbleTime < skillConfigurationVo.invincibleList[skillID]){
					characterJudge.inviclbleTime = skillConfigurationVo.invincibleList[skillID];
				}
			}
		}
		
		public function checkCommonOnlyHurt(commonID:int) : void{
			if(skillConfigurationVo.commonOnlyHurtList[commonID] != 0 && characterJudge.onlyHurtTime >= 0){
				characterJudge.isOnlyHurt = true;
				if(characterJudge.onlyHurtTime < skillConfigurationVo.commonOnlyHurtList[commonID]){
					characterJudge.onlyHurtTime = skillConfigurationVo.commonOnlyHurtList[commonID];
				}
			}
		}
		
		//技能是否霸体
		public function checkOnlyHurt(skillID:int) : void{
			if(skillConfigurationVo.onlyHurtList[skillID] != 0 && characterJudge.onlyHurtTime >= 0){
				characterJudge.isOnlyHurt = true;
				if(characterJudge.onlyHurtTime < skillConfigurationVo.onlyHurtList[skillID]){
					characterJudge.onlyHurtTime = skillConfigurationVo.onlyHurtList[skillID];
				}
			}
		}
		
		public function checkReleaseSkill(skillID:int) : Boolean{
			var result:Boolean = false;
			if(skillConfigurationVo.releaseSkillList[skillID] != 0){
				result = true;
			}
			return result;
		}
		
		//添加霸体时间
		public function addOnlyHurt(count:Number) : void{
			characterJudge.isOnlyHurt = true;
			if(characterJudge.onlyHurtTime < count){
				characterJudge.onlyHurtTime = count;
			}
		}
		
		//添加无敌时间
		public function addInvincible(count:Number) : void{
			characterJudge.isInvincible = true;
			if(characterJudge.inviclbleTime < count){
				characterJudge.inviclbleTime = count;
			}
		}
		
		//
		public function addTemptation(count:Number) : void{
			characterJudge.isTemptation = true;
			if(characterJudge.temptationTime < count){
				characterJudge.temptationTime = count;
			}
		}
		
		//删除buff
		public function removeBuff(type:int, num:Number) : void{
			for(var i:int = 0; i < buffStatus.length; i++){
				if(buffStatus[i].buffType == type && buffStatus[i].buffValue == num){
					buffStatus.splice(i, 1);
					setBuffStatus(type);
					break;
				}
			}
		}
		
		//删除一个buff
		public function removeOneBuff() : void{
			if(buffStatus.length > 0){
				var type:int = buffStatus[0].buffType;
				buffStatus.splice(0, 1);
				setBuffStatus(type);
			}
		}
		
		//添加buff
		public function addBuff(type:int, num:Number, buring:Boolean = false) : void{
			if(type == BuffType.BUFF_ONLY_HURT){
				addOnlyHurt(num);
			}else if(type == BuffType.BUFF_INVINCIBLE){
				addInvincible(num);
			}else if(type == BuffType.BUFF_TEMPTATION){
				addTemptation(num);
			}else{
				buffStatus.push(new BuffVo(type, num));
				setBuffStatus(type, true);
			}
			if(buring){
				buringBuffStatus.push(new BuffVo(type, num));
			}
		}
		
		//获得buff的加成值
		public function getBuffValue(type:int) : Number{
			var result:Number = 0;
			for(var i:int = 0; i < buffStatus.length; i++){
				if(buffStatus[i].buffType == type){
					result += buffStatus[i].buffValue;
				}
			}
			return result;
		}
		
		private function setBuffStatus(type:int, isAdd:Boolean = false) : void{
			switch(type){
				//伤害加深
				case BuffType.BUFF_DEEPEN_HURT:
					useProperty.hurt_deepen = totalProperty.hurt_deepen + getBuffValue(type);
					break;
				//伤害减免
				case BuffType.BUFF_REDUCE_HURT:
					useProperty.hurt_reduce = totalProperty.hurt_reduce + getBuffValue(type);
					break;
				//暴击
				case BuffType.BUFF_CRIT:
					useProperty.crit = totalProperty.crit + getBuffValue(type);
					break;
				//吸血
				case BuffType.BUFF_BLOOD:
					break;
				//速度
				case BuffType.BUFF_SPEED:
					useProperty.spd = totalProperty.spd * (1 + getBuffValue(type));
					speedEntity.changeSpeed(useProperty.spd);
					break;
				//闪避
				case BuffType.BUFF_EVASION:
					useProperty.evasion = totalProperty.evasion + getBuffValue(type);
					break;
				//内功附加伤害
				case BuffType.BUFF_ATS_HURT:
					break;
				//回蓝
				case BuffType.BUFF_REGAIN_MP:
					break;
				//攻击力
				case BuffType.BUFF_ATTACK:
					useProperty.atk = totalProperty.atk * (1 + getBuffValue(type));
					break;
				//每秒回血
				case BuffType.BUFF_REGAIN_HP:
					break;
				//只受属性技能伤害
				case BuffType.BUFF_PROPERTY_HURT:
					break;
				//魅惑
				case BuffType.BUFF_TEMPTATION:
					if(characterJudge.temptationTime <= -1) return;
					characterJudge.temptationTime = getBuffValue(type);
					if(characterJudge.temptationTime == 0){
						characterJudge.isTemptation = false;
						characterJudge.unMoveTime = 0;
						characterJudge.isUnMoveStatus = false;
					}else{
						characterJudge.addUnMoveTime(getBuffValue(type));
						characterJudge.temptationTime = getBuffValue(type);
						characterJudge.isTemptation = true;
					}
					break;
				//霸体
				case BuffType.BUFF_ONLY_HURT:
					if(characterJudge.onlyHurtTime <= -1) return;
					characterJudge.onlyHurtTime = getBuffValue(type);
					if(characterJudge.onlyHurtTime == 0){
						characterJudge.isOnlyHurt = false;
					}else{
						characterJudge.isOnlyHurt = true;
					}
					break;
				//无敌
				case BuffType.BUFF_INVINCIBLE:
					if(characterJudge.inviclbleTime <= -1) return;
					characterJudge.inviclbleTime = getBuffValue(type);
					if(characterJudge.inviclbleTime == 0){
						characterJudge.isInvincible = false;
					}else{
						characterJudge.isInvincible = true;
					}
					break;
				
			}
		}
		
		//检测死亡
		public function checkDead() : Boolean{
			if(useProperty.hp <= 0)
				return true;
			else
				return false;
		}
		
		//改变Hp
		public function changeHp(count:int) : void{
			useProperty.hp -= count;
			/*if(characterType == CharacterType.PLAYER
				&& SceneManager.getIns().sceneType == SceneManager.NORMAL_SCENE
				&& PlayerManager.getIns().hasProtect){
				if(useProperty.hp <= NumberConst.getIns().zero){
					useProperty.hp = NumberConst.getIns().one;
				}
			}*/
			if(useProperty.hp > totalProperty.hp){
				useProperty.hp = totalProperty.hp;
			}
			_playerUIControl.setHP(useProperty.hp, totalProperty.hp, characterType, characterBarIndex);
		}
		
		//改变Mp
		public function changeMp(count:int) : void{
			useProperty.mp -= count;
			if(useProperty.mp > totalProperty.mp){
				useProperty.mp = totalProperty.mp;
			}
			_playerUIControl.setMP(useProperty.mp, totalProperty.mp, characterType, characterBarIndex);
		}
		
		//技能是否可以随时释放
		public function skillReleaseJudge(actionState:uint) : Boolean{
			var result:Boolean = false;
			for(var i:int = 0; i < 10; i++){
				if(i == actionState - ActionState.SKILLBASE - 1){
					if(skillConfigurationVo.releaseSkillList[i] > 0){
						result = true;
					}
				}
			}
			return result;
		}
		
		//技能冷却时间判断
		public function skillColdTimeJudge(actionState:uint):Boolean{
			var result:Boolean = false;
			for(var i:int = 0; i < 10; i++){
				if(i == actionState - ActionState.SKILLBASE - 1){
					if(skillConfigurationVo.nowColdTimeList[i] > 0){
						result = true;
					}
				}
			}
			return result;
		}
		
		//技能消耗mp判断
		public function skillMpJudge(actionState:uint) : Boolean{
			var result:Boolean = false;
			for(var i:int = 0; i < 10; i++){
				if(i == actionState - ActionState.SKILLBASE - 1){
					if(skillConfigurationVo.mpUseList[i] > useProperty.mp){
						result = true;
					}
				}
			}
			return result;
		}
		
		//检测在正确的帧上释放普通攻击
		public function checkFrameCommonHit(keyFrame:int, count:int) : Boolean{
			var result:Boolean = false;
			for(var i:int = 0; i < skillConfigurationVo.commonFrameList[count].length; i++){
				if(keyFrame == skillConfigurationVo.commonFrameList[count][i]){
					result = true;
				}
			}
			return result;
		}
		
		//检测在正确的帧上释放技能
		public function checkFrameSKill(keyFrame:int, count:int, skillID:int) : Boolean{
			var result:Boolean = false;
			for(var i:int = 0; i < skillConfigurationVo.skillFrameList[count].length; i++){
				if(keyFrame == skillConfigurationVo.skillFrameList[count][i]){
					result = true;
				}
			}
			return result;
		}
		
		//删除怒气Buff
		private function removeBuringBuff():void
		{
			for(var i:int = 0; i < buringBuffStatus.length; i++){
				removeBuff(buringBuffStatus[i].buffType, buringBuffStatus[i].buffValue);
			}
			buringBuffStatus.length = 0;
		}		
		
		//设置冷却时间
		public function setSkillColdDown(count:int) : void{
			if(PlayerManager.getIns().hasProtect){
				skillConfigurationVo.nowColdTimeList[count] = skillConfigurationVo.skillColdTimeList[count] * NumberConst.getIns().percent50;
				changeMp(0);
				_playerUIControl.setSkillColdDown(count + 1, skillConfigurationVo.skillColdTimeList[count] * NumberConst.getIns().percent50, characterType);
			}else{
				skillConfigurationVo.nowColdTimeList[count] = skillConfigurationVo.skillColdTimeList[count];
				changeMp(skillConfigurationVo.mpUseList[count]);
				_playerUIControl.setSkillColdDown(count + 1, skillConfigurationVo.skillColdTimeList[count], characterType);
			}
		}
		
		private var _stepTime:int;
		public function step() : void{
			coldTimeStep();
			skillMpStep();
			invicibleStep();
			onlyHurtStep();
			temptationStep();
			protectedStep();
			_stepTime++;
			if(_stepTime == 30){
				hpRegain();
				mpRegain();
				angerDown();
				bossRegain();
				buffHpRegain();
				_stepTime = 0;
			}
		}
		
		private function protectedStep():void{
			
		}
		
		private function bossRegain():void{
			if(characterType == CharacterType.PLAYER
				|| characterType == CharacterType.OTHER_PLAYER
				|| characterType == CharacterType.PARTNER_PLAYER){
				bossCount += bossRegainCount;
				/*if(ShopManager.getIns().vipLv >= NumberConst.getIns().four){
					bossCount += bossRegainCount;
				}else{
					bossCount += bossRegainCount;
				}*/
			}
		}
		
		private function buffHpRegain():void{
			if(getBuffValue(9) != 0){
				useProperty.hp += totalProperty.hp * getBuffValue(9);
				if(useProperty.hp > totalProperty.hp){
					useProperty.hp = totalProperty.hp;
				}
				_playerUIControl.setHP(useProperty.hp, totalProperty.hp, characterType, characterBarIndex);
			}
		}
		
		//魅惑时间计算
		private function temptationStep() : void{
			if(characterJudge.temptationTime > 0){
				characterJudge.temptationTime--;
				if(characterJudge.temptationTime <= 0){
					characterJudge.isTemptation = false;
					characterJudge.unMoveTime = 0;
					characterJudge.isUnMoveStatus = false;
				}
			}else if(characterJudge.temptationTime <= -1){
				characterJudge.isTemptation = true;
			}
		}
		
		//霸体时间计算
		private function onlyHurtStep():void{
			if(characterJudge.onlyHurtTime > 0){
				characterJudge.onlyHurtTime--;
				if(characterJudge.onlyHurtTime <= 0){
					characterJudge.isOnlyHurt = false;
				}
			}else if(characterJudge.onlyHurtTime <= -1){
				characterJudge.isOnlyHurt = true;
			}
		}
		
		//无敌时间计算
		private function invicibleStep():void{
			if(characterJudge.inviclbleTime > 0){
				characterJudge.inviclbleTime--;
				if(characterJudge.inviclbleTime <= 0){
					characterJudge.isInvincible = false;
				}
			}else if(characterJudge.inviclbleTime <= -1){
				characterJudge.isInvincible = true;
			}
		}
		
		//技能冷却时间每帧减少
		private function coldTimeStep():void{
			if(characterType == CharacterType.PLAYER
				|| characterType == CharacterType.OTHER_PLAYER
				|| characterType == CharacterType.PARTNER_PLAYER){
				for(var i:int = 0; i < skillConfigurationVo.nowColdTimeList.length; i++){
					if(skillConfigurationVo.nowColdTimeList[i] <= 0){
						skillConfigurationVo.nowColdTimeList[i] = 0;
					}else{
						skillConfigurationVo.nowColdTimeList[i]--;
					}
				}
			}
		}
		
		//判断技能图标显示效果
		private function skillMpStep():void{
			if(characterType == CharacterType.PLAYER || characterType == CharacterType.PARTNER_PLAYER){
				_playerUIControl.skillMpSet(skillConfigurationVo.checkMpUse(useProperty.mp), characterType);
			}
		}
		
		//hp恢复
		private function hpRegain() : void{
			if(useProperty != null && useProperty.hp_regain > 0 && useProperty.hp > 0){
				if(useProperty.hp < totalProperty.hp){
					useProperty.hp += useProperty.hp_regain;
					if(useProperty.hp > totalProperty.hp){
						useProperty.hp = totalProperty.hp;
					}
					_playerUIControl.setHP(useProperty.hp, totalProperty.hp, characterType, characterBarIndex);
				}
			}
		}
		
		//mp恢复
		private function mpRegain() : void{
			if(useProperty != null && useProperty.mp_regain > 0 && useProperty.hp > 0){
				if(useProperty.mp < totalProperty.mp){
					useProperty.mp += useProperty.mp_regain;
					if(useProperty.mp > totalProperty.mp){
						useProperty.mp = totalProperty.mp;
					}
					_playerUIControl.setMP(useProperty.mp, totalProperty.mp, characterType, characterBarIndex);
				}
			}
		}
		
		//怒气下降
		private function angerDown() : void{
			if(startAngerDown){
				angerCount -= 5;
				if(angerCount <= 0){
					startAngerDown = false;
					angerCount = 0;
					removeBuringBuff();
				}
			}
		}
		
		//复活
		public function relive() : void{
			this.useProperty.hp = this.totalProperty.hp;
			this.useProperty.mp = this.totalProperty.mp;
			this.startAngerDown = false;
			this.angerCount = 10 * 10;
			this.bossCount = 10 * 10;
			this.characterJudge.relive();
			this.skillConfigurationVo.resetColdTime();
			removeAllBuff();
			changeHp(0);
			changeMp(0);
		}
		
		private function removeAllBuff():void
		{
			removeBuringBuff();
			for(var i:int = buffStatus.length - 1; i >= 0; i--){
				var buff:BuffVo = buffStatus.pop();
				setBuffStatus(buff.buffType);
				buff = null;
			}
			buffStatus.length = 0;
		}
		
		public function assignConfigProperty() : void
		{
			var properyVo:BasePropertyVo = new BasePropertyVo();
			properyVo.hp = characterConfig.hp;
			properyVo.mp = characterConfig.mp;
			properyVo.atk = characterConfig.atk;
			properyVo.def = characterConfig.def;
			properyVo.ats = characterConfig.ats;
			properyVo.adf = characterConfig.adf;
			properyVo.spd = characterConfig.spd;
			properyVo.hit = characterConfig.hit;
			properyVo.evasion = characterConfig.evasion;
			properyVo.crit = characterConfig.crit;
			properyVo.toughness = characterConfig.toughness;
			properyVo.hp_regain = characterConfig.hp_regain;
			properyVo.mp_regain = characterConfig.mp_regain;
			
			configProperty = properyVo;
		}

		
		/**
		 * 附体属性
		 */
		private var _attachProperty:BasePropertyVo;
		
		public function get attachProperty():BasePropertyVo
		{
			return _attachProperty;
		}
		
		public function set attachProperty(value:BasePropertyVo):void
		{
			_attachProperty = value;
		}


		
		/**
		 * 八卦牌属性
		 */
		private var _baGuaProperty:BasePropertyVo;
		public function get baGuaProperty():BasePropertyVo
		{
			return _baGuaProperty;
		}
		public function set baGuaProperty(value:BasePropertyVo):void
		{
			_baGuaProperty = value;
		}
		
		
		/**
		 * 时装属性
		 */
		private var _fashionProperty:BasePropertyVo;
		public function get fashionProperty():BasePropertyVo
		{
			return _fashionProperty;
		}
		public function set fashionProperty(value:BasePropertyVo):void
		{
			_fashionProperty = value;
		}
		
		
		/**
		 * 经脉属性
		 */
		private var _jingMaiProperty:BasePropertyVo;
		public function get jingMaiProperty():BasePropertyVo
		{
			return _jingMaiProperty;
		}
		public function set jingMaiProperty(value:BasePropertyVo):void
		{
			_jingMaiProperty = value;
		}
		
		/**
		 * 称号属性
		 */
		private var _titleProperty:BasePropertyVo;
		public function get titleProperty():BasePropertyVo
		{
			return _titleProperty;
		}
		public function set titleProperty(value:BasePropertyVo):void
		{
			_titleProperty = value;
		}
		
		
		public function assignLevelUpProperty(data:Object):void{
			var obj:CharactersUp = data as CharactersUp;
			var properyVo:BasePropertyVo = new BasePropertyVo();
			properyVo.hp = (lv - 1) * obj.hp_rate;
			properyVo.mp = (lv - 1) * obj.mp_rate;
			properyVo.atk = (lv - 1) * obj.atk_rate;
			properyVo.def = (lv - 1) * obj.def_rate;
			properyVo.ats = (lv - 1) * obj.ats_rate;
			properyVo.adf = (lv - 1) * obj.adf_rate;
			
			levelUpProperty = properyVo;
		}
		
		public var useProperty:BasePropertyVo;
		/**
		 * 总属性
		 */		
		public var totalProperty:BasePropertyVo;
		
		
		public function countTotalProperty():void{
			totalProperty.hp = configProperty.hp + equipProperty.hp + levelUpProperty.hp + attachProperty.hp + baGuaProperty.hp + fashionProperty.hp + jingMaiProperty.hp + heroUpgradeProperty.hp + titleProperty.hp ;
			totalProperty.mp = configProperty.mp + equipProperty.mp + levelUpProperty.mp + attachProperty.mp + baGuaProperty.mp + fashionProperty.mp + jingMaiProperty.mp + heroUpgradeProperty.mp  + titleProperty.mp;
			totalProperty.atk = configProperty.atk + equipProperty.atk + levelUpProperty.atk + attachProperty.atk + baGuaProperty.atk + fashionProperty.atk + jingMaiProperty.atk + heroUpgradeProperty.atk  + titleProperty.atk;
			totalProperty.def = configProperty.def + equipProperty.def + levelUpProperty.def + attachProperty.def + baGuaProperty.def + fashionProperty.def + jingMaiProperty.def + heroUpgradeProperty.def  + titleProperty.def;
			totalProperty.ats = configProperty.ats + equipProperty.ats + levelUpProperty.ats + attachProperty.ats + baGuaProperty.ats + fashionProperty.ats + jingMaiProperty.ats + heroUpgradeProperty.ats  + titleProperty.ats;
			totalProperty.adf = configProperty.adf + equipProperty.adf + levelUpProperty.adf + attachProperty.adf + baGuaProperty.adf + fashionProperty.adf + jingMaiProperty.adf + heroUpgradeProperty.adf  + titleProperty.adf;
			totalProperty.spd = configProperty.spd + equipProperty.spd + levelUpProperty.spd + baGuaProperty.spd;
			totalProperty.atk_spd = configProperty.atk_spd + equipProperty.atk_spd + levelUpProperty.atk_spd + baGuaProperty.atk_spd;
			totalProperty.crit = configProperty.crit + equipProperty.crit* .01 + levelUpProperty.crit + baGuaProperty.crit * .01 + jingMaiProperty.crit*.01;
			totalProperty.toughness = configProperty.toughness + equipProperty.toughness* .01 + levelUpProperty.toughness + baGuaProperty.toughness * .01 + jingMaiProperty.toughness*.01;
			totalProperty.hit = configProperty.hit + equipProperty.hit* .01 + levelUpProperty.hit + baGuaProperty.hit * .01 + jingMaiProperty.hit*.01;
			totalProperty.evasion = configProperty.evasion + equipProperty.evasion* .01 + levelUpProperty.evasion + baGuaProperty.evasion * .01 + jingMaiProperty.evasion*.01;
			totalProperty.hp_regain = configProperty.hp_regain + equipProperty.hp_regain + levelUpProperty.hp_regain + baGuaProperty.hp_regain + jingMaiProperty.hp_regain;
			totalProperty.mp_regain = configProperty.mp_regain + equipProperty.mp_regain + levelUpProperty.mp_regain + baGuaProperty.mp_regain + jingMaiProperty.mp_regain;
			totalProperty.hurt_deepen = configProperty.hurt_deepen + equipProperty.hurt_deepen* .01 + levelUpProperty.hurt_deepen + baGuaProperty.hurt_deepen * .01 + jingMaiProperty.hurt_deepen* .01;
			totalProperty.hurt_reduce = configProperty.hurt_reduce + equipProperty.hurt_reduce* .01 + levelUpProperty.hurt_reduce + baGuaProperty.hurt_reduce * .01 + jingMaiProperty.hurt_reduce* .01;
			
			countUseProperty();
		}
		
		//维护数据
		private function countUseProperty():void{
			//if(useProperty == null){
				useProperty = new BasePropertyVo();
				useProperty.hp = totalProperty.hp;
				useProperty.mp = totalProperty.mp;
			/*}else{
				var rateHp:Number = useProperty.hp / totalProperty.hp;
				useProperty.hp = int(totalProperty.hp * rateHp);
				var rateMp:Number = useProperty.mp / totalProperty.mp;
				useProperty.mp = int(totalProperty.mp * rateMp);
			}*/
			useProperty.atk = totalProperty.atk;
			useProperty.def = totalProperty.def;
			useProperty.ats = totalProperty.ats;
			useProperty.adf = totalProperty.adf;
			useProperty.spd = totalProperty.spd;
			useProperty.atk_spd = totalProperty.atk_spd;
			useProperty.crit = totalProperty.crit;
			useProperty.toughness = totalProperty.toughness;
			useProperty.hit = totalProperty.hit;
			useProperty.evasion = totalProperty.evasion;
			useProperty.hp_regain = totalProperty.hp_regain;
			useProperty.mp_regain = totalProperty.mp_regain;
			useProperty.hurt_deepen = totalProperty.hurt_deepen;
			useProperty.hurt_reduce = totalProperty.hurt_reduce;
			
			speedEntity.changeSpeed(useProperty.spd);
		}
		
		//角色id
		public function get id():int
		{
			return _anti["id"];
		}
		
		public function set id(value:int):void
		{
			_anti["id"] = value;
		}
		
		//角色名称
		public function get name():String
		{
			return _anti["name"];
		}
		
		public function set name(value:String):void
		{
			_anti["name"] = value;
		}
		
		//角色等级
		public function get lv():int
		{
			return _anti["lv"];
		}
		
		public function set lv(value:int):void
		{
			_anti["lv"] = value;
		}
		
		
		//角色定位
		public function get location():String
		{
			return _anti["location"];
		}
		
		public function set location(value:String):void
		{
			_anti["location"] = value;
		}

		
		//角色信息
		public function get info():String
		{
			return _anti["info"];
		}
		
		public function set info(value:String):void
		{
			_anti["info"] = value;
		}
		
		public function get startAngerDown() : Boolean{
			return _anti["startAngerDown"];
		}
		public function set startAngerDown(value:Boolean) : void{
			_anti["startAngerDown"] = value;
			if(value == true){
				_playerUIControl.onBuringDown(characterType);
			}else if(value == false){
				_playerUIControl.removeBuringDown(characterType);
			}
		}
		//怒气
		public function get angerCount() : int{
			return _anti["angerCount"];
		}
		public function set angerCount(value:int) : void{
			if(startAngerDown && angerCount < value) return;
			if(value > 100)	value = 100;
			_anti["angerCount"] = value;
			_playerUIControl.setAnger(angerCount/ 100, characterType);
		}
		
		public function get bossCount() : int{
			return _anti["bossCount"];
		}
		public function set bossCount(value:int) : void{
			if(value > 100)	value = 100;
			_anti["bossCount"] = value;
			_playerUIControl.addBossCount(value / 100, characterType);
		}
		
		
		//角色受到的总共伤害
		public function set allHurtCount(value:int) : void{
			_anti["allHurtCount"] = value;
		}
		public function get allHurtCount() : int{
			return _anti["allHurtCount"];
		}
		
		public function get playerUIControl() : PlayerUIControl{
			return _playerUIControl;
		}
		
		
		public function destroy() : void{
			_playerUIControl = null;
			_characterConfig = null;
			_configProperty = null;
			_equipProperty = null;
			_levelUpProperty = null;
			_attachProperty = null;
			_fashionProperty = null;
			_jingMaiProperty = null;
			totalProperty = null;
			speedEntity = null;
			characterJudge = null;
			if(buffStatus){
				buffStatus.length = 0;
				buffStatus = null;
			}
			if(buringBuffStatus){
				buringBuffStatus.length = 0;
				buringBuffStatus = null;
			}
			if(skillConfigurationVo){
				skillConfigurationVo.destroy();
				skillConfigurationVo = null;
			}
		}
		
	}
}