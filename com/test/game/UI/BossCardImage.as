package com.test.game.UI
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Mvc.Vo.ItemVo;
	
	import flash.display.BitmapData;
	
	public class BossCardImage extends BaseSprite
	{
		private var _image:BaseNativeEntity;
		private var _colorBg:BaseNativeEntity;
		private var _stars:BaseNativeEntity;
		private var _data:ItemVo;
		
		public function BossCardImage()
		{
			if(!_image){
				_image  = new BaseNativeEntity();
				this.addChild(_image);
			}
			
			//颜色底
			if(!_colorBg){
				_colorBg  = new BaseNativeEntity();
				_colorBg.x=0;
				_colorBg.y=0;
				this.addChild(_colorBg);
			}
			
			//星星
			if(!_stars){
				_stars  = new BaseNativeEntity();
				_stars.x=5;
				_stars.y=32;
				this.addChild(_stars);
			}
			
			super();
		}
		
		
		public function setData(data:ItemVo):void{
			_data = data;
			var _url:String = _data.type+_data.id.toString();
			_image.data.bitmapData = AUtils.getNewObj(_url) as BitmapData;
			
			_colorBg.data.bitmapData = AUtils.getNewObj(_data.bossUp.color) as BitmapData;
			var starId:String = "starIcon"+ _data.bossUp.star;
			_stars.data.bitmapData = AUtils.getNewObj(starId) as BitmapData;
			
		}
		
		override public function destroy():void{
			removeComponent(_image);
			removeComponent(_colorBg);
			removeComponent(_stars);
			super.destroy();
		}
		

	}
}