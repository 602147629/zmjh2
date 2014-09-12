package com.test.game.Entitys.Test
{
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	
	import flash.display.BitmapData;

	public class StationShow extends BaseNativeEntity
	{
		public var isInStation:Boolean;
		public var offsetY:int;
		public function StationShow(wid:int, hei:int)
		{
			super();
			
			this.data.bitmapData = new BitmapData(wid,hei,true,0xaaffffff);
			isInStation = false;
		}
		
		public function get getDistance() : int
		{
			return (this.data.height + 1);
		}
		
		public function get halfX() : int
		{
			return this.data.width * .5;
		}
		override public function destroy():void
		{
			super.destroy();
		}
		
	}
}