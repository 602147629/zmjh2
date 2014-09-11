package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Modules.MainGame.MainUI.ExtraBar;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class ExtraBarManager extends Singleton
	{
		public function ExtraBarManager()
		{
			super();
		}
		
		public static function getIns():ExtraBarManager{
			return Singleton.getIns(ExtraBarManager);
		}
		
		public function getBtnPos(name:String) : Point{
			var p:Point = new Point();
			var sp:DisplayObject = ViewFactory.getIns().getView(ExtraBar).layer[name];
			p.x = sp.x  + sp.width * .5;
			p.y = sp.y  + sp.height * .5;
			return p;
		}
	}
}