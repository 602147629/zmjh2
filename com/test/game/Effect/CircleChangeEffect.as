package com.test.game.Effect
{
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.test.game.Manager.SceneManager;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class CircleChangeEffect extends RenderEffect
	{
		public function CircleChangeEffect(pos:Point, color:uint = 0xFFFFFF, isRepeat:Boolean = true)
		{
			super();
			create(pos, color);
			_isRepeat = isRepeat;
		}
		
		private var _layer:BaseNativeEntity;
		private var _pos:Point;
		private var _isRepeat:Boolean;
		public function create(pos:Point, color:uint) : void{
			_pos = pos;
			var circle:Sprite = new Sprite();
			circle.graphics.beginFill(color, .7);
			circle.graphics.drawCircle(500, 500, 500);
			circle.graphics.endFill();
			
			var bpData:BitmapData = new BitmapData(1000, 1000, true, 0x00FFFFFF);
			bpData.draw(circle);
			
			var bne:BaseNativeEntity = new BaseNativeEntity();
			bne.data.bitmapData = bpData;
			bne.registerPoint = new Point(bne.width * .5, bne.height * .5);
			_layer = new BaseNativeEntity();
			_layer.addChild(bne);
			_layer.pos = pos;
			_layer.registerPoint = new Point(_layer.width * .5, _layer.height * .5);
			_layer.scaleXValue = 0.1;
			_layer.scaleYValue = 0.1;
			if(SceneManager.getIns().nowScene != null){
				SceneManager.getIns().nowScene.addChildAt(_layer, 0);
			}
		}
		
		override public function step() : void{
			super.step();
			
			if(_layer != null){
				_layer.scaleXValue += .3;
				_layer.scaleYValue += .3;
				if(_layer.scaleXValue >= 2){
					_layer.visible = false;
				}
				if(_layer.scaleXValue >= 3){
					if(_isRepeat){
						var circle:CircleChangeEffect = new CircleChangeEffect(_pos, 0x000000, false);
					}
					_layer.destroy();
					_layer = null;
					this.destroy();
				}
			}
		}
	}
}