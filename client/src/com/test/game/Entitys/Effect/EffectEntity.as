package com.test.game.Entitys.Effect
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.Manager.Effect.EffectManager;
	import com.test.game.Mvc.Vo.EffectVo;
	
	import flash.geom.Point;
	import com.test.game.Entitys.CharacterEntity;
	
	public class EffectEntity extends SequenceActionEntity
	{
		private var _effectVo:EffectVo;
		private var _role:CharacterEntity;
		private var _actionstate:uint;
		public function EffectEntity(effectVo:EffectVo, role:CharacterEntity, actionstate:uint)
		{
			this._effectVo = effectVo;
			this._role = role;
			this._actionstate = actionstate;
			super();
			RenderEntityManager.getIns().addEntity(this);
		}
		
		override protected function initSequenceAction():void{
			if(!this._effectVo.assetsArray){
				throw new Error("技能素材不能为空！");
			}
			this.bodyAction = new BaseSequenceActionBind(this._effectVo);
			this.setAction(_actionstate);
			super.initSequenceAction();
		}
		
		override public function step() : void{
			pos = _role.bodyPos;
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			switch(this.curAction){
				case ActionState.HIT:
					break;
			}
		}
		
		override protected function doWhenActionOver(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.HIT:
				case ActionState.HIT1:
					EffectManager.getIns().destroyEffect(this);
					break;
			}
		}
		
		private var _thisPostion:Point = new Point();
		public function get shadowPos():Point{
			_thisPostion.x = this.x;
			_thisPostion.y = this.y;
			return _thisPostion;
		}
		
		override public function destroy():void{
			_effectVo = null;
			_role = null;
			super.destroy();
		}
	}
}