package com.test.game.process
{
	import com.test.game.Entitys.MonsterEntity;
	
	public class HpConditionLower
	{
		private var _lower:Number;
		public function HpConditionLower(input:Number)
		{
			_lower = input;
		}
		
		public function judge(entity:MonsterEntity) : Boolean{
			var result:Boolean = false;
			if(entity.charData.useProperty.hp <= entity.charData.totalProperty.hp * _lower){
				result = true;
			}
			return result;
		}
		
	}
}