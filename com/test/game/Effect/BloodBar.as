package com.test.game.Effect
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class BloodBar
	{
		private var _bloodHpBg:BaseNativeEntity;
		private var _bloodHpBar:BaseNativeEntity;
		private var _bloodHpMask:BaseNativeEntity;
		private var _bloodLayer:BaseNativeEntity;
		public function BloodBar(layer:Object,  xPos:int = 0, yPos:int = 0)
		{
			_bloodLayer = new BaseNativeEntity();
			
			_bloodHpBg = new BaseNativeEntity();
			_bloodHpBg.data.bitmapData = AUtils.getNewObj("BloodHpBg") as BitmapData;
			_bloodHpBg.x = -2;
			_bloodHpBg.y = -layer.height + 2;
			if(yPos != 0){
				_bloodHpBg.y = yPos + 2;
			}
			
			_bloodHpBar = new BaseNativeEntity();
			_bloodHpBar.data.bitmapData = AUtils.getNewObj("BloodHpBar") as BitmapData;
			_bloodHpBar.x = 0;
			_bloodHpBar.y = -layer.height + 1;
			if(yPos != 0){
				_bloodHpBar.y = yPos + 1;
			}
			
			_bloodHpMask = new BaseNativeEntity();
			_bloodHpMask.data.bitmapData = AUtils.getNewObj("BloodHpMask") as BitmapData;
			_bloodHpMask.x = -8;
			_bloodHpMask.y = -layer.height;
			if(yPos != 0){
				_bloodHpMask.y = yPos;
			}
			
			_bloodLayer.addChild(_bloodHpBg);
			_bloodLayer.addChild(_bloodHpBar);
			_bloodLayer.addChild(_bloodHpMask);
			_bloodLayer.x = -_bloodLayer.width * .5;
			if(xPos != 0){
				_bloodLayer.x = xPos;
			}
			
			layer.addChild(_bloodLayer);
		}
		
		public function changeBar(rate:Number) : void{
			if(rate < .05 && rate > 0){
				_bloodHpBar.scaleXValue = .05;
			}else{
				_bloodHpBar.scaleXValue = rate;
			}
		}
		
		public function hide() : void{
			_bloodLayer.visible = false;
		}
		
		public function show() : void{
			_bloodLayer.visible = true;
		}
		
		public function set pos(point:Point) : void{
			_bloodLayer.x = point.x;
			//_bloodLayer.y = point.y;
		}
		
		public function destroy() : void{
			if(this._bloodHpBg){
				this._bloodHpBg.destroy();
				this._bloodHpBg = null;
			}
			if(this._bloodHpBar){
				this._bloodHpBar.destroy();
				this._bloodHpBar = null;
			}
			if(this._bloodHpMask){
				this._bloodHpMask.destroy();
				this._bloodHpMask = null;
			}
		}
	}
}