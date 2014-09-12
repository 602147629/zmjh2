package com.test.game.Mvc.control.key{
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Modules.ChooseLine.view.ChooseLineView;
	import com.test.game.Modules.ChoosePlayer.view.ChoosePlayerView;
	
	public class GoToLineChooseControl extends BaseControl{
		public function GoToLineChooseControl(){
			super();
		}
		
		/**
		 *进入选线
		 * 
		 */		
		public function goToLineChoose():void{
			//销毁选角色模块
			ViewFactory.getIns().destroyView(ChoosePlayerView);
			//注册选线模块
			ViewFactory.getIns().initView(ChooseLineView).show();
		}
		
		
	}
}