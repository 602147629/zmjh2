package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.TimeManager;
	import com.test.game.Manager.WuYiManager;
	
	public class WuYiVo extends BaseVO
	{
		private var _anti:Antiwear;
		public function WuYiVo()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			_anti["isGet"] = 0;
			_anti["time"] = "";
		}
		
		public var canGet:Boolean;
		public function get isGet() : int{
			return _anti["isGet"];
		}
		public function set isGet(value:int) : void{
			_anti["isGet"] = value;
		}
		
		public function get time() : String{
			return _anti["time"];
		}
		public function set time(value:String) : void{
			_anti["time"] = value;
		}
		
		public function judgeTime() : void{
			
		}
		
		public function updateTime() : void{
			var duration:int = TimeManager.getIns().disDayNum(NumberConst.getIns().wuyiDate, TimeManager.getIns().returnTimeNowStr());
			if(duration >= 0 && duration <= 2){
				if(time == ""){
					time = TimeManager.getIns().returnTimeNowStr();
					isGet = 0;
				}else{
					if(!TimeManager.getIns().checkEveryDayPlay(time)){
						time = TimeManager.getIns().returnTimeNowStr();
						isGet = 0;
					}
				}
				WuYiManager.getIns().setWuyiStart(true);
				canGet = true;
			}else{
				WuYiManager.getIns().setWuyiStart();
				canGet = false;
			}
		}
	}
}