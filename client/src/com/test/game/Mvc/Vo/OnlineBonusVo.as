package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Manager.Extra.OnlineBonusManager;
	
	public class OnlineBonusVo extends BaseVO
	{
		private var _anti:Antiwear;
		public function OnlineBonusVo()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["onlineTime"] = "";
			_anti["lv"] = 0;
		}
		
		public function get onlineTime() : String{
			return _anti["onlineTime"];
		}
		public function set onlineTime(value:String) : void{
			_anti["onlineTime"] = value;
		}
		
		public function get lv() : int{
			return _anti["lv"];
		}
		public function set lv(value:int) : void{
			_anti["lv"] = value;
		}
		
		//判断是否刷新每日任务
		public function judgeOnlineBonus() : void{
			if(onlineTime != ""){
				var result:Boolean = TimeManager.getIns().checkEveryDayPlay(onlineTime.split("_")[0]);
				if(!result){
					onlineTime = "";
					lv = 0;
				}else{
					OnlineBonusManager.getIns().updateOnlineBonus();
				}
			}else{
				OnlineBonusManager.getIns().updateOnlineBonus();
			}
		}
	}
}