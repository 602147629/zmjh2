package com.test.game.Modules.MainGame.FirstCharge
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.BuffConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DeformTipManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.Achieve.AchieveView;
	import com.test.game.Modules.MainGame.Info.CongratulationView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Configuration.GiftPackage;
	import com.test.game.Mvc.Vo.ItemVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.UI.ItemIcon;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class FirstChargeView extends BaseView
	{
		private var _obj:Sprite;
		
		private var _giftVo:GiftPackage;
		
		private var _itemIconArr:Array = [];
		
		private var _getEnable:Boolean;
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function FirstChargeView()
		{
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.FIRSTCHARGEVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView,LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function renderView(...args):void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = AssetsManager.getIns().getAssetObject("FirstChargeView") as Sprite;
				this.addChild(layer);
				
				_giftVo = ConfigurationManager.getIns().getObjectByID(
					AssetsConst.GIFT_PACKAGE,NumberConst.getIns().firstChargeGiftId) as GiftPackage;
				
				var idArr:Array = _giftVo.itemIds.split("|");
				var numArr:Array = _giftVo.itemNums.split("|");
				for(var i:int =0;i<4;i++){
					var itemIcon:ItemIcon = new ItemIcon();
					itemIcon.x = 450+i*53;
					itemIcon.y = 340;
					itemIcon.selectable = false;
					itemIcon.menuable = false;
					itemIcon.num = true;
					this.addChild(itemIcon);
					
					var itemVo:ItemVo
					if(int(idArr[i])>10000){
						itemVo = PackManager.getIns().creatBossData(
							ConfigurationManager.getIns().getObjectByProperty(AssetsConst.SPECIAL, "id", int(idArr[i])).bid
							,int((int(idArr[i]) - 10000) / 100) + 1);
					}else{
						itemVo = PackManager.getIns().creatItem(int(idArr[i]));
						itemVo.num = int(numArr[i]);
					}
					itemIcon.setData(itemVo);
					_itemIconArr.push(itemIcon);
				}
				
				initBg();
				setCenter();
				
				update();
				initEvent();
			}
			
		}
		
		
		
		override public function show():void{
			if(layer == null) return;
			update();
			super.show();
		}
		
		override public function update():void{
			updateFirstChargeInfo();
			//DeformTipManager.getIns().checkFirstCharge();
		}
		
		
		private function updateFirstChargeInfo():void{
			var isGet:int = player.vip.firstCharge;
			if(isGet==NumberConst.getIns().zero){
				getBtnEnable(true);	
				TipsManager.getIns().addTips(getBtn,{title:"点击领取首充礼包", tips:""});
			}else if(isGet==NumberConst.getIns().negativeOne){
				getBtnEnable(false);	
				TipsManager.getIns().addTips(getBtn,{title:"充值任意金额即可领取首充礼包", tips:""});
			}else{
				getBtnEnable(false);	
				TipsManager.getIns().addTips(getBtn,{title:"已领取首充礼包", tips:""});
			}
		}
		
		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			chargeBtn.addEventListener(MouseEvent.CLICK,onCharge);
			getBtn.addEventListener(MouseEvent.CLICK,onGet);
		}
		
		
		private function onCharge(e:MouseEvent):void{
			ShopManager.getIns().payMoney();
		}
		
		private function onGet(e:MouseEvent):void{
			if(_getEnable){
				var gift:ItemVo = PackManager.getIns().creatItem(NumberConst.getIns().firstChargeGiftId);
				if(PackManager.getIns().checkMaxRooM([gift])){
					PackManager.getIns().addItemIntoPack(gift.copy());
					(ViewFactory.getIns().initView(CongratulationView) as CongratulationView).startPlay(gift.id);
					player.vip.firstCharge = NumberConst.getIns().one;
					ViewFactory.getIns().getView(MainToolBar).update();
					update();
				}else{
					(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice(
						"背包空间不足！\n请留出空间后再领取");
				}
			}
		}
		
		private function getBtnEnable(enable:Boolean):void{
			if(enable){
				GreyEffect.reset(getBtn);
			}else{
				GreyEffect.change(getBtn);
			}
			_getEnable = enable;
		}
		
		
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		private function get getBtn():SimpleButton
		{
			return layer["getBtn"];
		}
		
		private function get chargeBtn():SimpleButton
		{
			return layer["chargeBtn"];
		}
		
		
		private function close(e:MouseEvent):void{
			hide();
		}
		
		
		override public function destroy():void{
			closeBtn.removeEventListener(MouseEvent.CLICK,close);
			chargeBtn.removeEventListener(MouseEvent.CLICK,close);
			getBtn.removeEventListener(MouseEvent.CLICK,close);
			for(var i:int=0;i<_itemIconArr.length;i++){
				_itemIconArr[i].destroy();
			}
			super.destroy();
		}

		
		
	}
}