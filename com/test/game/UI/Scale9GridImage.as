package com.test.game.UI
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Scale9GridImage extends Sprite
	{
		private var _sourceData:BitmapData;
		private var rect:Rectangle;
		
		private var grid00:Bitmap;
		private var grid10:Bitmap;
		private var grid20:Bitmap;
		private var grid01:Bitmap;
		private var grid11:Bitmap;
		private var grid21:Bitmap;
		private var grid02:Bitmap;
		private var grid12:Bitmap;
		private var grid22:Bitmap;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _minWidth:Number;
		private var _minHeight:Number;
		
		private var _targetSourceData:BitmapData;
		public function get targetBitmapData() : BitmapData{
			return _targetSourceData;
		}
		public function Scale9GridImage(source:Object,rectangle:Rectangle = null)
		{
			if(source is BitmapData){
				this._sourceData = BitmapData(source);
			}else{
				this._sourceData = new BitmapData(source.width+0.99999,source.height+0.99999,true,0);
				this._sourceData.draw(visualize(source));
			}
			
			if(rectangle != null){
				this.rect = rectangle;
			}else if(null != source.scale9Grid){
				this.rect = source.scale9Grid;
			}else{
				this.rect = new Rectangle(0,0,_sourceData.width,_sourceData.height);
			}
			
			this._width = _sourceData.width;
			this._height = _sourceData.height;
			
			grid00 = getBitmap(0,			0,rect.left,				rect.top);
			grid01 = getBitmap(rect.left,	0,rect.width,				rect.top);
			grid02 = getBitmap(rect.right,	0,this._width - rect.right,rect.top);
			
			grid10 = getBitmap(0,			rect.top,rect.left,					rect.height);
			grid11 = getBitmap(rect.left,	rect.top,rect.width,					rect.height);
			grid12 = getBitmap(rect.right,	rect.top,this._width - rect.right,	rect.height);
			
			grid20 = getBitmap(0,			rect.bottom,rect.left,					this._height - rect.bottom);
			grid21 = getBitmap(rect.left,	rect.bottom,rect.width,					this._height - rect.bottom);
			grid22 = getBitmap(rect.right,	rect.bottom,this._width - rect.right,	this._height - rect.bottom);
			
			this._minWidth = grid00.width+grid02.width;
			this._minHeight = grid00.height + grid20.height;
		}
		
		public function getBitmap(x:Number,y:Number,width:Number,height:Number):Bitmap{
			if(width <= 0||height <= 0){
				return null
			}
			var bitmapData:BitmapData = new BitmapData(width, height, true, 1);
			bitmapData.copyPixels(this._sourceData,new Rectangle(x, y, width, height),new Point(0, 0));
			var bitmap:Bitmap = new Bitmap(bitmapData, PixelSnapping.NEVER);
			bitmap.x = x;
			bitmap.y = y;
			//this.addChild(bitmap);
			return bitmap;
		}
		
		override public function set width(newWidth:Number):void{
			if(newWidth>= this._minWidth){
				update(newWidth - this._width,0);
				this._width = newWidth;
				updateNewImage();
			}
		} 
		
		override public function set height(newHeight:Number):void{
			if(newHeight>= this._minHeight){
				update(0,newHeight - this._height);
				this._height = newHeight;
				updateNewImage();
			}
		} 
		
		public function update(diffW:Number,diffH:Number):void{
			if(diffW != 0){
				diff(grid01,"width",diffW);
				diff(grid11,"width",diffW);
				diff(grid21,"width",diffW);
				diff(grid02,"x",diffW);
				diff(grid12,"x",diffW);
				diff(grid22,"x",diffW);
			}
			if(diffH != 0){
				diff(grid10,"height",diffH);
				diff(grid11,"height",diffH);
				diff(grid12,"height",diffH);
				diff(grid20,"y",diffH);
				diff(grid21,"y",diffH);
				diff(grid22,"y",diffH);
			}
		}
		
		private function updateNewImage():void{
			if(_width == 0 && _height == 0) return;
			_targetSourceData = new BitmapData(_width, _height, true, 1);
			for(var i:int = 0; i < 3; i++){
				for(var j:int = 0; j < 3; j++){
					var image:Bitmap = this["grid" + i + j];
					var newBitmapData:BitmapData = scalePic(image);
					_targetSourceData.copyPixels(newBitmapData,
						new Rectangle(0, 0, image.width, image.height),
						new Point(image.x, image.y));
				}
			}
			
		}
		
		public static function scalePic(bm:Bitmap):BitmapData{   
			var pw:Number = bm.width / bm.bitmapData.width;    //percentWidth   
			var ph:Number = bm.height / bm.bitmapData.height;    //percentHeight   
			var bmd:BitmapData = new BitmapData(bm.width, bm.height, true, 1);   
			var sm:Matrix = new Matrix();    //scaleMatrix   
			sm.scale(pw, ph);
			bmd.draw(bm, sm);
			return bmd;   
		}  

		
		public function diff(obj:DisplayObject,property:String,diffNum:Number):void{
			obj[property] += diffNum;
		}
		
		public function visualize(src:Object):DisplayObject{
			if(src== null) return null;
			var target:DisplayObject;
			if(src is DisplayObject) target = DisplayObject(src);
			return target;
		}
	}
}