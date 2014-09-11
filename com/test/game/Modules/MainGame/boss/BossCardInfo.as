package com.test.game.Modules.MainGame.boss
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.Base.BaseSprite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class BossCardInfo extends BaseSprite
	{

		private var _obj:Sprite;

		public function BossCardInfo()
		{
			this.buttonMode = true;
			
			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("bossCardInfo") as Sprite;
				this.addChild(_obj);
			}
		}

		
		public function get rank():MovieClip
		{
			return _obj["rank"];
		}
		
		public function get stars():MovieClip
		{
			return _obj["stars"];
		}

		override public function destroy():void{
			removeComponent(_obj);
			super.destroy();
		}
		
	}
}