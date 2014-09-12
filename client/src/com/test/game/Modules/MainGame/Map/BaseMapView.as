package com.test.game.Modules.MainGame.Map{
	import com.adobe.serialization.json.JSON;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.game.ResourceOperation.BitmapDataPool;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.DebugConst;
	import com.test.game.Effect.BlurEffect;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Test.StationShow;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.SoundManager;
	import com.test.game.Manager.SwitchViewManager;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Modules.MainGame.Guide.FirstLevelGuideView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Mvc.BmdView.GameSenceView;
	import com.test.game.Mvc.control.key.GoToBattleControl;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class BaseMapView extends BaseView{
		public var stationList:Vector.<StationShow>;
		protected var _mapEntity:Sprite;
		protected var _averagePoint:Point = new Point;
		private var _gsv:GameSenceView;
		//当前场次索引
		protected var _nowLimitIndex:int = 1;
		//当前怪物索引
		protected var _nowMonsterIndex:int = 1;
		//所有关卡战斗数据
		protected var _battleDisposition:Array = new Array();
		//当前关卡战斗数据
		protected var _nowBattle:Array = new Array();
		//当前场次是否是最后一个场次
		protected var _lastMonster:Boolean;
		//当前关卡名
		protected var _nowlevel:String;
		//地图
		public var mapBitmap:BaseNativeEntity;
		//第一关引导图片
		private var _guideImg:BaseNativeEntity;
		//怒气爆发蒙版
		protected var _uiBg:BaseNativeEntity;
		
		public var reEnterBattle:Boolean;
		
		protected var _loadingFodder:Array;
		private var _nowSound:String;
		
		private var _uiList:Array = new Array();
		
		public function BaseMapView(){
			super();
			RenderEntityManager.getIns().addEntity(this);
		}
		
		override public function init():void{
			//DebugArea.getIns().showResult("------onEnterBattle_4------:", DebugConst.NORMAL);
			super.init();
			var arr:Array = [];
			if(GameConst.isPreLoading){
				_loadingFodder = MapManager.getIns().preLoadingFodder(LevelManager.getIns().nowIndex, LevelManager.getIns().mapType);
				arr = arr.concat(AssetsUrl.getFodderObject(_loadingFodder));
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
			arr = arr.concat(soundResource);
			arr = arr.concat(MapManager.getIns().mapBgResource(LevelManager.getIns().nowIndex, LevelManager.getIns().mapType));
			arr = arr.concat([
				AssetsUrl.getAssetObject(MapManager.getIns().mapResource(LevelManager.getIns().nowIndex,LevelManager.getIns().mapType)),
				AssetsUrl.getAssetObject(AssetsConst.LEVELINFOVIEW),
				AssetsUrl.getAssetObject(AssetsConst.PASSLEVELVIEW),
				AssetsUrl.getAssetObject(AssetsConst.DUNGEONUI),
				AssetsUrl.getAssetObject(AssetsConst.BOSSFIGHTSOUND),
				AssetsUrl.getAssetObject(AssetsConst.PASSLEVELSOUND),
				AssetsUrl.getAssetObject(AssetsConst.XIAOYAOHITSOUND),
				AssetsUrl.getAssetObject(AssetsConst.KUANGWUHITSOUND),
				AssetsUrl.getAssetObject(AssetsConst.COMMONSOUND),
				AssetsUrl.getAssetObject(AssetsConst.WEATHEREFFECT),
				AssetsUrl.getAssetObject(AssetsConst.WEATHERBLACKSOUND),
				AssetsUrl.getAssetObject(AssetsConst.WEATHERRAINSOUND),
				AssetsUrl.getAssetObject(AssetsConst.HIDEMISSIONSCENE),
				AssetsUrl.getAssetObject(AssetsConst.BOSSBATTLEBAR)
			]);
			AssetsManager.getIns().addQueen([], arr, start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		protected function start(...args) : void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = new Sprite();
				this.addChild(layer);
				
				eyesEffect();
				registFodder();
			}
		}
		
		private function registFodder():void{
			if(_loadingFodder != null){
				for(var i:int = 0; i < _loadingFodder.length; i++){
					BitmapDataPool.registerData(_loadingFodder[i], true);
				}
			}
		}
		
		protected function get soundResource() : Array{
			var result:Array = [];
			_nowSound = SoundManager.getIns().soundName(LevelManager.getIns().nowIndex);
			result.push(AssetsUrl.getAssetObject(_nowSound));
			return result;
		}
		
		protected function eyesEffect():void{
			SoundManager.getIns().fightSoundPlayer("EnterLevelSound");
			SwitchViewManager.getIns().eyesCloseCallback = 
				function () : void{
					initParams();
					initUI();
					setParams();
				};
			if((ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).reEnterBattle){
				SwitchViewManager.getIns().eyesReStartEnter();
			}else{
				SwitchViewManager.getIns().eyesStartEnter();
			}
		}
		
		protected function initParams() : void{
			initBattleDisposition();
		}
		
		protected function initUI() : void{
			SoundManager.getIns().bgSoundPlay(_nowSound);
			setMap();
		}
		
		private function initBattleDisposition() : void{
			switch(LevelManager.getIns().mapType){
				case 0:
					_battleDisposition = com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData(AssetsConst.BATTLE_DISPOSITION)).RECORDS;
					break;
				case 1:
					_battleDisposition = com.adobe.serialization.json.JSON.decode(ConfigurationManager.getIns().getJsonData(AssetsConst.ELITE_DISPOSITION)).RECORDS;
					break;
			}
		}
		
		public var station:StationShow;
		private function initStation():void{
			stationList = new Vector.<StationShow>();
			for(var i:int = 0; i < 1; i++){
				station = new StationShow(200, 100);
				station.x = 200 + i * 300;
				station.y = 400 - i * 50;
				station.offsetY = (i + 1) * 50;
				layer.addChild(station);
				stationList.push(station);
			}
		}
		
		override public function step():void{
			super.step();
			LevelManager.getIns().step();
			
			/*if(_blurEffect != null){
				_blurEffect.createBlur();
			}*/
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			MainMapView(ViewFactory.getIns().getView(MainMapView) as MainMapView).hide();
			MainToolBar(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).hide();
			(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).initBattleView();
			//关卡1_1向导
			firstGuide();
			
			HideMissionManager.getIns().init();
		}
		
		private function firstGuide():void{
			GuideManager.getIns().judgeShowFirstLevelGuide();
		}
		
		private var _blurEffect:BlurEffect;
		public function setMap() : void{
			var arr:Array = MapManager.getIns().getMapFodder(LevelManager.getIns().nowIndex, LevelManager.getIns().mapType);
			var obj:Object = AssetsManager.getIns().getAssetObject(arr[0]);
			_mapEntity = obj as Sprite;
			layer.addChild(_mapEntity);
			_mapEntity.visible = false;
			_mapEntity["monster3_1"].x -= 150;
			
			mapBitmap = new BaseNativeEntity();
			mapBitmap.data.bitmapData = AUtils.getNewObj(arr[1]) as BitmapData;
			mapBitmap.x = -50;
			mapBitmap.y = -80;
			layer.addChild(mapBitmap);
			
			if(LevelManager.getIns().mapType == 0 && arr[0] == "Map1_1"){
				_guideImg = new BaseNativeEntity();
				_guideImg.data.bitmapData = AUtils.getNewObj("FirstGuide") as BitmapData;
				_guideImg.x = 106;
				_guideImg.y = 43;
				layer.addChild(_guideImg);
			}
			
			var bitmapdata:BitmapData = new BitmapData(940, 650, true, 0xFF000000);
			_uiBg = new BaseNativeEntity();
			_uiBg.data.bitmapData = bitmapdata;
			_uiBg.y = -60;
			_uiBg.alpha = .8;
			
			analysisBattleDisposition();
			//_blurEffect = new BlurEffect();
			//initStation();
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
		
		protected function analysisBattleDisposition():void{
			_nowBattle = [];
			var info:String = LevelManager.getIns().nowIndex;
			var len:int = _battleDisposition.length;
			for(var i:int = 0; i < len; i++){
				if(String(_battleDisposition[i].name.slice(0, 4)).indexOf(info) != -1){
					_nowBattle.push(_battleDisposition[i]);
				}
			}
		}
		
		public function controlMap(empty:Boolean = false):void{
			_gsv = BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView;
			
			checkStart();
			moveMap(empty);
		}
		
		protected function checkStart():void{
			if(this._mapEntity == null) return;
			if(this._mapEntity["start" + _nowMonsterIndex] != null){
				if(_gsv.checkPlayerCross(this._mapEntity["start" + _nowMonsterIndex].x)){
					createMonster();
					_lastMonster = false;
				}
			}else{
				_lastMonster = true;
			}
		}
		
		protected function createMonster() : void{
			if(_nowBattle[_nowMonsterIndex - 1] == null){
				DebugArea.getIns().showInfo("缺少关卡怪物配置信息，关卡：" + _nowlevel.slice(3), DebugConst.ERROR);
				//throw new Error("缺少关卡怪物配置信息，关卡：" + _nowlevel.slice(3));
			}
			
			//关卡1_1向导
			if(ViewFactory.getIns().getView(FirstLevelGuideView) != null){
				if(_nowMonsterIndex == 1 || _nowMonsterIndex == 2 || _nowMonsterIndex == 3){
					(ViewFactory.getIns().getView(FirstLevelGuideView) as FirstLevelGuideView).firstLevelGuide();
				}
			}
			
			//初始化数据
			LevelManager.getIns().initLevelData(_nowBattle[_nowMonsterIndex - 1], _nowMonsterIndex);
			_nowMonsterIndex++;
		}
		
		protected var _limitMove:Boolean;
		protected var _limitLeft:int;
		protected var _limitRight:int;
		protected var _emptyJudge:Boolean;
		protected function moveMap(empty:Boolean):void{
			var player:PlayerEntity;
			if(empty){
				_limitLeft = 0;
				_limitRight = -this.width + 100 + GameConst.stage.stageWidth;
				for each(player in _gsv.players){
					player.characterControl.limitLeftX = 0;
					player.characterControl.limitRightX = this.width - 100;
					if(DailyMissionManager.getIns().obstacleJudge(_nowLimitIndex)){
						player.characterControl.limitRightX = 3400;
					}
				}
				emptyJudge(true);
			}else{
				_limitLeft = -this.mapEntity["limit" + _nowLimitIndex + "_1"].x;
				_limitRight = -(this.mapEntity["limit" + _nowLimitIndex + "_2"].x - GameConst.stage.stageWidth);
				for each(player in _gsv.players){
					if(player.charData.useProperty.hp > 0){
						player.characterControl.limitLeftX = this.mapEntity["limit" + _nowLimitIndex + "_1"].x;
						player.characterControl.limitRightX = this.mapEntity["limit" + _nowLimitIndex + "_2"].x;
					}
				}
				if(this.x > _limitLeft){
					offsetPoint(new Point(-_gsv.myPlayer.speedX, 0));
					(ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView).offsetPoint(new Point(-_gsv.myPlayer.speedX, 0));
				}
				emptyJudge(false);
			}
			if(_gsv.myPlayer.charData.useProperty.hp > 0){
				player = _gsv.myPlayer;
			}else if(_gsv.partnerPlayer.charData.useProperty.hp > 0){
				player = _gsv.partnerPlayer;
			}else{
				player = _gsv.myPlayer;
			}
			_averagePoint.x = player.stagePos.x;
			if(_averagePoint.x > 2 * GameConst.stage.stageWidth / 3){
				if(this.x > _limitRight + player.speedX * .8){
					offsetPoint(new Point(-player.speedX, 0));
					(ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView).offsetPoint(new Point(-player.speedX, 0));
				}else{
					this.x = _limitRight;
				}
			}else if(_averagePoint.x < GameConst.stage.stageWidth / 3){
				if(this.x < _limitLeft - player.speedX * .8){
					offsetPoint(new Point(player.speedX, 0));
					(ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView).offsetPoint(new Point(player.speedX, 0));
				}else{
					//this.x = _limitLeft;
				}
			}
			
			//移动自身(实体层和背景层坐标一致)
			_gsv.x = x;
			if(_uiBg != null && _uiBg.parent != null){
				_uiBg.x = -x;
			}
			uiRender();
		}
		
		protected function uiRender():void{
			for(var i:int = 0; i < _uiList.length; i++){
				if(_uiList[i].parent != null){
					_uiList[i].x = -x;
				}
			}
		}
		
		public function pushUI(bne:BaseNativeEntity) : void{
			if(checkUI(bne) == -1){
				_uiList.push(bne);
				layer.addChildAt(bne, layer.numChildren - 1);
			}
		}
		
		public function popUI(bne:BaseNativeEntity) : void{
			var index:int = checkUI(bne);
			if(index != -1){
				_uiList.splice(index, 1);
			}
		}
		
		public function checkUI(bne:BaseNativeEntity) : int{
			var result:int = _uiList.indexOf(bne);
			return result;
		}
		
		protected function emptyJudge(judge:Boolean) : void{
			if(judge){
				if(_emptyJudge == false){
					_emptyJudge = true;
					//关卡1_1向导
					/*if(ViewFactory.getIns().getView(FirstLevelGuideView) != null){
						if(_nowMonsterIndex == 2){
							(ViewFactory.getIns().getView(FirstLevelGuideView) as FirstLevelGuideView).firstLevelGuide();
						}
					}*/
				}
			}else{
				if(_emptyJudge == true){
					_emptyJudge = false;
				}
			}
		}
		
		/**
		 * 移动地图 
		 * @param p
		 * 
		 */		
		public function offsetPoint(p:Point):void{
			this.x += p.x;
			this.y += p.y;
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().bgLayer;
		}
		
		override public function destroy():void{
			RenderEntityManager.getIns().removeEntity(this);
			if(this._mapEntity){
				this._mapEntity.parent.removeChild(_mapEntity);
				this._mapEntity = null;
			}
			if(this.mapBitmap){
				this.mapBitmap.destroy();
				this.mapBitmap = null;
			}
			if(_battleDisposition){
				_battleDisposition.length = 0;
				_battleDisposition = null;
			}
			if(_nowBattle){
				_nowBattle.length = 0;
				_nowBattle = null;
			}
			if(_loadingFodder){
				_loadingFodder.length = 0;
				_loadingFodder = null;
			}
			if(_uiList){
				for(var i:int = 0; i < _uiList.length; i++){
					_uiList[i].destory();
					_uiList[i] = null;
				}
				_uiList.length = 0;
				_uiList = null;
			}
			if(_blurEffect){
				_blurEffect.destroy();
				_blurEffect = null;
			}
			if(_guideImg){
				_guideImg.destroy();
				_guideImg = null;
			}
			if(_uiBg){
				_uiBg.destroy();
				_uiBg = null;
			}
			_gsv = null;
			_averagePoint = null;
			layer = null;
			super.destroy();
		}
		
		public function getCenter() : int{
			return (this.mapEntity["limit" + this.nowLimitIndex + "_1"].x + this.mapEntity["limit" + nowLimitIndex + "_2"].x)/2;
		}
		public function getLimitLeft() : int{
			return this.mapEntity["limit" + nowLimitIndex + "_1"].x;
		}
		public function getLimitRight() : int{
			return this.mapEntity["limit" + nowLimitIndex + "_2"].x;
		}
		public function getOffset() : int{
			return Math.abs((this.mapEntity["limit" + nowLimitIndex + "_1"].x - this.mapEntity["limit" + nowLimitIndex + "_2"].x) / 2 / 60);
		}
		
		public function get mapEntity() : Sprite{
			return _mapEntity;
		}
		
		public function get nowLimitIndex() : int{
			return _nowLimitIndex;
		}
		public function set nowLimitIndex(value:int) : void{
			_nowLimitIndex = value;
		}
		
		public function get nowMonsterIndex() : int{
			return _nowMonsterIndex;
		}
		public function set nowMonsterIndex(value:int) : void{
			_nowMonsterIndex = value;
		}
		
		public function get lastMonster() : Boolean{
			return _lastMonster;
		}
		public function set lastMonster(value:Boolean) : void{
			_lastMonster = value;
		}
		
		public function get nowMonsterStart() : int{
			return this._mapEntity["start" + _nowMonsterIndex].x;
		}
	}
}