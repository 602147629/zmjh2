package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class OnlineBonus extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function OnlineBonus()
		{
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			_anti["id"] = 0;
			_anti["time"] = 0;
			_anti["gold"] = 0;
			_anti["soul"] = 0;
			_anti["prop_id"] = "";
			_anti["number"] = "";
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			time = data.time;
			gold = data.gold;
			soul = data.soul;
			prop_id = data.prop_id;
			number = data.number;
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		public function get time() : int{
			return _anti["time"];
		}
		public function set time(value:int) : void{
			_anti["time"] = value;
		}
		
		public function get gold() : int{
			return _anti["gold"];
		}
		public function set gold(value:int) : void{
			_anti["gold"] = value;
		}
		
		public function get soul() : int{
			return _anti["soul"];
		}
		public function set soul(value:int) : void{
			_anti["soul"] = value;
		}
		
		public function get prop_id() : String{
			return _anti["prop_id"];
		}
		public function set prop_id(value:String) : void{
			_anti["prop_id"] = value;
		}
		
		public function get number() : String{
			return _anti["number"];
		}
		public function set number(value:String) : void{
			_anti["number"] = value;
		}
	}
}