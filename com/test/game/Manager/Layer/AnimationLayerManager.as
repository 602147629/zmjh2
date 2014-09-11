package com.test.game.Manager.Layer
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.mvc.BmdViewFactory;
	import com.test.game.Mvc.BmdView.OtherEntityView;
	import com.test.game.Mvc.BmdView.RoleEntityView;
	
	import flash.display.Sprite;
	
	public class AnimationLayerManager extends Singleton
	{
		private var _roleEntityLayer:AnimationLayer = new AnimationLayer();
		private var _otherEntityLayer:AnimationLayer = new AnimationLayer();
		public function AnimationLayerManager(){
			super();
		}
		
		public static function getIns():AnimationLayerManager{
			return Singleton.getIns(AnimationLayerManager);
		}
		
		public function get roleEntityLayer() : AnimationLayer{
			return _roleEntityLayer;
		}
		public function removeFromParentByRole() : void{
			if(roleEntityLayer.parent != null){
				roleEntityLayer.parent.removeChild(roleEntityLayer);
			}
		}
		public function setRolePosition(xPos:int, yPos:int, layer:Sprite, scaleX:Number = 1) : void{
			BmdViewFactory.getIns().initView(RoleEntityView).show();
			roleEntityLayer.x = xPos;
			roleEntityLayer.y = yPos;
			roleEntityLayer.scaleX = scaleX;
			layer.addChild(roleEntityLayer);
		}
		public function updateRole() : void{
			(BmdViewFactory.getIns().initView(RoleEntityView) as RoleEntityView).update();
		}
		public function setActionRole(action:uint) : void{
			(BmdViewFactory.getIns().initView(RoleEntityView) as RoleEntityView).setAction(action);
		}
		
		public function get otherEntityLayer() : AnimationLayer{
			return _otherEntityLayer;
		}
		public function removeFromParentByOther() : void{
			if(otherEntityLayer.parent != null){
				otherEntityLayer.parent.removeChild(otherEntityLayer);
			}
		}
		public function setOtherPosition(xPos:int, yPos:int, scaleX:Number = 1) : void{
			otherEntityLayer.x = xPos;
			otherEntityLayer.y = yPos;
			otherEntityLayer.scaleX = scaleX;
		}
		
		public function step() : void{
			if(_roleEntityLayer != null && _roleEntityLayer.parent != null){
				_roleEntityLayer.step();
			}
			if(_otherEntityLayer != null && _otherEntityLayer.parent != null){
				_otherEntityLayer.step();
			}
		}
	}
}