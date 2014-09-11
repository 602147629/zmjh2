package com.test.game.Modules.MainGame.Title
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class TitleIcon extends BaseSprite implements IGrid
	{

		private var _index:int;
		
		private var _obj:MovieClip;

		public var data:Object;

		//是够获得此称号
		private var _own:Boolean;

		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player
		}
		
		public function TitleIcon()
		{
			this.buttonMode = true;
			
			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("TitleIcon") as MovieClip;
				this.addChild(_obj);
			}
			titleName.mouseEnabled = false;
				
		}
		
		public function setData(data:*):void{

			if(data==null){
				this.visible = false;
				titleName.text = "";
				return;
			}
			this.data = new Object();
			this.data.titleData = data;
			this.visible = true;
			
			hideSelected();
			checkTitleEnable();
			if(this.data.titleData.id == NumberConst.getIns().title_10 && this.data.own==false){
				titleName.text = "????";
			}else{
				titleName.text = this.data.titleData.name;
			}
			initEvent();
			
		}
		
		private function checkTitleEnable():void
		{
			_own = false;
			for each(var titleId:int in player.titleInfo.titleOwned){
				if(titleId == this.data.titleData.id){
					_own = true;
				}
			}
			
			if(_own){
				GreyEffect.reset(this);
			}else{
				GreyEffect.change(this);
			}
			this.data.own = _own;
		}		
		
		
		public function hideSelected():void{
			_obj.gotoAndStop("unSelect");
		}
		
		public function showSelected():void{
			_obj.gotoAndStop("select");
		}
		
		private function initEvent():void{
			this.addEventListener(MouseEvent.CLICK,onTitleSelected);
		}
		
		protected function onTitleSelected(e:MouseEvent):void
		{
			EventManager.getIns().dispatchEvent(
				new CommonEvent(EventConst.TITLE_SELECT_CHANGE,[this.data,this]));
			
		}	
		

		
		private function get titleName():TextField
		{
			return _obj["titleName"];
		}
		
		public function setLocked() : void{
		}
		
		public function set menuable(value:Boolean) : void{
		}
		
		public function set selectable(value:Boolean) : void{
		}
		
		public function set index(value:int) : void{
			_index = value;
		}
		
		public function get index() : int{
			return _index;
		}
		
		override public function destroy() : void{
			removeComponent(_obj);
			super.destroy();
		}
	}
}