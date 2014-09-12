package com.test.game.Mvc.BmdView
{
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Manager.Layers.GameLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.Base.BaseBmdView;
	import com.test.game.Entitys.Show.ShowRoleEntity;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.Layer.AnimationLayerManager;
	
	public class RoleEntityView extends BaseBmdView
	{
		public function RoleEntityView()
		{
			super();
		}
		override public function init():void{
			initEntity();
			AnimationLayerManager.getIns().roleEntityLayer.bpWidth = 140;
			AnimationLayerManager.getIns().roleEntityLayer.bpHeight = 140;
			AnimationLayerManager.getIns().roleEntityLayer.content.addChild(this);
		}
		
		private var _showEntity:ShowRoleEntity;
		private var _equippedPre:Array;
		private var _equippedNow:Array;
		private function initEntity():void{
			_showEntity = RoleManager.getIns().createShowEntity(PlayerManager.getIns().player.occupation, PlayerManager.getIns().getEquipped());
			_showEntity.x = 70 + (_showEntity.name=="XiaoYao"?3:0);
			_showEntity.y = 80;
			this.addChild(_showEntity);
			_equippedPre = PlayerManager.getIns().getEquipped();
		}
		
		public function update() : void{
			if(_showEntity == null) return;
			_equippedNow = PlayerManager.getIns().getEquipped();
			_showEntity.setAction(ActionState.WAIT);
			for(var i:int = 0; i < _equippedPre.length; i++){
				if(_equippedNow[i] != _equippedPre[i]){
					_showEntity.bodyAction.replaceAssets(i, _equippedNow[i]);
				}
			}
			_equippedPre = _equippedNow;
		}
		
		public function setAction(action:uint) : void{
			_showEntity.setAction(action);
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
//			RenderEntityManager.getIns().removeEntity(this);
			AnimationManager.getIns().addEntity(this);
		}
		
		private function stopShow() : void{
//			RenderEntityManager.getIns().removeEntity(this);
			AnimationManager.getIns().removeEntity(this);
		}
		
		override public function destroy():void{
			if(_showEntity != null){
				if(_showEntity.parent != null){
					_showEntity.parent.removeChild(_showEntity);
				}
				_showEntity.destroy();
				_showEntity = null;
			}
			RenderEntityManager.getIns().removeEntity(this);
			AnimationManager.getIns().removeEntity(this);
			if(_equippedPre != null){
				_equippedPre.length = 0;
				_equippedPre = null;
			}
			if(_equippedNow != null){
				_equippedNow.length = 0;
				_equippedNow = null;
			}
			super.destroy();
		}
	}
}