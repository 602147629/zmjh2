package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class SouthMarket extends BaseConfiguration
	{
		public function SouthMarket()
		{	
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["number"] = 0;
			_anti["gold"] = 0;
			_anti["recommend"] = 0;

			super();
		}
		
		private var _anti:Antiwear;
		
		
		override public function assign(data:Object):void{
			
			id = data.id;
			name = data.name;
			number = data.number;
			gold = data.gold;
			recommend = data.recommend;
			
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
	
		public function get gold() : int{
			return _anti["gold"];
		}
		public function set gold(value:int) : void{
			_anti["gold"] = value;
		}
		
		public function get recommend() : int{
			return _anti["recommend"];
		}
		public function set recommend(value:int) : void{
			_anti["recommend"] = value;
		}

	}
}