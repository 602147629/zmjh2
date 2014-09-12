package com.test.game.Modules.MainGame.Market
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Configuration.SouthMarket;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class SouthMarketBuyItemView extends BaseView
	{
		
		private var _data:SouthMarket;
		
		private var _itemVo:ItemVo;
		
		private var _itemIcon:ItemIcon;
		
		private var _anti:Antiwear;

		public function get num():int
		{
			return _anti["num"];
		}

		public function set num(value:int):void
		{
			_anti["num"] = value;
		}

		
		public function SouthMarketBuyItemView()
		{
			_anti = new Antiwear(new binaryEncrypt());
			super();
		}
		
		override public function init() : void{
			super.init();
			
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("buyItemView") as Sprite;
				this.addChild(layer);
				setCenter();
			}
			
			if(!_itemIcon){
				_itemIcon = new ItemIcon();
				_itemIcon.x = 55;
				_itemIcon.y = 75;
				_itemIcon.menuable = false;
				_itemIcon.selectable = false;
				layer.addChild(_itemIcon);
			}

			initBg();
			initEvent();
		}
		

		
		private function initEvent():void
		{
			preBtn.addEventListener(MouseEvent.CLICK,reduceNum);
			nextBtn.addEventListener(MouseEvent.CLICK,addNum);
			maxNumBtn.addEventListener(MouseEvent.CLICK,maxNum);
			buyBtn.addEventListener(MouseEvent.CLICK,buyItem);
			closeBtn.addEventListener(MouseEvent.CLICK,closeView);
		}
		
		protected function closeView(event:MouseEvent):void
		{
			this.hide();
		}
		
		protected function buyItem(event:MouseEvent):void
		{
			if(PlayerManager.getIns().checkNumber("money",_data.gold*num)){
				if(PackManager.getIns().checkMaxRooM([_itemVo])){
					PackManager.getIns().addItemIntoPack(_itemVo.copy());
					PlayerManager.getIns().reduceMoney(_data.gold*num);
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					_data.name+"×"+num+" 购买成功！");
					this.hide();
				}else{
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"背包空间不足！\n请留出空间后再购买");
				}
			}else{
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
				"金钱不足！");
			}
		}
		
		protected function maxNum(event:MouseEvent):void
		{
			if(PlayerManager.getIns().player.money<=_data.gold){
				num = NumberConst.getIns().one;
			}else{
				num = Math.min(int(PlayerManager.getIns().player.money/_data.gold),NumberConst.getIns().buyItemMaxNum);	
			}
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
		
		public function setData(data:Object):void{
			
			_data = data[0];
			_itemVo = data[1];
			num = NumberConst.getIns().one;
			
			update();
		}
		
		override public  function update():void{
			
			itemNameTxt.text = _data.name;
			curMoneyTxt.text = NumberConst.numTranslate(PlayerManager.getIns().player.money);
			needMoneyTxt.text = NumberConst.numTranslate(_data.gold*num);
			itemNumTxt.text = num.toString();
			_itemVo.num = num;
			_itemIcon.setData(_itemVo);
			
			if(PlayerManager.getIns().player.money<=_data.gold){
				btnEnable(preBtn,false);
				btnEnable(nextBtn,false);
			}else{
				if(num==NumberConst.getIns().one){
					btnEnable(preBtn,false);
				}else{
					btnEnable(preBtn,true);
				}
				
				if(num == Math.min(int(PlayerManager.getIns().player.money/_data.gold),NumberConst.getIns().buyItemMaxNum)){
					btnEnable(nextBtn,false);
				}else{
					btnEnable(nextBtn,true);
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
		
		private function get itemNameTxt():TextField
		{
			return layer["itemNameTxt"];
		}
		
		private function get needMoneyTxt():TextField
		{
			return layer["needMoneyTxt"];
		}
		
		private function get curMoneyTxt():TextField
		{
			return layer["curMoneyTxt"];
		}
		
		private function get itemNumTxt():TextField
		{
			return layer["itemNumTxt"];
		}
	
		private function get preBtn():SimpleButton
		{
			return layer["preBtn"];
		}
		
		private function get nextBtn():SimpleButton
		{
			return layer["nextBtn"];
		}
		
		private function get buyBtn():SimpleButton
		{
			return layer["buyBtn"];
		}
		
		private function get maxNumBtn():SimpleButton
		{
			return layer["maxNumBtn"];
		}
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy():void{
			
			preBtn.removeEventListener(MouseEvent.CLICK,reduceNum);
			nextBtn.removeEventListener(MouseEvent.CLICK,addNum);
			maxNumBtn.removeEventListener(MouseEvent.CLICK,maxNum);
			buyBtn.removeEventListener(MouseEvent.CLICK,buyItem);
			closeBtn.removeEventListener(MouseEvent.CLICK,closeView);
			
			super.destroy();
		}
		

	}
}