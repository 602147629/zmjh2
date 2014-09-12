package com.test.game.process
{
	import com.test.game.Entitys.MonsterEntity;
	
	public class HpConditionHigher
	{
		private var _higher:Number;
		public function HpConditionHigher(input:Number)
		{
			_higher = input;
		}
		
		public function judge(entity:MonsterEntity) : Boolean{
			var result:Boolean = false;
			if(entity.charData.useProperty.hp >= entity.charData.totalProperty.hp * _higher){
				result = true;
			}
			return result;
		}
	}
}