package com.test.game.Modules.MainGame.boss
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class SummonBossIcon extends BaseSprite implements IGrid
	{
		private var _obj:Sprite;
		
		private var _image:BaseNativeEntity;
		
		public var layerName:String;
		
		private var _data:*;
		private var _nameTxt:TextField;
		
		private var _summonSelected:Sprite;
		
		//动画选择框
		private var _lightMc:MovieClip;
		
		//星级信息显示
		private var _cardInfo:BossCardInfo;
		
		private var _menuable:Boolean = true;
		private var _selectable:Boolean = true;
		
		
		public function get data():ItemVo{
			return _data;
		}
		
		
		public function set menuable(value:Boolean):void{
			_menuable = value;
		}
		

		
		public function set selectable(value:Boolean):void{
			_selectable = value;
		}
		
		private var _index:int;
		
		public function set index(value:int):void{
			_index = value;
		}
		
		public function get index():int{
			return _index;
		}
		
		public function SummonBossIcon()
		{
			this.buttonMode = true;
			
			//外选择框
			if(!_summonSelected){
				_summonSelected  = new Sprite();
				_summonSelected = AssetsManager.getIns().getAssetObject("summonSelected") as Sprite;
				_summonSelected.x=-8;
				_summonSelected.y=-8;
				_summonSelected.visible = false;
				this.addChild(_summonSelected);
			}
			
			//动画选择框
			if(!_lightMc){
				_lightMc = AssetsManager.getIns().getAssetObject("summonEnableMc") as MovieClip;
				_lightMc.x=-11;
				_lightMc.y=-11;
				_lightMc.visible = false;
				this.addChild(_lightMc);
			}
			
			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("summonCard") as Sprite;
				this.addChild(_obj);
			}
			
			//BOSS图标
			if(!_image){
				_image  = new BaseNativeEntity();
				_image.x = 35;
				_image.y =-10;
				this.addChild(_image);
			}
			
			//星级框
			if(!_cardInfo){
				_cardInfo = new BossCardInfo();
				_cardInfo.x= 20;
				_cardInfo.y= 106;
				this.addChild(_cardInfo);
			}
			
			if(!_nameTxt){	
				var tipTextFormat:TextFormat = new TextFormat();
				tipTextFormat.font = "宋体";
				tipTextFormat.size = 14;
				_nameTxt = new TextField();
				_nameTxt.x = 0;
				_nameTxt.y = 0;
				_nameTxt.width =100;
				_nameTxt.textColor = ColorConst.white;
				_nameTxt.defaultTextFormat = tipTextFormat;
				_nameTxt.filters = new Array( new GlowFilter(ColorConst.black,1,2,2,255));
				_nameTxt.mouseEnabled = false;
				this.addChild(_nameTxt);
			}
			
			
		}
		
		public function setLocked():void{
		}
		
		public function setData(data:*):void{
			

			if(!data){
				this.visible = false;
				return;
			}
			
			this.visible = true;
			_data = data;
			
			var _url:String = _data.type+(_data.id - 10000 + 1000).toString();
			_image.data.bitmapData = AUtils.getNewObj(_url) as BitmapData;
			_image.x = 155 *.5 - _image.width * .5;
			
			_nameTxt.text = _data.name;
			
			var pieceId:int = _data.id - 10000 + 9000;
			pieceNum.text = PackManager.getIns().searchItemNum(pieceId).toString()+"/"+ NumberConst.getIns().summonBossCost;
			
			initEvent();
			
		}
		
		private function initEvent():void{
			this.addEventListener(MouseEvent.CLICK,onEquipsSelected);
		}
		
		protected function onEquipsSelected(e:MouseEvent):void
		{
			if(_selectable){
				EventManager.getIns().dispatchEvent(
					new CommonEvent(EventConst.SUMMON_BOSS_SELECT_CHANGE,[_data,this]));
			}

		}	
		
		
		public function showSelected():void{
			if(_data){
				_summonSelected.visible = true;
			}
		}
		
		public function hideSelected():void{
			if(_data){
				_summonSelected.visible = false;
			}
		}
		
		
		public function showEnableMc():void{
			if(_data){
				//GreyEffect.reset(this);
				_lightMc.visible = true;
			}
		}
		
		public function hideEnableMc():void{
			if(_data){
				//GreyEffect.change(this);
				_lightMc.visible = false;
			}
		}
		

		
		private function get pieceNum():TextField
		{
			return _obj["pieceNum"];
		}
		
		override public function destroy():void{
			removeComponent(_obj);
			removeComponent(_image);
			removeComponent(_nameTxt);
			removeComponent(_summonSelected);
			_data = null;
			super.destroy();
		}
	}
}