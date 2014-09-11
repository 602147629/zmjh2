package com.test.game.Mvc.BmdView
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Manager.Layers.GameLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.Base.BaseBmdView;
	import com.test.game.Entitys.Show.ShowRoleEntity;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.Layer.AnimationLayerManager;
	
	public class OtherEntityView extends BaseBmdView
	{
		public function OtherEntityView()
		{
			super();
		}
		override public function init():void{
			AnimationLayerManager.getIns().otherEntityLayer.bpWidth = 140;
			AnimationLayerManager.getIns().otherEntityLayer.bpHeight = 140;
			AnimationLayerManager.getIns().otherEntityLayer.content.addChild(this);
		}
		
		private var _showEntity:ShowRoleEntity;
		private var _equippedPre:Array;
		private var _equippedNow:Array;
		public function setEntity(occupation:int, equipped:Array):void{
			if(_showEntity == null){
				_showEntity = RoleManager.getIns().createShowEntity(occupation, equipped);
				_showEntity.x = 70 + (_showEntity.name=="XiaoYao"?3:0);
				_showEntity.y = 70;
				this.addChild(_showEntity);
				_equippedPre = equipped;
				_showEntity.setAction(ActionState.WAIT);
			}else{
				update(equipped);
			}
			show();
		}
		
		public function update(equipped:Array) : void{
			if(_showEntity == null) return;
			_equippedNow = equipped;
			_showEntity.setAction(ActionState.WAIT);
			for(var i:int = 0; i < _equippedPre.length; i++){
				if(_equippedNow[i] != _equippedPre[i] && _equippedNow[i] != ""){
					_showEntity.bodyAction.replaceAssets(i, _equippedNow[i]);
				}
			}
			_equippedPre = _equippedNow;
		}
		
		override public function step() : void{
			super.step();
		}
		
		override public function show():void{
			super.show();
			startShow();
		}
		
		override public function hide():void{
			super.hide();
			stopShow();
		}
		
		override protected function getContainer():GameLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		private function startShow():void{
			RenderEntityManager.getIns().removeEntity(this);
			AnimationManager.getIns().addEntity(this);
		}
		
		private function stopShow() : void{
			RenderEntityManager.getIns().removeEntity(this);
			AnimationManager.getIns().removeEntity(this);
		}
		
		override public function destroy():void{
			if(this.parent != null){
				this.parent.removeChild(this);
			}
			if(_showEntity != null){
				if(_showEntity.parent != null){
					_showEntity.parent.removeChild(_showEntity);
				}
				_showEntity.destroy();
				_showEntity = null;
			}
			RenderEntityManager.getIns().removeEntity(this);
			AnimationManager.getIns().removeEntity(this);
			super.destroy();
		}
	}
}