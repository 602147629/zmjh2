package com.test.game.process
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.AgreeMent.Battle.IBeHurtAble;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Entitys.MonsterEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.HideMission.MoZhuHideMissionManager;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class BaseThingEntity extends SequenceActionEntity implements IBeHurtAble
	{
		private var tq:TestQuad;
		protected var _fodderArr:Array = new Array();
		protected var _collisionSkill:String;
		protected var _isOver:Boolean;
		protected var _collisionY:int;
		protected var _isClear:Boolean
		protected var _posX:int;
		protected var _posY:int;
		public var shadow:BaseNativeEntity;
		
		public function BaseThingEntity(input:String)
		{
			super();
			var arr:Array = input.split("|");
			_fodderArr = arr[0].split("_");
			_collisionSkill = arr[1];
			_collisionY = arr[2];
			_isClear = (arr[3]==1?true:false);
			_posX = arr[4].split("_")[0];
			_posY = arr[4].split("_")[1];
			this.isRectCollision = true;
			this.collisionIndex = CollisionFilterIndexConst.MONSTER;
			this.collisionListeners = [CollisionFilterIndexConst.PLAYER_SKILL];
			
			initImage();
			
			RenderEntityManager.getIns().addEntity(this);
			PhysicsWorld.getIns().addEntity(this);
			if(SceneManager.getIns().nowScene != null){
				SceneManager.getIns().nowScene.addChild(this);
			}
			
			this.initShadow();
		}
		
		override protected function initSequenceAction():void{
			
		}
		
		protected function initShadow():void{
			this.shadow = new BaseNativeEntity();
			this.shadow.data.bitmapData = AUtils.getNewObj("shadow") as BitmapData;	
			this.shadow.registerPoint = new Point(this.shadow.data.bitmapData.rect.width/2, this.shadow.data.bitmapData.rect.height/2)
			this.shadow.y = _collisionY;
			this.shadow.x = 50;
			//this.shadow.visible = false;
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
		}
		
		public function changeImage(fodder:String) : void{
			this.data.bitmapData = AUtils.getNewObj(fodder) as BitmapData;
		}
		
		public function set beAttackedIdVec(vec:Vector.<int>):void{
			
		}
		
		public function get beAttackedIdVec():Vector.<int>{
			return null;
		}
		
		public function set lastBeHurtSource(ia:IHurtAble):void{
			
		}
		
		public function get lastBeHurtSource():IHurtAble{
			return null;
		}
		
		public function isYourFather():Boolean{
			return false;
		}
		
		public function judge(entity:MonsterEntity) : Boolean{
			var result:Boolean = false;
			result = _isOver;
			if(!result){
				this.x = entity.x - this.width * .5 + _posX;
				this.y = entity.y - this.height * .5 + _posY;
			}
			return result;
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
					}
				}
			}
		}
		
		private var _stepInterval:int = 50;
		private var _stepTime:int;
		private var _stepStop:Boolean;
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
						destroy();
					}
				}
			}
		}
		
		override public function destroy():void{
			this.collisionBody = null;
			RenderEntityManager.getIns().removeEntity(this);
			PhysicsWorld.getIns().removeEntity(this);
			if(this.parent != null){
				this.parent.removeChild(this);
			}
			super.destroy();
		}
	}
}