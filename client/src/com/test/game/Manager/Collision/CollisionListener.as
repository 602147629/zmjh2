package com.test.game.Manager.Collision{
	import com.superkaka.game.AgreeMent.ICollisionAble;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Manager.Collision.BaseCollisionListener;
	import com.superkaka.mvc.ControlFactory;
	import com.test.game.AgreeMent.Battle.IBeHurtAble;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Entitys.Daily.ObstacleEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Mvc.control.logic.SkillsCollisionControl;
	
	public class CollisionListener extends BaseCollisionListener{
		
		public function CollisionListener(){
			
		}
		
		override public function beforeCollision(child1:ICollisionAble,child2:ICollisionAble):Boolean{
			//碰撞过滤
//			var flagChild1ToChild2:Boolean = false;//对象1是否关注对象2
//			var flagChild2ToChild1:Boolean = false;//对象2是否关注对象1
			if(child2.collisionListeners.indexOf(child1.collisionIndex) == -1 && child2.collisionListeners.indexOf(CollisionFilterIndexConst.ALL) == -1){
				return false;
			}
			if(child1.collisionListeners.indexOf(child2.collisionIndex) == -1 && child1.collisionListeners.indexOf(CollisionFilterIndexConst.ALL) == -1){
				return false;
			}
			
			var posOffset:int = 0;
			if(child1 is SkillEntity && !(child2 is ObstacleEntity)){
				if(posOffset == 0){
					posOffset = child1.collisionPos - child2.collisionPos;
					posOffset = posOffset>0?posOffset:-posOffset;
				}
				if(posOffset >= (child1 as SkillEntity).collisionRange)
					return false;
			}
			if(child2 is SkillEntity && !(child1 is ObstacleEntity)){
				if(posOffset == 0){
					posOffset = child1.collisionPos - child2.collisionPos;
					posOffset = posOffset>0?posOffset:-posOffset;
				}
				if(posOffset >= (child2 as SkillEntity).collisionRange)
					return false;
			}
			
			
			return true;
		}
		
		
		override public function collision(child1:ICollisionAble,child2:ICollisionAble):void{
//			trace(child1 + " 和 " + child2 + " 碰撞！");
			super.collision(child1,child2);
			//处理伤害
			var bcc:SkillsCollisionControl = ControlFactory.getIns().getControl(SkillsCollisionControl) as SkillsCollisionControl;

			if(child1 is IHurtAble && child2 is IBeHurtAble){
				bcc.collosion(IBeHurtAble(child2),IHurtAble(child1));
			}else if(child2 is IHurtAble && child1 is IBeHurtAble){
				bcc.collosion(IBeHurtAble(child1),IHurtAble(child2));
			}
			
		}
		
	}
}