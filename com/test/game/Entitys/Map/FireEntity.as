package com.test.game.Entitys.Map
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.test.game.Effect.BaseEffect;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class FireEntity extends BaseEffect
	{
		private var _fire:MovieClip;
		private var _isFire:Boolean;
		public function FireEntity(layer:Sprite, xPos:int, yPos:int)
		{
			super();
			
			_fire = AssetsManager.getIns().getAssetObject("MainMapFire") as MovieClip;
			_fire.buttonMode = true;
			_fire.x = xPos;
			_fire.y = yPos;
			layer.addChild(_fire);
			update();
		}
		
		public function update():void{
			if(!_fire.hasEventListener(MouseEvent.CLICK)){
				_fire.addEventListener(MouseEvent.CLICK, onFireClick);
			}
			_fire.gotoAndStop(1);
			_isFire = false;
		}
		
		protected function onFireClick(event:MouseEvent):void{
			if(!_isFire){
				_fire.gotoAndPlay(2);
				_isFire = true;
			}else{
				_fire.gotoAndStop(1);
				_isFire = false;
			}
		}
	}
}