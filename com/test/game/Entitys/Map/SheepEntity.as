package com.test.game.Entitys.Map
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.test.game.Effect.BaseEffect;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SheepEntity extends BaseEffect
	{
		private var _sheep:MovieClip;
		private var _layer:Sprite;
		private var _clickCount:int;
		private var _xPos:int;
		private var _yPos:int;
		private var _scaleX:int;
		private var _countStep:int;
		private var _isShow:Boolean;
		private var _speedX:Number;
		public function SheepEntity(layer:Sprite, xPos:int, yPos:int, scaleX:int = 1)
		{
			super();
			
			_layer = layer;
			_xPos = xPos;
			_yPos = yPos;
			_scaleX = scaleX;
			_speedX = _scaleX * .1;
			
			_sheep = AssetsManager.getIns().getAssetObject("MainMapSheep") as MovieClip;
			_sheep.buttonMode = true;
			_sheep.x = _xPos;
			_sheep.y = _yPos;
			_sheep.scaleX = _scaleX;
			update();
		}
		
		protected function onSheepClick(event:MouseEvent):void{
			_clickCount++;
			if(_clickCount >= 10){
				_sheep.removeEventListener(MouseEvent.CLICK, onSheepClick);
				_sheep.gotoAndPlay(33);
			}
		}
		
		override public function step():void{
			return;
			if(!_isShow)	return;
			if(_countStep < 300){
				if(_countStep == 0){
					_sheep.scaleX = -_scaleX;
					_sheep.gotoAndPlay(17);
				}
				_sheep.x += _speedX;
			}else if(_countStep < 600){
				if(_countStep == 300){
					_sheep.scaleX = _scaleX;
				}
				_sheep.x += -_speedX;
			}else if(_countStep < 1200){
				if(_countStep == 600){
					_sheep.gotoAndPlay(1);
				}
			}else{
				_countStep = -1;
			}
			_countStep++;
		}
		
		public function stop() : void{
			_isShow = false;
		}
		
		public function update() : void{
			if(!_sheep.hasEventListener(MouseEvent.CLICK)){
				_sheep.addEventListener(MouseEvent.CLICK, onSheepClick);
			}
			_countStep = int(Math.random() * 600) + 601;
			_sheep.x = _xPos;
			_sheep.y = _yPos;
			_sheep.scaleX = _scaleX;
			_sheep.gotoAndPlay(1);
			_layer.addChild(_sheep);
			_clickCount = 0;
			_isShow = true;
		}
	}
}