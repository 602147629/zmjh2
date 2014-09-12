package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Effect.EyesCloseEffect;
	import com.test.game.Modules.MainGame.GameOverView;
	import com.test.game.Modules.MainGame.Map.MainMapView;
	import com.test.game.Modules.MainGame.PassLevel.PassLevelView;
	
	public class SwitchViewManager extends Singleton{
		public function SwitchViewManager(){
			super();
			init();
		}
		
		private var _eyesEffect:EyesCloseEffect;
		private function init():void{
			_eyesEffect = new EyesCloseEffect();
		}
		
		public static function getIns():SwitchViewManager{
			return Singleton.getIns(SwitchViewManager);
		}
		
		public function set eyesCloseCallback(value:Function) : void{
			_eyesEffect.closeCallback = value;
		}
		
		public function eyesStartEnter() : void{
			_eyesEffect.clear();
			_eyesEffect.addStartItem(ViewFactory.getIns().getView(MainMapView));
			_eyesEffect.addEndItem(MapManager.getIns().nowMap);
			_eyesEffect.start();
		}
		
		public function eyesReStartEnter() : void{
			_eyesEffect.clear();
			_eyesEffect.addStartItem(ViewFactory.getIns().getView(MainMapView));
			_eyesEffect.addEndItem(MapManager.getIns().nowMap);
			_eyesEffect.openEye();
		}
		
		public function eyesEndEnter() : void{
			_eyesEffect.clear();
			_eyesEffect.addStartItem(ViewFactory.getIns().getView(PassLevelView));
			_eyesEffect.addEndItem(ViewFactory.getIns().getView(MainMapView));
			_eyesEffect.start();
		}
		
		public function eyesReEndEnter() : void{
			_eyesEffect.clear();
			_eyesEffect.addStartItem(MapManager.getIns().nowMap);
			_eyesEffect.addStartItem(ViewFactory.getIns().getView(PassLevelView));
			_eyesEffect.closeEye();
		}
		
		public function eyesGameOver() : void{
			_eyesEffect.clear();
			_eyesEffect.addStartItem(MapManager.getIns().nowMap);
			_eyesEffect.addStartItem(ViewFactory.getIns().getView(GameOverView));
			_eyesEffect.closeEye();
		}
	}
}