package com.test.game.UI
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class DungeonTip extends BaseNativeEntity
	{
		private var _tfBg:BaseNativeEntity;
		private var _tfShow:BaseNativeEntity;
		private var _title:Sprite;
		private var _fodder:String
		public function DungeonTip(str:String)
		{
			super();
			_fodder = str;
			initUI();
		}
		
		private function initUI() : void{
			_title = AUtils.getNewObj("DungeonTipTF") as Sprite;
			_title["DungeonTF"].text = _fodder;
			
			var scale9Grid:Scale9GridImage = new Scale9GridImage(AssetsManager.getIns().getAssetObject("DungeonTipBg"),new Rectangle(5,5,49,15));
			scale9Grid.height = 25;
			scale9Grid.width = _title["DungeonTF"].textWidth + 20;
			_tfBg = new BaseNativeEntity();
			_tfBg.data.bitmapData = scale9Grid.targetBitmapData;
			_tfBg.data.pixelSnapping = PixelSnapping.NEVER;
			_tfBg.x = -_tfBg.width * .5;
			_tfBg.y = -22;
			this.addChild(_tfBg);
			
			var bitmapData:BitmapData = new BitmapData(_title["DungeonTF"].textWidth, _title["DungeonTF"].textHeight, true, 1);
			bitmapData.draw(_title["DungeonTF"]);
			_tfShow = new BaseNativeEntity();
			_tfShow.data.bitmapData = bitmapData;
			_tfShow.x = -_tfShow.width * .5;
			_tfShow.y = -15;
			this.addChild(_tfShow);
		}
		
		override public function destroy():void{
			if(_tfBg != null){
				_tfBg.destroy();
				_tfBg = null;
			}
			if(_tfShow != null){
				_tfShow.destroy();
				_tfShow = null;
			}
			if(_title != null){
				_title = null;
			}
			super.destroy();
		}
	}
}