package com.test.game.Effect
{
	import com.superkaka.game.Loader.AssetsManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class LevelTimeEffect extends RenderEffect
	{
		public var oppositeType:Boolean = false;
		private var _isStart:Boolean;
		private var _timeLayer:Sprite;
		private var _timeList:Array = ["min1", "min2", "sec1", "sec2", "minSec1", "minSec2"];
		
		private var _minSecStep:int = -1;
		private var _secStep:int = 0;
		public function set secStep(value:int) : void{
			_secStep = value;
		}
		public function get secStep() : int{
			return _secStep;
		}
		
		public function get timeLayer() : Sprite{
			return _timeLayer;
		}
		public function LevelTimeEffect(){
			super();
			init();
		}
		
		private function init():void{
			var obj:Object = AssetsManager.getIns().getAssetObject("TimeShow");
			_timeLayer = obj as Sprite;
			_timeLayer.x = 10;
			_timeLayer.y = 50;
			for(var i:int = 0; i < _timeList.length; i++){
				(_timeLayer[_timeList[i]] as MovieClip).stop();
			}
			(_timeLayer["min1"] as MovieClip).visible = false;
		}
		
		override public function step() : void{
			if(_isStart){
				_minSecStep += 2;
				if(_minSecStep == 59){
					if(oppositeType){
						_secStep--
					}else{
						_secStep++;
					}
					_minSecStep = -1;
				}
				timeChange();
				//trace((int(_min / 10)) + "" + (int(_min % 10)) + ":" + (int(_sec / 10)) + "" + (int(_sec % 10)))
			}
		}
		
		private var _sec:int;
		private var _min:int;
		private function timeChange() : void{
			if(_secStep <= 0){
				(_timeLayer["min1"] as MovieClip).visible = false;
				(_timeLayer["min1"] as MovieClip).gotoAndStop(1);
				(_timeLayer["min2"] as MovieClip).gotoAndStop(1);
				(_timeLayer["sec1"] as MovieClip).gotoAndStop(1);
				(_timeLayer["sec2"] as MovieClip).gotoAndStop(1);
				(_timeLayer["minSec1"] as MovieClip).gotoAndStop(1);
				(_timeLayer["minSec2"] as MovieClip).gotoAndStop(1);
			}else if(_secStep < 3600){
				_min = _secStep / 60;
				(_timeLayer["min1"] as MovieClip).gotoAndStop(int(_min / 10) + 1);
				if((_timeLayer["min1"] as MovieClip).currentFrame == 1){
					(_timeLayer["min1"] as MovieClip).visible = false;
				}else{
					(_timeLayer["min1"] as MovieClip).visible = true;
				}
				(_timeLayer["min2"] as MovieClip).gotoAndStop(int(_min % 10) + 1);
				_sec = _secStep % 60;
				(_timeLayer["sec1"] as MovieClip).gotoAndStop(int(_sec / 10) + 1);
				(_timeLayer["sec2"] as MovieClip).gotoAndStop(int(_sec % 10) + 1);
				(_timeLayer["minSec1"] as MovieClip).gotoAndStop(int(_minSecStep / 10) + 1);
				(_timeLayer["minSec2"] as MovieClip).gotoAndStop(int(_minSecStep % 10) + 1);
			}else{
				(_timeLayer["min1"] as MovieClip).gotoAndStop(6);
				(_timeLayer["min2"] as MovieClip).gotoAndStop(10);
				(_timeLayer["sec1"] as MovieClip).gotoAndStop(6);
				(_timeLayer["sec2"] as MovieClip).gotoAndStop(10);
				(_timeLayer["minSec1"] as MovieClip).gotoAndStop(6);
				(_timeLayer["minSec2"] as MovieClip).gotoAndStop(10);
			}
		}
		
		public function start() : void{
			_isStart = true;
		}
		
		public function stop() : void{
			_isStart = false;
		}
		
		//过关时间
		public function get levelTime() : int{
			return _secStep;
		}
		
		override public function destroy():void{
			if(_timeLayer != null){
				if(_timeLayer.parent != null){
					_timeLayer.parent.removeChild(_timeLayer);
				}
				_timeLayer = null;
			}
			super.destroy();
		}
	}
}