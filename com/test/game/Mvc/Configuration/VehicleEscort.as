package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class VehicleEscort extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function VehicleEscort()
		{
			super();
			
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["lv"] = 0;
			_anti["money"] = 0;
			_anti["escortexp"] = 0;
			_anti["escortgold"] = 0;
			_anti["escortsoul"] = 0;
			_anti["extra_money"] = "";
			_anti["extra_soul"] = "";
			_anti["extra_material"] = "";
		}
		
		override public function assign(data:Object):void{
			lv = data.lv;
			money = data.money;
			escortexp = data.escortexp;
			escortgold = data.escortgold;
			escortsoul = data.escortsoul;
			extra_money = data.extra_money;
			extra_soul = data.extra_soul;
			extra_material = data.extra_material;
		}
		
		public function get lv() : int{
			return _anti["lv"];
		}
		public function set lv(value:int) : void{
			_anti["lv"] = value;
		}
		
		public function get money() : int{
			return _anti["money"];
		}
		public function set money(value:int) : void{
			_anti["money"] = value;
		}
		
		public function get escortexp() : int{
			return _anti["escortexp"];
		}
		public function set escortexp(value:int) : void{
			_anti["escortexp"] = value;
		}
		
		public function get escortgold() : int{
			return _anti["escortgold"];
		}
		public function set escortgold(value:int) : void{
			_anti["escortgold"] = value;
		}
		
		public function get escortsoul() : int{
			return _anti["escortsoul"];
		}
		public function set escortsoul(value:int) : void{
			_anti["escortsoul"] = value;
		}
		
		public function get extra_money() : String{
			return _anti["extra_money"];
		}
		public function set extra_money(value:String) : void{
			_anti["extra_money"] = value;
		}
		
		public function get extra_soul() : String{
			return _anti["extra_soul"];
		}
		public function set extra_soul(value:String) : void{
			_anti["extra_soul"] = value;
		}
		
		public function get extra_material() : String{
			return _anti["extra_material"];
		}
		public function set extra_material(value:String) : void{
			_anti["extra_material"] = value;
		}
	}
}