package com.test.game.Entitys.Daily
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.BmdViewFactory;
	import com.test.game.Effect.DailyMissionFontEffect;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Manager.DailyMissionManager;
	import com.test.game.Manager.LevelManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.StageClickManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class ClickThingEntity extends Sprite{
		private var _thing:MovieClip;
		private var _guide:MovieClip;
		private var _target:PlayerEntity;
		public function ClickThingEntity(){
			super();
			
			init();
		}
		
		private function init():void{
			initThing();
			initGuide();
		}
		
		private function initFind():void{
			var fontFind:DailyMissionFontEffect = new DailyMissionFontEffect();
			fontFind.initFontEffect(this, "ClickFind");
		}
		
		private function initGuide():void{
			_guide = AUtils.getNewObj("ClickGuide") as MovieClip;
			_guide.x = 300;
			_guide.y = 50;
		}
		
		private function initThing():void{
			var index:int = LevelManager.getIns().nowIndex.split("_")[0];
			_thing = AUtils.getNewObj("DailyClickThing_" + index) as MovieClip;
			_thing.stop();
			StageClickManager.getIns().addClickThing(this, onClickThing);
			this.addChild(_thing);
			
			this.x = 1430 + 3100 * Math.random();
			this.y = 215 + Math.random() * 10 + (index - 1) * 40;
		}
		
		protected function onClickThing():void{
			StageClickManager.getIns().removeClickThing(this);
			onClickOut();
			_thing.gotoAndStop(2);
			DailyMissionManager.getIns().setDailyComplete();
			initFind();
		}
		
		protected function onClickOver() : void{
			if(_guide.parent == null){
				LayerManager.getIns().gameTipLayer.addChild(_guide);
			}
		}
		
		protected function onClickOut() : void{
			if(_guide.parent != null){
				_guide.parent.removeChild(_guide);
			}
		}
		
		public function step() : void{
			if(!DailyMissionManager.getIns().judgeDailyComplete){
				if(_target != null){
					if(Math.abs(_target.x - this.x) < 50){
						onClickOver();
					}else{
						onClickOut();
					}
				}else{
					seekTarget();
				}
			}
		}
		
		//获得目标角色
		public function seekTarget() : void{
			if(SceneManager.getIns().nowScene != null){
				_target = SceneManager.getIns().myPlayer;
			}
		}
		
		public function destroy() : void{
			_target = null;
			StageClickManager.getIns().removeClickThing(this);
			if(_thing != null){
				if(_thing.parent != null){
					_thing.parent.removeChild(_thing);
				}
				_thing = null;
			}
			if(_guide != null){
				if(_guide.parent != null){
					_guide.parent.removeChild(_guide);
				}
				_guide = null
			}
		}
		
	}
}