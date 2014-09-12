package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Strengthen extends BaseConfiguration
	{
		public function Strengthen()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["strengthen_level"] = "";
			_anti["strengthen_stonetype"] = 0;
			_anti["strengthen_stonenumber"] = 0;
			_anti["money_add"] = 0;
		}
		
		private var _anti:Antiwear;
		
		
		override public function assign(data:Object):void{
			id = data.id;
			strengthen_level = data.strengthen_level;
			stoneId = data.strengthen_stonetype;
			stoneNum = data.strengthen_stonenumber;
			money_add = data.money_add;
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		public function get strengthen_level() : String{
			return _anti["strengthen_level"];
		}
		public function set strengthen_level(value:String) : void{
			_anti["strengthen_level"] = value;
		}
		
		public function get stoneId() : int{
			return _anti["strengthen_stonetype"];
		}
		public function set stoneId(value:int) : void{
			_anti["strengthen_stonetype"] = value;
		}
		
		public function get stoneNum() : int{
			return _anti["strengthen_stonenumber"];
		}
		public function set stoneNum(value:int) : void{
			_anti["strengthen_stonenumber"] = value;
		}
		
		
		public function get money_add() : int{
			return _anti["money_add"];
		}
		public function set money_add(value:int) : void{
			_anti["money_add"] = value;
		}
		
	}
}