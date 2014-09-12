package com.test.game.Entitys.Conjure
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Const.ActionState;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.Skill.SkillManager;
	import com.test.game.Mvc.Data.SkillConfigurationVo;
	import com.test.game.Mvc.Vo.CharacterVo;
	import com.test.game.Mvc.Vo.ConjureVo;
	
	public class ConjureEntity extends CharacterEntity{
		protected var endFrame:int;
		public var belong:PlayerEntity;
		
		public function ConjureEntity(charVo:CharacterVo, data:Object){
			super(charVo);
			
			this.isRectCollision = true;
			this.collisionIndex = CollisionFilterIndexConst.PLAYER;
		}
		
		public var tq:TestQuad;
		override protected function initSequenceAction():void{
			
			this.bodyAction = new BaseSequenceActionBind(this.charVo);
			this.setAction(ActionState.WAIT);
			
			super.initSequenceAction();
			tq = new TestQuad();
			tq.x = -tq.width/2;
			tq.y = -tq.height/2;
			tq.visible = false;
			this.bodyAction.addChild(tq);
			this.collisionBody = this.tq;
		}
		
		override public function setAction(actionState:uint,resetWhenSameAction:Boolean = false):void{
			super.setAction(actionState,resetWhenSameAction);
		}
		
		override protected function initParams():void{
			super.initParams();
			
			initSkillParams();
		}
		
		override public function hurtBy(ih:IHurtAble):void{
			return;
		}
		
		private function initSkillParams():void{
			var obj:Object = SkillManager.getIns().getEnemyConfigurationData((charVo as ConjureVo).ID);
			charVo.skillConfigurationVo = new SkillConfigurationVo();
			charVo.skillConfigurationVo.assignConjureData(obj);
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			//trace(keyFrame, curRenderIndex);
			switch(this.curAction){
				case ActionState.SKILL1:
				case ActionState.SKILL2:
					checkFrameSKill(keyFrame, this.curAction);
					break;
				case ActionState.WAIT:
					if(keyFrame == 3){
						var conjureID:int = (charVo as ConjureVo).ID;
						if(conjureID == 2112
							||conjureID == 1021
							||conjureID == 1022){
							this.setAction(ActionState.SKILL2);
						}else{
							this.setAction(ActionState.SKILL1);
						}
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
				case ActionState.SKILL1:
				case ActionState.SKILL2:
					resetSkillParams();
					endFrame++;
					this.alpha -= .06;
					if(endFrame >= 15){
						this.hideConjure();
						this.alpha = 1;
						endFrame = 0;
						this.setAction(ActionState.WALK);
					}
					break;
				default : 
					this.setAction(this.curAction, true);
					break;
			}
		}
		
		protected function checkFrameSKill(keyFrame:int, skillID:int, reset:Boolean = false) : void{
			var count:int = skillID - ActionState.SKILLBASE - 1;
			_nowCount = count;
			//跳跃技能
			if(charVo.skillConfigurationVo.jumpSkillList[count] != 0){
				bodyAction.y = -charVo.skillConfigurationVo.jumpSkillList[count];
			}
			//空中斩下
			if(charVo.skillConfigurationVo.rollSkillList[count].length > 1 && keyFrame == 1){
				charVo.characterJudge.isRollStatus = true;
			}
			if(charVo.checkFrameSKill(keyFrame, count, skillID)){
				this.releaseSkill(count, reset);
			}
		}
		
		private var _nowCount:int;
		protected function releaseSkill(skillID:int, reset:Boolean = false) : void{
			var allCount:Array = charVo.skillConfigurationVo.skillList[skillID][charVo.skillConfigurationVo.skillCountList[skillID]].split("_");
			for(var i:int = 0; i < allCount.length; i++){
				SkillManager.getIns().createSkill(this, allCount[i]);
			}
			//SkillManager.getIns().createSkill(this, charVo.skillConfigurationVo.skillList[skillID][charVo.skillConfigurationVo.skillCountList[skillID]]);
			charVo.skillConfigurationVo.skillCountList[skillID]++;
		}
		
		protected function resetSkillParams(setColdTime:Boolean = true) : void{
			charVo.skillConfigurationVo.skillCountList = [0, 0, 0, 0, 0];
			//跳跃技能
			bodyAction.y = 0;
			if(bodyAction.y < 0 && this.curAction != ActionState.HURT && charVo.skillConfigurationVo.jumpSkillList[_nowCount] != 0){
				characterControl.jumpStatus = true;
				characterControl.handJump = true;
			}
		}
		
		protected function hideConjure() : void{
			RoleManager.getIns().removeConjure(this);
		}
		
		override public function step():void{
			super.step();
		}
		
		override public function destroy():void{
			this.tq = null;
			this.belong = null;
			super.destroy();
			this.dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_DEAD_EVENT));
		}
		
	}
}