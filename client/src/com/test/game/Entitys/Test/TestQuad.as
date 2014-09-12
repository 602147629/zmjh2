package com.test.game.Entitys.Test{
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	
	import flash.display.BitmapData;
	
	public class TestQuad extends BaseNativeEntity{
		public function TestQuad(width:int = 50, height:int = 80){
			super();
			this.data.bitmapData = new BitmapData(width, height,true,0xaaff0000);
//			data = new BitmapData(50,80,true,0xaaff0000);
		}
		
	}
}