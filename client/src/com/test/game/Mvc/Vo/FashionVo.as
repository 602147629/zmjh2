package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class FashionVo extends BaseVO
	{
		public function FashionVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
		}
		
		private var _anti:Antiwear;
		
		public function get fashionId():int
		{
			return _anti["fashionId"];
		}
		public function set fashionId(value:int):void
		{
			_anti["fashionId"] = value;
		}
		
		public function get showFashion():int
		{
			return _anti["showFashion"];
		}
		public function set showFashion(value:int):void
		{
			_anti["showFashion"] = value;
		}
	}
}