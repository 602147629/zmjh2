package com.test.game.Modules.MainGame.Map
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.SwitchViewManager;
	import com.test.game.Mvc.BmdView.AutoPKSceneView;
	import com.test.game.Mvc.BmdView.PlayerKillingSceneView;
	import com.test.game.Mvc.control.key.GoToBattleControl;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class PlayerKillingMapView extends BaseView
	{
		public var mapBitmap:BaseNativeEntity;
		public var mapIndex:String = "";
		public var mapType:int = 0;
		private var _pkv:PlayerKillingSceneView;
		private var _apkv:AutoPKSceneView;
		private var _uiBg:BaseNativeEntity;
		private var _averagePoint:Point = new Point;
		public function PlayerKillingMapView()
		{
			super();
		}
		
		override public function init():void{
			super.init();
			var mapArr:Array = MapManager.getIns().getRandomMap();
			mapIndex = mapArr[0];
			mapType = mapArr[1];
			var arr:Array = [
				AssetsUrl.getAssetObject(MapManager.getIns().mapResource(mapIndex, mapType)),
				AssetsUrl.getAssetObject(AssetsConst.LEVELINFOVIEW),
				AssetsUrl.getAssetObject(AssetsConst.DUNGEONUI),
				AssetsUrl.getAssetObject(AssetsConst.PLAYERKILLINGSOUND),
				AssetsUrl.getAssetObject(AssetsConst.XIAOYAOHITSOUND),
				AssetsUrl.getAssetObject(AssetsConst.KUANGWUHITSOUND),
				AssetsUrl.getAssetObject(AssetsConst.COMMONSOUND),
				AssetsUrl.getAssetObject(AssetsConst.PLAYERKILLINGUI)
			];
			arr = arr.concat(MapManager.getIns().mapBgResource(mapIndex, mapType));
			arr = arr.concat(AssetsUrl.getFodderObject(MapManager.getIns().getPKPlayerFodder()));

			AssetsManager.getIns().addQueen([], arr, start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		public function start(...args) : void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = new Sprite();
				this.addChild(layer);
				
				eyesEffect();
			}
		}
		
		private function eyesEffect():void{
			SoundManager.getIns().fightSoundPlayer("EnterLevelSound");
			SwitchViewManager.getIns().eyesCloseCallback = 
				function () : void{
					initParams();
					initUI();
					setParams();
				};
			SwitchViewManager.getIns().eyesStartEnter();
		}
		
		private function initParams():void{
			(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).initPlayerKillingView();
		}
		
		private function initUI():void{
			setMap();
			SoundManager.getIns().bgSoundPlay(AssetsConst.PLAYERKILLINGSOUND);
		}
		
		public function setMap() : void{
			var arr:Array = MapManager.getIns().getMapFodder(mapIndex, mapType);
			mapBitmap = new BaseNativeEntity();
			mapBitmap.data.bitmapData = AUtils.getNewObj(arr[1]) as BitmapData;
			mapBitmap.x = -50;
			mapBitmap.y = -80;
			layer.addChild(mapBitmap);
			var bitmapdata:BitmapData = new BitmapData(940, 650, true, 0xFF000000);
			_uiBg = new BaseNativeEntity();
			_uiBg.data.bitmapData = bitmapdata;
			_uiBg.y = -60;
			_uiBg.alpha = .8;
			this.x = -3660;
		}
		
		private var _limitLeft:int;
		private var _limitRight:int;
		public function controlMap():void{
			_pkv = BmdViewFactory.getIns().getView(PlayerKillingSceneView) as PlayerKillingSceneView;
			if(_pkv == null){
				autoPKControlMap();
				return;
			}
			var player:PlayerEntity;
			_limitLeft = -3660;
			_limitRight = -(4600 - GameConst.stage.stageWidth);
			for each(player in _pkv.players){
				player.characterControl.limitLeftX = 3660;
				player.characterControl.limitRightX = 4600;
			}
			
			_averagePoint.x = _pkv.myPlayer.stagePos.x;
			if(_averagePoint.x > 2 * GameConst.stage.stageWidth / 3){
				if(this.x > _limitRight + _pkv.myPlayer.speedX * .8){
					offsetPoint(new Point(-_pkv.myPlayer.speedX, 0));
				}else{
					this.x = _limitRight;
				}
			}else if(_averagePoint.x < GameConst.stage.stageWidth / 3){
				if(this.x < _limitLeft - _pkv.myPlayer.speedX * .8){
					offsetPoint(new Point(_pkv.myPlayer.speedX, 0));
				}else{
					//this.x = _limitLeft;
				}
			}
			
			//移动自身(实体层和背景层坐标一致)
			_pkv.x = x;
			if(_uiBg != null && _uiBg.parent != null){
				_uiBg.x = -x;
			}
		}
		
		private function autoPKControlMap():void{
			_apkv = BmdViewFactory.getIns().getView(AutoPKSceneView) as AutoPKSceneView;
			if(_apkv == null) return;
			var player:PlayerEntity;
			_limitLeft = -3660;
			_limitRight = -(4600 - GameConst.stage.stageWidth);
			for each(player in _apkv.players){
				player.characterControl.limitLeftX = 3660;
				player.characterControl.limitRightX = 4600;
			}
			
			_averagePoint.x = _apkv.myPlayer.stagePos.x;
			if(_averagePoint.x > 2 * GameConst.stage.stageWidth / 3){
				if(this.x > _limitRight + _apkv.myPlayer.speedX * .8){
					offsetPoint(new Point(-_apkv.myPlayer.speedX, 0));
				}else{
					this.x = _limitRight;
				}
			}else if(_averagePoint.x < GameConst.stage.stageWidth / 3){
				if(this.x < _limitLeft - _apkv.myPlayer.speedX * .8){
					offsetPoint(new Point(_apkv.myPlayer.speedX, 0));
				}else{
					//this.x = _limitLeft;
				}
			}
			
			//移动自身(实体层和背景层坐标一致)
			_apkv.x = x;
			if(_uiBg != null && _uiBg.parent != null){
				_uiBg.x = -x;
			}
		}
		
		public function offsetPoint(p:Point):void{
			this.x += p.x;
			this.y += p.y;
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().bgLayer;
		}
		
		public function addUIBg() : void{
			if(_uiBg != null){
				layer.addChild(_uiBg);
			}
		}
		
		public function removeUIBg() : void{
			if(_uiBg != null && _uiBg.parent != null){
				_uiBg.parent.removeChild(_uiBg);
			}
		}
		
		public function getCenter() : int{
			return -this.x + 940 * .5;
		}
		
		public function getLimitLeft() : int{
			return -this.x;
		}
		public function getLimitRight() : int{
			return -this.x + 940;
		}
		public function getOffset() : int{
			return Math.abs(940 / 2 / 60);
		}
	}
}