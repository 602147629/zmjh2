package com.test.game.UI
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	
	
	public class ChangePage extends Sprite
	{
		private var _obj:Sprite;
		
		public static const PAGE_CHANGE_EVENT:String = "page_change_event";
		public var _callbackFunc:Function;
		
		private var _totalPages:uint = 1;//总页数
		private var _curPage:uint = 1;//当前页数
		private var _pageNum:uint = 1;//每页数目
		
		private var grayFilter:Array = new Array(new ColorMatrixFilter([0.5,0.5,0.5,0,0,0.5,0.5,0.5,0,0,0.5,0.5,0.5,0,0,0,0,0,1,0]));
		
		public var layerName:String;
		
		public function ChangePage()
		{
			_obj = AssetsManager.getIns().getAssetObject("ChangePage") as Sprite;
			this.addChild(_obj);

			preBtn.addEventListener(MouseEvent.CLICK,preBtnClicked);
			nextBtn.addEventListener(MouseEvent.CLICK,nextBtnClicked);
		}
		
		
		/**
		 * 设置数据 
		 * 
		 */		
		public function setData(dataLen:uint,pageNum:uint):void{
			this._pageNum = pageNum;
			_totalPages = Math.ceil(dataLen/this._pageNum);
			this._totalPages = _totalPages == 0 ? 1 : this._totalPages;//最少也有一页
			if(this._totalPages < this._curPage){
				//改变当前页
				this._curPage = this._totalPages;
			}
			this.dispatchEvent(new CommonEvent(PAGE_CHANGE_EVENT,[_curPage]));
			this.refreshDisplay();
			
			checkState();
		}
		
		private function preBtnClicked(e:MouseEvent):void{
			if(_curPage > 1 && _curPage <= _totalPages){
				_curPage--;
				this.refreshDisplay();
				this.dispatchEvent(new CommonEvent(PAGE_CHANGE_EVENT,[_curPage]));
			}
			checkState();
		}
		
		private function nextBtnClicked(e:MouseEvent):void{
			if(_curPage < _totalPages){
				_curPage++;
				this.refreshDisplay();
				this.dispatchEvent(new CommonEvent(PAGE_CHANGE_EVENT,[_curPage]));
			}
			checkState();
		}
		

		private function checkState() : void
		{
			
			preBtn.mouseEnabled=true;
			preBtn.filters = undefined;
			nextBtn.mouseEnabled=true;
			nextBtn.filters= undefined;
			
			if(_curPage <= 1)
			{
				preBtn.mouseEnabled=false;
				preBtn.filters = grayFilter;
			}
			if(_curPage >= _totalPages)
			{
				nextBtn.mouseEnabled=false;
				nextBtn.filters = grayFilter;
			}
			if(_callbackFunc != null) _callbackFunc(_curPage);
		}
		
		public function refreshDisplay(page:int=0):void{
			if(page>0){
				_curPage = page;
			}
			pageNum.text = _curPage+"/"+_totalPages;
			checkState();
		}
		
		public function get nextBtn():SimpleButton{
			return _obj["nextBtn"];
		}
		
		public function get preBtn():SimpleButton{
			return _obj["preBtn"];
		}
		
		public function get pageNum():TextField{
			return _obj["pageNum"];
		}
		
		public function destroy() : void{
			_callbackFunc = null;
			if(_obj != null){
				preBtn.removeEventListener(MouseEvent.CLICK,preBtnClicked);
				nextBtn.removeEventListener(MouseEvent.CLICK,nextBtnClicked);
				if(_obj.parent != null){
					_obj.parent.removeChild(_obj);
				}
				_obj = null;
			}
		}
	}
}