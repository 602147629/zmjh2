package com.test.game.Modules.MainGame.Map
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.SwitchViewManager;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Mvc.BmdView.FunnyBossSceneView;
	import com.test.game.Mvc.control.key.GotoFunnyBattleControl;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class FunnyMapView extends BaseView
	{
		private var _hsv:FunnyBossSceneView;
		//地图
		public var mapBitmap:BaseNativeEntity;
		//怒气爆发蒙版
		protected var _uiBg:BaseNativeEntity;
		protected var _averagePoint:Point = new Point;
		protected var _limitLeft:int;
		protected var _limitRight:int;
		public function FunnyMapView()
		{
			super();
			RenderEntityManager.getIns().addEntity(this);
		}
		
		override public function init():void{
			super.init();
			var arr:Array = [];
			if(GameConst.isPreLoading){
				arr = arr.concat(AssetsUrl.getFodderObject(MapManager.getIns().getPlayerFodder(PlayerManager.getIns().player.occupation)));
				var equip:Array = PlayerManager.getIns().getEquipped();
				for(var i:int = 0; i < equip.length; i++){
					arr.push(AssetsUrl.getAssetObject("Role/" + equip[i]));
				}
				var partnerEquip:Array = PlayerManager.getIns().getPartnerEquipped();
				for(var j:int = 0; j < partnerEquip.length; j++){
					arr.push(AssetsUrl.getAssetObject("Role/" + partnerEquip[j]));
				}
			}
			arr = arr.concat([
				AssetsUrl.getAssetObject(AssetsConst.FUNNY_MAP),
				AssetsUrl.getAssetObject(AssetsConst.LEVELINFOVIEW),
				AssetsUrl.getAssetObject(AssetsConst.PASSLEVELVIEW),
				AssetsUrl.getAssetObject(AssetsConst.DUNGEONUI),
				AssetsUrl.getAssetObject(AssetsConst.BOSSFIGHTSOUND),
				AssetsUrl.getAssetObject(AssetsConst.PASSLEVELSOUND),
				AssetsUrl.getAssetObject(AssetsConst.XIAOYAOHITSOUND),
				AssetsUrl.getAssetObject(AssetsConst.KUANGWUHITSOUND),
				AssetsUrl.getAssetObject(AssetsConst.COMMONSOUND),
				AssetsUrl.getAssetObject(AssetsConst.BOSSBATTLEBAR),
				AssetsUrl.getAssetObject(AssetsConst.HEROFIGHTVIEW),
				AssetsUrl.getAssetObject(AssetsConst.PLAYERKILLINGSOUND)
			]);
			AssetsManager.getIns().addQueen([], arr, start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = new Sprite();
				this.addChild(layer);
				eyesEffect();
			}
		}
		
		protected function eyesEffect():void{
			SoundManager.getIns().fightSoundPlayer("EnterLevelSound");
			SwitchViewManager.getIns().eyesCloseCallback = 
				function () : void{
					initParams();
					initUI();
					setParams();
				};
			SwitchViewManager.getIns().eyesStartEnter();
		}
		
		protected function initParams() : void{
			
		}
		
		protected function initUI() : void{
			setMap();
			SoundManager.getIns().bgSoundPlay(AssetsConst.PLAYERKILLINGSOUND);
		}
		
		public function setMap() : void{
			mapBitmap = new BaseNativeEntity();
			mapBitmap.data.bitmapData = AUtils.getNewObj("FunnyMap") as BitmapData;
			mapBitmap.x = -50;
			mapBitmap.y = -80;
			layer.addChild(mapBitmap);
			
			var bitmapdata:BitmapData = new BitmapData(940, 650, true, 0xFF000000);
			_uiBg = new BaseNativeEntity();
			_uiBg.data.bitmapData = bitmapdata;
			_uiBg.y = -60;
			_uiBg.alpha = .8;
			
			//offsetPoint(new Point(-130, 0));
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			MainMapView(ViewFactory.getIns().getView(MainMapView) as MainMapView).hide();
			MainToolBar(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).hide();
			(ControlFactory.getIns().getControl(GotoFunnyBattleControl) as GotoFunnyBattleControl).initBattleView();
		}
		
		public function moveMap():void{
			var player:PlayerEntity;
			_hsv = BmdViewFactory.getIns().getView(FunnyBossSceneView) as FunnyBossSceneView;
			_limitLeft = 0;
			_limitRight = -this.width + 100 + GameConst.stage.stageWidth;
			for each(player in _hsv.players){
				player.characterControl.limitLeftX = 0;
				player.characterControl.limitRightX = this.width - 50;
			}
			if(_hsv.myPlayer.charData.useProperty.hp > 0){
				player = _hsv.myPlayer;
			}else if(_hsv.partnerPlayer.charData.useProperty.hp > 0){
				player = _hsv.partnerPlayer;
			}else{
				player = _hsv.myPlayer;
			}
			_averagePoint.x = player.stagePos.x;
			/*if(_averagePoint.x > 3 * GameConst.stage.stageWidth / 4){
				if(this.x > _limitRight + player.speedX * .8){
					offsetPoint(new Point(-player.speedX, 0));
				}else{
					this.x = _limitRight - 100;
				}
			}else if(_averagePoint.x < GameConst.stage.stageWidth / 4){
				if(this.x < _limitLeft - player.speedX * .8){
					offsetPoint(new Point(player.speedX, 0));
				}else{
					//this.x = _limitLeft;
				}
			}*/
			
			_hsv.x = x;
			if(_uiBg != null && _uiBg.parent != null){
				_uiBg.x = -x;
			}
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
		
		public function offsetPoint(p:Point):void{
			this.x += p.x;
			this.y += p.y;
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().bgLayer;
		}
		
		override public function destroy():void{
			RenderEntityManager.getIns().removeEntity(this);
			if(this.mapBitmap){
				this.mapBitmap.destroy();
				this.mapBitmap = null;
			}
			if(_uiBg){
				_uiBg.destroy();
				_uiBg = null;
			}
			_hsv = null;
			_averagePoint = null;
			layer = null;
			super.destroy();
		}
		
		public function getCenter() : int{
			return 600;
		}
		public function getLimitLeft() : int{
			return 0;
		}
		public function getLimitRight() : int{
			return 1000;
		}
		public function getOffset() : int{
			return 10;
		}
	}
}