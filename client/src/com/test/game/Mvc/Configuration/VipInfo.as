package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class VipInfo extends BaseConfiguration
	{

		private var _anti:Antiwear;
		public function VipInfo(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["coupon"] = 0;
			
			_anti["info_1"] = "";
			_anti["info_2"] = "";
			_anti["info_3"] = "";
			_anti["info_4"] = "";
			_anti["info_5"] = "";
			_anti["info_6"] = "";
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			coupon = data.coupon;
			
			info_1 = data.info_1;
			info_2 = data.info_2;
			info_3 = data.info_3;
			info_4 = data.info_4;
			info_5 = data.info_5;
			info_6 = data.info_6;

			
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		public function get coupon() : int{
			return _anti["coupon"];
		}
		public function set coupon(value:int) : void{
			_anti["coupon"] = value;
		}

		
		public function get info_1() : String{
			return _anti["info_1"];
		}
		public function set info_1(value:String) : void{
			_anti["info_1"] = value;
		}
		
		public function get info_2() : String{
			return _anti["info_2"];
		}
		public function set info_2(value:String) : void{
			_anti["info_2"] = value;
		}
		
		public function get info_3() : String{
			return _anti["info_3"];
		}
		public function set info_3(value:String) : void{
			_anti["info_3"] = value;
		}
		
		public function get info_4() : String{
			return _anti["info_4"];
		}
		public function set info_4(value:String) : void{
			_anti["info_4"] = value;
		}
		
		public function get info_5() : String{
			return _anti["info_5"];
		}
		public function set info_5(value:String) : void{
			_anti["info_5"] = value;
		}
		
		public function get info_6() : String{
			return _anti["info_6"];
		}
		public function set info_6(value:String) : void{
			_anti["info_6"] = value;
		}

	}
}