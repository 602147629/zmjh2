package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Manager.TimeManager;
	
	public class SignInVo extends BaseVO
	{
		private var _anti:Antiwear;
		public function get signInTime() : String{
			return _anti["signInTime"];
		}
		public function set signInTime(value:String) : void{
			_anti["signInTime"] = value;
		}
		
		public function get signInCount() : int{
			return _anti["signInCount"];
		}
		public function set signInCount(value:int) : void{
			_anti["signInCount"] = value;
		}
		
		public function get achievements() : int{
			return _anti["achievements"];
		}
		public function set achievements(value:int) : void{
			_anti["achievements"] = value;
		}
		
		public function SignInVo(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["signInCount"] = 0;
			_anti["signInTime"] = "";
			_anti["achievements"] = 0;
		}
		
		public function judgeSignInTime() : void{
			if(signInTime == ""){
				signInCount = 0;
			}else{
				resetSignIn();
			}
		}
		
		public function resetSignIn() : void{
			if(signInTime != "" && TimeManager.getIns().curTimeStr != ""){
				var time1:Date = TimeManager.getIns().getAnalysisDate(signInTime);
				var time2:Date = TimeManager.getIns().returnTimeNow();
				if((time1.fullYear == time2.fullYear && time1.month != time2.month)
					||(time1.fullYear != time2.fullYear)){
					signInCount = 0;
					signInTime = "";
				}
			}
		}
		
		public function get canSignIn() : Boolean{
			var result:Boolean = false;
			if(signInTime == ""){
				result = true;
			}else{
				var index:int = TimeManager.getIns().disDayNum(TimeManager.getIns().returnTimeNowStr(), signInTime);
				result = (index==0?false:true);
			}
			return result;
		}
		
	}
}