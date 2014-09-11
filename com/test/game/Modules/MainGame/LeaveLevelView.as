package com.test.game.Modules.MainGame
{
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Mvc.control.key.LeaveGameControl;
	
	import flash.events.MouseEvent;
	
	import fl.controls.Button;
	
	public class LeaveLevelView extends BaseView
	{
		private var _leaveBtn:Button;
		public function LeaveLevelView()
		{
			super();
		}
		
		override public function init():void{
			super.init();
			
			initView();
		}
		
		private function initView() : void
		{
			_leaveBtn = new Button();
			_leaveBtn.label = "离开关卡";
			_leaveBtn.x = 450;
			_leaveBtn.y = 290;
			this.addChild(_leaveBtn);
			_leaveBtn.addEventListener(MouseEvent.CLICK, leaveGame);
		}
		
		private function leaveGame(e:MouseEvent) : void
		{
			this.hide();
			LeaveGameControl(ControlFactory.getIns().getControl(LeaveGameControl)).leaveLevel();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
	}
}