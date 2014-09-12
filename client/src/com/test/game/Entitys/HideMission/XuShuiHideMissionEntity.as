package com.test.game.Entitys.HideMission
{
	import com.superkaka.Tools.AUtils;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Manager.HideMission.TaiXuHideMissionManager;
	
	import flash.display.BitmapData;

	public class XuShuiHideMissionEntity extends TaiXuBaseHideMissionEntity
	{
		private var _thingStatus:int = 0;
		public function get thingStatus() : int{
			return _thingStatus;
		}
		public function set thingStatus(value:int) : void{
			_thingStatus = value;
		}
		public function XuShuiHideMissionEntity(fodderArr:Array, collisionSkill:String="", collisionY:int=50, isClear:Boolean=false)
		{
			super(fodderArr, collisionSkill, collisionY, isClear);
		}
		
		
		public function setImageIndex(count:int) : void{
			if(!_isOver){
				thingStatus = count;
				this.data.bitmapData = AUtils.getNewObj(_fodderArr[count]) as BitmapData;
			}
		}
		
		override public function hurtBy(ih:IHurtAble):void{
			if(!_isOver && _collisionSkill != "" && thingStatus == 1){
				var skillEntity:SkillEntity = ih as SkillEntity;
				if(skillEntity.hitName.indexOf(_collisionSkill) != -1){
					_isOver = true;
					TaiXuHideMissionManager.getIns().setHideMissionComplete(HideMissionManager.TAIXUGUAM_ID);
					this.data.bitmapData = AUtils.getNewObj(_fodderArr[2]) as BitmapData;
				}
			}
		}
	}
}