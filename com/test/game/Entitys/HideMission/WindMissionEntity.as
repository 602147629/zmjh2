package com.test.game.Entitys.HideMission
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.test.game.AgreeMent.Battle.IBeHurtAble;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.HideMission.WanEGuMissionManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class WindMissionEntity extends SequenceActionEntity implements IBeHurtAble
	{
		public var shadow:BaseNativeEntity;
		private var tq:TestQuad;
		private var _shadowY:int;
		private var _charVo:CharacterVo;
		private var _collisionSkill:String;
		private var _beAttackedIdVec:Vector.<int>;
		private var _action:BaseSequenceActionBind;
		private var _isOver:Boolean = false;
		public function WindMissionEntity(id:int, assets:Array, collisionSkill:String, shadowY:int)
		{
			_collisionSkill = collisionSkill;
			_shadowY = shadowY;
			_charVo = new CharacterVo();
			_charVo.id = id;
			_charVo.assetsArray = assets;
			_charVo.isDouble = false;
			
			super();
			
			this._beAttackedIdVec = new Vector.<int>();
			this.isRectCollision = true;
			this.collisionIndex = CollisionFilterIndexConst.MONSTER;
			this.collisionListeners = [CollisionFilterIndexConst.PLAYER_SKILL];
		}
		
		override protected function initSequenceAction():void{
			initCollision();
			initAction();
			initShadow();
			
			this.collisionBody = tq;
		}
		
		protected function initShadow():void{
			this.shadow = new BaseNativeEntity();
			this.shadow.data.bitmapData = AUtils.getNewObj("shadow") as BitmapData;	
			this.shadow.registerPoint = new Point(this.shadow.data.bitmapData.rect.width/2, this.shadow.data.bitmapData.rect.height/2)
			this.shadow.y = _shadowY;
			this.shadow.visible = true;
			this.addChildAt(this.shadow, 0);
		}
		
		private function initCollision() : void{
			tq = new TestQuad();
			tq.x = tq.width/2;
			tq.y = tq.height/2;
			tq.visible = false;
			this.addChild(tq);
		}
		
		private function initAction():void{
			_action = AnimationEffect.createAnimation(_charVo.id, _charVo.assetsArray, _charVo.isDouble);
			this.addChild(_action);
		}
		
		public function hurtBy(ih:IHurtAble):void{
			if(!_isOver && _collisionSkill != ""){
				var skillEntity:SkillEntity = ih as SkillEntity;
				if(skillEntity.hitName.indexOf(_collisionSkill) != -1){
					_isOver = true;
					WanEGuMissionManager.getIns().setHideMissionComplete();
					this.visible = false;
				}
			}
		}
		
		public function get beAttackedIdVec():Vector.<int>{
			return _beAttackedIdVec;
		}
		
		public function set beAttackedIdVec(value:Vector.<int>):void{
			_beAttackedIdVec = value;
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
		
		public function set lastBeHurtSource(ia:IHurtAble):void{
			
		}
		
		public function get lastBeHurtSource():IHurtAble{
			return null;
		}
		
		public function isYourFather():Boolean{
			return false;
		}
		
		override public function destroy():void{
			if(tq != null){
				tq.destroy();
				tq = null;
			}
			if(shadow != null){
				shadow.destroy();
				shadow = null;
			}
			if(_action != null){
				_action.destroy();
				_action = null;
			}
			this.collisionBody = null;
			super.destroy();
		}
	}
}