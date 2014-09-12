package com.test.game.Effect
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.ResourceOperation.BitmapDataPool;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class DigitalEffect extends BaseEffect
	{
		private var _offsetX:Number = 100;
		public function DigitalEffect() : void{
			super();
		}
		
		public static function createDigital(assets:String, count:int):Sprite
		{
			var len:int = (count.toString()).length;
			var digitalLayer:Sprite = new Sprite();
			var digitalNum:Vector.<MovieClip> = new Vector.<MovieClip>();
			
			for each(var item:String in assets){
				BitmapDataPool.registerData(item, false);
			}
			
			var str:int;
			for(var i:int = 0; i < len; i++){
				str = int(count.toString().substr(i, 1)) + 1;
				var obj:Object = AssetsManager.getIns().getAssetObject(assets);
				var digital:MovieClip = obj as MovieClip;
				digital.gotoAndStop(str);
				digital.y = -17;
				digital.x = i * 33;
				digitalNum.push(digital);
				digitalLayer.addChild(digital);
			}
			
			return digitalLayer;
		}
		
		override public function destroy():void{
			
		}
	}
}