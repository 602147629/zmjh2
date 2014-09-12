package com.test.game.Mvc.view.Loading{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Manager.ConfigurationManager;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class LoadingView extends BaseView{
		public var showBg:Boolean;
		private var _stepCount:int;
		public function LoadingView(){
			super();
		}
		
		override public function init():void{
			super.init();
			
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.LOADVIEW)], start, null);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject(AssetsConst.LOADVIEW.split("/")[1]) as Sprite;
				this.addChild(layer);
				
				initParams();
				initUI();
				setParams();
				//setCenter();
			}
		}
		
		private function initUI():void{
			initBg();
		}
		
		private var _message:Array;
		private function initParams():void{
			_message = com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData(AssetsConst.HELP_MESSAGE)).RECORDS;
		}		
		
		public function showProgress(...args):void{
			var currentFileIdx:uint = args[0][0];
			var totalFileIdx:uint = args[0][1];
			var currentLoadedBytes:uint = args[0][2];
			var totalLoadedBytes:uint = args[0][3];
			
			loadTF.text = int((currentLoadedBytes/totalLoadedBytes) * 100) + "%" + "("+currentFileIdx+"/"+totalFileIdx+")";
			loadBar.width = (currentLoadedBytes/totalLoadedBytes) * 445;
			moveEffect.x = 156 + loadBar.width;
			
			if(showBg){
				layer["Bg"].visible = true;
				firstTF.visible = true;
				loadShowTF.x = 730;
				loading.y = 360;
			}else{
				layer["Bg"].visible = false;
				firstTF.visible = false;
				loadShowTF.x = 340;
				loading.y = 175;
			}
			//LayerManager.getIns().gameInfoLayer.setChildIndex(this, LayerManager.getIns().gameInfoLayer.numChildren - 1);
			if(currentLoadedBytes == totalLoadedBytes && currentFileIdx == totalFileIdx){
				this.hide();
				_stepCount = 0;
			}else{
				this.show();
			}
			changeContent();
		}
		
		private function changeContent():void{
			if(_stepCount == 0){
				loadContentTF.text = _message[int(Math.random() * _message.length)].content;
			}
			_stepCount++;
			if(_stepCount > 30 * 10){
				_stepCount = 0;
			}
		}
		
		private function get loadTF() : TextField{
			return layer["Loading"]["LoadTF"];
		}
		private function get loadBar() : Sprite{
			return layer["Loading"]["LoadBar"];
		}
		private function get moveEffect() : Sprite{
			return layer["Loading"]["MoveEffect"];
		}
		private function get loadContentTF() : TextField{
			return layer["Loading"]["LoadContentTF"];
		}
		private function get firstTF() : TextField{
			return layer["Loading"]["FirstTF"];
		}
		private function get loadShowTF() : TextField{
			return layer["Loading"]["LoadShowTF"]
		}
		private function get loading() : Sprite{
			return layer["Loading"];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameInfoLayer;
		}
		
	}
}