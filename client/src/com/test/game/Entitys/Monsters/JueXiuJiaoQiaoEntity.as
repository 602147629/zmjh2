package com.test.game.Entitys.Monsters
{
	import com.superkaka.game.Const.ActionState;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Const.CharacterType;
	import com.test.game.Event.CharacterEvent;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	public class JueXiuJiaoQiaoEntity extends BaseMonsterEntity
	{
		public function JueXiuJiaoQiaoEntity(charVo:CharacterVo, hasMainAI:Boolean=true)
		{
			super(charVo, hasMainAI);
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT1:
					checkFrameCommon(keyFrame, 1);
					//hitType = 0;
					break;
				case ActionState.SKILL1:
				case ActionState.SKILL3:
				case ActionState.SKILL4:
				case ActionState.SKILL5:
					checkFrameSKill(keyFrame, this.curAction);
					//hitType = 1;
					break;
				case ActionState.SKILL2:
					checkFrameSKill(keyFrame, this.curAction);
					break;
				case ActionState.DEAD:
					if(this.mainAi != null){
						this.mainAi.lock();
						charVo.useProperty.hp = 0;
						changeHp(0);
					}
					break;
				case ActionState.GROUNDDEAD:
					if(this.mainAi != null){
						this.mainAi.lock();
						charVo.useProperty.hp = 0;
						changeHp(0);
					}
					if(keyFrame < 6){
						groundDeadMove();
					}
					break;
			}
		}
		
		override protected function doWhenActionOver(...args) : void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT1:
					resetSkillParams();
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.SKILL1:
				case ActionState.SKILL3:
				case ActionState.SKILL4:
				case ActionState.SKILL5:
					_characterControl.setAttackEnd();
					this.resetSkillParams();
					this.setAction(ActionState.WAIT);
					break;
				case ActionState.SKILL2:
					_characterControl.setAttackEnd();
					this.resetSkillParams();
					this.setAction(ActionState.WAIT);
					createOtherEntity();
					break;
				case ActionState.HURT:
					unMoveHurt();
					isAirHurt();
					resetSkillParams();
					break;
				case ActionState.DEAD:
				case ActionState.GROUNDDEAD:
					this.dispatchEvent(new CharacterEvent(CharacterEvent.CHARACTER_DEAD_EVENT));
					//this.destroy();
					break;
				case ActionState.FALL:
					isAirHurt();
					if(curRenderIndex == 30){
						standUp();
						unMoveHurt();
						resetSkillParams();
					}
					break;
				default:
					if(this.curAction == ActionState.NONE)
						this.setAction(ActionState.WAIT);
					this.setAction(this.curAction, true);
					//resetShadow();
					break;
			}
		}
		
		private function createOtherEntity() : void{
			var monsterID:int;
			if(this.charVo.characterType == CharacterType.BOSS_MONSTER){
				monsterID = 2326;
			}else{
				monsterID = 4326;
			}
			var xPosList:Array = [-200, -200, 200, 200];
			var yPosList:Array = [90, -90, 90, -90];
			
			var index:int = int(Math.random() * 4);
			var xPos:int = xPosList[index];
			var yPos:int = yPosList[index];
			xPosList.splice(index, 1);
			yPosList.splice(index, 1);
			
			LevelManager.getIns().createSpecialMonster(monsterID, this.x + xPosList.shift(), this.y + yPosList.shift());
			LevelManager.getIns().createSpecialMonster(monsterID, this.x + xPosList.shift(), this.y + yPosList.shift());
			LevelManager.getIns().createSpecialMonster(monsterID, this.x + xPosList.shift(), this.y + yPosList.shift());
			this.x = this.x + xPos;
			this.y = this.y + yPos;
			SceneManager.getIns().nowScene["allSpecialMonsterAction"](ActionState.HIT1);
			
		}
		
		override public function hurtBy(ih:IHurtAble):void{
			if(charVo.characterType != CharacterType.SPECIAL_BOSS_MONSTER){
				SceneManager.getIns().nowScene["allSpecialMonsterDeath"]();
			}
			super.hurtBy(ih);
		}
	}
}