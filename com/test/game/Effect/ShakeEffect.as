package com.test.game.Effect
{
	import flash.display.Sprite;

	public class ShakeEffect extends RenderEffect
	{
		private var _shakeList:Array;
		private var _shakeCount:int;
		private var _shakeStep:int;
		private var _shakeFrame:int;
		private var _offset:Number;
		public function ShakeEffect(inputList:Array, shakeFrame:int, offset:Number = 1)
		{
			super();
			renderSpeed = 15;
			_shakeStep = 0;
			_shakeList = inputList;
			_shakeFrame = shakeFrame;
			_offset = offset;
		}
		
		override public function step() : void{
			if(_shakeList != null){
				if(_shakeCount == _shakeFrame){
					destroy();
				}else{
					for each(var item:Sprite in _shakeList){
						if(item == null) continue;
						if(_shakeStep < 15){
							item.x += _offset;
							item.y += _offset * .5;
						}else if(_shakeStep >= 15 && _shakeStep < 30){
							item.x -= _offset;
							item.y -= _offset * .5;
						}
					}
					
					if(_shakeStep >= 29){
						_shakeCount++;
						_shakeStep = 0;
					}else{
						_shakeStep++;
					}
				}
			}
		}
		
		override public function destroy() : void{
			_shakeList = null;
			super.destroy();
		}
	}
}