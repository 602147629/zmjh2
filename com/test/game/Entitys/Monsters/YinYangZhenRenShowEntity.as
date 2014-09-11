package com.test.game.Entitys.Monsters
{
	import com.superkaka.game.Base.WorldEntity.CollisionFilterIndexConst;
	import com.superkaka.game.Const.ActionState;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	public class YinYangZhenRenShowEntity extends SkillShowEntity
	{
		public function YinYangZhenRenShowEntity(charVo:CharacterVo){
			super(charVo);
			this.collisionIndex = CollisionFilterIndexConst.MONSTER_SPECIAL;
			this.collisionListeners = [CollisionFilterIndexConst.ALL];
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			switch(this.curAction){
				case ActionState.SHOW:
					break;
			}
		}
		
		override protected function doWhenActionOver(...args) : void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.SHOW:
					this.setAction(ActionState.WALK);
					break;
				default:
					if(this.curAction == ActionState.NONE)
						this.setAction(ActionState.WAIT);
					this.setAction(this.curAction, true);
					break;
			}
		}
	}
}