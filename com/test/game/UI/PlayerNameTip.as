package com.test.game.UI
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class PlayerNameTip extends BaseNativeEntity
	{
		private var _tfShow:BaseNativeEntity;
		private var _title:Sprite;
		private var _playerName:String;
		private var _type:int;
		public function PlayerNameTip(playerName:String, type:int){
			super();
			name = "PlayerNameTip";
			_playerName = playerName;
			_type = type;
			initUI();
		}
		
		private function initUI() : void{
			if(_type == 0){
				_title = AUtils.getNewObj("PKMyName") as Sprite;
			}else{
				_title = AUtils.getNewObj("PKOtherName") as Sprite;
			}
			_title["PlayerName"].text = _playerName;
			
			var bitmapData:BitmapData = new BitmapData(_title["PlayerName"].width, _title["PlayerName"].textHeight, true, 1);
			bitmapData.draw(_title["PlayerName"]);
			/*_tfShow = new BaseNativeEntity();
			_tfShow.data.bitmapData = bitmapData;
			_tfShow.x = -_tfShow.width * .5;
			_tfShow.y = -15;
			this.addChild(_tfShow);*/
			this.data.bitmapData = bitmapData;
			this.x = -this.width * .5;
		}
		
		override public function destroy():void{
			_title = null;
			if(_tfShow != null){
				_tfShow.destroy();
				_tfShow = null;
			}
			super.destroy();
		}
	}
}