package com.test.game.Entitys.Show
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class BaseAnimationEntity extends Sprite
	{
		private var _animationName:String;
		private var _layer:Sprite;
		private var _isDestroy:Boolean = false;//在多线程返回数据之前销毁，则回调函数不执行
		private var _loadComplete:Boolean;
		private var _data:Bitmap;
		public var animation:MovieClip;
		public function BaseAnimationEntity(name:String, layer:Sprite){
			this._animationName = name;
			this._layer = layer;
			var arr:Array = [AssetsUrl.getAssetObject("Animation/" + _animationName)];
			AssetsManager.getIns().addQueen([], arr, start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args):void{
			if(this._isDestroy){
				return;
			}
			_loadComplete = true;
			var obj:Object = AssetsManager.getIns().getAssetObject(_animationName);
			animation = obj as MovieClip;
			this.addChild(animation);
			_layer.addChild(this);
		}
		
		public function get data():Bitmap{
			return _data;
		}
		
		public function set data(value:Bitmap):void{
			_data = value;
		}
		
		public function destroy() : void{
			if(this.parent != null){
				this.parent.removeChild(this);
			}
			_isDestroy = true;
			if(animation != null){
				if(animation.parent != null){
					animation.parent.removeChild(animation);
				}
				animation = null;
			}
		}
	}
}