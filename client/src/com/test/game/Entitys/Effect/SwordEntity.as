package com.test.game.Entitys.Effect
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Const.ActionState;
	import com.superkaka.game.Const.DirectConst;
	import com.superkaka.game.Manager.Render.RenderEntityManager;
	import com.test.game.Entitys.CharacterEntity;
	import com.test.game.Manager.DigitalManager;
	import com.test.game.Mvc.Vo.EffectVo;
	
	import flash.geom.Point;
	
	public class SwordEntity extends SequenceActionEntity
	{
		private var _effectVo:EffectVo;
		private var _role:CharacterEntity;
		private var _actionstate:uint;
		private var _startFloat:int;
		public function SwordEntity(effectVo:EffectVo, role:CharacterEntity, actionstate:uint)
		{
			this._effectVo = effectVo;
			this._role = role;
			this._actionstate = actionstate;
			this._startFloat = DigitalManager.getIns().getRandom() * 10;
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
			
			if(role.faceHorizontalDirect == DirectConst.DIRECT_LEFT){
				this.x = role.bodyPos.x + 40;
			}else if(role.faceHorizontalDirect == DirectConst.DIRECT_RIGHT){
				this.x = role.bodyPos.x - 40;
			}
		}
		
		private var floatCount:int;
		override public function step() : void{
			if(_startFloat <= 0){
				if(floatCount < 20){
					this.bodyAction.y += 1;
					floatCount++;
				}else if(floatCount >= 20 && floatCount < 40){
					this.bodyAction.y -= 1;
					floatCount++;
				}else{
					floatCount = 0;
				}
			}else{
				_startFloat--;
			}
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
					this.setAction(ActionState.HIT, true);
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
		
		public function get role() : CharacterEntity{
			return _role;
		}
	}
}