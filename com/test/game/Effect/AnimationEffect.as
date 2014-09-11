package com.test.game.Effect
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.ResourceOperation.BitmapDataPool;
	import com.superkaka.mvc.Vo.SequenceVo;

	public class AnimationEffect
	{
		public function AnimationEffect(){
			super();
		}
		
		public static function createAnimation(sequenceId:uint, assetsArray:Array, isDouble:Boolean, callback:Function = null) : BaseSequenceActionBind{
			for each(var str:String in assetsArray){
				BitmapDataPool.registerData(str, isDouble);
			}
			var vo:SequenceVo = new SequenceVo();
			vo.sequenceId = sequenceId;
			vo.assetsArray = assetsArray;
			vo.isDouble = isDouble;
			
			var animation:BaseSequenceActionBind = new BaseSequenceActionBind(vo);
			animation.setAction(ActionState.SHOW);
			if(callback == null){
				animation.funcWhenActionOver = function () : void{animation.setAction(ActionState.SHOW);}
			}else{
				animation.funcWhenActionOver = callback;
			}
			return animation;
		}
		
		public static function createRainAnimation(sequenceId:uint, assetsArray:Array, isDouble:Boolean) : RainFallEntity{
			for each(var str:String in assetsArray){
				BitmapDataPool.registerData(str, isDouble);
			}
			var vo:SequenceVo = new SequenceVo();
			vo.sequenceId = sequenceId;
			vo.assetsArray = assetsArray;
			vo.isDouble = isDouble;
			
			var animation:RainFallEntity = new RainFallEntity(vo);
			animation.setAction(ActionState.SHOW);
			return animation;
		}
	}
}