package com.test.game.Manager.Enemy
{
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.Tools.Singleton;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.DebugConst;
	import com.test.game.Manager.ConfigurationManager;
	
	public class EnemyManager extends Singleton{
		public var enemyList:Array;
		public var enemyUpList:Array;
		
		public function EnemyManager(){
			super();
		}
		
		public static function getIns():EnemyManager{
			return Singleton.getIns(EnemyManager);
		}
		
		public function initEnemyData() : void{
			enemyList = ConfigurationManager.getIns().getAllData(AssetsConst.ENEMY);
			enemyUpList = ConfigurationManager.getIns().getAllData(AssetsConst.ENEMY_UP);
		}
		
		public function getEnemyData(enemyID:int) : Object{
			var result:Object;
			
			for each(var obj:Object in enemyList){
				if(obj.ID == enemyID){
					result = obj;
					break;
				}
			}
			if(result == null){
				DebugArea.getIns().showInfo("怪物ID:" + enemyID + " --- 没有该怪物的配置信息！", DebugConst.ERROR);
				//throw new Error("怪物ID:" + enemyID + " --- 没有该怪物的配置信息！");
			}
			return result;
		}
		
		public function getEnemyUpData(enemyID:int) : Object{
			var result:Object;
			
			for each(var obj:Object in enemyUpList){
				if(obj.id == enemyID){
					result = obj;
					break;
				}
			}
			if(result == null){
				DebugArea.getIns().showInfo("怪物ID:" + enemyID + " --- 没有该怪物的配置信息！", DebugConst.ERROR);
				//throw new Error("怪物ID:" + enemyID + " --- 没有该怪物的配置信息！");
			}
			return result;
		}
	}
}