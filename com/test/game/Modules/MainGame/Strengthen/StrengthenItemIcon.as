package com.test.game.Modules.MainGame.Strengthen
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EquipedManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Mvc.Configuration.Strengthen;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.ItemIcon;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class StrengthenItemIcon extends ItemIcon implements IGrid
	{
		
		private var _obj:Sprite;
		
		private var _image:BaseNativeEntity;
		
		private var _data:ItemVo;
		
		private var _strengthenData:Strengthen;
		
		private var _menu:Boolean;
		
		//选择框
		private var _lightBG:Sprite;
		
		//动画选择框
		private var _lightMc:MovieClip;
		
		override public function get data():ItemVo{
			return _data;
		}
		
		
		public function StrengthenItemIcon()
		{
			_obj = AssetsManager.getIns().getAssetObject("strengthenItemIcon") as Sprite;
			this.addChild(_obj);
			this.buttonMode = true;
			
			if(!_image){
				_image  = new BaseNativeEntity();
				this.addChild(_image);
			}
			
			//外选择框
			if(!_lightBG){
				_lightBG  = new Sprite();
				_lightBG = AssetsManager.getIns().getAssetObject("lightBG") as Sprite;
				_lightBG.x= 0;
				_lightBG.y= 0;
				_lightBG.visible = false;
				this.addChild(_lightBG);
			}
			
			//动画选择框
			if(!_lightMc){
				_lightMc = AssetsManager.getIns().getAssetObject("strengthenLightMc") as MovieClip;
				_lightMc.x=-1;
				_lightMc.y=-1;
				_lightMc.visible = false;
				this.addChild(_lightMc);
			}
			
			super();
	
		}
		
		override public function setData(data:*):void{
			initEvent();
			
			if (!data) {
				return;
			}
			_data = data;
			

			
			var _url:String = _data.type+_data.id.toString();
			_image.data.bitmapData = AUtils.getNewObj(_url) as BitmapData;
			_image.x=4;
			_image.y=4;
			
			
			_strengthenData=ConfigurationManager.getIns().getObjectByID(AssetsConst.STRENGTHEN,_data.lv) as Strengthen

			var propertyArr:Array = EquipedManager.getIns().getPropertyName(_data); 
			var equipTip:String = propertyArr[1] + "+" + _data.equipConfig[propertyArr[0]].toString();
			TipsManager.getIns().addTips(this,_data);	
			
			itemName.text = _data.name;
			itemRank.text = _strengthenData.strengthen_level;
			
		}
		
		
		private function initEvent():void{
			this.addEventListener(MouseEvent.CLICK,onEquipsSelected);
		}
		
		protected function onEquipsSelected(e:MouseEvent):void
		{
			if(_data){
				EventManager.getIns().dispatchEvent(
					new CommonEvent(EventConst.STRENGTHEN_SELECT_CHANGE,[_data,this]));
			}
		}		
		
		override public function showSelected():void{
			if(_data){
				_lightBG.visible = true;	
			}
		}
		
		override public function hideSelected():void{
			if(_data){
				_lightBG.visible = false;	
			}
		}
		
		public function showEnableMc():void{
			if(_data){
				_lightMc.visible = true;
			}
		}
		
		public function hideEnableMc():void{
			if(_data){
				_lightMc.visible = false;
			}
		}
		
		
		
		private function get itemName():TextField
		{
			return _obj["itemName"];
		}
		
		private function get itemRank():TextField
		{
			return _obj["itemRank"];
		}
		
		
		override public function destroy() : void
		{		

			removeComponent(_image);
			removeComponent(_lightBG);
			
			_data = null;
					
		}

	}
}