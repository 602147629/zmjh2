package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Mvc.view.Loading.LoadingView;
	
	public class LoadManager extends Singleton
	{
		public function LoadManager(){
			super();
		}
		
		public static function getIns():LoadManager{
			return Singleton.getIns(LoadManager);
		}
		
		public function onProgress(...args):void{
			var loadingView:LoadingView = ViewFactory.getIns().getView(LoadingView) as LoadingView;
			loadingView.showBg = true;
			loadingView.showProgress(args);
		}
		
		public function onProgressLittle(...args):void{
			var loadingView:LoadingView = ViewFactory.getIns().getView(LoadingView) as LoadingView;
			loadingView.showBg = false;
			loadingView.showProgress(args);
		}
		
		public function hideProgress() : void{
			var loadingView:LoadingView = ViewFactory.getIns().getView(LoadingView) as LoadingView;
			loadingView.hide();
		}
			
	}
}