package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.Monsters.BaseMonsterEntity;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	public class MonsterManager extends Singleton
	{
		public function MonsterManager()
		{
			super();
		}
		
		public static function getIns():MonsterManager{
			return Singleton.getIns(MonsterManager);
		}
		
		
		public function createMonster(monsterType:int, typeArray:Array, xPos:int, yPos:int) : MonsterEntity
		{
			var mVo:CharacterVo = new CharacterVo();
			mVo.sequenceId = monsterType;
			mVo.assetsArray = typeArray;
			mVo.isDouble = true;
			
			var mon:BaseMonsterEntity = new BaseMonsterEntity(mVo);
			mon.x = xPos;
			mon.y = yPos;
			mon.renderSpeed = 1;
			//this.addChild(mon);
			
			RenderEntityManager.getIns().addEntity(mon);
			PhysicsWorld.getIns().addEntity(mon);
			
			return mon;
			//_monsterVec.push(mon);
		}
	}
}