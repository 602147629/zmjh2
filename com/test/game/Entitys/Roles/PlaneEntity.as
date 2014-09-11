package com.test.game.Entitys.Roles{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.CampConst;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Const.SequenceConst;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.SkillInfo;
	
	import flash.geom.Point;
	
	public class PlaneEntity extends PlayerEntity{
		public var tq:TestQuad;
		
		public function PlaneEntity(charVo:CharacterVo){
			super(charVo);
			
			this.isRectCollision = true;
			this.collisionListeners = [CollisionFilterIndexConst.MONSTER_SKILL];
			
		}
		
		override protected function initSequenceAction():void{
			this.bodyAction = new BaseSequenceActionBind(this.charVo);
			
			this.setAction(ActionState.WAIT);
			this.bodyAction.renderSpeed = 3;
			
			super.initSequenceAction();
			tq = new TestQuad();
			tq.x = -tq.width/2;
			tq.y = -tq.height/2;
			tq.visible = false;
			this.bodyAction.addChild(tq);
			
			this.collisionBody = this.tq;
			
		}
		
		override protected function initShadow():void{
//			super.initShadow();
		}
		
		override public function setAction(actionState:uint,resetWhenSameAction:Boolean = false):void{
			super.setAction(actionState,resetWhenSameAction);
			if(actionState == ActionState.WAIT){
//				this.bodyAction.isStopRender = false;
			}
		}
		
		
		override public function hurtBy(ih:IHurtAble):void{
			if(!this.isYourFather()){
				super.hurtBy(ih);
				
				var attackId:int = ih.getAttackId();
				if(this.beAttackedIdVec.indexOf(attackId) == -1){
					this.beAttackedIdVec.push(attackId);
				}
//				this.destroy();
			}
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			var totalRenderIndex:int = args[4];
			
			
			switch(label){
//				case ActionState.getStateLabelById(ActionState.HIT1):
//
//					break;
			}
		}
		
		override protected function doWhenActionOver(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				
			}
			
		}
		
		
		override public function step():void{
			super.step();
			
			if(this.hitInterval > 0){
				this.hitInterval -- ;
			}
		}
		
		private var hitInterval:uint = 4;
		
		public function doHit1():void{
			if(this.hitInterval == 0){
				this.releaseSkill1();
				this.hitInterval = 4;
			}
		}
		
		
		private function releaseSkill1():void{
			var skillVo:SkillInfo = new SkillInfo(SequenceConst.SKILL_BULLET_1, ["bullet1"], false);
			
			var skill:SkillEntity = new SkillEntity(skillVo, this, new Object());
			skill.hurtSource = this;
			skill.hurt = 100;
			skill.moveHorizontalDirect = this.faceHorizontalDirect;
			skill.faceHorizontalDirect = this.faceHorizontalDirect;
			skill.pos = this.bodyPos.clone();
			if(this.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
				skill.attackBackAxis = [-10,0];
			}else{
				skill.attackBackAxis = [10,0];
			}
			SkillManager.getIns().addSkill(skill);
		}
		override public function destroy():void{
			this.tq = null;
			
			super.destroy();
		}
		
	}
}