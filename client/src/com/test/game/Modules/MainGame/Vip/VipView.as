package com.test.game.Modules.MainGame.Vip
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.GiftManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	import com.test.game.Modules.MainGame.Shop.ShopView;
	import com.test.game.Mvc.Configuration.VipInfo;
	import com.test.game.Mvc.Vo.VipVo;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class VipView extends BaseView
	{
		
		private var _curPage:int;
		private var _curData:VipInfo;
		private var _curPageData:VipInfo;
		
		private var _originBarWidth:int;
		
		private var _images:Vector.<BaseNativeEntity>;
		
		private var _giftEnable:Boolean;
		
		
		public function VipView()
		{
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.VIPVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView,LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		
		
		private function renderView(...args):void{
			
			LoadManager.getIns().hideProgress();
			layer = AssetsManager.getIns().getAssetObject("VipView") as Sprite;
			
			
			this.addChild(layer);
			layer.x=150;
			layer.y=10;
			
			_originBarWidth = vipExpBar.width;
			_curPage = ShopManager.getIns().vipLv;
			vipGiftMc.buttonMode =true;
			
			if(GameConst.localData){
				updateCoupon();
			}else{
				updateCoupon();
			}
			
			
			update();
			initBg();
			initEvent();
		}
		
		private function updateCoupon(balance:int=1):void
		{
			couponTxt.text = vip.curCoupon.toString();
		}		
		
		
		
		
		override public function show():void{
			if(layer == null) return;
			_curPage = ShopManager.getIns().vipLv;
			
			updateCoupon();
			
			update();
			super.show();
		}
		
		
		
		override public function update():void{
			renderCurVipInfo();
			updatePage();
			renderVipInfo();
		}
		
		
		
		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			preBtn.addEventListener(MouseEvent.CLICK,reduceNum);
			nextBtn.addEventListener(MouseEvent.CLICK,addNum);
			payMoneyBtn.addEventListener(MouseEvent.CLICK,onPayMoney);
			openShopBtn.addEventListener(MouseEvent.CLICK,onShowShop);
			vipGiftMc.addEventListener(MouseEvent.CLICK,onGetVipGift);
		}
		
		protected function onGetVipGift(event:MouseEvent):void
		{
			if(_giftEnable){
				_giftEnable = false;
				SaveManager.getIns().onSaveGame(
					function () : void{
						GiftManager.getIns().addVipDailyGift();
					},
					function () : void{
						updateVipGift();
						ViewFactory.getIns().getView(RoleStateView).update();
					});
			}
		}
		
		protected function buyItemUpdate():void
		{
			couponTxt.text = vip.curCoupon.toString();
		}
		
		public function updateVip():void
		{
			updateCoupon();
			ShopManager.getIns().setTotalRechaged(renderCurVipInfo);
		}		
		
		protected function onShowShop(event:MouseEvent):void
		{
			hide();
			GuideManager.getIns().destoryGuideMC();
			ViewFactory.getIns().initView(ShopView).show();
		}		
		
		
		protected function onPayMoney(event:MouseEvent):void
		{
			ShopManager.getIns().payMoney();
		}		
		
		
		protected function addNum(event:MouseEvent):void
		{
			_curPage++;
			update();
		}
		
		protected function reduceNum(event:MouseEvent):void
		{
			
			_curPage--;
			update();
		}
		
		
		private function renderCurVipInfo():void
		{
			
			if(ShopManager.getIns().vipLv < NumberConst.getIns().one){
				_curData =  ConfigurationManager.getIns().getObjectByProperty(AssetsConst.VIPINFO,"id",1) as VipInfo;
				var diff1:int = _curData.coupon - vip.totalRecharge;
				vipInfoTxt.text = "再充值"+diff1+"点券，您将成为VIP"+int(_curData.id)+"，获得更多特权";
				
				GreyEffect.change(vipIcon);
				GreyEffect.change(vipLvMcTitle);
				vipLvMcTitle.gotoAndStop("vip1");
			}else{
				if(ShopManager.getIns().vipLv < NumberConst.getIns().vipMaxLv){
					_curData =  ConfigurationManager.getIns().getObjectByProperty(AssetsConst.VIPINFO,"id",ShopManager.getIns().vipLv+1) as VipInfo;
					var diff2:int = _curData.coupon - vip.totalRecharge;
					vipInfoTxt.text = "再充值"+diff2+"点券，您将成为VIP"+int(_curData.id)+"，获得更多特权";
				}else{
					_curData =  ConfigurationManager.getIns().getObjectByProperty(AssetsConst.VIPINFO,"id",ShopManager.getIns().vipLv) as VipInfo;	
					vipInfoTxt.text = "已达到当前最高VIP等级";
				}
				
				GreyEffect.reset(vipIcon);
				GreyEffect.reset(vipLvMcTitle);
				vipLvMcTitle.gotoAndStop("vip"+ShopManager.getIns().vipLv);
			}
			
			updateVipGift();
			
			vipExpTxt.text = vip.totalRecharge+"/"+_curData.coupon;
			
			vipExpBar.width = Math.min(1,(Number(vip.totalRecharge/_curData.coupon)))*_originBarWidth;
		}		
		
		
		private function updateVipGift():void{
			if(ShopManager.getIns().vipLv > NumberConst.getIns().zero){
				if(!vip.isVipGiftGet){
					enableGift(true);
					TipsManager.getIns().addTips(vipGiftMc,{title:"点击领取VIP每日礼包",tips:""});
					GuideManager.getIns().guideSetting(GuideManager.ARROW, new Point(180, 30));
				}else{
					enableGift(false);
					TipsManager.getIns().addTips(vipGiftMc,{title:"今日VIP每日礼包已领取",tips:""});
					GuideManager.getIns().destoryGuideMC();
				}
			}else{
				enableGift(false);
				GuideManager.getIns().destoryGuideMC();
				TipsManager.getIns().addTips(vipGiftMc,{title:"成为VIP可领取VIP每日礼包",tips:""});
			}
		}
		
		private function enableGift(enable:Boolean):void{
			if(enable){
				_giftEnable = true;
				GreyEffect.reset(vipGiftMc);
				vipGiftMc.play();
			}else{
				_giftEnable = false;
				GreyEffect.change(vipGiftMc);
				vipGiftMc.stop();
			}
		}
		
		
		private function updatePage():void
		{
			if(_curPage<=NumberConst.getIns().one){
				_curPage = NumberConst.getIns().one;
				btnEnable(preBtn,false);
			}else{
				btnEnable(preBtn,true);
			}
			
			if(_curPage >= NumberConst.getIns().vipMaxLv){
				_curPage = NumberConst.getIns().vipMaxLv;
				btnEnable(nextBtn,false);
			}else{
				btnEnable(nextBtn,true);
			}
			
			
			vipLvMcInfo.gotoAndStop("vip"+_curPage);
			
			_curPageData = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.VIPINFO,"id",_curPage) as VipInfo;
			
			
		}
		
		private function renderVipInfo():void
		{
			if(!_images){
				_images = new Vector.<BaseNativeEntity>;
				for(var j:int=1;j<=6;j++){
					var _image:BaseNativeEntity  = new BaseNativeEntity();
					var x:int = (j-1)%3;
					var y:int = j>3?1:0
					_image.x=270+x*155;
					_image.y=170+y*155;
					this.addChild(_image);	
					_images.push(_image);
				}
			}
			for(var i:int=1;i<=6;i++){
				if(ShopManager.getIns().vipLv>=_curPage){
					GreyEffect.reset(_images[i-1]);
				}else{
					GreyEffect.change(_images[i-1]);
				}
				if(_curPageData["info_"+i]!="0"){
					(layer["vipInfoTxt"+i] as TextField).text = _curPageData["info_"+i].split("|")[0];
					var _url:String = "vip"+_curPage+"_"+i;
					_images[i-1].data.bitmapData = AUtils.getNewObj(_url) as BitmapData;
					TipsManager.getIns().addTips(_images[i-1],{title:_curPageData["info_"+i].split("|")[1]
						,tips:""});
				}else{
					(layer["vipInfoTxt"+i] as TextField).text = "";
					_images[i-1].data.bitmapData = null;
					TipsManager.getIns().removeTips(_images[i-1]);
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
		
		
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		private function get couponTxt():TextField
		{
			return layer["couponTxt"];
		}
		
		private function get openShopBtn():SimpleButton
		{
			return layer["openShopBtn"];
		}
		
		private function get payMoneyBtn():SimpleButton
		{
			return layer["payMoneyBtn"];
		}
		
		
		private function get vipGiftMc():MovieClip
		{
			return layer["vipGiftMc"];
		}
		
		private function get vipIcon():Sprite
		{
			return layer["vipIcon"];
		}
		
		private function get vipLvMcTitle():MovieClip
		{
			return layer["vipLvMcTitle"];
		}
		
		private function get vipLvMcInfo():MovieClip
		{
			return layer["vipLvMcInfo"];
		}
		
		private function get vipInfoTxt():TextField
		{
			return layer["vipInfoTxt"];
		}
		
		private function get vipExpTxt():TextField
		{
			return layer["vipExpTxt"];
		}
		
		private function get vipExpBar():Sprite
		{
			return layer["vipExpBar"];
		}
		
		private function get preBtn():SimpleButton
		{
			return layer["preBtn"];
		}
		
		private function get nextBtn():SimpleButton
		{
			return layer["nextBtn"];
		}
		
		
		
		private function get vip():VipVo{
			return PlayerManager.getIns().player.vip;
		}
		
		
		
		private function close(e:MouseEvent):void{
			hide();
			GuideManager.getIns().destoryGuideMC();
		}
		
		
		override public function destroy():void{
			if(closeBtn.hasEventListener(MouseEvent.CLICK)){
				closeBtn.removeEventListener(MouseEvent.CLICK,close);;
			}
			super.destroy();
		}
	}
}