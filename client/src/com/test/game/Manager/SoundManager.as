package com.test.game.Manager
{
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Const.GameConst;
	import com.test.game.Const.AssetsConst;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class SoundManager extends Singleton{
		//背景音乐sound
		private var _bgSound:Sound;
		//背景音乐channel
		private var _bgSoundChannel:SoundChannel = new SoundChannel();
		//背景音乐开启控制
		private var _bgSoundControll:Boolean = true;
		//背景音乐音量控制
		private var _bgSoundVolume:Number = 1;
		//当前背景音乐类型
		private var _bgSoundType:String;
		//战斗音乐开启控制
		private var _fightSoundControll:Boolean = true;
		//战斗音乐音量控制
		private var _fightSoundVolume:Number = 1;
		//战斗音乐channel
		private var _fightSoundChannel:SoundChannel = new SoundChannel();
		//击打音乐channel
		private var _hitSoundChannel:SoundChannel = new SoundChannel();
		//天气音乐channel
		private var _weatherSoundChannel:SoundChannel = new SoundChannel();
		private var _weatherSound:Sound;
		private var _weatherType:String;
		private var _weatherSoundControll:Boolean = false;
		private var _nowCount:int;
		private var _stepCount:int = 0;
		public function SoundManager(){
			super();
		}
		
		public static function getIns():SoundManager{
			return Singleton.getIns(SoundManager);
		}
		
		private function closeBgSound() : void{
			if(_bgSoundChannel != null){
				_bgSoundChannel.removeEventListener(Event.SOUND_COMPLETE, onReplay);
				_bgSoundChannel.stop();
			}
		}
		
		public function bgSoundPlay(type:String) : void{
			if(!GameConst.localLogin){
				_bgSoundType = type;
				if(_bgSoundControll){
					if(_bgSoundChannel != null){
						if(_bgSoundChannel.hasEventListener(Event.SOUND_COMPLETE)){
							_bgSoundChannel.removeEventListener(Event.SOUND_COMPLETE, onReplay);
						}
						_bgSoundChannel.stop();
						_bgSound = null;
						_bgSound = AUtils.getNewObj(type.split("/")[1]) as Sound;
						if(_bgSound != null){
							_bgSoundChannel = _bgSound.play();
							if(_bgSoundChannel != null){
								_bgSoundChannel.soundTransform = setVolume(_bgSoundVolume); 
								_bgSoundChannel.addEventListener(Event.SOUND_COMPLETE, onReplay);
							}
						}
					}
				}
			}
		}
		
		private function onReplay(e:Event) : void{
			_bgSoundChannel.removeEventListener(Event.SOUND_COMPLETE, onReplay);
			_bgSoundChannel.stop();
			_bgSoundChannel = _bgSound.play(0);
			if(_bgSoundChannel != null){
				_bgSoundChannel.soundTransform = setVolume(_bgSoundVolume); 
				_bgSoundChannel.addEventListener(Event.SOUND_COMPLETE, onReplay);
			}
		}
		
		
		public function weatherSoundPlay(type:String = "") : void{
			if(!GameConst.localLogin){
				_weatherType = type;
				if(_weatherType == ""){
					if(_weatherSoundChannel.hasEventListener(Event.SOUND_COMPLETE)){
						_weatherSoundChannel.removeEventListener(Event.SOUND_COMPLETE, onWeatherReplay);
					}
					_weatherSoundChannel.stop();
					_weatherSound = null;
				}else{
					if(_fightSoundControll){
						if(_weatherSoundChannel != null){
							if(_weatherSoundChannel.hasEventListener(Event.SOUND_COMPLETE)){
								_weatherSoundChannel.removeEventListener(Event.SOUND_COMPLETE, onWeatherReplay);
							}
							_weatherSoundChannel.stop();
							_weatherSound = null;
							_weatherSound = AUtils.getNewObj(type.split("/")[1]) as Sound;
							if(_weatherSound != null){
								_weatherSoundChannel = _weatherSound.play();
								if(_weatherSoundChannel != null){
									_weatherSoundChannel.soundTransform = setVolume(_bgSoundVolume); 
									_weatherSoundChannel.addEventListener(Event.SOUND_COMPLETE, onWeatherReplay);
								}
							}
						}
					}
				}
			}
		}
		
		private function onWeatherReplay(e:Event) : void{
			_weatherSoundChannel.removeEventListener(Event.SOUND_COMPLETE, onWeatherReplay);
			_weatherSoundChannel.stop();
			_weatherSoundChannel = _weatherSound.play(0);
			if(_weatherSoundChannel != null){
				_weatherSoundChannel.soundTransform = setVolume(_bgSoundVolume); 
				_weatherSoundChannel.addEventListener(Event.SOUND_COMPLETE, onWeatherReplay);
			}
		}
		
		private function setVolume(volume:Number) : SoundTransform{
			var soundTrans:SoundTransform = new SoundTransform();
			soundTrans.volume = volume;
			return soundTrans;
		}
		
		public function fightSoundPlayer(type:String, repeat:int = 1) : void{
			if(!GameConst.localLogin){
				if(_fightSoundControll){
					var fightSound:Sound = AUtils.getNewObj(type) as Sound;
					if(fightSound != null){
						_fightSoundChannel = fightSound.play();
						if(_fightSoundChannel != null){
							_fightSoundChannel.soundTransform = setVolume(_fightSoundVolume);
						}
					}
				}
			}
		}
		
		public function hitSoundPlayer(type:String) : void{
			if(!GameConst.localLogin){
				if(_fightSoundControll){
					var fightSound:Sound = AUtils.getNewObj(type) as Sound;
					if(fightSound != null && (_stepCount - _nowCount) > 1){
						_nowCount = _stepCount;
						_hitSoundChannel = fightSound.play();
						if(_hitSoundChannel != null){
							_hitSoundChannel.soundTransform = setVolume(_fightSoundVolume);
						}
					}
				}
			}
		}
		
		public function step() : void{
			_stepCount++;
			if(_stepCount > 10000000){
				_stepCount = 0;
			}
		}
		
		public function clear() : void{
			_stepCount = 0;
			_nowCount = 0;
		}
		
		
		//背景音乐开启控制
		public function get bgSoundControll() : Boolean{
			return _bgSoundControll;
		}
		public function set bgSoundControll(value:Boolean) : void{
			_bgSoundControll = value;
			if(_bgSoundControll == true){
				bgSoundPlay(_bgSoundType);
			}else{
				closeBgSound();
			}
		}
		
		//背景音乐音量控制
		public function get bgSoundVolume() : Number{
			return _bgSoundVolume;
		}
		public function set bgSoundVolume(value:Number) : void{
			_bgSoundVolume = value;
			_bgSoundVolume = (_bgSoundVolume<0?0:_bgSoundVolume);
			_bgSoundVolume = (_bgSoundVolume>1?1:_bgSoundVolume);
			if(_bgSoundChannel != null){
				_bgSoundChannel.soundTransform = setVolume(_bgSoundVolume);
			}
		}
		
		//战斗音乐开启控制
		public function get fightSoundControll() : Boolean{
			return _fightSoundControll;
		}
		public function set fightSoundControll(value:Boolean) : void{
			_fightSoundControll = value;
		}
		//战斗音乐音量控制
		public function get fightSoundVolume() : Number{
			return _fightSoundVolume;
		}
		public function set fightSoundVolume(value:Number) : void{
			_fightSoundVolume = value;
			_fightSoundVolume = (_fightSoundVolume<0?0:_fightSoundVolume);
			_fightSoundVolume = (_fightSoundVolume>1?1:_fightSoundVolume);
			if(_weatherSoundChannel != null){
				_weatherSoundChannel.soundTransform = setVolume(_fightSoundVolume);
			}
		}
		
		public function soundName(level:String) : String{
			var index:int = level.split("_")[0];
			var sound:String = "";
			switch(index){
				case 1:
					sound = AssetsConst.MOZHULINFIGHTSOUND;
					break;
				case 2:
					sound = AssetsConst.TAIXUGUANFIGHTSOUND;
					break;
				case 3:
					sound = AssetsConst.WANEGUFIGHTSOUND;
					break;
				case 4:
					sound = AssetsConst.FENGBODUFIGHTSOUND;
					break;
			}
			return sound;
		}
	}
}