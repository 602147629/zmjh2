package com.test.game.Entitys.Roles{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.CampConst;
	import com.superkaka.game.Const.SequenceConst;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Event.CharacterEvent;
	
	public class WukongEntity extends PlayerEntity{
		public var tq:TestQuad;
		
		public function WukongEntity(charVo:CharacterVo){
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
			
			this.charVo.hp = 1000000;
		}
		
		override protected function initShadow():void{
			super.initShadow();
		}
		
		override public function setAction(actionState:uint,resetWhenSameAction:Boolean = false):void{
			super.setAction(actionState,resetWhenSameAction);
		}
		
		
		override public function hurtBy(ih:IHurtAble):void{
			if(!this.isYourFather()){
				super.hurtBy(ih);
				
				var attackId:int = ih.getAttackId();
				if(this.beAttackedIdVec.indexOf(attackId) == -1){
					this.beAttackedIdVec.push(attackId);
				}
			}
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(label){
				case ActionState.getStateLabelById(ActionState.HIT1):
					if(keyFrame == 3){
						releaseSkill1();
					}
					else if(keyFrame > 4)
						_comboTime = 1;
					break;
				case ActionState.getStateLabelById(ActionState.CONTINUEHIT1):
					if(keyFrame == 4)
						this.releaseSkill2();
					if(keyFrame > 5)
						_comboTime = 2;
					break;
				case ActionState.getStateLabelById(ActionState.CONTINUEHIT2):
					if(keyFrame == 2)
						this.releaseSkill3();
					break;
				case ActionState.getStateLabelById(ActionState.ROLL):
					if(keyFrame == 1)
						this.releaseSkill4();
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
					this.setAction(ActionState.WAIT);
					_comboTime = 0;
					break;
				case ActionState.CONTINUEHIT1:
				case ActionState.CONTINUEHIT2:
					this.setAction(ActionState.WAIT);
					_comboTime = 0;
					break;
				case ActionState.ROLL:
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.HURT:
					unMoveHurt();
					break;
				case ActionState.FALL:
					if(curRenderIndex == 50){
						standUp();
					}
					break;
				case ActionState.DEAD:
					this.dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_DEAD_EVENT));
				default : 
					this.setAction(this.curAction, true);
					break;
			}
		}
		
		override public function step():void{
			super.step();
		}
		
		private function releaseSkill1():void{
			SkillManager.getIns().createSkill(this, CampConst.CAMP_PLAYER, SequenceConst.KUANGWU_COMMON_HIT_1, "skill_1");
		}
		
		private function releaseSkill2() : void{
			SkillManager.getIns().createSkill(this, CampConst.CAMP_PLAYER, SequenceConst.KUANGWU_COMMON_HIT_1, "skill_2");
		}
		
		private function releaseSkill3():void{
			SkillManager.getIns().createSkill(this, CampConst.CAMP_PLAYER, SequenceConst.KUANGWU_COMMON_HIT_1, "skill_3");
		}
		
		private function releaseSkill4() : void{
			SkillManager.getIns().createSkill(this, CampConst.CAMP_PLAYER, SequenceConst.KUANGWU_COMMON_HIT_1, "skill_4");
		}
		
		override public function destroy():void{
			this.tq = null;
			
			super.destroy();
		}
		
		
	}
}