package com.test.game.Modules.MainGame.Gift
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.Tools.CommonEvent;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseSprite;
	import com.test.game.Const.EventConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.EventManager;
	import com.test.game.Manager.GiftManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Vo.ItemVo;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class GiftComponent extends BaseSprite
	{
		private var _obj:Sprite;
		
		private var _anti:Antiwear;
		
		private var _giftVo:ItemVo;
		private var _giftEnable:Boolean;
		/**
		 * 礼包id
		 */		
		//private var _giftId:int;
		private function get giftId() : int{
			return _anti["giftId"];
		}
		private function set giftId(value:int) : void{
			_anti["giftId"] = value;
		}
		
		/**
		 *礼包状态  -1未开启   0未领取  1已领取 -2已过期
		 */
		public function get getState() : int{
			return _anti["getState"];
		}
		public function set getState(value:int) : void{
			_anti["getState"] = value;
		}
		public function GiftComponent()
		{
			_anti = new Antiwear(new binaryEncrypt());
			_anti["getState"] = NumberConst.getIns().negativeOne;
			_anti["giftId"] = NumberConst.getIns().zero;
			
			this.buttonMode = true;
			_obj = AssetsManager.getIns().getAssetObject("GiftComponent") as Sprite;
			this.addChild(_obj);
			this.addEventListener(MouseEvent.CLICK,onGiftClick);
		}
		
		
		//礼包组件点击响应
		protected function onGiftClick(e:MouseEvent):void
		{
			if(getState == NumberConst.getIns().zero && _giftEnable){
				if(giftId == NumberConst.getIns().guiZuGiftId || 
					giftId == NumberConst.getIns().wuYiGiftId ||
					giftId == NumberConst.getIns().duanwuGiftId ||
					giftId == NumberConst.getIns().fiveYearsGiftId ||
					giftId == NumberConst.getIns().qiXiGiftId ||
					giftId == NumberConst.getIns().zhongQiuGiftId){
					EventManager.getIns().dispatchEvent(
						new CommonEvent(EventConst.SCORE_GIFT_CLICK,[giftId]));	
				}else if(giftId == NumberConst.getIns().tenYearsGiftId){
					EventManager.getIns().dispatchEvent(
						new CommonEvent(EventConst.TEN_YEARS_CLICK));	
				}else{
					if(PackManager.getIns().checkMaxRooM([_giftVo])){
						GiftManager.getIns().addGift(giftId);
						_giftEnable = false;
						//setData(NumberConst.getIns().one);
					}else{
						(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
							"背包空间不足！\n请留出空间后再领取");
					}
				}
			}
		}
		
		
		public function setId(id:int):void{
			giftId = id;
			giftName.gotoAndStop("gift"+id.toString());
			bgs.gotoAndStop("gift"+id.toString());
			if(id !=0){
				_giftVo = PackManager.getIns().creatItem(id);
				if(id == NumberConst.getIns().guiZuGiftId){
					TipsManager.getIns().addTips(this,{title:"使用论坛积分换取贵族礼包",tips:""});	
				}else{
					TipsManager.getIns().addTips(this,_giftVo);	
				}

			}
		}
		
		public function setData(state:int):void{
			getState = state;
			if(getState == NumberConst.getIns().zero){
				giftIcons.gotoAndStop("none");
				GreyEffect.reset(bgs);
			}else if(getState == NumberConst.getIns().one){
				giftIcons.gotoAndStop("get");
				GreyEffect.change(bgs);
			}else if(getState == NumberConst.getIns().negativeOne){
				giftIcons.gotoAndStop("close");
				GreyEffect.change(bgs);
			}else if(getState == NumberConst.getIns().negativeTwo){
				giftIcons.gotoAndStop("none");
				GreyEffect.change(bgs);
			}
			_giftEnable = true;
			
		}
		
		private function get giftName():MovieClip
		{
			return _obj["giftName"];
		}
		
		private function get giftIcons():MovieClip
		{
			return _obj["giftIcons"];
		}
		
		private function get bgs():MovieClip
		{
			return _obj["bgs"];
		}
	
		override public function destroy():void{
			removeComponent(_obj);
			super.destroy();
		}
	}
}