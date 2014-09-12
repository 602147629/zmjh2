package com.test.game.Mvc.control.key{
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ProxyFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.superkaka.mvc.Control.ActionsControl;
	import com.superkaka.mvc.Proxy.ActionsProxy;
	import com.test.game.Modules.ChoosePlayer.view.ChoosePlayerView;
	import com.test.game.Modules.ChooseServer.view.ChooseServerView;
	
	public class GoToPlayerChooseControl extends BaseControl{
		public function GoToPlayerChooseControl(){
			super();
		}
		
		/**
		 *进入选角色
		 * 
		 */		
		public function goToPlayerChoose():void{
			//销毁选角色模块
			ViewFactory.getIns().destroyView(ChooseServerView);
			
			//选角色界面
			ViewFactory.getIns().initView(ChoosePlayerView).show();
			ControlFactory.getIns().initControl(GoToBattleControl);
			ControlFactory.getIns().initControl(GoToLineChooseControl);
			ControlFactory.getIns().initControl(GoToGameMenuControl);
			ControlFactory.getIns().initControl(ActionsControl);
			
			ProxyFactory.getIns().initProxy(ActionsProxy);
		}
		
		
	}
}