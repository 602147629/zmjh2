package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.AutoFightConst;
	import com.test.game.Manager.AutoFightManager;
	
	public class AutoFightVo extends BaseVO
	{
		private var _anti:Antiwear;
		public function AutoFightVo()
		{
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["autoFightCount"] = 0;
			_anti["rpCardCount"] = 0;
			_anti["doubleCardCount"] = 0;
		}
		
		public function get rpCardCount() : int{
			return _anti["rpCardCount"];
		}
		public function set rpCardCount(value:int) : void{
			_anti["rpCardCount"] = value;
		}
		
		public function get doubleCardCount() : int{
			return _anti["doubleCardCount"];
		}
		public function set doubleCardCount(value:int) : void{
			_anti["doubleCardCount"] = value;
		}
		
		public function get autoFightCount() : int{
			return _anti["autoFightCount"];
		}
		public function set autoFightCount(value:int) : void{
			_anti["autoFightCount"] = value;
			if(value <= 0){
				AutoFightManager.getIns().autoType = AutoFightConst.AUTO_TYPE_NORMAL;
			}else{
				AutoFightManager.getIns().autoType = AutoFightConst.AUTO_TYPE_ACE;
			}
		}
	}
}