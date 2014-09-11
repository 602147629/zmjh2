package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.TimeManager;
	
	public class SummerCarnivalVo extends BaseVO
	{
		private var _anti:Antiwear;
		public function get summerRecharge() : Array{
			return _anti["summerRecharge"];
		}
		public function set summerRecharge(value:Array) : void{
			_anti["summerRecharge"] = value;
		}
		
		public function get summerConsume() : Array{
			return _anti["summerConsume"];
		}
		public function set summerConsume(value:Array) : void{
			_anti["summerConsume"] = value;
		}
		
		public var summerTime:String;
		
		public function SummerCarnivalVo()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["summerRecharge"] = [];
			_anti["summerConsume"] = [];
		}
		
		public function checkIsGet(index:int, type:int) : Boolean{
			var result:Boolean = false;
			switch(type){
				case NumberConst.getIns().one:
					if(summerRecharge[index] == NumberConst.getIns().one){
						result = true;
					}
					break;
				case NumberConst.getIns().two:
					if(summerConsume[index] == NumberConst.getIns().one){
						result = true;
					}
					break;
			}
			return result;
		}
		
		public function checkShowView() : Boolean{
			var result:Boolean = false;
			if(TimeManager.getIns().disDayNum(NumberConst.getIns().summerEndDate, TimeManager.getIns().curTimeStr) > 0){
				result = false;
			}else{
				if(summerTime == "" || summerTime == null){
					result = true;
					summerTime = TimeManager.getIns().curTimeStr;
				}else{
					var interval:int = TimeManager.getIns().disDayNum(summerTime, TimeManager.getIns().curTimeStr);
					if(interval >= 3){
						result = true;
						summerTime = TimeManager.getIns().curTimeStr;
					}
				}
			}
			return result;
		}
	}
}