package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class MidAutumnVo extends BaseVO
	{
		private var _anti:Antiwear;
		public function MidAutumnVo(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
		}
		
		public function get moonCakeCount() : int{
			return _anti["moonCakeCount"];
		}
		public function set moonCakeCount(value:int) : void{
			_anti["moonCakeCount"] = value;
		}
		
		public function get alreadyGet() : Array{
			return _anti["alreadyGet"];
		}
		public function set alreadyGet(value:Array) : void{
			_anti["alreadyGet"] = value;
		}
	}
}