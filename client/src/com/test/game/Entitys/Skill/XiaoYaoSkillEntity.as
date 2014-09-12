package com.test.game.Entitys.Skill
{
	import com.superkaka.game.Const.DirectConst;
	import com.test.game.AgreeMent.Battle.IAttackAble;
	import com.test.game.Const.SkillMoveConst;
	import com.test.game.Entitys.Effect.SwordEntity;
	import com.test.game.Entitys.Roles.XiaoYaoEntity;
	import com.test.game.Mvc.Vo.SkillVo;
	
	import flash.geom.Point;
	
	public class XiaoYaoSkillEntity extends SkillEntity
	{
		public function XiaoYaoSkillEntity(skillVo:SkillVo, source:IAttackAble, skillData:Object){
			super(skillVo, source, skillData);
		}
		
		override protected function initSkillConfiguration(skillData:Object):void{
			super.initSkillConfiguration(skillData);
		}
		
		override protected function initSequenceAction():void{
			super.initSequenceAction();
			//逍遥的普通剑气攻击
			if(_skillConfiguration.skillMoveType == SkillMoveConst.MOVE_SWORD || _skillConfiguration.skillMoveType == SkillMoveConst.MOVE_SWORD_AIR){
				var obj:XiaoYaoEntity = hurtSource as XiaoYaoEntity;
				var sword:SwordEntity = obj.swordList[obj.swordList.length - 1];
				this.x = sword.x + sword.bodyAction.x;
				this.y = sword.y + 10;
				this.bodyAction.y = sword.bodyAction.y - 10;
				if(this.collisionBody != null){
					this.collisionBody.y = sword.bodyAction.y;
				}
				this.registerPoint = new Point(this.bodyAction.width * .5, this.bodyAction.height * .5)
				obj.pushSword();
			}
		}
		
		private function swordMove() : void{
			if(_skillConfiguration.skillMoveType == SkillMoveConst.MOVE_SWORD){
				var faceDirect:int;
				if(this.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
					faceDirect = 1;
				}else if(this.faceHorizontalDirect == DirectConst.DIRECT_RIGHT){
					faceDirect = -1;
				}
				if((faceDirect == 1 && this.bodyAction.rotationValue < 90 / 180 * Math.PI) || (faceDirect == -1 && this.bodyAction.rotationValue > -90 / 180 * Math.PI)){
					this.bodyAction.rotationValue += faceDirect * .3;
					if(this.collisionBody != null){
						this.collisionBody.rotationValue += faceDirect * .3;
					}
				}else{
					this.bodyAction.rotationValue = faceDirect * 90 / 180 * Math.PI;
					if(this.collisionBody != null){
						this.collisionBody.rotationValue = faceDirect * 90 / 180 * Math.PI;
					}
					this.x -= faceDirect * skillMoveList[0];
				}
			}else if(_skillConfiguration.skillMoveType == SkillMoveConst.MOVE_SWORD_AIR){
				if(this.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
					faceDirect = 1;
				}else if(this.faceHorizontalDirect == DirectConst.DIRECT_RIGHT){
					faceDirect = -1;
				}
				if((faceDirect == 1 && this.bodyAction.rotationValue < 55 / 180 * Math.PI) || (faceDirect == -1 && this.bodyAction.rotationValue > -55 / 180 * Math.PI)){
					this.bodyAction.rotationValue += faceDirect * .3;
					if(this.collisionBody != null){
						this.collisionBody.rotationValue += faceDirect * .3;
					}
				}else{
					this.bodyAction.rotationValue = faceDirect * 55 / 180 * Math.PI;
					if(this.collisionBody != null){
						this.collisionBody.rotationValue = faceDirect * 55 / 180 * Math.PI;
					}
					if(this.bodyAction.y < this.shadow.y - 20){
						this.x -= faceDirect * skillMoveList[0];
						this.bodyAction.y += skillMoveList[1];
						if(this.collisionBody != null)
							this.collisionBody.y += skillMoveList[1];
					}else{
						_canDestroy = true;
					}
				}
			}
		}
		
		override public function step() : void{
			swordMove();
			super.step();
		}
	}
}