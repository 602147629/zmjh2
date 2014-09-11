package com.test.game.Modules.MainGame.Activity
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.Activity.MidAutumnManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class MidAutumnView extends BaseView
	{
		private function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		public function MidAutumnView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.MIDAUTUMNVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.MIDAUTUMNVIEW.split("/")[1]) as Sprite;
				this.addChild(layer);
				
				initUI();
				setParams();
				initBg();
				setCenter();
			}
		}
		
		private var _titleInfo:Array = [
			"贡献30个月饼可获得：",
			"贡献60个月饼可获得：",
			"贡献100个月饼可获得：",
			"贡献150个月饼可获得：",
			"贡献210个月饼可获得：",
			"贡献300个月饼可获得："
			];
		private var _contentInfo:Array = [
			"复活币×5，万能钥匙×5，经验卡×1，金钱×10000，战魂×10000\n点击礼包图标领取奖励",
			"天气控制器×1，夜之令牌×1、雨之令牌×1、风之令牌×1、雷之令牌×1、金钱×30000，战魂×30000\n点击礼包图标领取奖励",
			"刷新券×5，复活币×5，人品卡×1，双倍卡×1，高手卡×1、金钱×50000，战魂×50000\n点击礼包图标领取奖励",
			"改名卡×1，夜之令牌×2、雨之令牌×2、风之令牌×2、雷之令牌×2、金钱×100000，战魂×100000\n点击礼包图标领取奖励",
			"紫色兔爷×1，金钱×200000，战魂×200000\n点击礼包图标领取奖励",
			"紫色兔妹×1，花好月圆称号×1，金钱×300000，战魂×300000\n点击礼包图标领取奖励"
			];
		private function initUI() : void{
			closeBtn.addEventListener(MouseEvent.CLICK, onClose);
			startDevote.addEventListener(MouseEvent.CLICK, onStartDevote);
			for(var i:int = 1; i <= 6; i++){
				(this["gift_" + i] as Sprite).buttonMode = true;
				(this["gift_" + i] as Sprite).addEventListener(MouseEvent.CLICK, onGetGift);
				TipsManager.getIns().addTips((this["gift_" + i] as Sprite), {title:_titleInfo[i-1], tips:_contentInfo[i-1]});
			}
			TipsManager.getIns().addTips(introduce, {title:"兔爷需要你贡献大量的月饼才会给你好礼物！\n从9月2日到9月8日，在江湖中随时都会碰到来自月球的兔爷和兔妹，打败他们就可以获得月饼，收集月饼来贡献就可以获得各种丰厚的奖励！", tips:""});
		}
		
		protected function onGetGift(e:MouseEvent) : void{
			var index:int = e.target.name.split("_")[1];
			var arr:Array = MidAutumnManager.getIns().calculateIndex();
			if(arr[index - 1] == NumberConst.getIns().one){
				MidAutumnManager.getIns().getGift(index);
				update();
			}
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			update();
		}
		
		override public function update():void{
			nowMoonCake.text = PackManager.getIns().searchItemNum(NumberConst.getIns().moonCakeId).toString();
			devoteMoonCake.text = player.midAutumnInfo.moonCakeCount.toString();
			
			var arr:Array = MidAutumnManager.getIns().calculateIndex();
			for(var i:int = 0; i < 6; i++){
				if(arr[i] == NumberConst.getIns().one){
					GreyEffect.reset(this["gift_" + (i + 1)]);
				}else{
					GreyEffect.change(this["gift_" + (i + 1)], .3);
				}
			}
			giftBar.width = MidAutumnManager.getIns().barLen;
		}
		
		protected function onStartDevote(e:MouseEvent) : void{
			ViewFactory.getIns().initView(DevoteView).show();
		}
		
		protected function onClose(e:MouseEvent) : void{
			this.hide();
		}
		
		private function get closeBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
		private function get nowMoonCake() : TextField{
			return layer["NowMoonCake"];
		}
		private function get devoteMoonCake() : TextField{
			return layer["DevoteMoonCake"];
		}
		private function get startDevote() : SimpleButton{
			return layer["StartDevote"];
		}
		private function get introduce() : Sprite{
			return layer["Introduce"];
		}
		private function get giftBar() : Sprite{
			return layer["GiftBar"];
		}
		private function get gift_1() : Sprite{
			return layer["Gift_1"];
		}
		private function get gift_2() : Sprite{
			return layer["Gift_2"];
		}
		private function get gift_3() : Sprite{
			return layer["Gift_3"];
		}
		private function get gift_4() : Sprite{
			return layer["Gift_4"];
		}
		private function get gift_5() : Sprite{
			return layer["Gift_5"];
		}
		private function get gift_6() : Sprite{
			return layer["Gift_6"];
		}
	}
}