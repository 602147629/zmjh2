package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class GameSettingVo extends BaseVO
	{
		private var _anti:Antiwear;
		public function GameSettingVo()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
		}
		
		public function get bgSoundVolume() : Number{
			return _anti["bgSoundVolume"];
		}
		public function set bgSoundVolume(value:Number) : void{
			_anti["bgSoundVolume"] = value;
		}
	}
}