package com.test.game.Manager
{
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class StageClickManager extends Singleton
	{
		private var _thingList:Array;
		private var _clickCallbackList:Array;
		private var _overCallbackList:Array;
		private var _outCallbackList:Array;
		public function StageClickManager()
		{
			super();
		}
		
		public static function getIns():StageClickManager{
			return Singleton.getIns(StageClickManager);
		}
		
		public function init() : void{
			_thingList = new Array();
			_clickCallbackList = new Array();
			_overCallbackList = new Array();
			_outCallbackList = new Array();
			GameConst.stage.addEventListener(MouseEvent.CLICK, onClick);
			GameConst.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
		}
		
		public function step() : void{
			if(_thingList == null) return;
			for(var i:int = 0; i < _thingList.length; i++){
				_thingList[i].step();
			}
		}
		
		public function addClickThing(obj:DisplayObject, clickCallback:Function = null, overCallback:Function = null, outCallback:Function = null) : void{
			_thingList.push(obj);
			_clickCallbackList.push(clickCallback);
			_overCallbackList.push(overCallback);
			_outCallbackList.push(outCallback);
		}
		
		public function removeClickThing(obj:DisplayObject) : void{
			var index:int = _thingList.indexOf(obj);
			if(index != -1){
				_thingList.splice(index, 1);
				_clickCallbackList.splice(index, 1);
			}
		}
		
		private var _mouseOverIndex:int;
		protected function onMouseOver(e:MouseEvent):void{
			_mouseOverIndex = positionJudge(e.stageX, e.stageY);
			if(_mouseOverIndex != -1){
				if(_overCallbackList[_mouseOverIndex] != null){
					_overCallbackList[_mouseOverIndex]();
				}
				Mouse.cursor = MouseCursor.BUTTON;
			}else{
				Mouse.cursor = MouseCursor.AUTO;
			}
			onMouseOut(_mouseOverIndex);
		}
		
		private function onMouseOut(index:int) : void{
			for(var i:int = 0; i < _outCallbackList.length; i++){
				if(i != index){
					if(_outCallbackList[i] != null){
						_outCallbackList[i]();
					}
				}
			}
		}
		
		protected function onClick(e:MouseEvent):void{
			var index:int = positionJudge(e.stageX, e.stageY);
			if(index != -1){
				if(_clickCallbackList[index] != null){
					_clickCallbackList[index]();
				}
			}
		}
		
		private function positionJudge(xPos:int, yPos:int) : int{
			var index:int = -1;
			for(var i:int = 0; i < _thingList.length; i++){
				var point:Point = (_thingList[i] as DisplayObject).localToGlobal(new Point(_thingList[i].x, _thingList[i].y));
				if(Math.abs(xPos - (point.x - _thingList[i].x))< _thingList[i].width * .5
					&& Math.abs(yPos - (point.y - _thingList[i].y)) < _thingList[i].height * .5){
					index = i;
					break;
				}
			}
			return index;
		}
		
		public function clear() : void{
			if(_thingList != null){
				_thingList.length = 0;
				_clickCallbackList.length = 0;
				_overCallbackList.length = 0;
				_outCallbackList.length = 0;
				
				GameConst.stage.removeEventListener(MouseEvent.CLICK, onClick);
				GameConst.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
			}
		}
	}
}