package com.test.game.UI
{
	import com.superkaka.Tools.CommonEvent;
	import com.test.game.Const.EventConst;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class TabBar extends Sprite
	{
		

		private var _items:Array;
		
		private var _selectIndex:int;
		public function set selectIndex(value:int) : void
		{

			_selectIndex = value;	
			setItemsStatus();
			this.dispatchEvent(new CommonEvent(EventConst.TYPE_SELECT_CHANGE,_selectIndex));
		}
		
		protected function setItemsStatus() : void
		{
			var mc:MovieClip;
			for (var i:int = 0, len:int = _items.length; i < len; i++)
			{
				mc = _items[i];
				
				if (i != _selectIndex)
				{
					mc.gotoAndStop(1);
				}
				else
				{
					mc.gotoAndStop(2);
				}
			}
		}
		
		public function TabBar(items:Array)
		{
			_items = items;
			_selectIndex = 0;
			init();
		}
		
		private function init() : void
		{
			var mc:MovieClip;
			for (var i:int = 0, len:int = _items.length; i < len; i++)
			{
				mc = _items[i];
				
				mc.buttonMode = true;

				mc.useHandCursor = true;
				
				mc["mName"] = i.toString();
				
				mc.addEventListener(MouseEvent.CLICK, onTabClick);
			}
			this.x = _items[0].x;
			this.y = _items[0].y;
		}
		
		private function onTabClick(e:MouseEvent) : void
		{
			selectIndex = parseInt(e.currentTarget["mName"]);
		}
		
		public function destroy() : void{
			if(_items != null){
				var mc:MovieClip;
				
				while(_items.length > 0){
					mc = _items.pop();
					mc = null;
				}
				_items.length = 0;
				_items = null
			}
		}
	}
}