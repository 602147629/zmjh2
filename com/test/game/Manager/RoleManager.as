package com.test.game.Manager
{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Const.SequenceConst;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Keyboard.KeyboardInput;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.CharacterType;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.OccupationConst;
	import com.test.game.Effect.DisappearEffect;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Conjure.ChiNanConjureEntity;
	import com.test.game.Entitys.Conjure.ConjureEntity;
	import com.test.game.Entitys.Conjure.JianMoWangHunConjureEntity;
	import com.test.game.Entitys.Conjure.YinYangZhenRenConjureEntity;
	import com.test.game.Entitys.Conjure.YuanNvConjureEntity;
	import com.test.game.Entitys.Map.ItemIconEntity;
	import com.test.game.Entitys.Monsters.BaseMonsterEntity;
	import com.test.game.Entitys.Monsters.ChiNanEntity;
	import com.test.game.Entitys.Monsters.EscortEntity;
	import com.test.game.Entitys.Monsters.FunnyBossOneEntity;
	import com.test.game.Entitys.Monsters.JianMoWangHunEntity;
	import com.test.game.Entitys.Monsters.JueXiuJiaoQiaoEntity;
	import com.test.game.Entitys.Monsters.SkillShowEntity;
	import com.test.game.Entitys.Monsters.TanDeWuYanEntity;
	import com.test.game.Entitys.Monsters.YinYangZhenRenEntity;
	import com.test.game.Entitys.Monsters.YinYangZhenRenShowEntity;
	import com.test.game.Entitys.Monsters.YuanNvEntity;
	import com.test.game.Entitys.Roles.KuangWuEntity;
	import com.test.game.Entitys.Roles.XiaoYaoEntity;
	import com.test.game.Entitys.Show.ShowRoleEntity;
	import com.test.game.Entitys.Weather.ThunderEntity;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Manager.Activity.MidAutumnManager;
	import com.test.game.Manager.Activity.QingMingManager;
	import com.test.game.Modules.MainGame.BossBattleBar;
	import com.test.game.Modules.MainGame.HeroBattleBar;
	import com.test.game.Mvc.BmdView.EscortSceneView;
	import com.test.game.Mvc.Vo.BasePropertyVo;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.EnemyVo;
	import com.test.game.Mvc.Vo.FashionVo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.Vo.SkillInfo;
	import com.test.game.Mvc.Vo.SkillUpVo;
	import com.test.game.Mvc.Vo.TitleVo;
	import com.test.game.Utils.EnemyUtils;
	
	import flash.events.Event;
	
	public class RoleManager extends Singleton{
		private var _target:CharacterEntity;
		private var _replaceTarget:SequenceActionEntity;
		private var _replaceList:Array = new Array();
		public var fightType:int;
		public function RoleManager(){
			super();
		}
		
		public static function getIns():RoleManager{
			return Singleton.getIns(RoleManager);
		}
		
		public function getEscortProperty() : Object{
			var result:Object = new Object();
			result.name = PlayerManager.getIns().player.name;
			result.occupation = PlayerManager.getIns().player.occupation;
			result.lv = PlayerManager.getIns().player.character.lv;
			result.assistInfo = PlayerManager.getIns().player.assistInfo;
			result.ConfigProperty = PlayerManager.getIns().ConfigProperty;
			result.EquipProperty = PlayerManager.getIns().EquipProperty;
			result.LevelUpProperty = PlayerManager.getIns().LevelUpProperty;
			result.AttachProperty = PlayerManager.getIns().AttachProperty;
			result.BaGuaProperty = PlayerManager.getIns().BaGuaProperty;
			result.FashionProperty = PlayerManager.getIns().FashionProperty;
			result.JingMaiProperty = PlayerManager.getIns().JingMaiProperty;
			result.assetsArray = PlayerManager.getIns().getEquipped();
			result.skill = PlayerManager.getIns().player.skill;
			result.skillUp = PlayerManager.getIns().player.skillUp;
			result.fashionInfo = PlayerManager.getIns().player.fashionInfo;
			if(PlayerManager.getIns().player.assistInfo != -1){
				result.ConjureLv = PackManager.getIns().searchAssistedBossCard(PlayerManager.getIns().player.assistInfo).lv;
			}else{
				result.ConjureLv = -1;
			}
			result.EscortType = EscortManager.getIns().nowBiaoChe;
			result.fightNum = PlayerManager.getIns().battlePower;
			result.vipLv = ShopManager.getIns().vipLv;

			return result;
		}
		
		public function getPlayerProperty() : Object{
			var result:Object = new Object();
			result.name = PlayerManager.getIns().player.name;
			result.occupation = PlayerManager.getIns().player.occupation;
			result.lv = PlayerManager.getIns().player.character.lv;
			result.assistInfo = PlayerManager.getIns().player.assistInfo;
			result.ConfigProperty = PlayerManager.getIns().ConfigProperty;
			result.EquipProperty = PlayerManager.getIns().EquipProperty;
			result.LevelUpProperty = PlayerManager.getIns().LevelUpProperty;
			result.AttachProperty = PlayerManager.getIns().AttachProperty;
			result.BaGuaProperty = PlayerManager.getIns().BaGuaProperty;
			result.FashionProperty = PlayerManager.getIns().FashionProperty;
			result.JingMaiProperty = PlayerManager.getIns().JingMaiProperty;
			result.TitleProperty = PlayerManager.getIns().TitleProperty;
			result.assetsArray = PlayerManager.getIns().getEquipped();
			result.skill = PlayerManager.getIns().player.skill;
			result.skillUp = PlayerManager.getIns().player.skillUp;
			result.fashionInfo = PlayerManager.getIns().player.fashionInfo;
			if(PlayerManager.getIns().player.assistInfo != -1){
				result.ConjureLv = PackManager.getIns().searchAssistedBossCard(PlayerManager.getIns().player.assistInfo).lv;
			}else{
				result.ConjureLv = -1;
			}
			result.pkInfo = PlayerManager.getIns().player.pkInfo;
			result.fightNum = PlayerManager.getIns().battlePower;
			result.operateMode = GameSettingManager.getIns().operateMode;
			result.vipLv = ShopManager.getIns().vipLv;
			result.titleInfo = PlayerManager.getIns().player.titleInfo;
			
			return result;
		}
		
		private function getPropertyVo(data:Object) : BasePropertyVo{
			var propertyVo:BasePropertyVo = new BasePropertyVo();
			propertyVo.init(data)
			return propertyVo;
		}
		
		private function getSkillUpInfo(data:Object) : SkillUpVo{
			var skillUp:SkillUpVo = new SkillUpVo();
			skillUp.init(data);
			return skillUp;
		}
		
		private function getSkillInfo(data:Object) : SkillInfo{
			var skillInfo:SkillInfo = new SkillInfo();
			skillInfo.initData(data);
			return skillInfo;
		}
		
		private function getFashionInfo(data:Object) : FashionVo{
			var fashionInfo:FashionVo = new FashionVo();
			fashionInfo.fashionId = data.fashionId;
			fashionInfo.showFashion = data.showFashion;
			return fashionInfo;
		}
		
		private function getTitleInfo(data:Object) : TitleVo{
			var titleInfo:TitleVo = new TitleVo();
			titleInfo.titleNow = data.titleNow;
			return titleInfo;
		}
		
		//创建主角
		public function createPlayer(xPos:int, yPos:int, data:Object = null, isHpCount:int = 1) : PlayerEntity{
			var isSingleGame:Boolean = (data.data==null?true:false);
			var playerData:Object = null;
			var gameKey:String = "";
			if(!isSingleGame){
				playerData = data.data;
				gameKey = data.gameKey;
				playerData.ConfigProperty = getPropertyVo(playerData.ConfigProperty);
				playerData.EquipProperty = getPropertyVo(playerData.EquipProperty);
				playerData.LevelUpProperty = getPropertyVo(playerData.LevelUpProperty);
				playerData.AttachProperty = getPropertyVo(playerData.AttachProperty);
				playerData.BaGuaProperty = getPropertyVo(playerData.BaGuaProperty);
				playerData.FashionProperty = getPropertyVo(playerData.FashionProperty);
				if(playerData.TitleProperty != null){
					playerData.TitleProperty = getPropertyVo(playerData.TitleProperty);
				}
				playerData.JingMaiProperty = getPropertyVo(playerData.JingMaiProperty);
				playerData.skill = getSkillInfo(playerData.skill);
				playerData.skillUp = getSkillUpInfo(playerData.skillUp);
				playerData.fashionInfo = getFashionInfo(playerData.fashionInfo);
				if(playerData.titleInfo != null){
					playerData.titleInfo = getTitleInfo(playerData.titleInfo);
				}
			}else{
				playerData = getPlayerProperty();
			}
			var obj:Object = com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData(AssetsConst.CHARACTERS)).RECORDS[playerData.occupation - 1];
			var roleType:uint = getRoleType(playerData.occupation);
			var roleVo:CharacterVo = new CharacterVo();
			roleVo.id = obj.id;
			roleVo.configProperty = playerData.ConfigProperty;
			roleVo.equipProperty = playerData.EquipProperty;
			roleVo.levelUpProperty = playerData.LevelUpProperty;
			roleVo.attachProperty = playerData.AttachProperty;
			roleVo.baGuaProperty = playerData.BaGuaProperty;
			roleVo.fashionProperty = playerData.FashionProperty;
			roleVo.jingMaiProperty = playerData.JingMaiProperty;
			if(playerData.TitleProperty != null){
				roleVo.titleProperty = playerData.TitleProperty;
			}
			roleVo.countTotalProperty();
			roleVo.characterType = CharacterType.PLAYER;
			if(isHpCount != 1){
				roleVo.totalProperty.hp *= isHpCount;
				roleVo.useProperty.hp = roleVo.totalProperty.hp;
			}
			if(playerData.vipLv != null && playerData.vipLv >= NumberConst.getIns().four){
				roleVo.bossRegainCount = NumberConst.getIns().two;
			}
			roleVo.fashionInfo = playerData.fashionInfo;
			roleVo.assetsArray = playerData.assetsArray;
			roleVo.isDouble = true;
			roleVo.sequenceId = roleType;
			
			var player:PlayerEntity;
			switch(roleType){
				case SequenceConst.ROLE_XIAOYAO:
					player = new XiaoYaoEntity(roleVo);
					player.playerName = "XiaoYao";
					break;
				case SequenceConst.ROLE_KUANGWU:
					player = new KuangWuEntity(roleVo);
					player.playerName = "KuangWu";
					break;
			}
			
			var playerObj:PlayerVo = new PlayerVo();
			playerObj.name = playerData.name;
			playerObj.assistInfo = playerData.assistInfo;
			playerObj.occupation = playerData.occupation;
			playerObj.operateMode = playerData.operateMode;
			if(!isSingleGame && gameKey != null){
				playerObj.gameKey = gameKey;
			}
			playerObj.index = data.index;
			playerObj.character = roleVo;
			playerObj.character.lv = playerData.lv;
			playerObj.fodder = player.playerName;
			playerObj.skill = playerData.skill;
			playerObj.skillUp = playerData.skillUp;
			if(playerData.titleInfo != null){
				playerObj.titleInfo = playerData.titleInfo;
			}
			MyUserManager.getIns().player = playerObj;
			player.player = playerObj;
			player.keyBoard = new KeyboardInput();
			player.initPlayerParams(playerData.ConjureLv);
			player.x = xPos;
			player.y = yPos;
			if(xPos > 3800){
				player.faceHorizontalDirect = DirectConst.DIRECT_LEFT;
			}
			player.addEventListener(CharacterEvent.CHARACTER_DEAD_EVENT, playerDeath);
			
			RenderEntityManager.getIns().addEntity(player);
			PhysicsWorld.getIns().addEntity(player);
			
			return player;
		}
		
		public function getOnlyHpAndMp() : Array{
			var roleVo:CharacterVo = new CharacterVo();
			roleVo.id = (PlayerManager.getIns().player.occupation==1?2:1);
			roleVo.configProperty = PlayerManager.getIns().ConfigProperty;
			roleVo.levelUpProperty = PlayerManager.getIns().LevelUpProperty;
			roleVo.heroUpgradeProperty = PlayerManager.getIns().heroUpgradeProperty;
			//roleVo.titleProperty = PlayerManager.getIns().TitleProperty;
			roleVo.countTotalProperty();
			
			return [roleVo.totalProperty.hp, roleVo.totalProperty.mp];
		}
		
		//获得伙伴的详细数据
		public function getPartnerPlayerProperty() : Object{
			var result:Object = new Object();
			result.name = PlayerManager.getIns().player.name;
			result.occupation = (PlayerManager.getIns().player.occupation==1?2:1);
			result.lv = PlayerManager.getIns().player.character.lv;
			result.assistInfo = PlayerManager.getIns().player.assistInfo;
			result.ConfigProperty = PlayerManager.getIns().ConfigProperty;
			result.LevelUpProperty = PlayerManager.getIns().LevelUpProperty;
			result.heroUpgradeProperty = PlayerManager.getIns().heroUpgradeProperty;
			result.assetsArray = PlayerManager.getIns().getPartnerEquipped();
			result.skill = getPartnerSkill();
			//result.skillUp = PlayerManager.getIns().player.skillUp;
			result.fashionInfo = PlayerManager.getIns().player.fashionInfo;
			if(PlayerManager.getIns().player.assistInfo != -1){
				result.ConjureLv = PackManager.getIns().searchAssistedBossCard(PlayerManager.getIns().player.assistInfo).lv;
			}else{
				result.ConjureLv = -1;
			}
			result.pkInfo = PlayerManager.getIns().player.pkInfo;
			result.fightNum = PlayerManager.getIns().battlePower;
			
			return result;
		}
		
		private function getPartnerSkill() : SkillInfo{
			var skill:SkillInfo = new SkillInfo();
			skill.skill_H = 1;
			skill.skill_U = 2;
			skill.skill_I = 3;
			skill.skill_O = 6;
			skill.skill_L = 7;
			return skill;
		}
		
		public function getPartnerInfo() : Array{
			var fodder:String;
			var name:String;
			if(PlayerManager.getIns().player.occupation == 1){
				fodder = "XiaoYao";
				name = "逍遥";
			}else{
				fodder = "KuangWu";
				name = "狂武";
			}
			return new Array(name, fodder);
		}
		
		public function createPartnerPlayer(xPos:int, yPos:int, data:Object = null) : PlayerEntity{
			var playerData:Object = null;
			playerData = getPartnerPlayerProperty();
			var obj:Object = com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData(AssetsConst.CHARACTERS)).RECORDS[playerData.occupation - 1];
			var roleType:uint = getRoleType(playerData.occupation);
			var roleVo:CharacterVo = new CharacterVo();
			roleVo.id = obj.id;
			roleVo.configProperty = playerData.ConfigProperty;
			roleVo.levelUpProperty = playerData.LevelUpProperty;
			roleVo.heroUpgradeProperty = playerData.heroUpgradeProperty;
			roleVo.countTotalProperty();
			roleVo.characterType = CharacterType.PARTNER_PLAYER;
			roleVo.fashionInfo = playerData.fashionInfo;
			roleVo.assetsArray = playerData.assetsArray;
			roleVo.isDouble = true;
			roleVo.sequenceId = roleType;
			if(playerData.vipLv != null && playerData.vipLv >= NumberConst.getIns().four){
				roleVo.bossRegainCount = NumberConst.getIns().two;
			}
			
			var player:PlayerEntity;
			switch(roleType){
				case SequenceConst.ROLE_XIAOYAO:
					player = new XiaoYaoEntity(roleVo);
					player.playerName = "XiaoYao";
					break;
				case SequenceConst.ROLE_KUANGWU:
					player = new KuangWuEntity(roleVo);
					player.playerName = "KuangWu";
					break;
			}
			
			var playerObj:PlayerVo = new PlayerVo();
			playerObj.name = playerData.name;
			playerObj.assistInfo = playerData.assistInfo;
			playerObj.occupation = playerData.occupation;
			playerObj.index = 1;
			playerObj.character = roleVo;
			playerObj.character.lv = playerData.lv;
			playerObj.fodder = player.playerName;
			playerObj.skill = playerData.skill;
			playerObj.skillUp = playerData.skillUp;
			MyUserManager.getIns().partnerPlayer = playerObj;
			
			player.player = playerObj;
			player.keyBoard = new KeyboardInput();
			player.initPlayerParams(playerData.ConjureLv);
			player.x = xPos;
			player.y = yPos;
			player.addEventListener(CharacterEvent.CHARACTER_DEAD_EVENT, playerDeath);
			
			RenderEntityManager.getIns().addEntity(player);
			PhysicsWorld.getIns().addEntity(player);
			
			return player;
		}
		
		private function getRoleType(dataIndex:int) : uint{
			var result:int;
			switch(dataIndex){
				case 1:
					result = SequenceConst.ROLE_KUANGWU;
					break;
				case 2:
					result = SequenceConst.ROLE_XIAOYAO;
					break;
			}
			return result;
		}
		
		public function addPlayerDeathEvent(player:PlayerEntity) : void{
			player.addEventListener(CharacterEvent.CHARACTER_DEAD_EVENT, playerDeath);
		}
		
		private function playerDeath(e:CharacterEvent) : void{
			var player:PlayerEntity = e.target as PlayerEntity;
			player.removeEventListener(CharacterEvent.CHARACTER_DEAD_EVENT, playerDeath);
			SceneManager.getIns().playerDeath(player);
		}
		
		//创建援护
		public function createConjure(obj:Object, lv:int, belong:PlayerEntity) : ConjureEntity{
			var cVo:CharacterVo = EnemyUtils.assignConjure(obj.ID, lv);
			cVo.sequenceId = obj.sid;
			cVo.assetsArray = obj.fodder.split("|");
			cVo.isDouble = true;
			cVo.characterType = CharacterType.CONJURE;
			var conjure:ConjureEntity;
			switch(obj.ID){
				case 2109:
					conjure = new YinYangZhenRenConjureEntity(cVo, obj);
					break;
				case 2012:
					conjure = new JianMoWangHunConjureEntity(cVo, obj);
					break;
				case 2209:
					conjure = new ChiNanConjureEntity(cVo, obj);
					break;
				case 2219:
					conjure = new YuanNvConjureEntity(cVo, obj);
					break;
				default:
					conjure = new ConjureEntity(cVo, obj);
					break;
			}
			conjure.renderSpeed = 1;
			conjure.belong = belong;
			
			return conjure;
		}
		
		public function addConjure(conjure:ConjureEntity) : void{
			RenderEntityManager.getIns().addEntity(conjure);
			PhysicsWorld.getIns().addEntity(conjure);
			if(SceneManager.getIns().nowScene != null){
				SceneManager.getIns().nowScene.addChild(conjure);
			}
		}
		
		public function removeConjure(conjure:ConjureEntity) : void{
			RenderEntityManager.getIns().removeEntity(conjure);
			PhysicsWorld.getIns().removeEntity(conjure);
			if(conjure.parent != null){
				conjure.parent.removeChild(conjure);
			}
		}
		
		public function createQingMingMonster(monsterID:int, lv:int) : MonsterEntity{
			var mVo:CharacterVo = EnemyUtils.assignEnemy(monsterID, lv);
			mVo.characterType = (mVo as EnemyVo).type;
			var mon:BaseMonsterEntity = new BaseMonsterEntity(mVo);
			mon.renderSpeed = 1;
			mon.addEventListener(CharacterEvent.CHARACTER_DEAD_EVENT, qingMingMonsterDeath);
			mon.addEventListener(CharacterEvent.MONSTER_CLEAR_EVENT, monsterClear);
			RenderEntityManager.getIns().addEntity(mon);
			PhysicsWorld.getIns().addEntity(mon);
			return mon;
		}
		
		private function qingMingMonsterDeath(e:CharacterEvent) : void{
			var monster:MonsterEntity = e.target as MonsterEntity;
			monster.removeEventListener(CharacterEvent.CHARACTER_DEAD_EVENT, qingMingMonsterDeath);
			monster.removeEventListener(CharacterEvent.MONSTER_CLEAR_EVENT, monsterClear);
			AssessManager.getIns().addMonsterDeath();
			var disapperEffect:DisappearEffect = new DisappearEffect(monster, .8,
				function () : void{
					SceneManager.getIns().checkMonsterDeath(monster);
				});
			QingMingManager.getIns().addQingMingItem(monster);
		}
		
		public function createTuZiMonster(monsterID:int, lv:int) : MonsterEntity{
			var mVo:CharacterVo = EnemyUtils.assignEnemy(monsterID, lv);
			mVo.characterType = (mVo as EnemyVo).type;
			var mon:BaseMonsterEntity = new BaseMonsterEntity(mVo);
			mon.renderSpeed = 1;
			mon.addEventListener(CharacterEvent.CHARACTER_DEAD_EVENT, tuZiMonsterDeath);
			mon.addEventListener(CharacterEvent.MONSTER_CLEAR_EVENT, monsterClear);
			RenderEntityManager.getIns().addEntity(mon);
			PhysicsWorld.getIns().addEntity(mon);
			return mon;
		}
		
		protected function tuZiMonsterDeath(e:Event) : void{
			var monster:MonsterEntity = e.target as MonsterEntity;
			monster.removeEventListener(CharacterEvent.CHARACTER_DEAD_EVENT, tuZiMonsterDeath);
			monster.removeEventListener(CharacterEvent.MONSTER_CLEAR_EVENT, monsterClear);
			AssessManager.getIns().addMonsterDeath();
			var disapperEffect:DisappearEffect = new DisappearEffect(monster, .8,
				function () : void{
					SceneManager.getIns().checkMonsterDeath(monster);
				});
			MidAutumnManager.getIns().addTuZiItem(monster);
		}
		
		public function createThunder() : ThunderEntity{
			var mVo:CharacterVo = new CharacterVo();
			mVo.countTotalProperty();
			var thunder:ThunderEntity = new ThunderEntity(mVo);
			
			return thunder;
		}
		
		//创建怪物
		public function createMonster(monsterID:int, xPos:int, yPos:int, lv:int = -1) : MonsterEntity{
			var mVo:CharacterVo = EnemyUtils.assignEnemy(monsterID, lv);
			mVo.characterType = (mVo as EnemyVo).type;
			var mon:BaseMonsterEntity;
			switch((mVo as EnemyVo).fodder){
				case "YinYangZhenRen":
					mon= new YinYangZhenRenEntity(mVo);
					break;
				case "JianMoWangHun":
					mon = new JianMoWangHunEntity(mVo);
					break;
				case "ChiNan":
					mon = new ChiNanEntity(mVo);
					break;
				case "YuanNv":
					mon = new YuanNvEntity(mVo);
					break;
				case "TanDeWuYan_01":
					mon = new TanDeWuYanEntity(mVo);
					break;
				case "JueXiuJiaoQiao":
					mon = new JueXiuJiaoQiaoEntity(mVo);
					break;
				case "FunnyBossOne":
					mon = new FunnyBossOneEntity(mVo);
					break;
				default:
					mon= new BaseMonsterEntity(mVo);
					break;
			}
			mon.x = xPos;
			mon.y = yPos;
			mon.renderSpeed = 1;
			mon.addEventListener(CharacterEvent.CHARACTER_DEAD_EVENT, monsterDeath);
			mon.addEventListener(CharacterEvent.MONSTER_CLEAR_EVENT, monsterClear);
			switch(mVo.characterType){
				case CharacterType.BOSS_MONSTER:
				case CharacterType.ELITE_BOSS_MONSTER:
					if(LevelManager.getIns().mainBossEntity == null){
						LevelManager.getIns().mainBossEntity = mon;
						mon.charData.characterBarIndex = 0;
					}else{
						LevelManager.getIns().minorBossEntity = mon;
						mon.charData.characterBarIndex = 1;
					}
					((ViewFactory.getIns().initView(BossBattleBar)) as BossBattleBar).show();
					SoundManager.getIns().bgSoundPlay(AssetsConst.BOSSFIGHTSOUND);
					break;
				case CharacterType.HERO_MONSTER:
					ViewFactory.getIns().destroyView(HeroBattleBar);
					if(monsterID == 6029){
						LevelManager.getIns().minorBossEntity = mon;
						mon.charData.characterBarIndex = 1;
					}else{
						LevelManager.getIns().mainBossEntity = mon;
						mon.charData.characterBarIndex = 0;
					}
					((ViewFactory.getIns().initView(HeroBattleBar)) as HeroBattleBar).show();
					break;
				case CharacterType.SPECIAL_BOSS_MONSTER:
					mon.hasAppearEffect = false;
					break;
			}
			RenderEntityManager.getIns().addEntity(mon);
			PhysicsWorld.getIns().addEntity(mon);
			
			return mon;
		}
		
		//创建护镖的怪物
		public function createConvoyMonster(monsterID:int, xPos:int, yPos:int, lv:int, hasMainAI:Boolean = true) : MonsterEntity{
			var mVo:CharacterVo = EnemyUtils.assignEnemy(monsterID, lv);
			mVo.characterType = (mVo as EnemyVo).type;
			var mon:BaseMonsterEntity;
			switch((mVo as EnemyVo).fodder){
				case "YinYangZhenRen":
					mon= new YinYangZhenRenEntity(mVo, hasMainAI);
					break;
				case "JianMoWangHun":
					mon = new JianMoWangHunEntity(mVo, hasMainAI);
					break;
				case "ChiNan":
					mon = new ChiNanEntity(mVo, hasMainAI);
					break;
				case "YuanNv":
					mon = new YuanNvEntity(mVo, hasMainAI);
					break;
				default:
					mon= new BaseMonsterEntity(mVo, hasMainAI);
					break;
			}
			mon.x = xPos;
			mon.y = yPos;
			mon.renderSpeed = 1;
			mon.addEventListener(CharacterEvent.CHARACTER_DEAD_EVENT, monsterDeath);
			mon.addEventListener(CharacterEvent.MONSTER_CLEAR_EVENT, monsterClear);
			RenderEntityManager.getIns().addEntity(mon);
			PhysicsWorld.getIns().addEntity(mon);
			
			return mon;
		}
		
		//创建镖车
		public function createConvoy(monsterID:int, xPos:int, yPos:int, lv:int) : EscortEntity{
			var mVo:CharacterVo = EnemyUtils.assignEnemy(monsterID, lv);
			mVo.characterType = (mVo as EnemyVo).type;
			var mon:EscortEntity = new EscortEntity(mVo, false);
			mon.x = xPos;
			mon.y = yPos;
			RenderEntityManager.getIns().addEntity(mon);
			PhysicsWorld.getIns().addEntity(mon);
			
			
			return mon;
		}
		
		private function monsterDeath(e:CharacterEvent) : void{
			var monster:MonsterEntity = e.target as MonsterEntity;
			monster.removeEventListener(CharacterEvent.CHARACTER_DEAD_EVENT, monsterDeath);
			monster.removeEventListener(CharacterEvent.MONSTER_CLEAR_EVENT, monsterClear);
			AssessManager.getIns().addMonsterDeath();
			var disapperEffect:DisappearEffect = new DisappearEffect(monster, .8,
				function () : void{
					SceneManager.getIns().checkMonsterDeath(monster);
				});
			SceneManager.getIns().nowScene["isShowPassLevel"](monster);
			addItem(monster);
		}
		
		private function addItem(monster:MonsterEntity) : void{
			if(SceneManager.getIns().sceneType == SceneManager.NORMAL_SCENE){
				var levelInfo:Object = LevelManager.getIns().levelData;
				var arr:Array = levelInfo.collection.split("|");
				var rate:Number = Number(levelInfo.collection_rate) * NumberConst.getIns().percent10;
				var random:Number = Math.random();
				if(random < rate){
					var itemVo:ItemVo = PackManager.getIns().creatItem(arr[int(Math.random() * arr.length)]);
					itemVo.num = NumberConst.getIns().one;
					PackManager.getIns().addItemIntoPack(itemVo);
					var iie:ItemIconEntity = new ItemIconEntity(itemVo.type + itemVo.id, itemVo.name, monster.bodyPos, DigitalManager.getIns().getOneStauts());
					SceneManager.getIns().nowScene.addChild(iie);
				}
			}
		}
		
		public function monsterClear(e:CharacterEvent) : void{
			var monster:MonsterEntity = e.target as MonsterEntity;
			monster.removeEventListener(CharacterEvent.CHARACTER_DEAD_EVENT, monsterDeath);
			monster.removeEventListener(CharacterEvent.MONSTER_CLEAR_EVENT, monsterClear);
			SceneManager.getIns().checkMonsterClear(monster);
		}
		
		public function createSkillShowEntity(monsterID:int) : SkillShowEntity{
			var mVo:CharacterVo = EnemyUtils.assignEnemy(monsterID);
			mVo.characterType = (mVo as EnemyVo).type;
			var mon:SkillShowEntity;
			switch((mVo as EnemyVo).fodder){
				case  "YinYangZhenRen":
					mon= new YinYangZhenRenShowEntity(mVo);
					break;
				default:
					mon= new SkillShowEntity(mVo);
					break;
			}
			mon.renderSpeed = 1;
			RenderEntityManager.getIns().addEntity(mon);
			PhysicsWorld.getIns().addEntity(mon);
			
			return mon;
		}
		
		public function createShowEntity(occupation:int, equipped:Array) : ShowRoleEntity{
			var obj:Object = com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData(AssetsConst.CHARACTERS)).RECORDS[occupation - 1];
			var roleType:uint = getRoleType(occupation);
			var sVo:CharacterVo = new CharacterVo();
			sVo.id = obj.id;
			sVo.assetsArray = equipped;
			sVo.isDouble = true;
			sVo.sequenceId = roleType;
			
			var show:ShowRoleEntity = new ShowRoleEntity(sVo);
			show.renderSpeed = 1;
			show.name = (occupation==OccupationConst.KUANGWU?"KuangWu":"XiaoYao");
			RenderEntityManager.getIns().removeEntity(show.bodyAction);
			AnimationManager.getIns().addEntity(show.bodyAction);
			
			return show;
		}
		
		public function createReplacePlayer(xPos:int, yPos:int) : void{
			var mVo:CharacterVo = EnemyUtils.assignEnemy(1001);
			mVo.characterType = (mVo as EnemyVo).type;
			var mon:SkillShowEntity = new SkillShowEntity(mVo);
			mon.renderSpeed = 1;
			mon.x = xPos;
			mon.y = yPos;
			RenderEntityManager.getIns().addEntity(mon);
			PhysicsWorld.getIns().addEntity(mon);
			
			_replaceTarget = mon;
			_replaceList.push(mon);
		}
		
		public function destroyReplacePlayer() : void{
			if(_replaceList.length > 0){
				var replace:SequenceActionEntity = _replaceList.shift();
				replace.destroy();
				replace = null;
			}
			if(_replaceList.length == 0){
				_replaceTarget = null;
			}
		}
		
		
		//获得目标角色
		public function seekTarget(source:CharacterEntity = null) : void{
			_target = null;
			if(SceneManager.getIns().sceneType == SceneManager.ESCORT_SCENE){
				_target = escortTarget(source);
			}else{
				_target = normalTarget(source);
			}
		}
		
		private function escortTarget(source:CharacterEntity = null) : CharacterEntity{
			var result:CharacterEntity;
			var convoys:Vector.<EscortEntity> = (BmdViewFactory.getIns().getView(EscortSceneView) as EscortSceneView).convoys;
			if(convoys.length > 0 && convoys.length > 1){
				if(source != null){
					var distance:int = 10000;
					for(var i:int = 0; i < convoys.length; i++){
						if(convoys[i].charData.useProperty.hp > 0){
							if(Math.abs(source.x - convoys[i].x) < distance){
								result = convoys[i];
								distance = Math.abs(source.x - convoys[i].x);
							}
						}
					}
				}
				if(result == null){
					result = convoys[0];
				}
			}
			return result;
		}
		
		private function normalTarget(source:CharacterEntity = null) : CharacterEntity{
			var result:CharacterEntity;
			var players:Vector.<PlayerEntity> = SceneManager.getIns().players;
			if(players.length > 0){
				if(source != null && players.length > 1){
					var distance:int = 10000;
					for(var j:int = 0; j < players.length; j++){
						if(players[j].charData.useProperty.hp > 0){
							if(Math.abs(source.x - players[j].x) < distance){
								result = players[j];
								distance = Math.abs(source.x - players[j].x);
							}
						}
					}
				}
				if(result == null){
					result = players[0];
				}
			}
			return result;
		}
		
		private function __targetDestroyed(evt:Event) : void{
			_target.removeEventListener(BaseNativeEntity.DESTROY, __targetDestroyed);
			//目标销毁，切换目标
			seekTarget();
		}
		
		public function destroyTarget() : void{
			if(_target){
				_target.removeEventListener(BaseNativeEntity.DESTROY, __targetDestroyed);
				_target = null;
			}
		}
		
		public function get target() : SequenceActionEntity{
			if(_replaceTarget != null){
				return _replaceTarget;
			}else{
				return _target;
			}
		}
		
		public function clear() : void{
			for(var i:int = 0; i < _replaceList.length; i++){
				if(_replaceList[i] != null){
					(_replaceList[i] as SequenceActionEntity).destroy();
					_replaceList[i] = null;
				}
			}
			_replaceList.length = 0;
			_replaceTarget = null;
		}
	}
}