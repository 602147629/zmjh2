package com.test.game.Entitys.HideMission
{
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Manager.HideMission.TaiXuHideMissionManager;

	public class TaiXuBaseHideMissionEntity extends BaseHideMissionEntity
	{
		public function TaiXuBaseHideMissionEntity(fodderArr:Array, collisionSkill:String="", collisionY:int=50, isClear:Boolean=false)
		{
			super(fodderArr, collisionSkill, collisionY, isClear);
		}
		
		
		override public function hurtBy(ih:IHurtAble):void{
			if(!_isOver && _collisionSkill != ""){
				var skillEntity:SkillEntity = ih as SkillEntity;
				if(skillEntity.hitName.indexOf(_collisionSkill) != -1){
					_isOver = true;
					TaiXuHideMissionManager.getIns().setHideMissionComplete(HideMissionManager.TAIXUGUAM_ID);
					if(_fodderArr.length >= 2){
						changeImage(_fodderArr[1]);
					}else{
						changeImage("");
					}
				}
			}
		}
	}
}