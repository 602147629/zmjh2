package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class SummerCarnival extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function SummerCarnival()
		{
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["id"] = 0;
			_anti["coupon"] = 0;
			_anti["value"] = 0;
			_anti["recharge_prop_id"] = "";
			_anti["recharge_prop_number"] = "";
			_anti["recharge_gold"] = 0;
			_anti["recharge_soul"] = 0
			_anti["recharge_fashion"] = "";
			_anti["consume_prop_id"] = "";
			_anti["consume_prop_number"] = "";
			_anti["consume_gold"] = 0;
			_anti["consume_soul"] = 0
			_anti["consume_fashion"] = "";
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			coupon = data.coupon;
			value = data.value;
			recharge_prop_id = data.recharge_prop_id;
			recharge_prop_number = data.recharge_prop_number;
			recharge_gold = data.recharge_gold;
			recharge_soul = data.recharge_soul;
			recharge_fashion = data.recharge_fashion;
			consume_prop_id = data.consume_prop_id;
			consume_prop_number = data.consume_prop_number;
			consume_gold = data.consume_gold;
			consume_soul = data.consume_soul;
			consume_fashion = data.consume_fashion;
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
		
		public function get value() : int{
			return _anti["value"];
		}
		public function set value(value:int) : void{
			_anti["value"] = value;
		}
		
		public function get recharge_prop_id() : String{
			return _anti["recharge_prop_id"];
		}
		public function set recharge_prop_id(value:String) : void{
			_anti["recharge_prop_id"] = value;
		}
		
		public function get recharge_prop_number() : String{
			return _anti["recharge_prop_number"];
		}
		public function set recharge_prop_number(value:String) : void{
			_anti["recharge_prop_number"] = value;
		}
		
		public function get recharge_gold() : int{
			return _anti["recharge_gold"];
		}
		public function set recharge_gold(value:int) : void{
			_anti["recharge_gold"] = value;
		}
		
		public function get recharge_soul() : int{
			return _anti["recharge_soul"];
		}
		public function set recharge_soul(value:int) : void{
			_anti["recharge_soul"] = value;
		}
		
		public function get recharge_fashion() : String{
			return _anti["recharge_fashion"];
		}
		public function set recharge_fashion(value:String) : void{
			_anti["recharge_fashion"] = value;
		}
		
		public function get consume_prop_id() : String{
			return _anti["consume_prop_id"];
		}
		public function set consume_prop_id(value:String) : void{
			_anti["consume_prop_id"] = value;
		}
		
		public function get consume_prop_number() : String{
			return _anti["consume_prop_number"];
		}
		public function set consume_prop_number(value:String) : void{
			_anti["consume_prop_number"] = value;
		}
		
		public function get consume_gold() : int{
			return _anti["consume_gold"];
		}
		public function set consume_gold(value:int) : void{
			_anti["consume_gold"] = value;
		}
		
		public function get consume_soul() : int{
			return _anti["consume_soul"];
		}
		public function set consume_soul(value:int) : void{
			_anti["consume_soul"] = value;
		}
		
		public function get consume_fashion() : String{
			return _anti["consume_fashion"];
		}
		public function set consume_fashion(value:String) : void{
			_anti["consume_fashion"] = value;
		}
	}
}