package com.test.game.Effect
{
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Entitys.Weather.ThunderEntity;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.SceneManager;
	
	import flash.display.BitmapData;

	public class ThunderEffect extends BaseEffect
	{
		private var _allBg:BaseNativeEntity;
		private var _blackBg:BaseNativeEntity;
		private var _lightBg:BaseNativeEntity;
		private var _emptyLightBg:BaseNativeEntity;
		private var _isStart:Boolean;
		private var _stepCount:int;
		private var _emptyStepCount:int;
		private var _emptyNum:int;
		private var _thunder:ThunderEntity;
		private var _thunderInterval:int;
		private function get player() : PlayerEntity{
			if(SceneManager.getIns().nowScene != null){
				return SceneManager.getIns().nowScene["myPlayer"];
			}else{
				return null;
			}
		}
		
		public function get isStart() : Boolean{
			return _isStart;
		}
		
		public function ThunderEffect(){
			super();
			init();
			AnimationManager.getIns().removeEntity(this);
		}
		
		private function init():void{
			_allBg = new BaseNativeEntity();
			_blackBg = new BaseNativeEntity();
			_blackBg.data.bitmapData = new BitmapData(GameConst.stage.stageWidth, GameConst.stage.stageHeight, true, 0x80000000);
			_allBg.addChild(_blackBg);
			_lightBg = new BaseNativeEntity();
			_lightBg.data.bitmapData = new BitmapData(GameConst.stage.stageWidth, GameConst.stage.stageHeight, true, 0xB6FFFFFF);
			_emptyLightBg = new BaseNativeEntity();
			_emptyLightBg.data.bitmapData = new BitmapData(GameConst.stage.stageWidth, GameConst.stage.stageHeight, true, 0xB6FFFFFF);
			_thunder = RoleManager.getIns().createThunder();
		}
		
		public function start() : void{
			_isStart = true;
			SceneManager.getIns().nowScene.parent.getChildIndex(SceneManager.getIns().nowScene);
			var index:int = SceneManager.getIns().nowScene.parent.getChildIndex(SceneManager.getIns().nowScene);
			LayerManager.getIns().gameLayer.addChildAt(_allBg, index);
			_allBg.alpha = 0;
			_stepCount = 0;
			_emptyNum = 0;
			_emptyStepCount = 0;
			_thunderInterval = 10 + Math.random() * 10;
		}
		
		public function stop() : void{
			_isStart = false;
			clear();
		}
		
		public function clear():void{
			if(_allBg != null && _allBg.parent != null){
				_allBg.parent.removeChild(_allBg);
			}
		}
		
		override public function step():void{
			if(_isStart){
				if(_allBg != null){
					if(_allBg.alpha < .9){
						_allBg.alpha += .1;
					}
					releaseThunder();
					releaseLight();
					releaseEmptyLight();
					_stepCount++;
					_emptyStepCount++;
				}
			}
		}
		
		private function releaseEmptyLight():void{
			if(_emptyStepCount == 0){
				_emptyNum = Math.random() * 9;
			}
			if(_emptyStepCount >= _emptyNum * 30 - 10 && _emptyStepCount < _emptyNum * 30 + 5){
				if(_emptyStepCount % 3 == 0){
					if(_emptyLightBg.parent == null){
						_allBg.addChild(_emptyLightBg);
					}
				}else{
					if(_emptyLightBg.parent != null){
						_emptyLightBg.parent.removeChild(_emptyLightBg);
					}
				}
			}else{
				if(_emptyLightBg.parent != null){
					_emptyLightBg.parent.removeChild(_emptyLightBg);
				}
			}
			if(_emptyStepCount > 300){
				_emptyStepCount = 0;
			}
		}
		
		private function releaseLight():void{
			if(_stepCount >= _thunderInterval * 30 - 10 && _stepCount < _thunderInterval * 30 + 5){
				if(_stepCount % 3 == 0){
					if(_lightBg.parent == null){
						_allBg.addChild(_lightBg);
					}
				}else{
					if(_lightBg.parent != null){
						_lightBg.parent.removeChild(_lightBg);
					}
				}
			}else{
				if(_lightBg.parent != null){
					_lightBg.parent.removeChild(_lightBg);
				}
			}
		}
		
		private function releaseThunder() : void{
			if(_stepCount == (_thunderInterval - 1) * 30){
				_thunder.releaseThunder();
			}else if(_stepCount == _thunderInterval * 30 - 5){
				_thunder.releaseThunderContinue();
			}else if(_stepCount >= (_thunderInterval + 1) * 30){
				_thunderInterval = 10 + Math.random() * 10;
				_stepCount = -1;
			}
		}
		
		override public function destroy() : void{
			if(_allBg != null){
				_allBg.destroy();
				_allBg = null;
			}
			if(_blackBg != null){
				_blackBg.destroy();
				_blackBg = null;
			}
			if(_lightBg != null){
				_lightBg.destroy();
				_lightBg = null;
			}
			if(_emptyLightBg != null){
				_emptyLightBg.destroy();
				_emptyLightBg = null;
			}
			if(_thunder != null){
				_thunder.destroy();
				_thunder = null;
			}
			super.destroy();
		}
	}
}