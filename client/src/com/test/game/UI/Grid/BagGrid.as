package com.test.game.UI.Grid
{
	
	import com.superkaka.Tools.CommonEvent;
	import com.test.game.Manager.PackManager;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.ChangePage;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	

	
	public class BagGrid extends Sprite
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
		
		
		private var _data:Vector.<ItemVo>;
		
		private var _uiPool:Object; 
		
		private var _curPage:uint;
		
		private var _pageNum:uint;
		
		private var _itemArr:Array = [];
		
		private var _changePage:ChangePage;
		
		
		
		
		public function BagGrid(CS:Class,col:uint, row:uint, W:int, H:int, offsetX:int, offsetY:int):void
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
			/*while(_itemArr.length>0){
				var tempItem:ItemIcon=_itemArr[0];
				_itemArr.splice(0,1);
			}*/
			_itemArr.length = 0;
		}
		

		public function refresh():void{
			resetData();
			clearItemArr();
			initRender();
			checkPage();
		}
		
		public function setData(data:Vector.<ItemVo>, pageNavi:ChangePage = null) : void
		{
			_data = data;
			_changePage = pageNavi;
			if(_changePage){
				var dataLen:uint = PackManager.getIns().pack.packMaxRoom;
				if(!_changePage.hasEventListener(ChangePage.PAGE_CHANGE_EVENT)){
					_changePage.addEventListener(ChangePage.PAGE_CHANGE_EVENT,naviPageChanged);
				}
				_changePage.setData(dataLen,this._pageNum);
			}
			//refresh();
		}
		
		private function naviPageChanged(evt:CommonEvent):void{
			this._curPage = uint(evt.data);
			refresh();
		}
		
		public function sortDataByMid():void{
			_data=_data.sort(compare);
			function compare(x:ItemVo,y:ItemVo):Number{
				var result:Number;
				if(x.mid > y.mid){
					result = 1;
				}else if(x.mid < y.mid){
					result = -1;
				}else{
					result = 0;
				}
				return result;
			}
		}
		
		public function sortDataByItemId():void{
			
			_data=_data.sort(compare);
			refresh();
			
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
		
		private function resetData() : void{
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
		
		private function getDataByMid(mid:int):ItemVo{
			var itemData:ItemVo;
			for each(var item:ItemVo in _data){
				if(item.mid == mid){
					itemData = item;
					break;
				}
			}
			return itemData;
		}
		
		private function get MaxMid():int{
			var max:int;
			for each(var item:ItemVo in _data){
				if(item.mid>max){
					max = item.mid;
				}
			}
			return max;
		}

		private function initRender() : void{
			var item:ItemIcon;
			var index:int;
			var totalIconNum:int=Math.ceil(PackManager.getIns().pack.packMaxRoom/_pageNum);
			totalIconNum = (totalIconNum == 0 ? 1 : totalIconNum)*_pageNum;//最少也有一页
			
			var maxMid:int = MaxMid;
			for(var i:int = 0; i < totalIconNum; i++){
				index = i / this._pageNum;
				if (!_uiPool[index]) _uiPool[index] = [];
				item = new ItemIcon();
				if(i < PackManager.getIns().pack.packMaxRoom){
					if(i <= maxMid){
						item.setData(getDataByMid(i));
					}else{
						item.setData(null);
					}
				}else{
					item.setLocked();
				}

				item.x = Math.floor(i % _row) * (_W + _offsetX);
				var j:int = Math.floor(i / _row);
				j = j % _col;
				item.y = j * (_H + _offsetY);
				this.addChild(item as DisplayObject);
				_uiPool[index].push(item);
				_itemArr.push(item);
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