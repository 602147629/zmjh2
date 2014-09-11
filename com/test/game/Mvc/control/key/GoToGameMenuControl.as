package com.test.game.Mvc.control.key{
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseControl;
	import com.test.game.Modules.ChooseLine.view.ChooseLineView;
	import com.test.game.Modules.GameMenu.view.GameMenuView;
	import com.test.game.Mvc.BmdView.GameSenceView;
	import com.test.game.Mvc.view.Loading.MenuBarView;
	import com.test.game.Modules.MainGame.Map.BaseMapView;
	
	public class GoToGameMenuControl extends BaseControl{
		public function GoToGameMenuControl(){
			super();
		}
		
		/**
		 *返回开始界面
		 * 
		 */		
		public function goToGameMenu():void{
			//隐藏开始界面
			var gmv:GameMenuView = ViewFactory.getIns().getView(GameMenuView) as GameMenuView;
			if(gmv){
				gmv.show();
			}
			//隐藏菜单界面
			var mbv:MenuBarView = ViewFactory.getIns().getView(MenuBarView) as MenuBarView;
			if(mbv){
				mbv.hide();
			}
			//销毁gameview
			var gsv:GameSenceView = BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView;
			if(gsv){
				BmdViewFactory.getIns().destroyView(GameSenceView);
			}
			
			//销毁地图
			var bmv:BaseMapView = ViewFactory.getIns().getView(BaseMapView) as BaseMapView;
			if(bmv){
				ViewFactory.getIns().destroyView(BaseMapView)
			}
			
			//销毁选线
			var clv:ChooseLineView = ViewFactory.getIns().getView(ChooseLineView) as ChooseLineView;
			if(clv){
				ViewFactory.getIns().destroyView(clv)
			}
			
			//显示gamemenu
			ViewFactory.getIns().initView(GameMenuView).show();
			
//			BitmapDataPool.removeUnionData();
//			BitmapDataPool.removeData("map1");
		}
		
		
	}
}