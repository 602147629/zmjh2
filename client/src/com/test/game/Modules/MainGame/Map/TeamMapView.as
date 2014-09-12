package com.test.game.Modules.MainGame.Map
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.DebugArea;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.DebugConst;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Mvc.BmdView.TeamGameSceneView;
	import com.test.game.Mvc.control.key.GoToBattleControl;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class TeamMapView extends BaseMapView
	{
		private var _gsv:TeamGameSceneView;
		public function TeamMapView()
		{
			super();
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			MainMapView(ViewFactory.getIns().getView(MainMapView) as MainMapView).hide();
			MainToolBar(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).hide();
			(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).initTeamBattleView();
		}
		
		override public function setMap() : void{
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
			
			var bitmapdata:BitmapData = new BitmapData(940, 650, true, 0xFF000000);
			_uiBg = new BaseNativeEntity();
			_uiBg.data.bitmapData = bitmapdata;
			_uiBg.y = -60;
			_uiBg.alpha = .8;
			
			analysisBattleDisposition();
		}
		
		override public function controlMap(empty:Boolean = false):void{
			_gsv = BmdViewFactory.getIns().getView(TeamGameSceneView) as TeamGameSceneView;
			
			checkStart();
			moveMap(empty);
		}
		
		override protected function checkStart():void{
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
		
		override protected function createMonster() : void{
			if(_nowBattle[_nowMonsterIndex - 1] == null){
				DebugArea.getIns().showInfo("缺少关卡怪物配置信息，关卡：" + _nowlevel.slice(3), DebugConst.ERROR);
				//throw new Error("缺少关卡怪物配置信息，关卡：" + _nowlevel.slice(3));
			}
			
			//初始化数据
			LevelManager.getIns().initLevelData(_nowBattle[_nowMonsterIndex - 1], _nowMonsterIndex);
			_nowMonsterIndex++;
		}
		
		override protected function moveMap(empty:Boolean):void{
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
					player.characterControl.limitLeftX = this.mapEntity["limit" + _nowLimitIndex + "_1"].x;
					player.characterControl.limitRightX = this.mapEntity["limit" + _nowLimitIndex + "_2"].x;
				}
				if(this.x > _limitLeft){
					offsetPoint(new Point(-_gsv.myPlayer.speedX, 0));
					(ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView).offsetPoint(new Point(-_gsv.myPlayer.speedX, 0));
				}
				emptyJudge(false);
			}
			
			_averagePoint.x = _gsv.myPlayer.stagePos.x;
			if(_averagePoint.x > 2 * GameConst.stage.stageWidth / 3){
				if(this.x > _limitRight + _gsv.myPlayer.speedX * .8){
					offsetPoint(new Point(-_gsv.myPlayer.speedX, 0));
					(ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView).offsetPoint(new Point(-_gsv.myPlayer.speedX, 0));
				}else{
					this.x = _limitRight;
				}
			}else if(_averagePoint.x < GameConst.stage.stageWidth / 3){
				if(this.x < _limitLeft - _gsv.myPlayer.speedX * .8){
					offsetPoint(new Point(_gsv.myPlayer.speedX, 0));
					(ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView).offsetPoint(new Point(_gsv.myPlayer.speedX, 0));
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
	}
}