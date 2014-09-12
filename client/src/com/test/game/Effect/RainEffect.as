package com.test.game.Effect
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.Manager.SceneManager;
	
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;

	public class RainEffect extends BaseEffect{
		private static var RAIN_DENSITY:int = 15;
		private var _rain_density:int;
		private var _rainBmpData:BitmapData;
		private var _littleRainBmpData:BitmapData;
		private var _rainImageList:Array;
		private var _rainClearList:Array;
		private var _rainFallList:Array;
		private var _speedList:Array;
		private var _isStart:Boolean;
		public function get isStart() : Boolean{
			return _isStart;
		}
		public function RainEffect(){
			super();
			init();
		}
		
		private function init() : void{
			createBmpData();
			createRain();
		}
		
		private function createBmpData():void{
			var shape:Shape = new Shape();
			var colors:Array = [0xFFFFFF, 0xFFFFFF];
			var alphas:Array = [0.1, 0.6];//可以设置渐变两边的alpha值,1<alpha>0
			var ratios:Array = [0x00, 0xFF];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(20, 20, 0, 0, 0);
			var spreadMethod:String = SpreadMethod.PAD;
			shape.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matr, spreadMethod);  
			shape.graphics.drawRoundRect(0, 0, 70, 1, 1, 1);
			
			var matrix:Matrix = new Matrix();
			matrix.rotate((80/180)*Math.PI);
			
			_rainBmpData = new BitmapData(70, 50, true, 0);
			_rainBmpData.draw(shape, matrix);
			
			
			_littleRainBmpData = new BitmapData(40, 30, true, 0);
			_littleRainBmpData.draw(shape, matrix);
			
			_rainImageList = [];
			_rainFallList = [];
			_speedList = [];
			_rainClearList = [];
		}
		
		private function createRain() : void{
			if(_rain_density == 0){
				_rain_density = RAIN_DENSITY;
			}
			for(var i:uint = 0 ; i < _rain_density; i++){
				var rain:BaseNativeEntity = new BaseNativeEntity();
				rain.x = Math.random() * (GameConst.stage.stageWidth + 50) - 50;
				rain.y = -Math.random() * GameConst.stage.stageHeight;
				if(i % 2 == 0){
					rain.data.bitmapData = _rainBmpData;
				}else{
					rain.data.bitmapData = _littleRainBmpData;
				}
				rain.height = 2;
				rain.name = "RainLayer";
				//rain.rotationValue = -100 / 180 * Math.PI;
				_speedList.push(2.5 + Math.random() * 2.5);
				_rainImageList.push(rain);
				
				var fall:RainFallEntity = AnimationEffect.createRainAnimation(10018, ["RainFall"], false);
				fall.setAction(ActionState.WAIT);
				fall.name = "RainLayer";
				RenderEntityManager.getIns().removeEntity(fall);
				_rainFallList.push(fall);
			}
		}
		public function start() : void{
			_isStart = true;
			_isAllClearOver = false;
			for(var i:int = 0; i < _rainImageList.length; i++){
				SceneManager.getIns().nowScene["pushTop"](_rainImageList[i]);
			}
			_rainClearList = _rainImageList.slice(0, _rainImageList.length - 1);
		}
		
		public function stop() : void{
			_isStart = false;
			//clear();
		}
		
		override public function step():void{
			if(_isStart){
				normalFallDown();
			}else{
				clearFallDown();
			}
		}
		
		private var _isClearOver:Boolean;
		private var _isAllClearOver:Boolean;
		private function clearFallDown():void{
			if(_rainClearList == null)	return;
			if(_rainClearList.length == 0){
				if(_isAllClearOver == false){
					clear();
					_isAllClearOver = true;
				}
				return;
			}
			_isClearOver = false;
			for(var i:int = _rainClearList.length - 1; i >= 0; i--){
				var rainImage:BaseNativeEntity = _rainClearList[i];
				rainImage.y += _speedList[i] * 6;
				rainImage.x += _speedList[i];
				//重新设置移动到界面外的雨丝
				if(rainImage.y > GameConst.stage.stageHeight){
					rainImage.x = Math.random() * (GameConst.stage.stageWidth + 50) - 50 - SceneManager.getIns().nowScene.x;
					rainImage.y = -Math.random() * 50 - 200;
					if(!_isClearOver){
						var index:int = _rainClearList.indexOf(rainImage);
						_rainClearList.splice(index, 1);
						_isClearOver = true;
					}
				}
			}
			for(var j:int = 0; j < 2; j++){
				if(_rainClearList.length == 0){
					if(_isAllClearOver == false){
						clear();
						_isAllClearOver = true;
					}
					return;
				}
				var random:int = int(Math.random() * _rainClearList.length);
				if(_rainClearList[random].y > 320){
					_rainFallList[random].x = _rainClearList[random].x - 20;
					_rainFallList[random].y = _rainClearList[random].y - 5;
					(_rainFallList[random] as BaseSequenceActionBind).setAction(ActionState.SHOW);
					SceneManager.getIns().nowScene.addChildAt(_rainFallList[random], 0);
					RenderEntityManager.getIns().addEntity(_rainFallList[random]);
					_rainClearList[random].x = Math.random() * (GameConst.stage.stageWidth + 50) - 50 - SceneManager.getIns().nowScene.x;;
					_rainClearList[random].y = -Math.random() * 50 - 200;
					if(!_isClearOver){
						_rainClearList.splice(random, 1);
						_isClearOver = true;
					}
				}
			}
		}
		
		private function normalFallDown() : void{
			for(var i:int = 0; i < _rainImageList.length; i++){
				var rainImage:BaseNativeEntity = _rainImageList[i];
				rainImage.y += _speedList[i] * 6;
				rainImage.x += _speedList[i];
				//重新设置移动到界面外的雨丝
				if(rainImage.y > GameConst.stage.stageHeight){
					rainImage.x = Math.random() * (GameConst.stage.stageWidth + 50) - 50 - SceneManager.getIns().nowScene.x;
					rainImage.y = -Math.random() * 50;
				}
			}
			
			for(var j:int = 0; j < 2; j++){
				var random:int = int(Math.random() * _rain_density);
				if(_rainImageList[random].y > 320){
					_rainFallList[random].x = _rainImageList[random].x - 20;
					_rainFallList[random].y = _rainImageList[random].y - 5;
					(_rainFallList[random] as BaseSequenceActionBind).setAction(ActionState.SHOW);
					SceneManager.getIns().nowScene.addChildAt(_rainFallList[random], 0);
					RenderEntityManager.getIns().addEntity(_rainFallList[random]);
					_rainImageList[random].x = Math.random() * (GameConst.stage.stageWidth + 50) - 50 - SceneManager.getIns().nowScene.x;;
					_rainImageList[random].y = -Math.random() * 50 - 50;
				}
			}
		}
		
		public function clear() : void{
			for(var i:int = 0; i < _rainImageList.length; i++){
				SceneManager.getIns().nowScene["popTop"](_rainImageList[i]);
			}
		}
		
		override public function destroy() : void{
			super.destroy();
			stop();
			clear();
			if(_rainImageList != null){
				for(var i:int = 0; i < _rainImageList.length; i++){
					SceneManager.getIns().nowScene["popTop"](_rainImageList[i]);
					_rainImageList[i].destroy();
					_rainImageList[i] = null;
				}
				_rainImageList.length = 0;
				_rainImageList = null;
			}
			if(_rainBmpData != null){
				_rainBmpData.dispose();
				_rainBmpData = null;
			}
			if(_rainClearList != null){
				_rainClearList.length = 0;
				_rainClearList = null;
			}
			if(_rainFallList != null){
				for(var j:int = 0; j < _rainFallList.length; j++){
					_rainFallList[j].destroy();
					_rainFallList[j] = null;
				}
				_rainFallList.length = 0;
				_rainFallList = null
			}
			if(_speedList != null){
				_speedList.length = 0;
				_speedList = null;
			}
		}
	}
}