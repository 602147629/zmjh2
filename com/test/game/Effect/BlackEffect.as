package com.test.game.Effect
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.SceneManager;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BlackEffect extends BaseEffect
	{
		private var _isStart:Boolean;
		private var _circle:BaseNativeEntity;
		private var _upRect:BaseNativeEntity;
		private var _downRect:BaseNativeEntity;
		private var _leftRect:BaseNativeEntity;
		private var _rightRect:BaseNativeEntity;
		private var _layerBitmapData:BitmapData;
		private var _show:BaseNativeEntity;
		private var _showPosX:int;
		private var _showPosY:int;
		public function get isStart() : Boolean{
			return _isStart;
		}
		private function get player() : PlayerEntity{
			if(SceneManager.getIns().nowScene != null){
				return SceneManager.getIns().nowScene["myPlayer"];
			}else{
				return null;
			}
		}
		public function BlackEffect()
		{
			super();
			init();
		}
		
		private function init():void{
			_circle = new BaseNativeEntity();
			_circle.data.bitmapData = AUtils.getNewObj("BlackCircle") as BitmapData;
			_upRect = new BaseNativeEntity();
			_upRect.data.bitmapData = new BitmapData(_circle.width, 550, true, 0xE6000000);
			_downRect = new BaseNativeEntity();
			_downRect.data.bitmapData = new BitmapData(_circle.width, 550, true, 0xE6000000);
			_leftRect = new BaseNativeEntity();
			_leftRect.data.bitmapData = new BitmapData(940, 1100 + 372, true, 0xE6000000);
			_rightRect = new BaseNativeEntity();
			_rightRect.data.bitmapData = new BitmapData(940, 1100 + 372, true, 0xE6000000);
			
			_leftRect.x = 0;
			_leftRect.y = 0;
			_upRect.x = _leftRect.width;
			_upRect.y = 0;
			_circle.x = _leftRect.width;
			_circle.y = _upRect.height;
			_downRect.x = _leftRect.width;
			_downRect.y = _circle.y + _circle.height;
			_rightRect.x = _circle.x + _circle.width;
			_rightRect.y = 0;
			
			_layerBitmapData = new BitmapData(940+940+380, 550+550+372, true, 0x00FFFFFF);
			_layerBitmapData.copyPixels(_leftRect.data.bitmapData, _leftRect.data.bitmapData.rect, new Point(_leftRect.x, _leftRect.y), null, null, true);
			_layerBitmapData.copyPixels(_upRect.data.bitmapData, _upRect.data.bitmapData.rect, new Point(_upRect.x, _upRect.y), null, null, true);
			_layerBitmapData.copyPixels(_circle.data.bitmapData, _circle.data.bitmapData.rect, new Point(_circle.x, _circle.y), null, null, true);
			_layerBitmapData.copyPixels(_downRect.data.bitmapData, _downRect.data.bitmapData.rect, new Point(_downRect.x, _downRect.y), null, null, true);
			_layerBitmapData.copyPixels(_rightRect.data.bitmapData, _rightRect.data.bitmapData.rect, new Point(_rightRect.x, _upRect.y), null, null, true);
			
			_show = new BaseNativeEntity();
		}
		
		override public function step() : void{
			if(_isStart){
				if(player != null){
					_showPosX = int(player.x - 1130);
					_showPosY = int(player.y - 736 + player.bodyAction.y / 3 * 2);
				}
				if(_show != null){
					if(_show.alpha < .7){
						_show.alpha += .1;
					}
				}
				var showBitmapData:BitmapData = new BitmapData(940, 590, true, 0x00FFFFFF);
				var rect:Rectangle = new Rectangle(-_showPosX - SceneManager.getIns().nowScene.x, -_showPosY, 940, 590);
				_show.data.bitmapData = showBitmapData;
				_show.data.bitmapData.copyPixels(_layerBitmapData, rect, new Point(0, 0), null, null, true);
				
			}else{
				if(_show != null){
					if(_show.alpha <= 0.1){
						clear();
					}else{
						var showBitmapDatas:BitmapData = new BitmapData(940, 590, true, 0x00FFFFFF);
						var rects:Rectangle = new Rectangle(-_showPosX - SceneManager.getIns().nowScene.x, -_showPosY, 940, 590);
						_show.data.bitmapData = showBitmapDatas;
						_show.data.bitmapData.copyPixels(_layerBitmapData, rects, new Point(0, 0), null, null, true);
						_show.alpha -= .1;
					}
				}
			}
		}
		
		public function start() : void{
			_isStart = true;
			SceneManager.getIns().nowScene.parent.getChildIndex(SceneManager.getIns().nowScene);
			var index:int = SceneManager.getIns().nowScene.parent.getChildIndex(SceneManager.getIns().nowScene);
			LayerManager.getIns().gameLayer.addChildAt(_show, index);
			_show.alpha = 0;
		}
		
		public function stop() : void{
			_isStart = false;
			_show.alpha = .9;
		}
		
		public function clear():void{
			if(_show != null){
				if(_show.parent != null){
					_show.parent.removeChild(_show);
				}
			}
		}
		
		override public function destroy() : void{
			super.destroy();
			_isStart = false;
			if(_layerBitmapData != null){
				_layerBitmapData.dispose();
				_layerBitmapData = null;
			}
			if(_show != null){
				if(_show.parent != null){
					_show.parent.removeChild(_show);
				}
				_show.destroy();
				_show = null;
			}
			if(_circle != null){
				_circle.destroy();
				_circle = null;
			}
			if(_leftRect != null){
				_leftRect.destroy();
				_leftRect = null;
			}
			if(_rightRect != null){
				_rightRect.destroy();
				_rightRect = null;
			}
			if(_upRect != null){
				_upRect.destroy();
				_upRect = null;
			}
			if(_downRect != null){
				_downRect.destroy();
				_downRect = null;
			}
		}
	}
}