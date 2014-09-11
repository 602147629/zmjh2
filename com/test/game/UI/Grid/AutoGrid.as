package com.test.game.UI.Grid
{
	import com.superkaka.Tools.CommonEvent;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.ChangePage;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	
	/**
	 * 
	 * 自动缩进的Grid
	 * 
	 */	
	public class AutoGrid extends Sprite
	{
		public var layerName:String;
		
		private var _CS:Class;
		/**
		 * 行 
		 */		
		private var _col:int;
		/**
		 * 列 
		 */		
		private var _row:int;
		
		private var _W:int;
		
		private var _H:int;
		
		private var _offsetX:int; 
		
		private var _offsetY:int;
		
		
		private var _data:*;
		
		private var _uiPool:Object; 
		
		private var _curPage:uint;
		
		private var _pageNum:uint;
		
		private var _itemArr:Array = [];
		
		public function get itemArr():Array{
			return _itemArr;
		}
		
		//col竖排数量   row横排数量
		public function AutoGrid(CS:Class,col:uint, row:uint, W:int, H:int, offsetX:int, offsetY:int):void
		{
			_CS = CS;
			_col = col;
			_row = row;
			_W = W;
			_H = H;
			_offsetX = offsetX;
			_offsetY = offsetY;
			
			_curPage = 1;
			_pageNum = col*row;
			_uiPool = {};
		}
		
		
		
		
		private var _changePage:ChangePage;
		public function setData(data:*, pageNavi:ChangePage = null) : void
		{
			_data = data;
			_changePage = pageNavi;
			if(_changePage){
				var dataLen:uint = _data.length;
				_changePage.setData(dataLen,this._pageNum);
				if(!_changePage.hasEventListener(ChangePage.PAGE_CHANGE_EVENT)){
					_changePage.addEventListener(ChangePage.PAGE_CHANGE_EVENT,naviPageChanged);
				}
			}
			
			resetData();
			clearItemArr();
			initRender();
			checkPage();
		}
		
		
		
		private function naviPageChanged(evt:CommonEvent):void{
			this._curPage = uint(evt.data);
			
			resetData();
			clearItemArr();
			initRender();
			checkPage();
		}
		
		private function resetData() : void
		{
			
			var item:DisplayObject;
			var items:Array;
			for (var key:String in _uiPool)
			{
				items = _uiPool[key];
				
				while (items.length > 0)
				{
					item = items.pop();
					if (item.parent) item.parent.removeChild(item);
					item["destroy"]();
					item = null;
				}
				delete _uiPool[key];
			}
		}
		
		
		public function sortDataByItemId():void{
			
			_data=_data.sort(compare);
			resetData();
			clearItemArr();
			initRender();
			checkPage();
			
			function compare(x:ItemVo,y:ItemVo):Number{
				var result:Number;
				if(x.id > y.id){
					result = 1;
				}else if(x.id < y.id){
					result = -1;
				}else{
					result = 0;
				}
				
				return result;
			}
		}
		
		private function initRender() : void
		{
			var item:IGrid;
			var index:int;

			for (var i:int = 0; i <_data.length ; i++)
			{
				index = i /this._pageNum;
				if (! _uiPool[index]) _uiPool[index] = [];
				item = new _CS();
				
				item.x = Math.floor(i % _row) * (_W + _offsetX);
				var j:int = Math.floor(i / _row);
				j = j % _col;
				item.y = j * (_H + _offsetY);
				item.index = i;
				item.setData(_data[i]);
				
				this.addChild(item as DisplayObject );
				_uiPool[index].push(item);
				_itemArr.push(item);
			}
		}
		
		
		public function checkSummonEnableMc():void{
			for(var i:int =0; i<_itemArr.length; i++){
				if(_itemArr[i]!=null && (DeformTipManager.getIns().checkSummon(_itemArr[i].data))){
					_itemArr[i].showEnableMc();
				}else{
					_itemArr[i].hideEnableMc();
				}
			}
		}
		
		
		
		public function get first():*{
			return _itemArr[0].data;
		}
		
		/**
		 * 显示指定序号图标发光框
		 */	
		public function showItemArrSelected(index:int):void{
			if(index != -1 && _itemArr != null && _itemArr.length!=0){
				_itemArr[index].showSelected();
			}
		}

		
		/**
		 * 显示指定序号图标发光框
		 */	
		public function showIconSelected(data:*):void{
			if(data != null){
				for(var i:int = 0;i<_itemArr.length;i++){
					if(_itemArr[i].data == data){
						_itemArr[i].showSelected();
					}
				}
			}
		}
		
		
		/**
		 * 清空图标发光框
		 */	
		public function clearItemArrSelected():void{
			for(var i:int = 0; i<_itemArr.length ; i++){
				_itemArr[i].hideSelected();
			}
		}
		
		/**
		 * 清空数组
		 */	
		private function clearItemArr():void{
			while(_itemArr.length>0){
				var tempItem:IGrid=_itemArr[0];
				_itemArr.splice(0,1);
			}
		}
		
		private function checkPage() : void
		{
			var item:DisplayObject;
			for (var key:String in _uiPool)
			{
				if (key == (_curPage-1).toString())
				{
					for each(item in _uiPool[key]) item.visible = true;
				}
				else
				{
					for each(item in _uiPool[key]) item.visible = false;
				}
			}
		}
		
		public function destroy() : void{
			if(_changePage != null){
				if(_changePage.hasEventListener(ChangePage.PAGE_CHANGE_EVENT)){
					_changePage.removeEventListener(ChangePage.PAGE_CHANGE_EVENT,naviPageChanged);
				}
				_changePage.destroy();
				_changePage = null;
			}
			
			resetData();
			_uiPool = null;
			
			_data = null;
			if(_itemArr != null){
				_itemArr.length = 0;
				_itemArr = null;
			}
		}
		
	}
}