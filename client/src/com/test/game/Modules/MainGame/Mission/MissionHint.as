package com.test.game.Modules.MainGame.Mission
{
	import com.greensock.TweenMax;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Mvc.Vo.PlayerVo;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class MissionHint extends BaseView
	{

		private var _obj:Sprite;
		
		private var _dataArr:Array;
		
		private var _hintVector:Vector.<MissionHintIcon>;
		
		public function MissionHint()
		{
			var arr:Array = [
				AssetsUrl.getAssetObject(AssetsConst.MISSIONVIEW)				
			];
			AssetsManager.getIns().addQueen([],arr,renderView,LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;	
		}
		
		
		private function get player():PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		
		private function renderView(...args):void{
			LoadManager.getIns().hideProgress();
			layer = new Sprite();
			this.addChild(layer);

			this.x = 928;
			this.y = 100;
			
			update();
			

		}
		

		
		override public function show():void{
			if(layer == null) return;
			update();
			this.x = 928;
			this.y = 100;
			super.show();
		}
		

		
		override public function update():void{
			
			
			_dataArr = [];
			
			var mainId:int = player.mainMissionVo.id;
			_dataArr.push(mainId);
			
			for(var i:int =0;i < player.hideMissionInfo.length ; i++){
				if(player.hideMissionInfo[i].isShow){
					var hideId:int = player.hideMissionInfo[i].id;
					_dataArr.push(hideId);
				}
			}
			
			var dailyId:int = player.dailyMissionVo.missionType+2000;

			if(DailyMissionManager.getIns().checkDailyMission){
				if(player.dailyMissionVo.missionType!=NumberConst.getIns().negativeOne){
					_dataArr.push(dailyId);
				}else{
					_dataArr.push(2000);
				}
				
			}
			
			clearAllHint();
			initRender();
		}
		

		
		private function initRender() : void
		{
			if(!_hintVector){
				_hintVector = new Vector.<MissionHintIcon>;
			}

			for (var i:int = 0; i <_dataArr.length ; i++)
			{
				var hint:MissionHintIcon = new MissionHintIcon();
				
				hint.x = -5;
				hint.y = 27+60*i;
				hint.index = i;
				hint.setData(_dataArr[i]);
				_hintVector.push(hint);
				layer.addChild(hint);
			}
		}
		
		private function clearAllHint() : void
		{
			if(_hintVector){
				while (_hintVector.length > 0)
				{
					var hint:MissionHintIcon = _hintVector.pop();
					if (hint.parent) hint.parent.removeChild(hint);
					hint.destroy();
					hint = null;
				}
			}
		}
		
	
		private function close(e:MouseEvent):void{
			hide();
		}
		
		override public function destroy() : void{
			clearAllHint();
		}
	}
}