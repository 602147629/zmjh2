package com.test.game.Modules.MainGame.Map
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.EscortManager;
	import com.test.game.Manager.MapManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Mvc.control.Escort.EscortControl;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class EscortMapView extends BaseMapView
	{
		public function EscortMapView()
		{
			super();
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			MainMapView(ViewFactory.getIns().getView(MainMapView) as MainMapView).hide();
			MainToolBar(ViewFactory.getIns().getView(MainToolBar) as MainToolBar).hide();
			(ControlFactory.getIns().getControl(EscortControl) as EscortControl).initEscortBattleView();
		}
		
		override public function setMap() : void{
			var arr:Array = MapManager.getIns().getMapFodder(EscortManager.getIns().nowIndex, 0);
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
			
			moveMap(empty);
		}
		
		override public function step():void{
			
		}
		
		override protected function moveMap(empty:Boolean):void{
			var player:PlayerEntity;
			if(empty){
				_limitLeft = 0;
				_limitRight = -this.width + 100 + GameConst.stage.stageWidth;
				for each(player in SceneManager.getIns().players){
					player.characterControl.limitLeftX = 0;
					player.characterControl.limitRightX = this.width - 100;
				}
				emptyJudge(true);
			}else{
				_limitLeft = 0;
				_limitRight = -this.width + 100 + GameConst.stage.stageWidth;
				for each(player in SceneManager.getIns().players){
					player.characterControl.limitLeftX = 0;
					player.characterControl.limitRightX = this.width - 100;
				}
				if(this.x > _limitLeft){
					offsetPoint(new Point(-SceneManager.getIns().myPlayer.speedX, 0));
					(ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView).offsetPoint(new Point(-SceneManager.getIns().myPlayer.speedX, 0));
				}
				emptyJudge(false);
			}
			
			_averagePoint.x = SceneManager.getIns().myPlayer.stagePos.x;
			if(_averagePoint.x > 2 * GameConst.stage.stageWidth / 3){
				if(this.x > _limitRight + SceneManager.getIns().myPlayer.speedX * .8){
					offsetPoint(new Point(-SceneManager.getIns().myPlayer.speedX, 0));
					(ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView).offsetPoint(new Point(-SceneManager.getIns().myPlayer.speedX, 0));
				}else{
					this.x = _limitRight;
				}
			}else if(_averagePoint.x < GameConst.stage.stageWidth / 3){
				if(this.x < _limitLeft - SceneManager.getIns().myPlayer.speedX * .8){
					offsetPoint(new Point(SceneManager.getIns().myPlayer.speedX, 0));
					(ViewFactory.getIns().getView(BaseMapBgView) as BaseMapBgView).offsetPoint(new Point(SceneManager.getIns().myPlayer.speedX, 0));
				}else{
					//this.x = _limitLeft;
				}
			}
			
			//移动自身(实体层和背景层坐标一致)
			SceneManager.getIns().nowScene.x = x;
			if(_uiBg != null && _uiBg.parent != null){
				_uiBg.x = -x;
			}
			uiRender();
		}
	}
}