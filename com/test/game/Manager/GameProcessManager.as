package com.test.game.Manager
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.superkaka.Tools.AUtils;
	import com.superkaka.Tools.Singleton;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.GameConst;
	import com.superkaka.game.Loader.AssetsManager;
	import com.superkaka.game.Manager.Layers.LayerManager;
	import com.superkaka.game.ResourceOperation.BitmapDataPool;
	import com.superkaka.mvc.ViewFactory;
	import com.superkaka.mvc.Vo.SequenceVo;
	import com.test.game.Const.LimitConst;
	import com.test.game.Effect.GoEffect;
	import com.test.game.Entitys.PlayerEntity;
	import com.test.game.Modules.MainGame.LevelInfoView;
	import com.test.game.Modules.MainGame.MainUI.RoleStateView;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class GameProcessManager extends Singleton
	{
		private var _digitalLayer:BaseNativeEntity;
		private var _comboLayer:Sprite;
		private var _digitalNum:Vector.<BaseSequenceActionBind>;
		private var _goEffect:GoEffect;
		private var _countDownDigital:BaseNativeEntity;
		private var _assessLayer:MovieClip;
		private var _assessEffect:MovieClip;
		private var _assessType:int;
		private var _hpEffectList:Array = new Array();
		private var _mpEffectList:Array = new Array();
		private var _allEffectList:Array = new Array();
		
		public function GameProcessManager(){
			super();
		}
		
		public static function getIns():GameProcessManager{
			return Singleton.getIns(GameProcessManager);
		}
		
		public function init() : void{
			comboShow();
			countDownShow();
			assessShow();
		}
		
		private function assessShow():void{
			_assessLayer = AUtils.getNewObj("AssessLayer") as MovieClip;
			_assessLayer.scaleX = 1.2;
			_assessLayer.scaleY = 1.2;
			_assessLayer.stop();
			_assessLayer.x = 675;
			_assessLayer.y = 145;
			
			_assessEffect = AUtils.getNewObj("AssessEffect") as MovieClip;
			_assessEffect.stop();
			_assessEffect.x = 770;
			_assessEffect.y = 190;
		}
		
		public function step() : void{
			if(SceneManager.getIns().nowScene["playerAliveStatus"]){
				if(_digitalLayer.scaleX > 1){
					_digitalLayer.scaleX -= .2;
					_digitalLayer.scaleY -= .2;
				}else{
					_digitalLayer.scaleX = 1;
					_digitalLayer.scaleY = 1;
				}
				
				hpAndMpStep();
			}else{
				if(_digitalLayer.parent != null){
					_digitalLayer.parent.removeChild(_digitalLayer);
				}
				if(_assessLayer.parent != null){
					_assessLayer.parent.removeChild(_assessLayer);
				}
				if(_assessEffect.parent != null){
					_assessEffect.parent.removeChild(_assessEffect);
				}
				if(_comboLayer.parent != null){
					_comboLayer.parent.removeChild(_comboLayer);
				}
			}
		}
		
		//连击
		private function comboShow() : void{
			var obj:Object = AssetsManager.getIns().getAssetObject("ComboLayer");
			_comboLayer = obj as Sprite;
			_comboLayer.x = 680;
			_comboLayer.y = 160;
			
			var comboMask:Sprite = new Sprite();
			comboMask.graphics.beginFill(0xFF0000);
			comboMask.graphics.drawRect(0, 0, 157, 10);
			comboMask.graphics.endFill();
			comboMask.x = 20;
			comboMask.y = 34;
			_comboLayer.addChild(comboMask);
			_comboLayer["ComboBar"].mask = comboMask;
			
			_digitalLayer = new BaseNativeEntity();
			_digitalLayer.y = 190;
			
			BitmapDataPool.registerData("ComboDigital", false);
			
			var vo:SequenceVo = new SequenceVo();
			vo.sequenceId = 10001;
			vo.assetsArray = ["ComboDigital"];
			vo.isDouble = false;
			_digitalNum = new Vector.<BaseSequenceActionBind>();
			for(var i:int = 0; i < 6; i++){
				var digital:BaseSequenceActionBind = new BaseSequenceActionBind(vo);
				digital.setAction(ActionState.DIGITAL0);
				_digitalNum.push(digital);
			}
		}
		
		public function setBarMask(rate:Number) : void{
			if(rate == 0 || _comboLayer == null) return;
			_comboLayer["ComboBar"].mask.width = 157 * rate;
		}
		
		//增加连击评价的奖励
		public function addComboAssess(combo:int) : void{
			if(SceneManager.getIns().nowScene != null){
				if(SceneManager.getIns().nowScene["playerAliveStatus"]){
					if(combo >= 10){
						if(combo >= 10 && combo < 50){
							SceneManager.getIns().nowScene["playerAddHpAndMp"](1);
							addHpAndMpEffect(1);
							_assessLayer.gotoAndStop(1);
						}else if(combo >= 50 && combo < 100){
							SceneManager.getIns().nowScene["playerAddHpAndMp"](6);
							addHpAndMpEffect(6);
							_assessLayer.gotoAndStop(2);
						}else if(combo >= 100 && combo < 300){
							SceneManager.getIns().nowScene["playerAddHpAndMp"](14);
							addHpAndMpEffect(14);
							_assessLayer.gotoAndStop(3);
						}else if(combo >= 300 && combo < 500){
							SceneManager.getIns().nowScene["playerAddHpAndMp"](45);
							addHpAndMpEffect(45);
							_assessLayer.gotoAndStop(4);
						}else if(combo >= 500 && combo < LimitConst.MAX_COMBO){
							SceneManager.getIns().nowScene["playerAddHpAndMp"](80);
							addHpAndMpEffect(50);
							_assessLayer.gotoAndStop(5);
						}else if(combo == LimitConst.MAX_COMBO){
							SceneManager.getIns().nowScene["playerAddHpAndMp"](100);
							addHpAndMpEffect(50);
							_assessLayer.gotoAndStop(6);
						}
						LayerManager.getIns().gameTipLayer.addChild(_assessLayer);
						LayerManager.getIns().gameTipLayer.addChild(_assessEffect);
						_assessEffect.gotoAndPlay(1);
						TweenLite.delayedCall(.3, removeFromParent, [_assessEffect]);
						TweenLite.delayedCall(2, removeFromParent, [_assessLayer]);
					}
				}
			}
		}
		
		private function removeFromParent(obj:DisplayObject) : void{
			if(obj != null && obj.parent != null){
				obj.parent.removeChild(obj);
			}
		}
		
		private function hpAndMpStep() : void{
			var speed:Number;
			if(_hpEffectList.length > 0){
				speed = Math.random() * 1.5 + 1;
				var hp:BaseNativeEntity = _hpEffectList.shift();
				LayerManager.getIns().gameTipLayer.addChild(hp);
				var xPos:int = -Math.random() * 25 + 700;
				TweenMax.to(hp, speed, {bezierThrough:[{x:xPos, y:-5.5 * xPos + 3940}, {x:65, y:65}], orientToBezier:true, 
					onComplete:destroyEffect, ease:Expo.easeInOut, onCompleteParams:[hp]});
				_allEffectList.push(hp);
			}
			if(_mpEffectList.length > 0){
				speed = Math.random() * 1.5 + 1;
				var mp:BaseNativeEntity = _mpEffectList.shift();
				LayerManager.getIns().gameTipLayer.addChild(mp);
				var xPos1:int = -Math.random() * 25 + 700;
				TweenMax.to(mp, speed, {bezierThrough:[{x:xPos1, y:-5.5 * xPos1 + 3940}, {x:65, y:65}], orientToBezier:true, 
					onComplete:destroyEffect, ease:Expo.easeInOut, onCompleteParams:[mp]});
				_allEffectList.push(mp);
			}
		}
		
		private function addHpAndMpEffect(count:int) : void{
			var bmpHpData:BitmapData = AUtils.getNewObj("AddHp") as BitmapData;
			var bmpMpData:BitmapData = AUtils.getNewObj("AddMp") as BitmapData;
			for(var i:int = 0; i < count; i++){
				var bneHp:BaseNativeEntity = new BaseNativeEntity();
				bneHp.data.bitmapData = bmpHpData;
				bneHp.x = 740 + Math.random() * 70;
				bneHp.y = 160 + Math.random() * 50;
				_hpEffectList.push(bneHp);
				
				var bneMp:BaseNativeEntity = new BaseNativeEntity();
				bneMp.data.bitmapData = bmpMpData;
				bneMp.x = 740 + Math.random() * 70;
				bneMp.y = 160 + Math.random() * 50;
				_mpEffectList.push(bneMp);
			}
			if(count >= 50){
				_assessType = 2;
			}else{
				_assessType = 1;
			}
		}
		
		private function destroyEffect(bne:BaseNativeEntity) : void{
			var index:int = _allEffectList.indexOf(bne);
			if(index != -1){
				_allEffectList.splice(index, 1);
			}
			bne.destroy();
			bne = null;
		}
		
		//显示连击数
		public function showDigital(comboCount:int):void{
			if(comboCount <= 0){
				for each(var item:BaseSequenceActionBind in _digitalNum){
					if(item.parent != null){
						item.parent.removeChild(item);
					}
					if(_digitalLayer.parent != null){
						_digitalLayer.parent.removeChild(_digitalLayer);
					}
					if(_comboLayer.parent != null){
						_comboLayer.parent.removeChild(_comboLayer);
					}
				}
			}else{
				var len:int = (comboCount.toString()).length;
				var str:String;
				for(var i:int = 0; i < _digitalNum.length; i++){
					if(i < len){
						str = comboCount.toString().substr(i, 1);
						_digitalNum[i].x = i * 30;
						_digitalNum[i].y = -50;
						_digitalNum[i].setAction(ActionState["DIGITAL" + str]);
						_digitalLayer.addChild(_digitalNum[i]);
					}
				}
				if(comboCount >= 1){
					_digitalLayer.scaleX = 2;
					_digitalLayer.scaleY = 2;
					_digitalLayer.x = 795 - len * 28;
					LayerManager.getIns().gameTipLayer.addChildAt(_digitalLayer, 0);
					LayerManager.getIns().gameTipLayer.addChildAt(_comboLayer, 0);
				}
			}
		}
		
		//倒计时
		private function countDownShow():void{
			_goEffect = new GoEffect("StartGo");
			_countDownDigital = new BaseNativeEntity();
			_countDownDigital.x = GameConst.stage.stageWidth * .5;
			_countDownDigital.y = GameConst.stage.stageHeight * .5 - 50;
			LayerManager.getIns().gameInfoLayer.addChild(_countDownDigital);
			levelInfoEnAble();
			roleDetailEnAble();
			threeDigital();
		}
		
		private function levelInfoEnAble() : void{
			if(ViewFactory.getIns().getView(LevelInfoView) != null 
				&& ViewFactory.getIns().getView(LevelInfoView).layer != null){
				ViewFactory.getIns().getView(LevelInfoView).layer.mouseChildren = false;
			}
		}
		private function roleDetailEnAble() : void{
			if(ViewFactory.getIns().getView(RoleStateView) != null 
				&& ViewFactory.getIns().getView(RoleStateView).layer != null){
				ViewFactory.getIns().getView(RoleStateView).layer.mouseChildren = false;
			}
		}
		
		private function threeDigital() : void{
			_countDownDigital.data.bitmapData = AUtils.getNewObj("ThreeDigital") as BitmapData;
			scaleChange(_countDownDigital);
			SoundManager.getIns().fightSoundPlayer("ColdDownSound");
			twoDigital();
		}
		
		private function scaleChange(bne:BaseNativeEntity) : void{
			bne.data.x = -bne.data.width * .5;
			bne.data.y = -bne.data.height * .5;
			bne.scaleX = 2;
			bne.scaleY = 2;
			TweenLite.to(bne, .5, {scaleX:1, scaleY:1, ease:Elastic.easeOut});
		}
		
		private function twoDigital() : void{
			levelInfoEnAble();
			roleDetailEnAble();
			TweenLite.delayedCall(1,
				function () : void{
					_countDownDigital.data.bitmapData = AUtils.getNewObj("TwoDigital") as BitmapData;
					scaleChange(_countDownDigital);
					SoundManager.getIns().fightSoundPlayer("ColdDownSound");
					oneDigital();
				});
		}
		
		private function oneDigital() : void{
			levelInfoEnAble();
			roleDetailEnAble();
			TweenLite.delayedCall(1,
				function () : void{
					_countDownDigital.data.bitmapData = AUtils.getNewObj("OneDigital") as BitmapData;
					scaleChange(_countDownDigital);
					SoundManager.getIns().fightSoundPlayer("ColdDownSound");
					goStart();
				});
		}
		
		private function goStart() : void{
			levelInfoEnAble();
			roleDetailEnAble();
			TweenLite.delayedCall(1,
				function () : void{
					countDownOver();
					SoundManager.getIns().fightSoundPlayer("GameGoSound");
				});
		}
		
		private function countDownOver() : void{
			if(_countDownDigital != null){
				_countDownDigital.destroy();
				_countDownDigital = null;
			}
			var players:Vector.<PlayerEntity> = SceneManager.getIns().nowScene["players"];//(BmdViewFactory.getIns().getView(GameSenceView) as GameSenceView).players;
			for each(var player:PlayerEntity in players){
				if(player != null){
					player.isLock = false;
				}
			}
			if(ViewFactory.getIns().getView(LevelInfoView) != null){
				ViewFactory.getIns().getView(LevelInfoView).layer.mouseChildren = true;
				(ViewFactory.getIns().getView(LevelInfoView) as LevelInfoView).levelTimeEffect.start();
			}
			if(ViewFactory.getIns().getView(RoleStateView) != null){
				ViewFactory.getIns().getView(RoleStateView).layer.mouseChildren = true;
			}
			
			if(SceneManager.getIns().hasMonsterScene){
				SceneManager.getIns().nowScene["gameStart"]();
			}
		}
		
		public function showGo() : void{
			if(_countDownDigital == null){
				_goEffect.start();
			}
		}
		public function hideGo() : void{
			_goEffect.stop();
		}
		
		private var pkCallback:Function;
		public function pkColdDown(callback:Function) : void{
			pkCallback = callback;
			_countDownDigital = new BaseNativeEntity();
			_countDownDigital.x = GameConst.stage.stageWidth * .5;
			_countDownDigital.y = GameConst.stage.stageHeight * .5 - 50;
			LayerManager.getIns().gameTipLayer.addChild(_countDownDigital);
			pkThree();
		}
		
		private function pkThree() : void{
			_countDownDigital.data.bitmapData = AUtils.getNewObj("ThreeDigital") as BitmapData;
			scaleChange(_countDownDigital);
			SoundManager.getIns().fightSoundPlayer("ColdDownSound");
			pkTwo();
		}
		
		private function pkTwo() : void{
			TweenLite.delayedCall(1,
				function () : void{
					_countDownDigital.data.bitmapData = AUtils.getNewObj("TwoDigital") as BitmapData;
					scaleChange(_countDownDigital);
					SoundManager.getIns().fightSoundPlayer("ColdDownSound");
					pkOne();
				});
		}
		
		private function pkOne() : void{
			TweenLite.delayedCall(1,
				function () : void{
					_countDownDigital.data.bitmapData = AUtils.getNewObj("OneDigital") as BitmapData;
					scaleChange(_countDownDigital);
					SoundManager.getIns().fightSoundPlayer("ColdDownSound");
					pkZero();
				});
		}
		
		private function pkZero():void{
			TweenLite.delayedCall(1,
				function () : void{
					if(_countDownDigital != null){
						_countDownDigital.destroy();
						_countDownDigital = null;
					}
					if(pkCallback != null){
						pkCallback();
					}
				});
		}
		
		public function clearAssess() : void{
			for(var j:int = 0; j < _allEffectList.length; j++){
				if(_allEffectList[j] != null){
					TweenMax.killTweensOf(_allEffectList[j], true);
				}
			}
			_allEffectList.length = 0;
			
			for(var k:int = 0; k < _hpEffectList.length; k++){
				_hpEffectList[k].destroy();
				_hpEffectList[k] = null;
			}
			_hpEffectList.length = 0;
			
			for(var l:int = 0; l < _hpEffectList.length; l++){
				_mpEffectList[l].destroy();
				_mpEffectList[l] = null;
			}
			_mpEffectList.length = 0;
			
			TweenLite.killDelayedCallsTo(removeFromParent);
			removeFromParent(_comboLayer);
			removeFromParent(_assessEffect);
			removeFromParent(_assessLayer);
		}
		
		public function clear() : void{
			if(_countDownDigital != null){
				_countDownDigital.destroy();
				_countDownDigital = null;
			}
			if(_goEffect != null){
				_goEffect.destroy();
				_goEffect = null;
			}
			for(var i:int = 0; i < _digitalNum.length; i++){
				if(_digitalNum[i] != null){
					_digitalNum[i].destroy();
					_digitalNum[i] = null;
				}
			}
			_digitalNum.length = 0;
			_digitalNum = null;
			if(_digitalLayer != null){
				_digitalLayer.destroy();
				_digitalLayer = null;
			}
			
			clearAssess();
			_comboLayer = null;
			_assessEffect = null;
			_assessLayer = null;
			
			BitmapDataPool.removeData("ComboDigital");
		}
	}
}