package com.test.game.Entitys.Monsters
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.test.game.AgreeMent.Battle.IBeHurtAble;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class SkillShowEntity extends SequenceActionEntity implements IBeHurtAble
	{
		private var _beAttackedIdVec:Vector.<int>;//被攻击过的id数组(防止重复攻击用)
		private var _lastBeHurtSource:IHurtAble;//最后一次被攻击的伤害来源
		protected var charVo:CharacterVo;//数据
		public var initBodyContainerY:Number;//初始化后body的y坐标
		public var shadow:BaseNativeEntity;
		private var tq:TestQuad;
		public function SkillShowEntity(charVo:CharacterVo){
			this.charVo = charVo;
			this._beAttackedIdVec = new Vector.<int>();
			super();
		}
		
		override protected function initSequenceAction():void{
			this.bodyAction = new BaseSequenceActionBind(this.charVo);
			this.bodyAction.setAction(ActionState.WAIT);
			
			super.initSequenceAction();
			
			tq = new TestQuad();
			tq.x = -tq.width/2;
			tq.y = -tq.height/2;
			tq.visible = false;
			this.bodyAction.addChild(tq);
			
			this.collisionBody = this.tq;
		}
		
		override protected function initCallBack():void{
			super.initCallBack();
			
			this.initShadow();
		}
		/**
		 * 初始化影子 
		 * 
		 */		
		protected function initShadow():void{
			this.shadow = new BaseNativeEntity();
			this.shadow.data.bitmapData = AUtils.getNewObj("shadow") as BitmapData;	
			this.shadow.registerPoint = new Point(this.shadow.data.bitmapData.rect.width/2, this.shadow.data.bitmapData.rect.height/2)
			this.shadow.y = 50;
			this.addChildAt(this.shadow, 0);
		}
		
		override public function setAction(actionState:uint,resetWhenSameAction:Boolean = false):void{
			super.setAction(actionState,resetWhenSameAction);
		}
		
		public function get beAttackedIdVec():Vector.<int>{
			return _beAttackedIdVec;
		}
		
		public function set beAttackedIdVec(value:Vector.<int>):void{
			_beAttackedIdVec = value;
		}
		
		public function get lastBeHurtSource():IHurtAble{
			return _lastBeHurtSource;
		}
		
		public function set lastBeHurtSource(value:IHurtAble):void{
			_lastBeHurtSource = value;
		}
		
		public function isYourFather():Boolean{
			return false;
		}
		
		public function hurtBy(ih:IHurtAble):void{
			blockJudge(ih as SkillEntity);
		}
		
		//挡住技能判断
		protected function blockJudge(skill:SkillEntity):void{
			if(skill.skillProperty == 5){
				if(skill.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
					if(this.x > skill.x){
						this.x = skill.x - 10;
					}
				}else{
					if(this.x < skill.x){
						this.x = skill.x + 10;
					}
				}
			}
		}
		
		private var shadowPosTemp:Point = new Point();
		/**
		 * 返回影子区域坐标
		 * @return 
		 * 
		 */		
		public function get shadowPos():Point{
			shadowPosTemp.x = this.x + this.shadow.x;
			shadowPosTemp.y = this.y + this.shadow.y;
			return shadowPosTemp;
		}
		
		override public function get collisionPos():int{
			return this.shadowPos.y;
		}
		
		override public function destroy():void{
			this._lastBeHurtSource = null;
			this.shadow = null;
			if(this._beAttackedIdVec){
				this._beAttackedIdVec.length = 0;
				this._beAttackedIdVec = null;
			}
			if(this.charVo){
				this.charVo.destroy();
				this.charVo = null;
			}
			
			super.destroy();
		}
	}
}