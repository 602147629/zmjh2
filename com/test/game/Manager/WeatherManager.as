package com.test.game.Manager
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Expo;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.mvc.ViewFactory;
	import com.test.game.Const.AssetsConst;
	import com.test.game.Const.NumberConst;
	import com.test.game.Const.WeatherConst;
	import com.test.game.Effect.BlackEffect;
	import com.test.game.Effect.RainEffect;
	import com.test.game.Effect.ThunderEffect;
	import com.test.game.Effect.WeatherShowEffect;
	import com.test.game.Effect.WindEffect;
	import com.test.game.Manager.HideMission.HideMissionManager;
	import com.test.game.Modules.MainGame.LevelInfoView;
	import com.test.game.Modules.MainGame.MainUI.MainToolBar;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class WeatherManager extends Singleton{
		private const RAINRATE:Number = .00625 / 3;
		private const BLACKRATE:Number = .0125 / 3;
		private const THUNDERRATE:Number = .01875 / 3;
		private const WINDRATE:Number = .025 / 3;
		private var _weatherShow:Sprite;
		private var _weatherMultiple:int = 1;
		private var _weatherStatus:int = WeatherConst.WEATHER_NONE;
		private var _weatherShowEffect:WeatherShowEffect;
		public function get weatherStatus() : int{
			return _weatherStatus;
		}
		public function set weatherStatus(value:int) : void{
			_weatherStatus = value;
			if(ViewFactory.getIns().getView(LevelInfoView) != null){
				(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).setWeather(_weatherStatus);
			}
			changeWeatherShow();
		}
		
		public function WeatherManager(){
			super();
		}
		
		public static function getIns():WeatherManager{
			return Singleton.getIns(WeatherManager);
		}
		
		private var _rainEffect:RainEffect;
		private var _blackEffect:BlackEffect;
		private var _thunderEffect:ThunderEffect;
		private var _windEffect:WindEffect;
		public function init() : void{
			_rainEffect = new RainEffect();
			_blackEffect = new BlackEffect();
			_thunderEffect = new ThunderEffect();
			_windEffect = new WindEffect();
			_weatherShow = AUtils.getNewObj("WeatherShow") as Sprite;
			_weatherShow.x = GameConst.stage.stageWidth * .5;
			_weatherShow.y = GameConst.stage.stageHeight * .5 - 100;
			_weatherShowEffect = new WeatherShowEffect();
		}
		
		private function changeWeatherShow():void{
			_weatherShow.alpha = 1;
			(_weatherShow["WeatherFont"] as MovieClip).gotoAndStop(_weatherStatus);
			_weatherShowEffect.start(_weatherShow);
			LayerManager.getIns().gameTipLayer.addChild(_weatherShow);
		}
		//雨天开始
		public function rainStart() : void{
			_rainEffect.start();
			weatherStatus = WeatherConst.WEATHER_RAIN;
			SoundManager.getIns().weatherSoundPlay(AssetsConst.WEATHERRAINSOUND);
			if(SceneManager.getIns().sceneType == SceneManager.NORMAL_SCENE){
				SceneManager.getIns().nowScene["rainSlowDonwSpeed"]();
			}
			_randomTime = 20 + Math.random() * 20;
		}
		//雨天结束
		public function rainStop() : void{
			_rainEffect.stop();
			weatherStatus = WeatherConst.WEATHER_NONE;
			SoundManager.getIns().weatherSoundPlay();
			if(SceneManager.getIns().sceneType == SceneManager.NORMAL_SCENE){
				SceneManager.getIns().nowScene["rainResetSpeed"]();
			}
		}
		//黑夜开始
		public function blackStart() : void{
			_blackEffect.start();
			weatherStatus = WeatherConst.WEATHER_BLACK;
			SoundManager.getIns().weatherSoundPlay(AssetsConst.WEATHERBLACKSOUND);
			_randomTime = 20 + Math.random() * 20;
		}
		//黑夜结束
		public function blackStop() : void{
			_blackEffect.stop();
			weatherStatus = WeatherConst.WEATHER_NONE;
			SoundManager.getIns().weatherSoundPlay();
		}
		//雷雨开始
		public function thunderStart() : void{
			_thunderEffect.start();
			weatherStatus = WeatherConst.WEATHER_THUNDER;
			SoundManager.getIns().weatherSoundPlay(AssetsConst.WEATHERTHUNDERSOUND);
			_randomTime = 20 + Math.random() * 20;
		}
		//雷雨结束
		public function thunderStop() : void{
			_thunderEffect.stop();
			weatherStatus = WeatherConst.WEATHER_NONE;
			SoundManager.getIns().weatherSoundPlay();
		}
		//大风开始
		public function windStart() : void{
			_windEffect.start();
			weatherStatus = WeatherConst.WEATHER_WIND;
			SoundManager.getIns().weatherSoundPlay(AssetsConst.WEATHERWINDSOUND);
			_randomTime = 20 + Math.random() * 20;
		}
		//大风结束
		public function windStop() : void{
			_windEffect.stop();
			weatherStatus = WeatherConst.WEATHER_NONE;
			SoundManager.getIns().weatherSoundPlay();
		}
		
		private var _stepTime:int;
		private var _stepStart:int;
		private var _randomTime:int;
		public function step() : void{
			//if(GameConst.localData) return;
			if(!_rainEffect.isStart && !_blackEffect.isStart && !_thunderEffect.isStart && !_windEffect.isStart){
				_stepTime++;
				if(_stepTime == 30){
					_stepTime = 0;
					var random:Number = Math.random();
					if(HideMissionManager.getIns().returnHasHideMission){
						_weatherMultiple = 2;
					}else{
						_weatherMultiple = 1;
					}
					if(random < RAINRATE * _weatherMultiple){
						rainStart();
					}else if(random < BLACKRATE * _weatherMultiple){
						blackStart();
					}else if(random < THUNDERRATE * _weatherMultiple){
						thunderStart();
					}else if(random < WINDRATE * _weatherMultiple){
						windStart();
					}
				}
			}else{
				_stepStart++;
				
				if(_stepStart >= 30 * _randomTime){
					if(_rainEffect.isStart){
						rainStop();
					}
					else if(_blackEffect.isStart){
						blackStop();
					}
					else if(_thunderEffect.isStart){
						thunderStop();
					}
					else if(_windEffect.isStart){
						windStop();
					}
					_stepStart = 0;
				}
			}
			if(_thunderEffect.isStart){
				_thunderEffect.step();
			}
			_windEffect.step();
		}
		
		public function showWeatherEffect(pos:Point) : void{
			switch(weatherStatus){
				case WeatherConst.WEATHER_RAIN:
				case WeatherConst.WEATHER_THUNDER:
					if(SceneManager.getIns().nowScene != null){
						if(GameSettingManager.getIns().openEffect == GameSettingManager.SHOW_EFFECT){
							var bneMoney:BaseNativeEntity = new BaseNativeEntity();
							bneMoney.data.bitmapData = AUtils.getNewObj("WeatherMoney") as BitmapData;
							bneMoney.pos = new Point(pos.x + SceneManager.getIns().nowScene.x, pos.y);
							bneMoney.alpha = .7;
							LayerManager.getIns().gameInfoLayer.addChild(bneMoney);
							TweenLite.to(bneMoney, 1, {x:55, y:55, onComplete:bneDestroy, ease:Expo.easeOut, onCompleteParams:[bneMoney]});
						}
						PlayerManager.getIns().addMoney(NumberConst.getIns().one);
					}
					break;
				case WeatherConst.WEATHER_BLACK:
				case WeatherConst.WEATHER_WIND:
					if(SceneManager.getIns().nowScene != null){
						if(GameSettingManager.getIns().openEffect == GameSettingManager.SHOW_EFFECT){
							var bneSoul:BaseNativeEntity = new BaseNativeEntity();
							bneSoul.data.bitmapData = AUtils.getNewObj("WeatherSoul") as BitmapData;
							bneSoul.pos = new Point(pos.x + SceneManager.getIns().nowScene.x, pos.y);
							bneSoul.alpha = .7;
							LayerManager.getIns().gameInfoLayer.addChild(bneSoul);
							TweenLite.to(bneSoul, 1, {x:55, y:55, onComplete:bneDestroy, ease:Expo.easeOut, onCompleteParams:[bneSoul]});
						}
						PlayerManager.getIns().addSoul(NumberConst.getIns().one);
					}
					break;
			}
		}
		
		private function bneDestroy(bne:BaseNativeEntity) : void{
			bne.destroy();
			bne = null;
		}
		
		
		public function clear() : void{
			if(_rainEffect != null){
				_rainEffect.clear();
			}
			if(_blackEffect != null){
				_blackEffect.clear();
			}
			if(_thunderEffect != null){
				_thunderEffect.clear();
			}
			if(_windEffect != null){
				_windEffect.clear();
			}
			if(_weatherShowEffect != null){
				_weatherShowEffect.clear();
			}
			if(_weatherShow != null){
				if(_weatherShow.parent != null){
					_weatherShow.parent.removeChild(_weatherShow);
				}
				_weatherShow = null;
			}
			SoundManager.getIns().weatherSoundPlay();
			_weatherStatus = 0;
			_stepStart = 0;
		}
		
		public function destroy() : void{
			SoundManager.getIns().weatherSoundPlay();
			_weatherStatus = 0;
			_stepStart = 0;
			if(ViewFactory.getIns().getView(MainToolBar) != null){
				ViewFactory.getIns().getView(MainToolBar).update();
			}
			if(_rainEffect != null){
				_rainEffect.destroy();
				_rainEffect = null;
			}
			if(_blackEffect != null){
				_blackEffect.destroy();
				_blackEffect = null;
			}
			if(_thunderEffect != null){
				_thunderEffect.destroy();
				_thunderEffect = null;
			}
			if(_windEffect != null){
				_windEffect.destroy();
				_windEffect = null;
			}
			if(_weatherShowEffect != null){
				_weatherShowEffect.clear();
				_weatherShowEffect = null;
			}
		}
	}
}