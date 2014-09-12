package com.test.game.Utils
{
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.Enemy.EnemyManager;
	import com.test.game.Mvc.Vo.BasePropertyVo;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.ConjureVo;
	import com.test.game.Mvc.Vo.EnemyVo;

	public class EnemyUtils
	{
		public function EnemyUtils()
		{
		}
		
		public static function assignEnemy(monsterID:int, lv:int = -1) : CharacterVo
		{
			var baseInfo:Object = EnemyManager.getIns().getEnemyData(monsterID);
			var levelUpInfo:Object = EnemyManager.getIns().getEnemyUpData(monsterID);
			var characterVo:EnemyVo = new EnemyVo(baseInfo);
			if(LevelManager.getIns().levelData != null){
				characterVo.lv = (lv==-1?LevelManager.getIns().levelData.level_lv:lv);
			}else{
				characterVo.lv = (lv==-1?1:lv);
			}
			characterVo.configProperty = assignProperty(baseInfo);
			characterVo.levelUpProperty = assignLevelUpProperty(levelUpInfo, characterVo.lv);
			characterVo.countTotalProperty();
			
			return characterVo;
		}
		
		public static function assignConjure(monsterID:int, lv:int) : CharacterVo{
			var baseInfo:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.BOSS, "sid", monsterID);
			var levelUpInfo:Object = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.BOSS_UP, "id", lv);
			var characterVo:ConjureVo = new ConjureVo(baseInfo);
			characterVo.ID = monsterID;
			characterVo.configProperty = assignConjureProperty(baseInfo, levelUpInfo);
			characterVo.countTotalProperty();
			
			return characterVo;
		}
		
		private static function assignConjureProperty(base:Object, up:Object) : BasePropertyVo{
			var properyVo:BasePropertyVo = new BasePropertyVo();
			properyVo.atk = base["atk"] * up.atk_rate;
			properyVo.ats = base["ats"] * up.ats_rate;
			return properyVo;
		}
		
		private static function assignProperty(data:Object) : BasePropertyVo{
			var properyVo:BasePropertyVo = new BasePropertyVo();
			properyVo.hp = data["hp"];
			properyVo.atk = data["atk"];
			properyVo.def = data["def"];
			properyVo.ats = data["ats"];
			properyVo.adf = data["adf"];
			properyVo.spd = data["spd"];
			return properyVo;
		}
		
		private static function assignLevelUpProperty(up:Object, level) : BasePropertyVo{
			var properyVo:BasePropertyVo = new BasePropertyVo();
			properyVo.hp = (level - 1) * up["hp_rate"];
			properyVo.atk = (level - 1) * up["atk_rate"];
			properyVo.def = (level - 1) * up["def_rate"];
			properyVo.ats = (level - 1) * up["ats_rate"];
			properyVo.adf = (level - 1) * up["adf_rate"];
			return properyVo;
		}
	}
}