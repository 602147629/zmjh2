package com.test.game.Modules.MainGame
{
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.BaseLayer;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ControlFactory;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Base.BaseView;
	import com.test.game.Effect.LevelTimeEffect;
	import com.test.game.Manager.AutoFightManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Modules.MainGame.Tip.TipView;
	import com.test.game.Mvc.control.Escort.EscortControl;
	import com.test.game.Mvc.control.View.GameSceneControl;
	import com.test.game.Mvc.control.View.PassLevelControl;
	import com.test.game.Mvc.control.key.LeaveGameControl;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class LevelInfoView extends BaseView
	{
		public var levelTimeEffect:LevelTimeEffect;
		
		public function LevelInfoView(){
			super();
			start();
		}
		
		private function start(...args) : void{
			if(layer == null){
				layer = AssetsManager.getIns().getAssetObject("LevelInfoView") as Sprite;
				layer.x = 780;
				layer.y = 5;
				this.addChild(layer);
				
				initUI();
				initParams();
				setParams();
			}
			//LayerManager.getIns().gameTipLayer.addChildAt(this, 0);
		}
		
		private function initParams():void{
			
		}
		
		private function initUI():void{
			levelTimeEffect = new LevelTimeEffect();
			layer.addChild(levelTimeEffect.timeLayer);
			(layer["QuitBtn"] as SimpleButton).addEventListener(MouseEvent.CLICK, quitLevel);
			(layer["LevelName"] as TextField).text = LevelManager.getIns().levelData.level_name;
		}
		
		private function quitLevel(e:MouseEvent) : void{
			(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameStopRender();
			(ViewFactory.getIns().initView(TipView) as TipView).setFun("是否退出关卡？",
					confirmQuit, 
					function () : void{
						(ControlFactory.getIns().getControl(GameSceneControl) as GameSceneControl).gameStartRender();
					}
				);
		}
		
		private function confirmQuit() : void{
			switch(SceneManager.getIns().sceneType){
				case SceneManager.NORMAL_SCENE:
					AutoFightManager.getIns().startAutoFight = false;
					(ControlFactory.getIns().getControl(PassLevelControl) as PassLevelControl).continueAutoFight = false;
					(ControlFactory.getIns().getControl(LeaveGameControl) as LeaveGameControl).leaveLevel();
					break;
				case SceneManager.ESCORT_SCENE:
					AutoFightManager.getIns().startAutoFight = false;
					(ControlFactory.getIns().getControl(EscortControl) as EscortControl).leaveEscort();
					break;
				case SceneManager.LOOT_SCENE:
					AutoFightManager.getIns().startAutoFight = false;
					(ControlFactory.getIns().getControl(EscortControl) as EscortControl).leaveLoot();
					break;
			}
		}
		
		override public function setParams():void{
			if(layer == null) return;
			
			response();
			setWeather(0);
		}
		
		public function unResponse() : void{
			this.layer.mouseEnabled = false;
			this.layer.mouseChildren = false;
		}
		
		public function response() : void{
			this.layer.mouseEnabled = true;
			this.layer.mouseChildren = true;
		}
		
		public function showQuit() : void{
			layer["QuitBtn"].visible = true;
			layer["PauseTF"].visible = true;
		}
		
		public function hideQuit() : void{
			layer["QuitBtn"].visible = false;
			layer["PauseTF"].visible = false;
		}
		
		public function setWeather(index:int) : void{
			weatherStatus.gotoAndStop(index);
		}
		
		public function get weatherStatus() : MovieClip{
			return layer["WeatherStatus"];
		}
		
		override protected function getContainer():BaseLayer{
			return LayerManager.getIns().gameLayer;
		}
		
		override public function destroy() : void{
			if(layer != null){
				layer = null
			}
			super.destroy();
		}
	}
}