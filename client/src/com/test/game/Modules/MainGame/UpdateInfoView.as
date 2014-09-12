package com.test.game.Modules.MainGame
{
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.LoadManager;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class UpdateInfoView extends BaseView
	{
		private var _nowIndex:int;
		private var _nowVersion:int;
		private var _nowDataList:Array;
		public function UpdateInfoView(){
			super();
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.UPDATEINFOVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("UpdateInfoView") as Sprite;
				layer.x = 5;
				layer.y = 480;
				this.addChild(layer);
				
				initParams();
				initUI();
				setParams();
				setCenter();
			}
		}
		
		private function initUI():void{
			preBtn.addEventListener(MouseEvent.CLICK, onPreInfo);
			nextBtn.addEventListener(MouseEvent.CLICK, onNextInfo);
		}
		
		protected function onNextInfo(event:MouseEvent):void{
			_nowIndex++;
			update();
		}
		
		protected function onPreInfo(event:MouseEvent):void{
			_nowIndex--;
			update();
		}
		
		private function initParams():void{
			(layer["CloseBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, onClose);
			_nowVersion = _nowIndex = Math.round(Number(GameConst.VERSION.slice(1, 5)) * 100);
			initBg();
			update();
		}
		
		override public function update():void{
			updateContent();
			updateBtnStatus();
		}
		
		private function updateContent() : void{
			_nowDataList = ConfigurationManager.getIns().getSearchByProperty(AssetsConst.UPDATE_MESSAGE, "version", _nowIndex);
			version.text = "V" + int(_nowIndex / 100) + "." + String(_nowIndex).slice(1);
			updateInfoTitle.text = version.text + "更新公告：";
			updateInfoContent.text = "";
			for(var i:int = 0; i < _nowDataList.length; i++){
				updateInfoContent.text += _nowDataList[i].info + "\n";
			}
		}
		
		private function updateBtnStatus() : void{
			if(_nowIndex == _nowVersion){
				GreyEffect.change(nextBtn);
				nextBtn.mouseEnabled = false;
			}else{
				GreyEffect.reset(nextBtn);
				nextBtn.mouseEnabled = true;
			}
			
			if(_nowIndex == 100){
				GreyEffect.change(preBtn);
				preBtn.mouseEnabled = false;
			}else{
				GreyEffect.reset(preBtn);
				preBtn.mouseEnabled = true;
			}
		}
		
		private function onClose(e:MouseEvent) : void{
			this.hide()
		}
		
		private function get preBtn() : SimpleButton{
			return layer["PreBtn"];
		}
		private function get nextBtn() : SimpleButton{
			return layer["NextBtn"];
		}
		private function get updateInfoTitle() : TextField{
			return layer["UpdateInfoTitle"];
		}
		private function get updateInfoContent() : TextField{
			return layer["UpdateInfoContent"];
		}
		private function get version() : TextField{
			return layer["Version"];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameInfoLayer;
		}
		
	}
}