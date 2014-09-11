package com.test.game.Entitys.HideMission
{
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Manager.HideMission.TaiXuHideMissionManager;

	public class LetterHideMissionEntity extends TaiXuBaseHideMissionEntity
	{
		public function LetterHideMissionEntity(fodderArr:Array, collisionSkill:String="", collisionY:int=50, isClear:Boolean=false)
		{
			super(fodderArr, collisionSkill, collisionY, isClear);
			_stepInterval = 70;
		}
		
		override public function hurtBy(ih:IHurtAble):void{
			if(!_isOver && _collisionSkill != ""){
				var skillEntity:SkillEntity = ih as SkillEntity;
				if(skillEntity.hitName.indexOf(_collisionSkill) != -1){
					_isOver = true;
					TaiXuHideMissionManager.getIns().setHideMissionComplete(HideMissionManager.TAIXUGUAM_ID);
				}
			}
		}
		
		override public function step() : void{
			if(_isClear){
				if(_isOver && !_stepStop){
					if(_stepTime < 20){
						this.y += 16;
						_stepTime++;
					}else{
						if(_stepTime < _stepInterval){
							if(_stepTime % 5 == 0){
								this.visible = true;
							}
							if(_stepTime % 10 == 0 && _stepTime != 0){
								this.visible = false;
							}
							_stepTime++;
						}else{
							_stepStop = true
							this.visible = false;
						}
					}
				}
			}
		}
	}
}