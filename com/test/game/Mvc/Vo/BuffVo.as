package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class BuffVo extends BaseVO
	{
		private var _anti:Antiwear;
		/**
		 * 0为无BUFF，1为伤害加成，2为暴击，3为吸血，4为速度，5为闪避，6为普通攻击带内功伤害，7为回蓝加成，8为增加攻击力，9为每秒回血
		 */		
		public var buffType:int;
		
		public function BuffVo(type:int, num:Number){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			
			buffType = type;
			_anti["buffValue"] = num;
		}
		
		public function get buffValue() : Number{
			return _anti["buffValue"];
		}
		public function set buffValue(value:Number) : void{
			_anti["buffValue"] = value;
		}
	}
}