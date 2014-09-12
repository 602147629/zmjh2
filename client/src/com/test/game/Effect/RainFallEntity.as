package com.test.game.Effect
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.superkaka.mvc.Vo.SequenceVo;
	
	public class RainFallEntity extends BaseSequenceActionBind
	{
		public function RainFallEntity(sVo:SequenceVo)
		{
			super(sVo);
			
			this.funcWhenActionOver = doWhenActionOver;
		}
		
		override public function step():void{
			super.step();
			
		}
		
		public function doWhenActionOver(...args) : void{
			if(this.parent != null){
				this.parent.removeChild(this);
			}
			this.setAction(ActionState.WAIT);
			RenderEntityManager.getIns().removeEntity(this);
		}
	}
}