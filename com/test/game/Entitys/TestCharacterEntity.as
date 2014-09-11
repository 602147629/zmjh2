package com.test.game.Entitys
{
	import com.superkaka.game.Base.BaseSequenceActionBind;
	import com.superkaka.game.Base.WorldEntity.SequenceActionEntity;
	import com.test.game.AgreeMent.Battle.IAttackAble;
	import com.test.game.AgreeMent.Battle.IBeHurtAble;
	import com.test.game.AgreeMent.Battle.IHurtAble;
	import com.test.game.Mvc.Vo.CharacterVo;
	
	public class TestCharacterEntity extends SequenceActionEntity implements IAttackAble, IBeHurtAble
	{
		protected var charVo:CharacterVo;//数据
		public function TestCharacterEntity(charVo:CharacterVo)
		{
			this.charVo = charVo;
			super();
		}
		
		override protected function initSequenceAction():void{
			this.bodyAction = new BaseSequenceActionBind(this.charVo);
			super.initSequenceAction();
			
			//打印中心点
			this.bodyAction.isDrawCenter = true;
		}
		
		override protected function initCallBack():void{
			super.initCallBack();
		}
		
		override public function destroy():void{
			charVo = null;
			super.destroy();
		}
		
		public function attackTarget(value:IBeHurtAble):void
		{
		}
		
		public function set beAttackedIdVec(vec:Vector.<int>):void
		{
		}
		
		public function get beAttackedIdVec():Vector.<int>
		{
			return null;
		}
		
		public function set lastBeHurtSource(ia:IHurtAble):void
		{
		}
		
		public function get lastBeHurtSource():IHurtAble
		{
			return null;
		}
		
		public function isYourFather():Boolean
		{
			return false;
		}
		
		public function hurtBy(ih:IHurtAble):void
		{
		}
	}
}