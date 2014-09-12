package com.test.game.Entitys.Weather
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	
	import flash.display.BitmapData;
	
	public class LeafEntity extends BaseNativeEntity
	{
		private var _fodder:String;
		private var _face:int;
		public var speedX:Number;
		public var speedY:Number;
		public function LeafEntity(fodder:String, inputX:Number, inputY:Number)
		{
			super();
			
			_fodder = fodder;
			speedX = inputX;
			speedY = inputY;
			this.data.bitmapData = AUtils.getNewObj(_fodder) as BitmapData;
		}
		
		public function setFodder(face:int) : void{
			if(_face != face){
				if(face == -1){
					this.data.bitmapData = AUtils.getNewObj(_fodder + "_1") as BitmapData;
				}else{
					this.data.bitmapData = AUtils.getNewObj(_fodder) as BitmapData;
				}
				_face = face;
			}
		}
	}
}