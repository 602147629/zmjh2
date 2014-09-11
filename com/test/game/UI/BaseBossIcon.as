package com.test.game.UI
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.ItemIcon;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BaseBossIcon extends ItemIcon implements IGrid
	{
		public function BaseBossIcon()
		{
			this.buttonMode = true;
			super();
		}
		
		private var _image:BaseNativeEntity;
		
		private var _data:*;
		
		private var _colorBg:BaseNativeEntity;
		private var _stars:BaseNativeEntity;
		
		private var _lightBG:Sprite;
		
		
		override public function get data():ItemVo{
			return _data;
		}
		
		
	    override public function setData(data:*):void{
			
			
			if (!data) {
				this.visible = false;
				return;
			}
			
			this.visible = true;
			_data = data;
			
			if(!_image){
				_image  = new BaseNativeEntity();
				this.addChild(_image);
			}
			
			//颜色底
			if(!_colorBg){
				_colorBg  = new BaseNativeEntity();
				_colorBg.x=-1;
				_colorBg.y=-1;
				this.addChild(_colorBg);
			}
			
			//星星
			if(!_stars){
				_stars  = new BaseNativeEntity();
				_stars.x=5;
				_stars.y=32;
				this.addChild(_stars);
			}
			
			//外选择框
			if(!_lightBG){
				_lightBG  = new Sprite();
				_lightBG = AssetsManager.getIns().getAssetObject("lightBG") as Sprite;
				_lightBG.x=-3;
				_lightBG.y=-3;
				_lightBG.visible = false;
				this.addChild(_lightBG);
			}
			
			
			var _url:String = _data.type+_data.id.toString();
			_image.data.bitmapData = AUtils.getNewObj(_url) as BitmapData;
			_colorBg.data.bitmapData = AUtils.getNewObj(_data.bossUp.color) as BitmapData;
			var starId:String = "starIcon"+ _data.bossUp.star;
			_stars.data.bitmapData = AUtils.getNewObj(starId) as BitmapData;

			TipsManager.getIns().addTips(this,_data);
		}
		
		override public function destroy() : void
		{		
			removeComponent(_image);
			removeComponent(_colorBg);
			removeComponent(_stars);
			removeComponent(_lightBG);
			_data = null;
			
			super.destroy();	
		}

	}
}