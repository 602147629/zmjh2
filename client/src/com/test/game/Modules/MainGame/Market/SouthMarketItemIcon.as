package com.test.game.Modules.MainGame.Market
{
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Configuration.SouthMarket;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.ItemIcon;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SouthMarketItemIcon extends BaseSprite implements IGrid
	{
		private var _obj:Sprite;
		
		private var _itemIcon:ItemIcon;
		
		public var layerName:String;
		
		private var _data:SouthMarket;
		
		private var _itemVo:ItemVo;
		
		public function SouthMarketItemIcon()
		{
			this.buttonMode = true;
			//this.mouseChildren = false;
			
			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("southMarketItemIcon") as Sprite;
				this.addChild(_obj);
			}
			
			if(!_itemIcon){
				_itemIcon = new ItemIcon();
				_itemIcon.x = 10;
				_itemIcon.y = 10;
				_itemIcon.selectable = false;
				_itemIcon.menuable = false;
				_itemIcon.num = false;
				this.addChild(_itemIcon);
			}
			
			initEvent();
			super();
		}
		
		
		public function setData(data:*) : void{
			if(data == null){
				this.visible = false;
				return;
			}
			this.visible = true;
			_data = data as SouthMarket;
			
			_itemVo = PackManager.getIns().creatItem(_data.id);
			_itemVo.num = _data.number;
			_itemVo.isPriceShow = false;
			_itemIcon.setData(_itemVo);
			
			itemNameTxt.text = _data.name;
			priceTxt.text = _data.gold.toString();
		}
		
		private function initEvent():void{
			_itemIcon.addEventListener(MouseEvent.CLICK,_onClick);
		}
		
		private  function _onClick(event:MouseEvent):void
		{
			if(_itemVo.type == ItemTypeConst.BOOK){
				if(PlayerManager.getIns().checkNumber("money",_data.gold)){
					(ViewFactory.getIns().getView(TipView) as TipView).setFun(
						"花费"+_data.gold+"金币购买"+_data.name+"?",buyBookItem);
				}else{
					(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
						"金钱不足！");
				}

			}else{
				EventManager.getIns().dispatchEvent(
					new CommonEvent(EventConst.SOUTH_MARKET_ITEM_CLICK,[_data,_itemVo]));	
			}

		}
		
		private function buyBookItem():void
		{
			if(PackManager.getIns().checkMaxRooM([_itemVo])){
				PackManager.getIns().addItemIntoPack(_itemVo.copy());
				PlayerManager.getIns().reduceMoney(_data.gold);
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					_data.name+"购买成功！");
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"背包空间不足！\n请留出空间后再购买");
			}
		}		
		
		
		private function get itemNameTxt():TextField
		{
			return _obj["itemNameTxt"];
		}
		
		private function get priceTxt():TextField
		{
			return _obj["priceTxt"];
		}
		

		
		public function setLocked() : void{
		}
		
		public function set menuable(value:Boolean) : void{
		}
		
		public function set selectable(value:Boolean) : void{
		}
		
		public function set index(value:int) : void{
		}
		
		override public function destroy():void{
			removeComponent(_obj);
			_itemIcon.destroy();
			_data = null;
			super.destroy();
		}
	}
}