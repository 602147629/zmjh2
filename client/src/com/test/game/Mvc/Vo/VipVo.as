package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.NumberConst;
	import com.test.game.Manager.TimeManager;
	
	public class VipVo extends BaseVO
	{

		private var _anti:Antiwear;
		
		public function get vipGiftGetTime() : String{
			return _anti["vipGiftGetTime"];
		}
		public function set vipGiftGetTime(value:String) : void{
			_anti["vipGiftGetTime"] = value;
		}
		
		public function get isVipGiftGet() : Boolean{
			return _anti["isVipGiftGet"];
		}
		public function set isVipGiftGet(value:Boolean) : void{
			_anti["isVipGiftGet"] = value;
		}
		
		public function get firstCharge() : int{
			return _anti["firstCharge"];
		}
		public function set firstCharge(value:int) : void{
			_anti["firstCharge"] = value;
		}
		
		public function get totalRecharge() : int{
			return _anti["totalRecharge"];
		}
		public function set totalRecharge(value:int) : void{
			_anti["totalRecharge"] = value;
		}
		
		public function get curCoupon() : int{
			return _anti["curCoupon"];
		}
		public function set curCoupon(value:int) : void{
			_anti["curCoupon"] = value;
		}
		
		public function VipVo(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["vipGiftGetTime"] = "";
			_anti["isVipGiftGet"] = false;
			_anti["firstCharge"] = NumberConst.getIns().negativeOne;
			_anti["totalRecharge"] = NumberConst.getIns().zero;
			_anti["curCoupon"] = NumberConst.getIns().zero;
		}
		

		public function updateVipGiftDate() : void{
			if(vipGiftGetTime == ""){
				vipGiftGetTime = TimeManager.getIns().returnTimeNowStr();
				isVipGiftGet = false;
			}else{
				var index:int = TimeManager.getIns().disDayNum(TimeManager.getIns().returnTimeNowStr(), vipGiftGetTime);
				if(index ==0 && isVipGiftGet==true){
					isVipGiftGet = true;
				}else{
					vipGiftGetTime = TimeManager.getIns().returnTimeNowStr();
					isVipGiftGet = false;
				}
			}
		}
		
	}
}