package com.test.game.Entitys.Roles{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.CampConst;
	import com.superkaka.game.Const.DirectConst;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.SkillInfo;
	
	import flash.geom.Point;
	
	public class TangsengEntity extends PlayerEntity{
		public var tq:TestQuad;
		
		public function TangsengEntity(charVo:CharacterVo){
			super(charVo);
			
			this.isRectCollision = true;
			this.collisionListeners = [CollisionFilterIndexConst.MONSTER_SKILL];
			
		}
		
		override protected function initSequenceAction():void{
			this.bodyAction = new BaseSequenceActionBind(this.charVo);
			
			this.setAction(ActionState.WAIT);
			this.bodyAction.renderSpeed = 1;
			
			super.initSequenceAction();
			tq = new TestQuad();
			tq.x = -tq.width/2;
			tq.y = -tq.height/2;
			tq.visible = false;
			this.bodyAction.addChild(tq);
			
			this.collisionBody = this.tq;
		}
		
		override protected function initShadow():void{
			super.initShadow();
		}
		
		override public function setAction(actionState:uint,resetWhenSameAction:Boolean = false):void{
			super.setAction(actionState,resetWhenSameAction);
			
		}
		
		
		override public function hurtBy(ih:IHurtAble):void{
			super.hurtBy(ih);
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			switch(label){
				case ActionState.HIT1:
					if(keyFrame == 3){
						//释放技能
						this.releaseSkill1();
					}
					break;
			}
		}
		
		override protected function doWhenActionOver(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT1:
					trace("-----------------攻击结束-----------------")
					this.setAction(ActionState.WAIT);
					break;
			}
			
		}
		
		
		override public function step():void{
			super.step();
			
		}
		
		
		private function releaseSkill1():void{
			var skillVo:SkillInfo = new SkillInfo();
			skillVo.sequenceId = 2000;
			skillVo.assetsArray = ["effect2"];
			skillVo.isDouble = false;
			
			var skill:SkillEntity = new SkillEntity(skillVo);
			skill.hurtSource = this;
			skill.hurt = 100;
			skill.moveHorizontalDirect = this.faceHorizontalDirect;
			skill.faceHorizontalDirect = this.faceHorizontalDirect;
			skill.pos = this.bodyPos.clone();
			skill.setSkillCamp(CampConst.CAMP_PLAYER);
			if(this.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
				skill.attackBackAxis = new Point(-10,0);
			}else{
				skill.attackBackAxis = new Point(10,0);
			}
			SkillManager.getIns().addSkill(skill);
		}
		override public function destroy():void{
			this.tq = null;
			
			super.destroy();
		}
		
	}
}