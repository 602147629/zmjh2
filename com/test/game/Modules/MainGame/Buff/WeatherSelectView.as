package com.test.game.Modules.MainGame.Buff
{
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.DebugConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.WeatherConst;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.WeatherManager;
	import com.test.game.Modules.MainGame.BuffShowView;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.control.View.GameSceneControl;
	import com.test.game.Mvc.control.View.PlayerUIControl;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class WeatherSelectView extends BaseView
	{
		public function WeatherSelectView()
		{
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.WEATHERSELECTVIEW)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("WeatherSelectView") as Sprite;
				this.addChild(layer);
				
				initUI();
				setParams();
				setCenter();
				initBg();
				update();
			}
		}
		
		private function initUI() : void{
			blackSelect_1.addEventListener(MouseEvent.CLICK, onSelectWeather);
			rainSelect_2.addEventListener(MouseEvent.CLICK, onSelectWeather);
			windSelect_3.addEventListener(MouseEvent.CLICK, onSelectWeather);
			thunderSelect_4.addEventListener(MouseEvent.CLICK, onSelectWeather);
			clostBtn.addEventListener(MouseEvent.CLICK, onClose);
		}
		
		override public function show():void{
			super.show();
			if(layer == null)	return;
			update();
		}
		
		override public function update() : void{
			(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameStopRender();
			propCount.text = PackManager.getIns().searchItemNum(NumberConst.getIns().weatherSelectID).toString();
		}
		
		protected function onClose(e:MouseEvent) : void{
			(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameStartRender();
			this.hide();
		}
		
		protected function onSelectWeather(e:MouseEvent) : void{
			if(WeatherManager.getIns().weatherStatus == WeatherConst.WEATHER_NONE
				|| WeatherManager.getIns().weatherStatus == 0){
				var index:int = e.target.name.split("_")[1];
				(ViewFactory.getIns().initView(NoticeView) as NoticeView).addNotice(
					"是否确定改变天气", function() : void{confirmWeather(index);});
			}else{
				(ViewFactory.getIns().initView(NoticeView) as NoticeView).addOnlySureNotice("当前已处于天气模式下");
			}
		}
		
		private function confirmWeather(index:int) : void{
			switch(index){
				case NumberConst.getIns().one:
					WeatherManager.getIns().blackStart();
					DebugArea.getIns().showResult("改变天气：黑夜", DebugConst.NORMAL);
					break;
				case NumberConst.getIns().two:
					WeatherManager.getIns().rainStart();
					DebugArea.getIns().showResult("改变天气：雨天", DebugConst.NORMAL);
					break;
				case NumberConst.getIns().three:
					WeatherManager.getIns().windStart();
					DebugArea.getIns().showResult("改变天气：大风", DebugConst.NORMAL);
					break;
				case NumberConst.getIns().four:
					WeatherManager.getIns().thunderStart();
					DebugArea.getIns().showResult("改变天气：雷雨", DebugConst.NORMAL);
					break;
			}
			PackManager.getIns().reduceItem(NumberConst.getIns().weatherSelectID, NumberConst.getIns().one);
			(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameStartRender();
			ViewFactory.getIns().getView(BuffShowView).update();
			this.hide();
		}
		
		private function get blackSelect_1() : SimpleButton{
			return layer["BlackSelect_1"];
		}
		private function get rainSelect_2() : SimpleButton{
			return layer["RainSelect_2"];
		}
		private function get windSelect_3() : SimpleButton{
			return layer["WindSelect_3"];
		}
		private function get thunderSelect_4() : SimpleButton{
			return layer["ThunderSelect_4"];
		}
		private function get clostBtn() : SimpleButton{
			return layer["CloseBtn"];
		}
		private function get propCount() : TextField{
			return layer["PropCount"];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameInfoLayer;
		}
	}
}