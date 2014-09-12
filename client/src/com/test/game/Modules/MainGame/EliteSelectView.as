package com.test.game.Modules.MainGame
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.AssetsUrl;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.ColorConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Effect.GreyEffect;
	import com.test.game.Effect.ViewTweenEffect;
	import com.test.game.Manager.ConfigurationManager;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.ExtraBarManager;
	import com.test.game.Manager.GuideManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.LoadManager;
	import com.test.game.Manager.PackManager;
	import com.test.game.Manager.PlayerManager;
	import com.test.game.Manager.TipsManager;
	import com.test.game.Manager.Extra.DoubleDungeonManager;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	import com.test.game.Modules.MainGame.Tip.NoticeView;
	import com.test.game.Mvc.Configuration.MainMission;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.control.key.GoToBattleControl;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	public class EliteSelectView extends BaseView
	{
		public function EliteSelectView(){
			super();
		}
		
		public function get player() : PlayerVo{
			return PlayerManager.getIns().player;
		}
		
		override public function init() : void{
			super.init();
			AssetsManager.getIns().addQueen([],[AssetsUrl.getAssetObject(AssetsConst.ELITESELECTVIEW)], start, LoadManager.getIns().onProgressLittle);
			AssetsManager.getIns().start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				LoadManager.getIns().hideProgress();
				layer = AssetsManager.getIns().getAssetObject("EliteSelectView") as Sprite;
				this.addChild(layer);
				layer.visible = false;
				
				initUI();
				initParams();
				setParams();
				setCenter();
				openTween();
			}
		}
		
		private var _eliteInfo:Array;
		private var _nowElite:int = 0;
		private var _nowInfo:Array;
		private var _preInfo:Array;
		private var _nextInfo:Array;
		private var _guideMC:MovieClip;
		private function initParams():void{
			_eliteInfo = ConfigurationManager.getIns().getAllData(AssetsConst.ELITE);
			_nowElite = (_nowElite != 0?_nowElite:1);
			_nowInfo = new Array();
			_preInfo = new Array();
			_nextInfo = new Array();
			setInfoList();
			setMission();
			setDouble();
		}
		

		private function initUI():void{
			_guideMC = GuideManager.getIns().getGuideMCByName(GuideManager.ARROW, 0, 0);
			_guideMC.visible = false;
			layer.addChild(_guideMC);
			CloseBtn.addEventListener(MouseEvent.CLICK, onClose);
			PreBtn.addEventListener(MouseEvent.CLICK, onPre);
			NextBtn.addEventListener(MouseEvent.CLICK, onNext);
			for(var i:int = 1; i < 5; i++){
				var eliteDungeonIcon:MovieClip = (layer["Level_" + i] as MovieClip);
				eliteDungeonIcon.stop();
				eliteDungeonIcon.buttonMode = true;
				eliteDungeonIcon.addEventListener(MouseEvent.CLICK, onEnterBattle);
				var bne:BaseNativeEntity = new BaseNativeEntity();
				(eliteDungeonIcon["RoleHead"] as Sprite).addChild(bne);
			}
			initBg();
		}
		
		private function onEnterBattle(e:MouseEvent) : void{
			//DebugArea.getIns().showResult("------onEnterBattle_1------:", DebugConst.NORMAL);
			var name:String = e.currentTarget.name;
			if(_eliteDungeonNumInfo[name.split("_")[1] - 1] < 5){
				//DebugArea.getIns().showResult("------onEnterBattle_2------:", DebugConst.NORMAL);
				var nowIndex:String = _nowElite + "_" + name.split("_")[1];
				LevelManager.getIns().mapType = 1;
				(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).goToBattle(_nowInfo[name.split("_")[1] - 1]);
				((ViewFactory.getIns().initView(MainToolBar) as MainToolBar) as MainToolBar).destroyGuide();
				this.hide();
			}else{
				var num:int = PackManager.getIns().searchItemNum(NumberConst.getIns().refreshCouponId);
				(ViewFactory.getIns().getView(NoticeView) as NoticeView).addNotice(
					"是否花费1张刷新券？\n当前拥有刷新券：" + num,
					function () : void{
						var cost:int = PackManager.getIns().searchItemNum(NumberConst.getIns().refreshCouponId);
						if(cost >= NumberConst.getIns().one){
							PackManager.getIns().reduceItem(NumberConst.getIns().refreshCouponId, NumberConst.getIns().one)
							//DebugArea.getIns().showResult("------onEnterBattle_2------:", DebugConst.NORMAL);
							var nowIndex:String = _nowElite + "_" + name.split("_")[1];
							LevelManager.getIns().mapType = 1;
							(ControlFactory.getIns().getControl(GoToBattleControl) as GoToBattleControl).goToBattle(_nowInfo[name.split("_")[1] - 1]);
							((ViewFactory.getIns().initView(MainToolBar) as MainToolBar) as MainToolBar).destroyGuide();
							hide();
						}else{
							(ViewFactory.getIns().getView(NoticeView) as NoticeView).addOnlySureNotice(
								"刷新券不足，无法刷新!");
						}
					}, null);
			}
		}
		
		private function onPre(e:MouseEvent) : void{
			_nowElite--;
			setEliteLevel();
		}
		
		private function onNext(e:MouseEvent) : void{
			_nowElite++;
			setEliteLevel();
		}
		
		public function setEliteLevel() : void{
			setInfoList();
			setIcon();
			setBtn();
			setMission();
			setDouble();
			setDailyMission();
			setPosition();
		}
		
		private function setGuideShow() : void{

			var index:String = (ConfigurationManager.getIns().getObjectByProperty(AssetsConst.MAIN_MISSION, "id", player.mainMissionVo.id) as MainMission).mission_rules_level;
			var arr:Array = index.split("_");
			if(arr.length == 3 && arr[0] == _nowElite){
				_guideMC.x = 115 + 106 * (arr[1] - 1);
				_guideMC.y = 120;
			}
			if(_hasMission){
				_guideMC.visible = true;
			}else{
				_guideMC.visible = false;
			}
		}
		
		override public function show():void{
			if(layer == null) return;
			openTween();
			update();
			super.show();
		}
		private function openTween():void{
			var pos:Point = ExtraBarManager.getIns().getBtnPos("Elite");
			ViewTweenEffect.openTween(layer, pos.x, pos.y, centerX, centerY);
		}
		
		private function closeTween():void{
			var pos:Point = ExtraBarManager.getIns().getBtnPos("Elite");
			ViewTweenEffect.closeTween(layer, pos.x, pos.y, hide);
		}
		
		private function onClose(e:MouseEvent) : void{
			closeTween();
		}
		
		private var _eliteDungeonPassInfo:Array;
		override public function setParams():void{
			if(layer == null) return;
			
			_eliteDungeonPassInfo = PlayerManager.getIns().getElitePassInfo();
			setInfoList();
			setIcon();
			setBtn();
			setMission();
			setDouble();
			setDailyMission();
			setPosition();
		}
		
		private function setPosition():void{
			var eliteDungeonIcon:MovieClip;
			var eliteDungeonTF:Sprite;
			if(_eliteDungeonInfo[3] == 0){
				for(var i:int = 0; i < 4; i++){
					eliteDungeonIcon = (layer["Level_" + (i + 1)] as MovieClip);
					eliteDungeonIcon.x = 88 + 105 * i;
					eliteDungeonTF = (layer["FightNum_" + (i + 1)] as Sprite);
					eliteDungeonTF.x = 85 + 105 * i;
					if(i == 3){
						eliteDungeonIcon.visible = false;
						eliteDungeonTF.visible = false;
					}else{
						eliteDungeonIcon.visible = true;
						eliteDungeonTF.visible = true;
					}
				}
			}else{
				for(var j:int = 0; j < 4; j++){
					eliteDungeonIcon = (layer["Level_" + (j + 1)] as MovieClip);
					eliteDungeonIcon.x = 40 + 100 * j;
					eliteDungeonIcon.visible = true;
					eliteDungeonTF = (layer["FightNum_" + (j + 1)] as Sprite);
					eliteDungeonTF.x = 37 + 100 * j;
					eliteDungeonTF.visible = true;
				}
			}
		}
		
		private var _hasMission:Boolean;
		private function setMission():void{
			var missionData:MainMission = ConfigurationManager.getIns().getObjectByProperty(AssetsConst.MAIN_MISSION, "id", player.mainMissionVo.id) as MainMission;
			var arr:Array = missionData.mission_rules_level.split("_");
			var index:String = arr[0] + "_" + arr[1];
			
			_hasMission = false;
			for(var i:int = 0; i < 4; i++){
				var eliteDungeonIcon:MovieClip = (layer["Level_" + (i + 1)] as MovieClip);
				if(eliteDungeonIcon.currentFrame == 1){
					if(arr.length == 3){
						if(_nowInfo[i].level_id == index && missionData.lv <= player.character.lv){
							eliteDungeonIcon["Mission"].visible = true;
							eliteDungeonIcon["Mission"].play();
							_hasMission = true;
						}else{
							eliteDungeonIcon["Mission"].visible = false;
							eliteDungeonIcon["Mission"].stop();
						}
					}else{
						eliteDungeonIcon["Mission"].visible = false;
						eliteDungeonIcon["Mission"].stop();
					}
				}
			}
			
			setGuideShow();
		}
		
		private function setDouble() : void{
			var eliteDungeonIcon:MovieClip;
			//var arr:Array = player.doubleDungeonVo.dungeonName.split("_");
			//var index:String = arr[0] + "_" + arr[1];
			for(var i:int = 0; i < 4; i++){
				eliteDungeonIcon = (layer["Level_" + (i + 1)] as MovieClip);
				if(eliteDungeonIcon.currentFrame == 1){
					if(DoubleDungeonManager.getIns().startDouble){
						//if(_nowInfo[i].level_id == index){
							eliteDungeonIcon["Double"].visible = true;
							eliteDungeonIcon["Double"].play();
						//}else{
						//	eliteDungeonIcon["Double"].visible = false;
						//	eliteDungeonIcon["Double"].stop();
						//}
					}else{
						eliteDungeonIcon["Double"].visible = false;
						eliteDungeonIcon["Double"].stop();
					}
				}
			}
		}
		
		private function setDailyMission():void{
			var eliteDungeonIcon:MovieClip;
			var arr:Array = player.dailyMissionVo.missionDungeon.split("_");
			var index:String = arr[0] + "_" + arr[1];
			for(var i:int = 0; i < 4; i++){
				eliteDungeonIcon = (layer["Level_" + (i + 1)] as MovieClip);
				if(eliteDungeonIcon.currentFrame == 1){
					if(arr.length == 3 
						&& DailyMissionManager.getIns().isDailyMissionStart
						&& !DailyMissionManager.getIns().isDailyMissionComplete){
						if(_nowInfo[i].level_id == index){
							eliteDungeonIcon["DailyMission"].visible = true;
							eliteDungeonIcon["DailyMission"].play();
							eliteDungeonIcon["Mission"].visible = false;
							eliteDungeonIcon["Mission"].stop();
						}else{
							eliteDungeonIcon["DailyMission"].visible = false;
							eliteDungeonIcon["DailyMission"].stop();
						}
					}else{
						eliteDungeonIcon["DailyMission"].visible = false;
						eliteDungeonIcon["DailyMission"].stop();
					}
				}
			}
		}
		
		private var _eliteDungeonInfo:Array;
		private var _eliteDungeonNumInfo:Array;
		
		/**
		 *设置精英副本按钮 
		 * 
		 */		
		private function setBtn():void{
			_eliteDungeonInfo = PlayerManager.getIns().getEliteDungeonInfo(_nowElite);
			_eliteDungeonNumInfo = PlayerManager.getIns().getEliteDungeonTimeInfo(_nowElite);
			
			for(var i:int = 0; i < _nowInfo.length; i++){
				var eliteDungeonIcon:MovieClip = (layer["Level_" + (i + 1)] as MovieClip);
				if(_eliteDungeonInfo[i] == 0){
					//添加未开启tips
					var tips:String = "通关"+_nowInfo[i].level_name.split("精英")[1]+"开启";
					TipsManager.getIns().addTips(eliteDungeonIcon,{title:tips, tips:""});
					
					eliteDungeonIcon.gotoAndStop(2);
					eliteDungeonIcon["LevelName"].text = "？？？";
					eliteDungeonIcon.removeEventListener(MouseEvent.CLICK, onEnterBattle);
					eliteDungeonIcon["RoleHead"].visible = false;
				}else{
					//添加开启tips
					TipsManager.getIns().addTips(eliteDungeonIcon,{title:ColorConst.setGold(_nowInfo[i].level_name), tips:_nowInfo[i].bonus});
					
					eliteDungeonIcon.gotoAndStop(1);
					eliteDungeonIcon["LevelName"].text = _nowInfo[i].level_name;
					eliteDungeonIcon["RoleHead"].visible = true;
					(eliteDungeonIcon["RoleHead"].getChildAt(0) as BaseNativeEntity).data.bitmapData 
						= AUtils.getNewObj(_nowInfo[i].fodder + "_LittleHead") as BitmapData;
					if(_eliteDungeonInfo[i] == -1){
						eliteDungeonIcon["Lv"].visible = false;
					}else{
						eliteDungeonIcon["Lv"].visible = true;
						eliteDungeonIcon["Lv"].gotoAndStop(6 - _eliteDungeonInfo[i]);
					}
					if(!eliteDungeonIcon.hasEventListener(MouseEvent.CLICK)){
						eliteDungeonIcon.addEventListener(MouseEvent.CLICK, onEnterBattle);
					}
				}
				
				if(_eliteDungeonNumInfo[i] == -1){
					(layer["FightNum_" + (i + 1)] as Sprite).visible = false;
				}else{
					(layer["FightNum_" + (i + 1)] as Sprite).visible = true;
					((layer["FightNum_" + (i + 1)] as Sprite)["FightCount"] as TextField).text = (5 - _eliteDungeonNumInfo[i]).toString();
				}
			}
		}
		
		private function setIcon():void{
			if(_preInfo != null && _preInfo.length > 0){
				PreLevel.text = _preInfo[0].scene_name;
				PreLevel.visible = true;
				PreBtn.mouseEnabled = true;
				GreyEffect.reset(PreBtn);
			}else{
				PreLevel.visible = false;
				PreBtn.mouseEnabled = false;
				GreyEffect.change(PreBtn);
			}
			
			if(_nextInfo != null && _nextInfo.length > 0){
				NextLevel.text = _nextInfo[0].scene_name;
				NextLevel.visible = true;
				NextBtn.mouseEnabled = true;
				GreyEffect.reset(NextBtn);
			}else{
				NextLevel.visible = false;
				NextBtn.mouseEnabled = false;
				GreyEffect.change(NextBtn);
			}
			
			NowLevel.text = _nowInfo[0].scene_name;
			
			if(_eliteDungeonPassInfo.length == _nowElite){
				NextBtn.mouseEnabled = false;
				NextLevel.visible = false;
				GreyEffect.change(NextBtn);
			}
		}
		
		private function setInfoList() : void{
			_nowInfo.length = 0;
			_preInfo.length = 0;
			_nextInfo.length = 0;
			for(var i:int = 0; i < _eliteInfo.length; i++){
				var info:Array = _eliteInfo[i].level_id.split("_");
				if(info[0] == _nowElite){
					_nowInfo.push(_eliteInfo[i]);
				}else if(info[0] == _nowElite + 1){
					_nextInfo.push(_eliteInfo[i]);
				}
				
				if(_nowElite > 1){
					if(info[0] == _nowElite - 1){
						_preInfo.push(_eliteInfo[i]);
					}
				}
			}
		}
		
		public function clear() : void{
			_nowElite = 1;
		}
		
		public function get nowElite() : int{
			return _nowElite;
		}
		public function set nowElite(value:int) : void{
			_nowElite = value;
		}
		
		private function get CloseBtn():SimpleButton{
			return layer["CloseBtn"];
		}
		
		private function get PreBtn():SimpleButton{
			return layer["PreBtn"];
		}
		
		private function get NextBtn():SimpleButton{
			return layer["NextBtn"];
		}  
		
		private function get NextLevel():TextField{
			return layer["NextLevel"];
		}
		private function get NowLevel():TextField{
			return layer["NowLevel"];
		}
		private function get PreLevel():TextField{
			return layer["PreLevel"];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy() : void{
			(layer["CloseBtn"] as SimpleButton).removeEventListener(MouseEvent.CLICK, onClose);
			(layer["PreBtn"] as SimpleButton).removeEventListener(MouseEvent.CLICK, onPre);
			(layer["NextBtn"] as SimpleButton).removeEventListener(MouseEvent.CLICK, onNext);
			for(var i:int = 1; i < 4; i++){
				(layer["Level_" + i] as MovieClip).removeEventListener(MouseEvent.CLICK, onEnterBattle);
			}
			super.destroy();
		}
	}
}