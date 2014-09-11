package com.test.game.Mvc.control.key{
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ProxyFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.superkaka.mvc.Control.ActionsControl;
	import com.superkaka.mvc.Proxy.ActionsProxy;
	import com.test.game.Modules.ChoosePlayer.view.ChoosePlayerView;
	import com.test.game.Modules.ChooseServer.view.ChooseServerView;
	import com.test.game.Mvc.control.Escort.EscortControl;
	import com.test.game.Mvc.view.Loading.LoadingView;
	
	public class InitLoadingCompleteControl extends BaseControl{
		public function InitLoadingCompleteControl(){
			super();
		}
		
		/**
		 *开始游戏 
		 * 
		 */		
		public function execute():void{
			//隐藏加载假面
			ViewFactory.getIns().initView(LoadingView).hide();
			ViewFactory.getIns().initView(ChooseServerView).show();
			ControlFactory.getIns().initControl(GoToPlayerChooseControl);
			ControlFactory.getIns().initControl(GoToBattleControl);
			ControlFactory.getIns().initControl(GoToLineChooseControl);
			ControlFactory.getIns().initControl(GoToGameMenuControl);
			ControlFactory.getIns().initControl(ActionsControl);
			ControlFactory.getIns().initControl(LeaveGameControl);
			ControlFactory.getIns().initControl(EscortControl);
			ControlFactory.getIns().initControl(NewGameControl);
			ControlFactory.getIns().initControl(GotoHeroBattleControl);
			ControlFactory.getIns().initControl(GotoFunnyBattleControl);
			
			//销毁选角色视图
			var cpv:ChoosePlayerView = ViewFactory.getIns().getView(ChoosePlayerView) as ChoosePlayerView;
			if(cpv){
				ViewFactory.getIns().destroyView(ChoosePlayerView);
			}
			
			ProxyFactory.getIns().initProxy(ActionsProxy);
		}
	}
}