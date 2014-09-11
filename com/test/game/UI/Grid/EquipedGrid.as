package com.test.game.UI.Grid
{
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Mvc.Vo.ItemVo;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class EquipedGrid extends Sprite
	{
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
		
		private var _itemArr:Array = [];
		
		private var _selectable:Boolean = true;
		
		public function set selectable(value:Boolean):void{
			_selectable = value;
		}
		
		
		public function EquipedGrid(CS:Class,col:uint, row:uint, W:int, H:int, offsetX:int, offsetY:int):void
		{
			_CS = CS;
			_col = col;
			_row = row;
			_W = W;
			_H = H;
			_offsetX = offsetX;
			_offsetY = offsetY;
			_uiPool = {};
			
		}
		
		
		public function checkEnableMc(tab:String):void{
			for(var i:int =0; i<_itemArr.length; i++){
				if(_itemArr[i]!=null){
					var result:Boolean;
					switch(tab){
						case "strengthen":
							result = DeformTipManager.getIns().checkStrengthen(_itemArr[i].data);
							break;
						case "forge":
							result = DeformTipManager.getIns().checkForge(_itemArr[i].data);
							break;
					}
					if(result){
						_itemArr[i].showEnableMc();
					}else{
						_itemArr[i].hideEnableMc();
					}
				}

			}
		}
	

		/**
		 * 显示指定序号图标发光框
		 */	
		public function showItemArrSelected(index:int):void{
			if(index != -1){
				_itemArr[index].showSelected();
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
		
		
		
		public function setData(data:Vector.<ItemVo>) : void
		{
			_data = data;
			resetData();
			clearItemArr();
			initRender();
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
		
		private function initRender() : void
		{
			var item:IGrid;
			
			for (var i:int = 0; i <_data.length ; i++)
			{
				
				if (! _uiPool[i]) _uiPool[i] = [];
				item = new _CS();
				item.setData(_data[i]);
				item.selectable = _selectable;
				item.index = i;
				item.x = Math.floor(i % _row) * (_W + _offsetX);
				
				var j:int = Math.floor(i / _row);
				j = j % _col;
				item.y = j * (_H + _offsetY);
				this.addChild(item as DisplayObject );
				_uiPool[i].push(item);
				_itemArr.push(item);
			}
			
		}
		
		
		/**
		 * 清除 
		 * 
		 */		
		 public function destroy():void
		{
			if(this._data){
				_data = null;
			}
			resetData();

		}
		
	}
}