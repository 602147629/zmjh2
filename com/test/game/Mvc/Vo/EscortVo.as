package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.EscortManager;
	import com.test.game.Manager.ShopManager;
	import com.test.game.Manager.TimeManager;
	
	public class EscortVo extends BaseVO
	{
		private var _anti:Antiwear;
		public function EscortVo()
		{
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["time"] = "";
			_anti["escortCount"] = 0;
			_anti["lootCount"] = 0;
			_anti["escortTime"] = "";
			_anti["lootTime"] = "";
		}
		
		public function get time() : String{
			return _anti["time"];
		}
		public function set time(value:String) : void{
			_anti["time"] = value;
		}
		
		public function get escortCount() : int{
			return _anti["escortCount"];
		}
		public function set escortCount(value:int) : void{
			_anti["escortCount"] = value;
		}
		
		public function get lootCount() : int{
			return _anti["lootCount"];
		}
		public function set lootCount(value:int) : void{
			_anti["lootCount"] = value;
		}
		
		public function get escortTime() : String{
			return _anti["escortTime"];
		}
		public function set escortTime(value:String) : void{
			_anti["escortTime"] = value;
		}
		
		public function get lootTime() : String{
			return _anti["lootTime"];
		}
		public function set lootTime(value:String) : void{
			_anti["lootTime"] = value;
		}
		
		//判断是否刷新护镖信息
		public function judgeResetEscort() : void{
			if(time == ""){
				initEscort();
			}else{
				var result:Boolean = TimeManager.getIns().checkEveryDayPlay(time.split("_")[0]);
				if(!result){
					initEscort();
				}else{
					EscortManager.getIns().initColdTime();
				}
			}
		}
		
		public function initEscort() : void{
			time = TimeManager.getIns().curTimeStr;
			escortCount = (ShopManager.getIns().vipLv >= NumberConst.getIns().four?NumberConst.getIns().three:NumberConst.getIns().two);
			lootCount = (ShopManager.getIns().vipLv >= NumberConst.getIns().four?NumberConst.getIns().three:NumberConst.getIns().two);
			escortTime = "";
			lootTime = "";
		}
	}
}