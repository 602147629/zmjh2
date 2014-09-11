package com.test.game.Effect
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.superkaka.game.Base.WorldEntity.BaseNativeEntity;
	import com.test.game.Manager.GameSettingManager;
	import com.test.game.Manager.RoleManager;
	import com.test.game.Manager.SceneManager;
	import com.test.game.Manager.Effect.EffectManager;
	
	import flash.geom.Point;

	public class HurtEffect extends RenderEffect
	{
		private var digitalNum:Vector.<BaseNativeEntity>;
		private var digitalLayer:BaseNativeEntity;
		private var _offsetX:Number = 30;
		private var _lowOffsetX:Number = 15;
		public function HurtEffect(type:uint, count:int, pos:Point){
			super();
			createHurt(type, count, pos);
		}
		
		private var _stepTime:int;
		override public function step():void{
			if(GameSettingManager.getIns().stageQuality > 2 && RoleManager.getIns().fightType == 0){
				for(var i:int = 0; i < digitalNum.length; i++){
					digitalNum[i].x = (digitalNum.length * .7 - (i + 1)) * _offsetX * digitalLayer.scaleXValue;
				}
				if(_stepTime > 8 && _stepTime <= 15){
					digitalLayer.scaleXValue -= .1;
					digitalLayer.scaleYValue -= .1;
				}
				else if(_stepTime > 15 && _stepTime < 31){
					digitalLayer.alpha -= .05;
					digitalLayer.y -= 4;
				}else if(_stepTime >= 31){
					this.destroy();
				}
			}else{
				if(_stepTime == 1){
					for(var j:int = 0; j < digitalNum.length; j++){
						digitalNum[j].x = (digitalNum.length * .7 - (j + 1)) * _lowOffsetX * digitalLayer.scaleXValue;
					}
				}
				if(_stepTime > 15 && _stepTime < 31){
//					digitalLayer.alpha -= .05;
					digitalLayer.y -= 4;
				}else if(_stepTime >= 31){
					this.destroy();
				}
			}
			_stepTime++;
		}
		
		private function createHurt(type:uint, count:int, pos:Point):void
		{
			_stepTime = 0;
			var len:int = (count.toString()).length;
			digitalLayer = new BaseNativeEntity();
			digitalLayer.name = "HurtEffect";
			digitalNum = new Vector.<BaseNativeEntity>();
			
			var str:String;
			for(var i:int = 0; i < len; i++){
				str = count.toString().substr(len - i - 1, 1)
				var digital:BaseNativeEntity = new BaseNativeEntity();
				digital.data.bitmapData = EffectManager.getIns().getHurtSource(type)[str];
				digital.y = 0;
				digitalNum.push(digital);
				digitalLayer.addChild(digital);
			}
			
			digitalLayer.x = pos.x;
			digitalLayer.y = pos.y - 72;
			if(GameSettingManager.getIns().stageQuality > 2 && RoleManager.getIns().fightType == 0){
				digitalLayer.scaleXValue = .1;
				digitalLayer.scaleYValue = .1;
				digitalLayer.registerPoint = new Point(digitalLayer.width * .5, digitalLayer.height * .5);
				TweenLite.to(digitalLayer, .26, {scaleXValue:1.1, scaleYValue:1.1, ease:Elastic.easeOut});
			}
			if(SceneManager.getIns().nowScene != null){
				SceneManager.getIns().nowScene.addChild(digitalLayer);
			}
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