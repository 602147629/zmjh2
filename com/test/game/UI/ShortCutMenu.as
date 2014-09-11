package com.test.game.UI
{

	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.TitleManager;
	import com.test.game.Modules.MainGame.BagView;
	import com.test.game.Modules.MainGame.BaGua.BaGuaView;
	import com.test.game.Modules.MainGame.ItemCombine.ChargeCombineView;
	import com.test.game.Modules.MainGame.ItemCombine.FashionCombineView;
	import com.test.game.Modules.MainGame.Role.RoleDetailView;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	
	public class ShortCutMenu extends BaseSprite
	{
		
		public static const startX:int = 4;
		public static const startY:int = 4;		
		public static const offsetY:int = 20;
		
		private var _bg:Sprite;		
		private var _uiPool:Vector.<ShortCutItem>;
		
		public var mouseOver:Boolean;
		
		private var _data:Array;
		private var _type:String;
		private var _itemData:*;
		
		
		public function ShortCutMenu()
		{
			_uiPool = new Vector.<ShortCutItem>();
			
			initUI();
			initEvent();
		}
		
		
		private function initUI() : void
		{
			// 底图
			_bg = new Scale9GridDisplayObject(AssetsManager.getIns().getAssetObject("tipBg")
				,new Rectangle(5,5,33,38));
			this.addChild(_bg);
		}
		
		private function initEvent() : void
		{
			this.addEventListener(MouseEvent.MOUSE_MOVE, RollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, rollOut);
		}
		
		private function RollOver(e:MouseEvent):void{
			mouseOver = true;
		}
		
		private function rollOut(e:MouseEvent) : void
		{
			mouseOver = false;
			this.hide();
		}

		public function setData(data:Array, type:String, itemData:*) : void
		{
			_data = data;
			_type = type;
			_itemData = itemData;
			
			checkData();
		}
		
		protected function checkData() : void
		{
			hideItems();
			
			var item:ShortCutItem;
			var maxWidth:int;
			for (var i:int = 0, len:int = _data.length; i < len; i++)
			{
				item = getItem(i);
				item.initRender(_data[i]);
				item.visible = true;
				if(item.width > maxWidth){
					maxWidth = item.width;
				}
			}
			
			_bg.width = 64;
			_bg.height = startY + i * offsetY + 2;
		}
		
		protected function onItemSelected(e:CommonEvent) : void
		{
			if (_type == ItemTypeConst.EQUIP)
			{
				switch (e.data)
				{
					case "装备":
						(ViewFactory.getIns().initView(BagView) as BagView).putOnEquip(_itemData);
						break;
					case "卸下": 
						PackManager.getIns().putDownEquipment(_itemData);
						break;
					case "卖出":
						trace(e.data);
						break;
				}
			}else if(_type == ItemTypeConst.PROP){
				switch (e.data)
				{
					case "使用":
						(ViewFactory.getIns().getView(BagView) as BagView).useProp(_itemData);
						break;
				}
			}else if(_type == ItemTypeConst.BOSS){
				switch (e.data)
				{
					case "出售":
						(ViewFactory.getIns().getView(BagView) as BagView).sellItem(_itemData,NumberConst.getIns().one);
						break;
				}
			}else if(_type == ItemTypeConst.BOOK){
				switch (e.data)
				{
					case "出售":
						(ViewFactory.getIns().getView(BagView) as BagView).sellItem(_itemData,NumberConst.getIns().one);
						break;
				}
			
			}else if(_type == ItemTypeConst.BAGUA){
				switch (e.data)
				{
					case "聚灵保护":
						_itemData.protect = 1;
						(ViewFactory.getIns().getView(BaGuaView) as BaGuaView).refresh();
						break;
					case "解除保护":
						_itemData.protect = 0;
						(ViewFactory.getIns().getView(BaGuaView) as BaGuaView).refresh();
						break;
				}
			}else if(_type == ItemTypeConst.TITLE){
				switch (e.data)
				{
					case "显示":
						TitleManager.getIns().showTitle();
						break;
					case "不显示":
						TitleManager.getIns().hideTitle();
						break;
					case "卸下":
						TitleManager.getIns().putDownTitle();
						break;
				}
			}else if(_type == ItemTypeConst.FASHION){
				switch (e.data)
				{
					case "装备":
						(ViewFactory.getIns().initView(BagView) as BagView).putOnFashion(_itemData);
						break;
					case "合成":
						if(ViewFactory.getIns().getView(FashionCombineView)){
							(ViewFactory.getIns().initView(FashionCombineView) as FashionCombineView).setData(_itemData);
						}else{
							(ViewFactory.getIns().initView(FashionCombineView) as FashionCombineView).callBack=
								function():void{
									(ViewFactory.getIns().initView(FashionCombineView) as FashionCombineView).setData(_itemData);
								}
						}
						ViewFactory.getIns().getView(BagView).hide();
						if(ViewFactory.getIns().getView(RoleDetailView)){
							ViewFactory.getIns().getView(RoleDetailView).hide();
						}
						ViewFactory.getIns().initView(FashionCombineView).show();
						break;
					case "卸下": 
						PackManager.getIns().putDownFashion(_itemData);
						break;
				}
			}else if(_type == ItemTypeConst.WEATHER_PIECE){
				switch (e.data)
				{
					case "合成":
						if(ViewFactory.getIns().getView(ChargeCombineView)){
							(ViewFactory.getIns().initView(ChargeCombineView) as ChargeCombineView).setData(_itemData);
						}else{
							(ViewFactory.getIns().initView(ChargeCombineView) as ChargeCombineView).callBack=
								function():void{
									(ViewFactory.getIns().initView(ChargeCombineView) as ChargeCombineView).setData(_itemData);
								}
						}
						ViewFactory.getIns().getView(BagView).hide();
						if(ViewFactory.getIns().getView(RoleDetailView)){
							ViewFactory.getIns().getView(RoleDetailView).hide();
						}
						ViewFactory.getIns().initView(ChargeCombineView).show();
						break;
					case "出售":
						(ViewFactory.getIns().getView(BagView) as BagView).sellItem(_itemData,NumberConst.getIns().one);
						break;
					case "全部出售":
						(ViewFactory.getIns().getView(BagView) as BagView).sellItem(_itemData,_itemData.num);
						break;
				}
			}else{
				switch (e.data)
				{
					case "出售":
						(ViewFactory.getIns().getView(BagView) as BagView).sellItem(_itemData,NumberConst.getIns().one);
						break;
					case "全部出售":
						(ViewFactory.getIns().getView(BagView) as BagView).sellItem(_itemData,_itemData.num);
						break;
				}
			}
			
			this.hide();
		}
		
		
		protected function getItem(index:int) : ShortCutItem
		{
			var item:ShortCutItem;
			
			if (index >= _uiPool.length)
			{
				item = new ShortCutItem();
				item.x = startX;
				item.y = startY + index * offsetY;
				addChild(item);
				item.addEventListener(ShortCutItem.ITEM_SELECTED, onItemSelected);
				_uiPool.push(item);
			}
			
			item = _uiPool[index];
			
			return item;
		}
		
		protected function hideItems() : void
		{
			for each(var item:ShortCutItem in _uiPool)
			{
				item.visible = false;
			}
		}
		
		public function show() : void
		{
			this.visible = true;
		}
		
		public function hide() : void
		{
			this.visible = false;

		}
		

		
		override public function destroy():void{
			removeComponent(_bg);
			while(_uiPool.length>0){
				var item:ShortCutItem=_uiPool[0];
				item.destroy();
				item.removeEventListener(ShortCutItem.ITEM_SELECTED, onItemSelected);
				_uiPool.splice(0,1);
			}
			
			_data = null;
			_itemData = null;
		
		}
	}
}