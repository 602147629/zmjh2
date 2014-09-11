package com.test.game.Entitys.HideMission
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.CollisionEntity;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.AgreeMent.Battle.IBeHurtAble;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Manager.HideMission.MoZhuHideMissionManager;
	
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	public class BaseHideMissionEntity extends CollisionEntity implements IBeHurtAble
	{
		private var tq:TestQuad;
		private var _beAttackedIdVec:Vector.<int>;
		protected var _fodderArr:Array = new Array();
		protected var _collisionSkill:String;
		protected var _isOver:Boolean = false;
		protected var _collisionY:int;
		protected var _isClear:Boolean
		public var shadow:BaseNativeEntity;
		
		public function BaseHideMissionEntity(fodderArr:Array, collisionSkill:String = "", collisionY:int = 50, isClear:Boolean = false){
			super();
			_fodderArr = fodderArr;
			_collisionSkill = collisionSkill;
			_collisionY = collisionY;
			_isClear = isClear;
			this._beAttackedIdVec = new Vector.<int>();
			this.isRectCollision = true;
			this.collisionIndex = CollisionFilterIndexConst.MONSTER;
			this.collisionListeners = [CollisionFilterIndexConst.PLAYER_SKILL];
			
			initImage();
			
			RenderEntityManager.getIns().addEntity(this);
			PhysicsWorld.getIns().addEntity(this);
			
			this.initShadow();
		}
		
		protected function initShadow():void{
			this.shadow = new BaseNativeEntity();
			this.shadow.data.bitmapData = AUtils.getNewObj("shadow") as BitmapData;	
			this.shadow.registerPoint = new Point(this.shadow.data.bitmapData.rect.width/2, this.shadow.data.bitmapData.rect.height/2)
			this.shadow.y = _collisionY;
			this.shadow.x = 50;
			this.shadow.visible = false;
			this.addChildAt(this.shadow, 0);
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
		
		private function initImage():void{
			this.data.bitmapData = AUtils.getNewObj(_fodderArr[0]) as BitmapData;
			this.collisionBody = this;
			if(_fodderArr[0] == "HideMission1_6"){
				this.glowFilter = new GlowFilter(0xFFFF00);
			}
		}
		
		public function changeImage(fodder:String) : void{
			this.data.bitmapData = AUtils.getNewObj(fodder) as BitmapData;
		}
		
		public function get beAttackedIdVec():Vector.<int>{
			return _beAttackedIdVec;
		}
		
		public function set beAttackedIdVec(value:Vector.<int>):void{
			_beAttackedIdVec = value;
		}
		
		public function set lastBeHurtSource(ia:IHurtAble):void{
			
		}
		
		public function get lastBeHurtSource():IHurtAble{
			return null;
		}
		
		public function isYourFather():Boolean{
			return false;
		}
		
		public function hurtBy(ih:IHurtAble):void{
			if(!_isOver && _collisionSkill != ""){
				var skillEntity:SkillEntity = ih as SkillEntity;
				if(skillEntity.hitName.indexOf(_collisionSkill) != -1){
					_isOver = true;
					MoZhuHideMissionManager.getIns().setHideMissionComplete();
					if(_fodderArr.length >= 2){
						changeImage(_fodderArr[1]);
					}else{
						changeImage("");
						if(_fodderArr[0] == "HideMission1_6"){
							this.glowFilter = null;
						}
					}
				}
			}
		}
		
		protected var _stepInterval:int = 50;
		protected var _stepTime:int;
		protected var _stepStop:Boolean;
		override public function step() : void{
			if(_isClear){
				if(_isOver && !_stepStop){
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
		
		override public function destroy():void{
			this.collisionBody = null;
			RenderEntityManager.getIns().removeEntity(this);
			PhysicsWorld.getIns().removeEntity(this);
			super.destroy();
		}
	}
}