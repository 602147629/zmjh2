package com.test.game.process
{
	import com.test.game.Entitys.MonsterEntity;

	public class NoneCallback
	{
		private var _type:int;
		public function NoneCallback(input:int){
			_type = input;
		}
		
		public function judge(entity:MonsterEntity) : Boolean{
			var result:Boolean;
			if(_type == 0){
				result = false;
			}else{
				result = true;
			}
			return result;
		}
	}
}