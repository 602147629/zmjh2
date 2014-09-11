package com.test.game.Manager
{
	import com.greensock.TweenLite;
	import com.superkaka.Tools.Singleton;
	
	public class MoveActionManager extends Singleton
	{
		public function MoveActionManager(){
			super();
			_tweenList = new Array();
			_tweenTime = new Array();
		}
		
		public static function getIns():MoveActionManager{
			return Singleton.getIns(MoveActionManager);
		}
		
		private var _tweenList:Array;
		private var _tweenTime:Array;
		private var _nowIndex:int;
		private var _callback:Function;
		public function addMoveObj(obj:Object, time:Number, vars:Object, index:int = -1, delayTime:Number = -1) : void{
			if(delayTime == -1){
				delayTime = time;
			}
			var input:Object = new Object();
			var arr:Array = new Array();
			input["obj"] = obj;
			input["time"] = time;
			input["vars"] = vars;
			if(index == -1){
				arr.push(input);
				_tweenList.push(arr);
				_tweenTime.push(delayTime);
			}else{
				while(_tweenList[index] == null){
					_tweenList.push(arr);
					_tweenTime.push(delayTime)
				}
				_tweenList[index].push(input);
			}
		}
		
		public function onRightNow() : void{
			for(var i:int = 0; i < _tweenList.length; i++){
				for(var j:int = 0; j < _tweenList[i].length; j++){
					var obj:Object = _tweenList[i][j];
					TweenLite.to(obj.obj, obj.time, obj.vars);
					TweenLite.killTweensOf(obj.obj, true);
				}
			}
			_nowIndex = _tweenList.length;
			_tweenList.length = 0;
			_tweenTime.length = 0;
		}
		
		public function start() : void{
			_nowIndex = 0;
			continueTween();
		}
		
		private function continueTween() : void{
			if(_tweenList[_nowIndex] != null){
				for(var i:int = 0; i < _tweenList[_nowIndex].length; i++){
					var obj:Object = _tweenList[_nowIndex][i];
					TweenLite.to(obj.obj, obj.time, obj.vars);
				}
				TweenLite.delayedCall(_tweenTime[_nowIndex], continueTween);
				_nowIndex++;
			}else{
				_tweenList.length = 0;
				_tweenTime.length = 0;
				if(_callback != null){
					_callback();
				}
			}
		}
		
		public function set callback(value:Function) : void{
			_callback = value;
		}
		public function get callback() : Function{
			return _callback;
		}
		
		public function get indexLength() : int{
			return _tweenTime.length;
		}
	}
}