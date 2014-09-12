package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.TimeManager;
	
	public class BlackMarketVo extends BaseVO
	{
		private var _anti:Antiwear;
		public function get items() : Array{
			return _anti["items"];
		}
		public function set items(value:Array) : void{
			_anti["items"] = value;
		}
		
		public function get itemsEnable() : Array{
			return _anti["itemsEnable"];
		}
		public function set itemsEnable(value:Array) : void{
			_anti["itemsEnable"] = value;
		}
		
		public function get blackMarketTime() : String{
			return _anti["blackMarketTime"];
		}
		public function set blackMarketTime(value:String) : void{
			_anti["blackMarketTime"] = value;
		}
		
		public function get freeRefresh() : int{
			return _anti["freeRefresh"];
		}
		public function set freeRefresh(value:int) : void{
			_anti["freeRefresh"] = value;;
		}
		
		public function BlackMarketVo(){
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["items"] = [];
			_anti["itemsEnable"] = [];
			_anti["blackMarketTime"] = "";
			_anti["freeRefresh"] = 0;
			
		}
		
		/**
		 * 判断是否需要重置免费刷新
		 * 
		 */		
		public function judgeResetRefreshNum() : void{
			var count:Number = TimeManager.getIns().disDayNum(TimeManager.getIns().returnTimeNowStr(), blackMarketTime);
			var result:Boolean = (count==0?true:false);
			if(!result || blackMarketTime == ""){
				freeRefresh = NumberConst.getIns().zero;
				blackMarketTime = TimeManager.getIns().curTimeStr;
			}
		}
		
	}
}