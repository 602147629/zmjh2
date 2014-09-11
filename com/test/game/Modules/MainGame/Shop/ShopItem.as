package com.test.game.Modules.MainGame.Shop
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.ItemTypeConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.BaGuaManager;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Modules.MainGame.BaGua.BaGuaPiece;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewForShopShortage;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.Vo.VipVo;
	import com.test.game.UI.ItemIcon;
	import com.test.game.UI.Grid.IGrid;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class ShopItem extends BaseSprite implements IGrid
	{
		private var _obj:Sprite;
		
		private var _isBagua:Boolean;
		
		private var _itemIcon:ItemIcon;
		
		private var _baguaPieceIcon:BaGuaPiece;
		
		public var layerName:String;
	
		private var _itemVo:ItemVo;
		
		private var _baguaPieceVo:BaGuaPieceVo;
		
		private var _data:*;
		
		private var _anti:Antiwear;
		
		private var _isFashion:Boolean;
		
		public function get num():int
		{
			return _anti["num"];
		}
		
		public function set num(value:int):void
		{
			_anti["num"] = value;
		}

		
		public function ShopItem()
		{
			_anti = new Antiwear(new binaryEncrypt());
			
			this.buttonMode = true;
			//this.mouseChildren = false;
			
			if(!_obj){
				_obj = AssetsManager.getIns().getAssetObject("ShopItem") as Sprite;
				this.addChild(_obj);
			}
			
			if(!_itemIcon){
				_itemIcon = new ItemIcon();
				_itemIcon.x = 23;
				_itemIcon.y = 40;
				_itemIcon.selectable = false;
				_itemIcon.menuable = false;
				_itemIcon.num = false;
				this.addChild(_itemIcon);
			}
			
			if(!_baguaPieceIcon){
				_baguaPieceIcon = new BaGuaPiece();
				_baguaPieceIcon.x = 23;
				_baguaPieceIcon.y = 40;
				_baguaPieceIcon.dragable = false;
				_baguaPieceIcon.menuable = false;
				this.addChild(_baguaPieceIcon);
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
			_data = data;
			

			var id:int = ConfigurationManager.getIns().getObjectByProperty(
				AssetsConst.SHOP,"propId",_data.propId).id;
			
			if(id>8000 && id<9000){
				_isBagua = true;
				_baguaPieceVo = BaGuaManager.getIns().creatLingQiBaGua(id);
				_baguaPieceIcon.setData(_baguaPieceVo);
				nameTxt.text = _baguaPieceVo.name;
				dayNum.visible = false;
			}else{
				_isBagua = false;
				_itemVo = PackManager.getIns().creatItem(id);
				_itemIcon.setData(_itemVo);
				
				if(_itemVo.type == ItemTypeConst.FASHION){
					_isFashion = true;
				}
				
				if(_isFashion){
					dayNum.visible = true;
				}else{
					dayNum.visible = false;
				}
				
				nameTxt.text = _itemVo.name;
			}
			
			
			priceTxt.text = _data.price+"点券";
			
			num = NumberConst.getIns().one;
			
			update();
		}
		
		private function initEvent():void{
			downBtn.addEventListener(MouseEvent.CLICK,reduceNum);
			upBtn.addEventListener(MouseEvent.CLICK,addNum);
			buyBtn.addEventListener(MouseEvent.CLICK,buyItem);
			numTxt.addEventListener(Event.CHANGE,numChange);
			this.addEventListener(MouseEvent.MOUSE_OVER,showPreView);
			this.addEventListener(MouseEvent.MOUSE_OUT,hidePreView);
		}
		
		
		private var preView:Sprite;
		private var previewEntity:MovieClip;
		protected function hidePreView(event:MouseEvent):void
		{
			if(_isFashion){
				if(preView.parent){
					preView.parent.removeChild(preView);
				}
				if(previewEntity != null && previewEntity.parent){
					previewEntity.parent.removeChild(previewEntity);
				}
			}
		}
		
		protected function showPreView(event:MouseEvent):void
		{
			if(_isFashion){
				if(!preView){
					preView = AssetsManager.getIns().getAssetObject("preview") as Sprite;
					if(this.x > 470){
						preView.x = this.x - 196;
					}else{
						preView.x = this.x + 204;
					}
					preView.y = this.y - 80;
				}

				if(!previewEntity){
					previewEntity = AssetsManager.getIns().getAssetObject(_itemVo.id.toString()) as MovieClip;
					if(previewEntity != null){
						if(this.x > 470){
							previewEntity.x = this.x - 130;
						}else{
							previewEntity.x = this.x + 274;
						}
						previewEntity.y = this.y;
					}
				}

				this.parent.addChild(preView);
				if(previewEntity != null){
					this.parent.addChild(previewEntity);
				}
				
			}

		}
		
		protected function numChange(event:Event):void
		{
			
			var tempNum:int = int(numTxt.text);
			if(vip.curCoupon<_data.price){
				numTxt.text = NumberConst.getIns().one.toString();
			}else{
				if(tempNum<NumberConst.getIns().one){
					numTxt.text = NumberConst.getIns().one.toString();
				}
				
				if(tempNum > Math.min(int(vip.curCoupon/_data.price),NumberConst.getIns().buyItemMaxNum)){
					numTxt.text = Math.min(int(vip.curCoupon/_data.price),NumberConst.getIns().buyItemMaxNum).toString();
				}
			}
			
			num = int(numTxt.text);
			update();
			
		}		
		
		protected function addNum(event:MouseEvent):void
		{
			num++;
			update();
		}
		
		protected function reduceNum(event:MouseEvent):void
		{
			
			num--;
			update();
		}
		
		public function update():void{
			
			priceTxt.text = NumberConst.numTranslate(_data.price*num)+"点券";
			
			numTxt.text = num.toString();
	
			if(vip.curCoupon<_data.price){
				btnEnable(downBtn,false);
				btnEnable(upBtn,false);
			}else{
				if(num<=NumberConst.getIns().one){
					btnEnable(downBtn,false);
				}else{
					btnEnable(downBtn,true);
				}
				
				if(num == Math.min(int(vip.curCoupon/_data.price),NumberConst.getIns().buyItemMaxNum)){
					btnEnable(upBtn,false);
				}else{
					btnEnable(upBtn,true);
				}	
			}

		}

		
		private function btnEnable(btn:SimpleButton,enable:Boolean):void{
			if(enable){
				btn.mouseEnabled = true;
				GreyEffect.reset(btn);
			}else{
				btn.mouseEnabled = false;
				GreyEffect.change(btn);
			}
		}
		
		
		private function buyItem(e:MouseEvent):void
		{

			if(num<=NumberConst.getIns().zero){
				num = NumberConst.getIns().one;
			}
			
			if(_isFashion && int(_itemVo.id.toString().substr(1,1))+1 != player.occupation){
				(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"请购买对应角色职业的时装");
				return;
			}
			
			if(_isBagua && !HideMissionManager.getIns().returnHideMissionComplete(3012)){
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"八卦牌功能尚未开启，请先通关太虚观隐藏副本");
				return;
			}
			
			if(vip.curCoupon<_data.price){
				(ViewFactory.getIns().initView(TipViewForShopShortage) as TipViewForShopShortage).setFun(
					"点券不足！\n请充值后再购买");
				return;
			}
			

			if(_isBagua){
				if(BaGuaManager.getIns().checkFull(num)<0){
					(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"八卦牌背包已满！\n请留出空间后再购买");
					return;
				}
			}else if(_isFashion){
				if(!PackManager.getIns().checkMaxRoomByNum(num)){
					(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"背包空间不足！\n请留出空间后再购买");
					return;
				}
			}else{
				if(!PackManager.getIns().checkMaxRooM([_itemVo])){
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"背包空间不足！\n请留出空间后再购买");
					return;
				}
			}
			

			if(_isBagua){
				(ViewFactory.getIns().getView(TipView) as TipView).setFun(
					"确定使用"+int(_data.price*num)+"点券购买"+num+"件"+_baguaPieceVo.name+"?",sureBuyItem);
			}else{
				(ViewFactory.getIns().getView(TipView) as TipView).setFun(
					"确定使用"+int(_data.price*num)+"点券购买"+num+"件"+_itemVo.name+"?",sureBuyItem);
			}
			

		}	
		
		private function sureBuyItem():void
		{
			if(GameConst.localData){
				buyItemCallBack(null);
			}else{
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"系统正在处理当中，请稍等...",null,null,true);
				SaveManager.getIns().onJudgeMulti(
					function () : void{
						var tag:String;
						if(_isBagua){
							tag = "buy"+_baguaPieceVo.id;
						}else{
							tag = "buy"+_itemVo.id;
						}
						var data:Object = {propId:_data.propId.toString(),count:num,price:_data.price,idx:PlayerManager.getIns().player.index,tag:tag};
						ShopManager.getIns().buyPropNd(data,buyItemCallBack);
					});
			}
		}
		
		private function buyItemCallBack(data:Object):void{
			//DebugArea.getIns().showInfo(data.tag,DebugConst.NORMAL);
			
			var name:String;
			if(_isBagua){
				for(var i:int=0;i<num;i++){
					BaGuaManager.getIns().addBaGuaIntoPack(_baguaPieceVo.copy());
				}
				name = _baguaPieceVo.name;
			}else if(_isFashion){
				for(var j:int=0;j<num;j++){
					PackManager.getIns().addItemIntoPack(_itemVo.copy());
				}
				name = _itemVo.name;
			}else{
				_itemVo.num = num;
				PackManager.getIns().addItemIntoPack(_itemVo.copy());
				name = _itemVo.name;
			}
			
			num = NumberConst.getIns().one;
			if(GameConst.localData){
				EventManager.getIns().dispatchEvent(new Event(EventConst.BUY_SHOP_ITEM_SCUUESS));
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					name+"购买成功！");
			}else{
				SaveManager.getIns().onlySave(function():void{
					vip.curCoupon = data.balance;
					EventManager.getIns().dispatchEvent(new Event(EventConst.BUY_SHOP_ITEM_SCUUESS));
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						name+"购买成功！");
					//update();
				});
			}
		}
		
		
		private function get vip():VipVo{
			return PlayerManager.getIns().player.vip;
		}
		
		private function get dayNum():Sprite
		{
			return _obj["dayNum"];
		}
		
		private function get nameTxt():TextField
		{
			return _obj["nameTxt"];
		}
		
		private function get priceTxt():TextField
		{
			return _obj["priceTxt"];
		}
		
		
		private function get numTxt():TextField
		{
			return _obj["numTxt"];
		}
		
		private function get upBtn():SimpleButton
		{
			return _obj["upBtn"];
		}
		private function get downBtn():SimpleButton
		{
			return _obj["downBtn"];
		}
		
		private function get buyBtn():SimpleButton
		{
			return _obj["buyBtn"];
		}
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
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
			_baguaPieceIcon.destroy();
			_data = null;
			super.destroy();
		}
	}
}