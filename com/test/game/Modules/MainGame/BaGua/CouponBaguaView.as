package com.test.game.Modules.MainGame.BaGua
{
	
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.AnimationEffect;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.BaGuaManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SaveManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Modules.MainGame.Tip.TipViewWithoutCancel;
	import com.test.game.Mvc.Vo.BaGuaPieceVo;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class CouponBaguaView extends BaseView
	{
		private var blueBaguaPiece:BaGuaPiece;
		private var purpleBaguaPiece:BaGuaPiece;
		private var _attachEffect:BaseSequenceActionBind;
		private var _baguaEnable:Boolean;
		
		public function CouponBaguaView()
		{
			renderView();
		}		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		private function renderView():void{
			
			LoadManager.getIns().hideProgress();
			layer = AssetsManager.getIns().getAssetObject("CouponBaguaView") as Sprite;
			layer.x = 300;
			layer.y = 150;
			this.addChild(layer);
			
			blueBaguaPiece = new BaGuaPiece();
			blueBaguaPiece.x = 94; 
			blueBaguaPiece.y = 90;
			blueBaguaPiece.dragable = false;
			blueBaguaPiece.menuable = false;
			layer.addChild(blueBaguaPiece);
			
			purpleBaguaPiece = new BaGuaPiece();
			purpleBaguaPiece.x = 219;
			purpleBaguaPiece.y = 90;
			purpleBaguaPiece.menuable = false;
			purpleBaguaPiece.dragable = false;
			layer.addChild(purpleBaguaPiece);
			
			TipsManager.getIns().addTips(blueBtn,{title:"花费30点券抽取一张蓝色八卦牌",tips:""});
			TipsManager.getIns().addTips(purpleBtn,{title:"花费300点券抽取一张紫色八卦牌",tips:""});
			
			update();
			initBg();
			initEvent();
		}
		
		
		
		override public function show():void{
			if(layer == null) return;
			update();
			super.show();
		}
		
		private function close(e:MouseEvent):void{
			this.hide();
		}
		
		
		
		override public function update():void{
			clearIcons();
			updateCoupon();
		}
		
		private function clearIcons():void{
			blueBaguaPiece.setData(null);
			purpleBaguaPiece.setData(null);
		}
		
		private function updateCoupon():void{
			
			couponTxt.text = player.vip.curCoupon.toString();
			_baguaEnable = true;
		}
		
		
		private function initEvent():void{
			closeBtn.addEventListener(MouseEvent.CLICK,close);
			blueBtn.addEventListener(MouseEvent.CLICK,onBlueClick);
			purpleBtn.addEventListener(MouseEvent.CLICK,onPurpleClick);
		}

		
		private function onBlueClick(e:MouseEvent):void{
			(ViewFactory.getIns().initView(TipView) as TipView).setFun(
				"花费30点券抽取一张蓝色八卦牌？",getBlueBagua);
		}
		
		private function onPurpleClick(e:MouseEvent):void{
			(ViewFactory.getIns().initView(TipView) as TipView).setFun(
				"花费300点券抽取一张紫色八卦牌？",getPurpleBagua);
		}
		

		private function getBlueBagua():void
		{
			addBaGuaPiece(1);
		}
		
		private function getPurpleBagua():void
		{
			addBaGuaPiece(2);
		}
		
		private function addBaGuaPiece(color:int):void{
			if(_baguaEnable){
				_baguaEnable = false;
				var bagState:int = BaGuaManager.getIns().checkFull();
				if(bagState>=0){
					sureBuyBagua(color);
				}else{
					(ViewFactory.getIns().initView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						"八卦牌背包已满！请整理，否则无法获得八卦牌");
				}
			}

		}
		
		private function sureBuyBagua(color:int):void{
			clearIcons();
			if(GameConst.localData){
				switch(color){
					case 1:
						buyBaguaCallBack({propId:1563,balance:30});
						break;
					case 2:
						buyBaguaCallBack({propId:1564,balance:300});
						break;
				}
			}else{
				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					"系统正在处理当中，请稍等...",null,null,true);
				var propId:int;
				var price:int;
				switch(color){
					case 1:
						propId = NumberConst.getIns().blueBaguaPropId;
						price = NumberConst.getIns().blueBaguaPrice;
						break;
					case 2:
						propId = NumberConst.getIns().purpleBaguaPropId;
						price = NumberConst.getIns().purpleBaguaPrice;
						break;
				}
				SaveManager.getIns().onJudgeMulti(
					function () : void{
						var data:Object = {propId:propId.toString(),count:1,price:price,idx:PlayerManager.getIns().player.index,tag:"buyBagua"};
						ShopManager.getIns().buyPropNd(data,buyBaguaCallBack);
					});
			}

		}
		
		private function buyBaguaCallBack(data:Object):void
		{
			var vo:BaGuaPieceVo;
			DebugArea.getIns().showInfo("八卦牌：propId:" + data.propId + "  count:" + data.count + "   balance:" + data.balance + "   tag:" + data.tag+"\n");
			switch(int(data.propId)){
				case NumberConst.getIns().blueBaguaPropId:
					vo = BaGuaManager.getIns().addRandomBaguaPiece(1);	
					blueBaguaPiece.setData(vo);
					showEffect(blueBaguaPiece.x,blueBaguaPiece.y);
					break;
				case NumberConst.getIns().purpleBaguaPropId:
					vo = BaGuaManager.getIns().addRandomBaguaPiece(2);
					purpleBaguaPiece.setData(vo);
					showEffect(purpleBaguaPiece.x,purpleBaguaPiece.y);
					break;
			}
			
			if(GameConst.localData){
				player.vip.curCoupon = data.balance;
				updateCoupon();
				
/*				(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
					vo.name+"购买成功！");*/
			}else{
				SaveManager.getIns().onlySave(function():void{
					player.vip.curCoupon = data.balance;
					updateCoupon();
					//EventManager.getIns().dispatchEvent(new Event(EventConst.BUY_SHOP_ITEM_SCUUESS));
					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).hide();
/*					(ViewFactory.getIns().getView(TipViewWithoutCancel) as TipViewWithoutCancel).setFun(
						vo.name+"购买成功！");*/
				});
			}
			
			couponTxt.text = player.vip.curCoupon.toString();
			ViewFactory.getIns().getView(BaGuaView).update();

			
		}

		
		private function showEffect(x:int,y:int):void{
			_attachEffect = AnimationEffect.createAnimation(10015,["attachEffect"],false,removeEffect)
			_attachEffect.x = x - 33;
			_attachEffect.y = y - 33;
			layer.addChild(_attachEffect);
			RenderEntityManager.getIns().removeEntity(_attachEffect);
			AnimationManager.getIns().addEntity(_attachEffect);
		}
		
		private function removeEffect(...args):void{
			if(_attachEffect != null){
				AnimationManager.getIns().removeEntity(_attachEffect);
				_attachEffect.destroy();
				_attachEffect = null;
			}
		}
		
	
		private function get closeBtn():SimpleButton
		{
			return layer["closeBtn"];
		}
		
		private function get blueBtn():SimpleButton
		{
			return layer["blueBtn"];
		}
		
		private function get purpleBtn():SimpleButton
		{
			return layer["purpleBtn"];
		}
		
		private function get couponTxt():TextField
		{
			return layer["couponTxt"];
		}
		
		

		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		
		override public function destroy():void{
			if(closeBtn.hasEventListener(MouseEvent.CLICK)){
				closeBtn.removeEventListener(MouseEvent.CLICK,close);;
			}
			super.destroy();
		}
	}
}