package com.test.game.Entitys.Show
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.superkaka.game.Const.ActionState;
	import com.test.game.Manager.AnimationManager;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	public class ShowRoleEntity extends SequenceActionEntity
	{
		protected var charVo:CharacterVo;//数据
		public var initBodyContainerY:Number;//初始化后body的y坐标
		private var _standCount:int;//待机
		private var _kuangWuStandCount:int = 0;
		public function ShowRoleEntity(charVo:CharacterVo){
			this.charVo = charVo;
			super();
		}
		
		override protected function initSequenceAction():void{
			this.bodyAction = new BaseSequenceActionBind(this.charVo);
			this.bodyAction.setAction(ActionState.WAIT);
			
			super.initSequenceAction();
		}
		
		override protected function initCallBack():void{
			super.initCallBack();
		}
		
		override public function setAction(actionState:uint,resetWhenSameAction:Boolean = false):void{
			super.setAction(actionState,resetWhenSameAction);
		}
		
		override protected function doWhenEnterFrame(...args):void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.STAND:
					if(charVo.id == 1){
						if(curRenderIndex == 9){
							if(_kuangWuStandCount < 3){
								this.setAction(ActionState.STAND, true);
							}
							_kuangWuStandCount++;
						}
					}
					break;
			}
		}
		
		override protected function doWhenActionOver(...args) : void{
			var label:String = args[0];
			var curRenderIndex:int = args[1];
			var keyFrame:int = args[2];
			var curRepeatIndex:int = args[3];
			
			switch(this.curAction){
				case ActionState.STAND:
				case ActionState.SHOW:
					this.setAction(ActionState.WAIT);
					break;
				default:
					if(this.curAction == ActionState.NONE)
						this.setAction(ActionState.WAIT);
					this.setAction(this.curAction, true);
					this.standJudge();
					_kuangWuStandCount = 0;
					break;
			}
		}
		
		//角色待机动作效果
		protected function standJudge() : void{
			if(this.curAction == ActionState.WAIT){
				_standCount++;
				if(_standCount > 7){
					this.setAction(ActionState.STAND);
					_standCount = 0;
				}
			}
		}
		
		override public function destroy():void{
			if(this.charVo){
				this.charVo.destroy();
				this.charVo = null;
			}
			
			AnimationManager.getIns().removeEntity(this.bodyAction);
			super.destroy();
		}
	}
}