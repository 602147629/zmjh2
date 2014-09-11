package com.test.game.Effect
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.test.game.Const.HurtHpConst;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.Effect.EffectManager;
	
	import flash.geom.Point;

	public class AnimationHurtEffect extends RenderEffect
	{
		private var digitalNum:Vector.<BaseSequenceActionBind>;
		private var digitalLayer:BaseNativeEntity;
		private var _hurtDigital:BaseSequenceActionBind;
		private var _offsetX:Number = 33;
		private var _lowOffsetX:Number = 15;
		public function AnimationHurtEffect(type:uint, count:int, pos:Point)
		{
			super();
			createHurt(type, count, pos);
		}
		
		private var _stepTime:int;
		override public function step():void{
			for(var i:int = 0; i < digitalNum.length; i++){
				if(_stepTime < 10){
					digitalNum[i].x = (digitalNum.length * .7 - (i + 1)) * _offsetX * digitalLayer.scaleXValue;
				}else if(_stepTime >= 10 && _stepTime < 16){
					digitalNum[i].x = (digitalNum.length * .7 - (i + 1)) * (_offsetX - _stepTime * 1) * digitalLayer.scaleXValue;
				}
			}
			if(_stepTime == 23){
				destroy();
			}
			_stepTime++;
		}
		
		private function createHurt(type:uint, count:int, pos:Point):void{
			var len:int = (count.toString()).length;
			digitalLayer = new BaseNativeEntity();
			digitalLayer.name = "HurtEffect";
			digitalNum = new Vector.<BaseSequenceActionBind>();
			var str:String;
			var fodder:String;
			for(var i:int = 0; i < len; i++){
				str = count.toString().substr(len - i - 1, 1);
				fodder = getHpType(type) + str;
				var hurtDigital:BaseSequenceActionBind = AnimationEffect.createAnimation(10024, [fodder], false, null);
				hurtDigital.y = 0;
				digitalNum.push(hurtDigital);
				digitalLayer.addChild(hurtDigital);
			}
			digitalLayer.x = pos.x;
			digitalLayer.y = pos.y - 72;
			if(SceneManager.getIns().nowScene != null){
				SceneManager.getIns().nowScene.addChild(digitalLayer);
			}
		}
		
		private function getHpType(type:uint) : String{
			var result:String = "";
			switch(type){
				case HurtHpConst.ATK_HP:
					result = "AnimationAtkHp";
					break;
				case HurtHpConst.ATS_HP:
					result = "AnimationAtsHp";
					break;
				case HurtHpConst.CHAOS_HP:
					result = "AnimationChaosHp";
					break;
				case HurtHpConst.REGAIN_HP:
					result = "AnimationRegainHp";
					break;
			}
			return result;
		}
		
		override public function destroy():void{
			for(var i:int = 0; i < digitalNum.length; i++){
				if(digitalNum[i] != null){
					digitalNum[i].destroy();
					digitalNum[i] = null
				}
			}
			digitalNum.length = 0;
			digitalNum = null;
			if(digitalLayer != null){
				digitalLayer.destroy();
				digitalLayer = null;
			}
			EffectManager.getIns().hurtCount--;
			super.destroy();
		}
	}
}