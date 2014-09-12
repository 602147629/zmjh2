package com.test.game.Effect
{
	import flash.display.Sprite;

	public class IncreaseEffect extends RenderEffect
	{
		private var _increaseList:Array;
		private var _increaseCount:int;
		private var _increaseStep:int;
		public function IncreaseEffect(inputList:Array)
		{
			super();
			renderSpeed = 2;
			_increaseList = inputList;
		}
		
		override public function step() : void{
			if(_increaseList != null){
				if(_increaseCount == 1){
					destroy();
				}else{
					for each(var item:Sprite in _increaseList){
						if(_increaseStep < 10){
							item.scaleX += .05;
							item.scaleY += .05;
						}else if(_increaseStep >= 10 && _increaseStep < 50){
							item.scaleX -= .0125;
							item.scaleY -= .0125;
						}else{
							_increaseCount++;
							_increaseStep = -1;
						}
					}
					_increaseStep++;
				}
			}
		}
		
		override public function destroy():void{
			super.destroy();
			for each(var item:Sprite in _increaseList){
				item.scaleX = 1;
				item.scaleY = 1;
			}
			_increaseList = null;
		}
	}
}