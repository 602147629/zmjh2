package com.test.game.UI
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.EquipedManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.BagView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	
	public class ItemIcon extends BaseSprite implements IGrid
	{

		
		public static const EQUIPED_MENU:Array = ["卸下"];
		public static const UNLOCK_MENU:Array = ["解锁"];
		public static const PACK_MENU:Array = ["装备"];
		public static const PACK_MENU_VIP4:Array = ["装备","合成"];
		public static const PROP_MENU:Array = ["使用"];
		public static const ONE_SELL_MENU:Array = ["出售"];
		public static const WEATHER_PIECE_MENU:Array = ["合成","出售","全部出售"];
		public static const SELL_MENU:Array = ["出售","全部出售"];
		public static const TITLE_HIDE_MENU:Array = ["不显示","卸下"];
		public static const TITLE_SHOW_MENU:Array = ["显示","卸下"];
		
		private var _image:BaseNativeEntity;
		
		private var _stars:BaseNativeEntity;
		
		private var _colorBg:BaseNativeEntity;
		
		private var _numBg:BaseNativeEntity;
		
		private var _numTxt:TextField;
		
		
		private var _url:String;
		
		private var _shortCutMenu:ShortCutMenu;
		
		private var _locked:Boolean;
		
		private var _menuable:Boolean = true;
		
		public function set menuable(value:Boolean):void{
			_menuable = value;
		}
		
		private var _selectable:Boolean = true;
		
		
		private var _data:ItemVo;
		
		//选择框
		private var _lightBG:Sprite;
		
		public var isSelected:Boolean;
		
		
		
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
		
		
		private var _num:Boolean = true;
		
		public function set num(value:Boolean):void{
			_num = value;
		}

		
		public function get data():ItemVo{
			return _data;
		}
		

		public function ItemIcon()
		{
			this.buttonMode = true;
			this.doubleClickEnabled = true;
			this.mouseChildren = false;
			//物品图标
			if(!_image){
				_image  = new BaseNativeEntity();
				this.addChild(_image);
			}
			
			//数字背景
			if(!_numBg){
				_numBg  = new BaseNativeEntity();
				_numBg.x=25;
				_numBg.y=25;
				this.addChild(_numBg);
			}
			
			//数字
			if(!_numTxt){
				_numTxt = new TextField();
				_numTxt.x = 22;
				_numTxt.y = 25;
				_numTxt.width =25;
				_numTxt.autoSize = TextFieldAutoSize.CENTER;
				_numTxt.textColor = 0Xffffff;
				_numTxt.filters = new Array( new GlowFilter(0X000000,1,2,2,255));
				_numTxt.mouseEnabled = false;
				this.addChild(_numTxt);
			}
			
			//颜色底
			if(!_colorBg){
				_colorBg  = new BaseNativeEntity();
				_colorBg.x=-1;
				_colorBg.y=-1;
				this.addChild(_colorBg);
			}
			
			//星星
			if(!_stars){
				_stars  = new BaseNativeEntity();
				_stars.x=5;
				_stars.y=32;
				this.addChild(_stars);
			}
			
			//外选择框
			if(!_lightBG){
				_lightBG = AssetsManager.getIns().getAssetObject("lightBG") as Sprite;
				_lightBG.x=-3;
				_lightBG.y=-3;
				_lightBG.visible = false;
				this.addChild(_lightBG);
			}
			
			super();		
		}

		
		private function initShortCutEvent():void{
			if(_menuable){
				this.addEventListener(MouseEvent.DOUBLE_CLICK,doubleClickEquip);
				this.addEventListener(MouseEvent.CLICK,showShortCut);
				this.addEventListener(MouseEvent.ROLL_OUT,hideShortCut);
			}
		}
		

		
		public function setLocked():void{
			_locked = true;
			setData(_locked);
		}
		
		public function setData(data:*):void{
			if(!data){
				this.visible = false;
				return;
			}
			this.visible =true;

			if(_locked){
				_data = null;
				//锁定图标
				_image.data.bitmapData = AUtils.getNewObj("locked") as BitmapData;
				_image.x=4;
				_image.y=4;
				TipsManager.getIns().addTips(this,{title:"使用万能钥匙解锁",tips:""});
				initUnlockEvent();
			}else{
				_data = data;
				var _url:String = _data.type+_data.id.toString();
				_image.data.bitmapData = AUtils.getNewObj(_url) as BitmapData;
				_image.x=0;
				_image.y=0;
				
				//物品数量
				setNum();
				
				//boss卡片星星和底
				setBoss();
				
				//物品tip
				setTips();	
				
				initShortCutEvent();
				checkEquipCheat();

			}
		}
		
		private function checkEquipCheat():void
		{
			if(_data && _data.mid<0 && _data.type == ItemTypeConst.EQUIP && _image.data.bitmapData==null){
				EquipedManager.getIns().downEquip(_data);
				var itemVo:ItemVo = PackManager.getIns().searchEquip(_data.id);
				itemVo.mid = PackManager.getIns().firstEmptyMid;
				PlayerManager.getIns().updatePropertys();
			}
		}
		
		private function initUnlockEvent():void
		{
			this.addEventListener(MouseEvent.CLICK,onUnlock);
		}
		
		private function onUnlock(event:MouseEvent):void
		{
			if(PackManager.getIns().searchItemNum(NumberConst.getIns().wanNengKeyId)>0){
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice(
					"使用一个万能钥匙解锁背包格？",sureUnlock);
			}else{
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
					"万能钥匙不足！");
			}
		}
		
		private function sureUnlock():void
		{
			EventManager.getIns().dispatchEvent(
				new CommonEvent(EventConst.BAG_UNLOCK,[_data]));
		}
		
		private function setBoss():void
		{
			if(_data.type==ItemTypeConst.BOSS){
				_colorBg.data.bitmapData = AUtils.getNewObj(_data.bossUp.color) as BitmapData;
				var starId:String = "starIcon"+ _data.bossUp.star;
				_stars.data.bitmapData = AUtils.getNewObj(starId) as BitmapData;
				_colorBg.visible = true;
				_stars.visible = true;
			}else{
				_colorBg.visible = false;
				_stars.visible = false;
			}
		}	
		
		public function showNum():void{
			_numBg.visible = true;
			_numTxt.visible = true;
		}
		
		public function hideNum():void{
			_numBg.visible = false;
			_numTxt.visible =false;
		}
		
		private function setNum():void
		{
			if(_data.type!=ItemTypeConst.EQUIP && _data.type!=ItemTypeConst.BOOK 
				&& _data.type!=ItemTypeConst.FASHION 
				&& _data.type!=ItemTypeConst.TITLE
				&& _data.type!=ItemTypeConst.BOSS && _num)
			{
				if(_data.type==ItemTypeConst.PROP && _data.propConfig.type == "礼包"){
					hideNum();
				}else{
					showNum();
					_numBg.data.bitmapData = AUtils.getNewObj("numBg") as BitmapData;
					_numTxt.text = _data.num.toString();
				}
			}
			else{
				hideNum();
			}
		}		
		
		private function setTips():void{
			TipsManager.getIns().addTips(this,_data);	
		}
		
		
		public function showSelected():void{
			_lightBG.visible = true;
			isSelected = true;
		}
		
		public function hideSelected():void{
			_lightBG.visible = false;
			isSelected = false;
		}
		

		
		
		private function doubleClickEquip(e:MouseEvent):void
		{
			if(_data.type == ItemTypeConst.EQUIP){
				if(_data.isEquiped){
					PackManager.getIns().putDownEquipment(_data);
				}else{
					(ViewFactory.getIns().getView(BagView) as BagView).putOnEquip(_data);
				}
			}

		}
		
		private function showShortCut(e:MouseEvent):void{
			
			if(_selectable){
				EventManager.getIns().dispatchEvent(
					new CommonEvent(EventConst.BAG_SELECT_CHANGE,[_data,this]));
			}


			var menu:Array = [];
			var type:String
			if(_locked){
				menu=UNLOCK_MENU;
				type = "lock"
					
			}else{

				
				switch(_data.type){
					case ItemTypeConst.EQUIP:
						if(_data.mid<0){
							menu=EQUIPED_MENU;
						}else{
							menu=PACK_MENU;
						}
						type = ItemTypeConst.EQUIP;
						break;
					case ItemTypeConst.FASHION:
						if(_data.mid<0){
							menu=EQUIPED_MENU;
						}else{
							if(ShopManager.getIns().vipLv>=4 && _data.fashionConfig.next!=0){
								menu=PACK_MENU_VIP4;
							}else{
								menu=PACK_MENU;
							}
						}
						type = ItemTypeConst.FASHION;
						break;
					case ItemTypeConst.SPECIAL:
						menu=SELL_MENU;
						type = ItemTypeConst.SPECIAL;
						break;
					case ItemTypeConst.TITLE:
						if(player.titleInfo.titleShow>0){
							menu=TITLE_HIDE_MENU;
						}else{
							menu=TITLE_SHOW_MENU;
						}
						type = ItemTypeConst.TITLE;
						break;
					case ItemTypeConst.MATERIAL:
						if(_data.materialConfig.type == "天气令牌碎片"){
							menu=WEATHER_PIECE_MENU;
							type = ItemTypeConst.WEATHER_PIECE;
						}else{
							menu=SELL_MENU;
							type = ItemTypeConst.MATERIAL;
						}
						
						break;
					case ItemTypeConst.BOOK:
						menu=ONE_SELL_MENU;
						type = ItemTypeConst.BOOK;
						break;
					case ItemTypeConst.BOSS:
						menu=ONE_SELL_MENU;
						type = ItemTypeConst.BOSS;
						break;
					case ItemTypeConst.PROP:
						if(_data.id == NumberConst.getIns().lifeCoinId || _data.id == NumberConst.getIns().refreshCouponId){
							_menuable = false;	
						}else{
							_menuable = true;	
						}
						menu=PROP_MENU;
						type = ItemTypeConst.PROP;
						break;

				}
				
				if( _menuable){
					if (!_shortCutMenu){
						_shortCutMenu = new ShortCutMenu();
						this.parent.addChild(_shortCutMenu);
					}
					_shortCutMenu.setData(menu, type, _data);
					_shortCutMenu.show();
					_shortCutMenu.x = this.x+e.localX+5;
					_shortCutMenu.y = this.y+e.localY+5;
				}
			}

			TipsManager.getIns().hideTip(e);
		}
		

		
		private function hideShortCut(e:MouseEvent):void{
			if(_shortCutMenu && !_shortCutMenu.mouseOver){
				_shortCutMenu.hide();
			}
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		override public function destroy() : void{
			if(_shortCutMenu){
				_shortCutMenu.destroy();
				_shortCutMenu = null;
			}
			removeComponent(_image);
			removeComponent(_colorBg);
			removeComponent(_stars);
			removeComponent(_numBg);
			removeComponent(_numTxt);
			
			removeComponent(_lightBG);

			super.destroy();
		}
	}
}
