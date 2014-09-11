package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class BlackMarket extends BaseConfiguration
	{
		public function BlackMarket()
		{	
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["number"] = 0;
			
			_anti["gold_before"] = 0;
			_anti["gold"] = 0;
			_anti["coupon_before"] = 0;
			_anti["coupon"] = 0;
			
			_anti["recommend"] = 0;
			
			_anti["propId"] = 0;
			_anti["type"] = 0;
			_anti["vip_type"] = 0;
			
			super();
		}
		
		private var _anti:Antiwear;
		
		
		override public function assign(data:Object):void{
			
			id = data.id;
			name = data.name;
			number = data.number;
			
			gold_before = data.gold_before;
			gold = data.gold;
			coupon_before = data.coupon_before;
			coupon = data.coupon;
			
			recommend = data.recommend;
			
			propId = data.propId;
			type = data.type;
			vip_type = data.vip_type;
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		public function get name() : String{
			return _anti["name"];
		}
		public function set name(value:String) : void{
			_anti["name"] = value;
		}
		
		public function get number() : int{
			return _anti["number"];
		}
		public function set number(value:int) : void{
			_anti["number"] = value;
		}
		
		
		public function get gold_before() : int{
			return _anti["gold_before"];
		}
		public function set gold_before(value:int) : void{
			_anti["gold_before"] = value;
		}
		
		public function get gold() : int{
			return _anti["gold"];
		}
		public function set gold(value:int) : void{
			_anti["gold"] = value;
		}
		
		public function get coupon_before() : int{
			return _anti["coupon_before"];
		}
		public function set coupon_before(value:int) : void{
			_anti["coupon_before"] = value;
		}
		
		public function get coupon() : int{
			return _anti["coupon"];
		}
		public function set coupon(value:int) : void{
			_anti["coupon"] = value;
		}
		
		public function get recommend() : int{
			return _anti["recommend"];
		}
		public function set recommend(value:int) : void{
			_anti["recommend"] = value;
		}

		public function get type() : int{
			return _anti["type"];
		}
		public function set type(value:int) : void{
			_anti["type"] = value;
		}
		
		public function get propId() : int{
			return _anti["propId"];
		}
		public function set propId(value:int) : void{
			_anti["propId"] = value;
		}
		
		public function get vip_type() : int{
			return _anti["vip_type"];
		}
		public function set vip_type(value:int) : void{
			_anti["vip_type"] = value;
		}

	
	}
}