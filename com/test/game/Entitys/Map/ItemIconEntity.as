package com.test.game.Entitys.Map
{
	import com.greensock.TweenLite;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.SceneManager;
	import com.test.game.UI.DungeonTip;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class ItemIconEntity extends BaseNativeEntity
	{
		private var _fodder:String;
		private var _itemName:String
		private var _pos:Point;
		private var _direct:int;
		private var _speed:Number = 1;
		private var _startMove:Boolean = false;
		private var _isDestroy:Boolean = false;
		private var _shadow:BaseNativeEntity;
		private var _itemIcon:BaseNativeEntity;
		private var _tfBg:DungeonTip;
		private var _layer:BaseNativeEntity;
		public function ItemIconEntity(fodder:String, itemName:String, pos:Point = null, direct:int = 1){
			super();
			
			_fodder = fodder;
			_itemName = itemName;
			_pos = pos;
			_direct = direct;
			
			initImage();
			initBg();
			initPos();
			
			RenderEntityManager.getIns().addEntity(this);
			var randomX:int = Math.random() * 20;
			var randomY:int = Math.random() * 10;
			TweenLite.to(this, .5, {bezier:[{x:_pos.x + _direct * (25 + randomX), y:_pos.y - 50 + randomY}, {x:_pos.x + _direct * (50 + randomX), y:_pos.y + 50 + randomY}], onComplete:startMove});
		}
		
		private function initImage():void{
			_layer = new BaseNativeEntity();
			this.addChild(_layer);
			_itemIcon = new BaseNativeEntity();
			_itemIcon.data.bitmapData = AUtils.getNewObj(_fodder) as BitmapData;
			_itemIcon.x = -_itemIcon.width * .5;
			_layer.addChild(_itemIcon);
		}
		
		private function initBg():void{
			_tfBg = new DungeonTip(_itemName);
			_layer.addChild(_tfBg);
		}
		
		private function startMove() : void{
			_shadow = new BaseNativeEntity();
			_shadow.data.bitmapData = AUtils.getNewObj("shadow") as BitmapData;	
			_shadow.scaleXValue = .5;
			_shadow.x = -_shadow.width * .5;
			_shadow.y = 20;
			//_layer.addChildAt(_shadow, 0);
			TweenLite.delayedCall(.5, 
				function () : void{
					if(_shadow.parent != null){
						_shadow.parent.removeChild(_shadow);
					}
					_startMove = true;
				});
		}
		
		private function initPos():void{
			this.x = _pos.x;
			this.y = _pos.y;
		}
		
		override public function step() : void{
			if(_startMove){
				if(_target == null){
					seekTarget();
				}else{
					var duration:Number = Math.abs(this.x - _target.x)/250;
					if(this.x > _target.x){
						TweenLite.to(this, duration, {x:_target.x - this.width * .5, y:_target.bodyPos.y});
					}else{
						TweenLite.to(this, duration, {x:_target.x + this.width * .5, y:_target.bodyPos.y});
					}
					if(Math.abs(this.y - _target.bodyPos.y) < 30 && Math.abs(this.x + this.width * .5 - _target.bodyPos.x) < this.width * .5){
						_startMove = false;
						_isDestroy = true;
					}
				}
			}else{
				if(_isDestroy){
					destroy();
				}
			}
		}
		
		private var _target:PlayerEntity;
		//获得目标角色
		public function seekTarget() : void{
			if(SceneManager.getIns().nowScene != null){
				_target = SceneManager.getIns().myPlayer;
			}
		}
		
		override public function destroy() : void{
			_startMove = false;
			_isDestroy = true;
			TweenLite.killTweensOf(this, false);
			if(_itemIcon != null){
				_itemIcon.destroy();
				_itemIcon = null;
			}
			if(_shadow != null){
				_shadow.destroy();
				_shadow = null;
			}
			_target = null;
			RenderEntityManager.getIns().removeEntity(this);
			super.destroy();
		}
	}
}