package com.test.game.Entitys.Daily
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Manager.Collision.PhysicsWorld;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.AgreeMent.Battle.IBeHurtAble;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Skill.SkillEntity;
	import com.test.game.Entitys.Test.TestQuad;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.SceneManager;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class TreasureShowEntity extends SequenceActionEntity implements IBeHurtAble
	{
		private var tq:TestQuad;
		public var shadow:BaseNativeEntity;
		private var _layer:BaseNativeEntity = new BaseNativeEntity();
		private var _guideMC:MovieClip;
		public function TreasureShowEntity(){
			
			super();
			this.isRectCollision = true;
			this.collisionIndex = CollisionFilterIndexConst.MONSTER;
			this.collisionListeners = [CollisionFilterIndexConst.PLAYER_SKILL];
			RenderEntityManager.getIns().addEntity(this);
			PhysicsWorld.getIns().addEntity(this);
		}
		
		override protected function initSequenceAction():void{
			initImage();
			//super.initSequenceAction();
			
			tq = new TestQuad();
			tq.x = tq.width/2;
			tq.y = tq.height/2;
			tq.visible = false;
			this.addChild(tq);
			
			this.collisionBody = this.tq;
			this.initShadow();
			initGuide();
			
			seekTarget();
		}
		
		private function initGuide():void{
			_guideMC = AUtils.getNewObj("TreasureGuide") as MovieClip;
			_guideMC.x = 300;
			_guideMC.y = 50;
		}
		
		protected function initShadow():void{
			this.shadow = new BaseNativeEntity();
			this.shadow.data.bitmapData = AUtils.getNewObj("shadow") as BitmapData;	
			this.shadow.registerPoint = new Point(this.shadow.data.bitmapData.rect.width/2, this.shadow.data.bitmapData.rect.height/2)
			this.shadow.y = 120;
			this.shadow.x = 50;
			this.shadow.visible = false;
			this.addChildAt(this.shadow, 0);
		}
		
		private function initImage():void{
			var index:int = LevelManager.getIns().nowIndex.split("_")[0];
			this.data.bitmapData = AUtils.getNewObj("Treasure_" + index) as BitmapData;
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
			return DailyMissionManager.getIns().judgeDailyComplete;
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
			return this.y + this.height * .5;
		}
		
		public function hurtBy(ih:IHurtAble):void{
			if(!isYourFather()){
				var skillEntity:SkillEntity = ih as SkillEntity;
				if(skillEntity.hitName.indexOf("JumpPress") != -1){
					findTreasureEffect();
					DailyMissionManager.getIns().setDailyComplete();
				}
			}
		}
		
		
		
		private var _effect:BaseSequenceActionBind;
		private var _findName:BaseNativeEntity;
		private function findTreasureEffect() : void{
			if(_effect == null){
				_effect = AnimationEffect.createAnimation(10017, ["TreasureEffect"], false, clearEffect);
				_effect.y = 80;
				_effect.x = 55;
				_effect.scaleXValue = .9;
				_effect.scaleYValue = .9;
				this.addChild(_effect);
			}
			if(_findName == null){
				_layer.x = 65;
				_layer.y = -30;
				if(_layer.parent != null){
					_layer.parent.removeChild(_layer);
				}
				this.addChild(_layer);
				_findName = new BaseNativeEntity();
				_findName.data.bitmapData = AUtils.getNewObj("TreasureFind") as BitmapData;
				_findName.registerPoint = new Point(_findName.width * .5, _findName.height * .5);
				_findName.scaleXValue = 3;
				_findName.scaleYValue = 3;
				_layer.addChild(_findName);
				TweenLite.to(_findName, .7, {scaleXValue:1, scaleYValue:1, ease:Elastic.easeOut, onComplete:alphaChange});
			}
		}
		private var _stepInterval:int = 50;
		private var _stepTime:int;
		override public function step():void{
			if(!isYourFather()){
				if(_target != null){
					if(Math.abs(_target.shadowPos.x - shadowPos.x) < 100 && Math.abs(_target.shadowPos.y - shadowPos.y) < 50){
						if(_guideMC.parent == null){
							LayerManager.getIns().gameTipLayer.addChild(_guideMC);
						}
					}else{
						if(_guideMC.parent != null){
							_guideMC.parent.removeChild(_guideMC);
						}
					}
				}else{
					seekTarget();
				}
			}else{
				if(_guideMC.parent != null){
					_guideMC.parent.removeChild(_guideMC);
				}
				if(_stepTime < _stepInterval){
					if(_stepTime % 5 == 0){
						this.visible = true;
					}
					if(_stepTime % 10 == 0 && _stepTime != 0){
						this.visible = false;
					}
					_stepTime++;
				}else{
					this.destroy();
				}
			}
		}
		
		private function alphaChange() : void{
			TweenLite.delayedCall(.7,
				function () : void{
					TweenLite.to(_findName, 1.3, {alpha:0, y:-80, onComplete:clearName});
				});
		}
		
		private function clearName() : void{
			if(_findName != null){
				_findName.destroy();
				_findName = null;
			}
		}
		
		private function clearEffect(...args) : void{
			if(_effect != null){
				_effect.destroy();
				_effect = null;
			}
		}
		
		private var _target:PlayerEntity;
		//获得目标角色
		public function seekTarget() : void{
			if(SceneManager.getIns().nowScene != null){
				_target = SceneManager.getIns().myPlayer;
			}
		}
		
		override public function destroy():void{
			RenderEntityManager.getIns().removeEntity(this);
			PhysicsWorld.getIns().removeEntity(this);
			if(_guideMC != null){
				if(_guideMC.parent != null){
					_guideMC.parent.removeChild(_guideMC);
				}
				_guideMC = null;
			}
			super.destroy();
		}
	}
}