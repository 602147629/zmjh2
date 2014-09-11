package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class BossCardUp extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function BossCardUp(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["color"] = "";
			_anti["star"] = 0;
			_anti["atk_rate"] = 0;
			_anti["ats_rate"] = 0;
			_anti["add_rate"] = 0;
			_anti["up_material"] = "";
			_anti["up_number"] = "";
			_anti["up_card"] = 0;
			_anti["up_money"] = 0;
			_anti["up_soul"] = 0;
			_anti["pass_soul"] = 0;
			
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			color = data.color;
			star = data.star;
			atk_rate = data.atk_rate;
			ats_rate = data.ats_rate;
			add_rate = data.add_rate;
			up_material = data.up_material;
			up_number = data.up_number;
			up_card = data.up_card;
			up_money = data.up_money;
			up_soul = data.up_soul;
			pass_soul = data.pass_soul;
			
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}

		
		public function get color() : String{
			return _anti["color"];
		}
		public function set color(value:String) : void{
			_anti["color"] = value;
		}
		
		
		public function get star() : int{
			return _anti["star"];
		}
		public function set star(value:int) : void{
			_anti["star"] = value;
		}
		
		public function get atk_rate() : Number{
			return _anti["atk_rate"];
		}
		public function set atk_rate(value:Number) : void{
			_anti["atk_rate"] = value;
		}
		
		public function get ats_rate() : Number{
			return _anti["ats_rate"];
		}
		public function set ats_rate(value:Number) : void{
			_anti["ats_rate"] = value;
		}
		
		public function get add_rate() : Number{
			return _anti["add_rate"];
		}
		public function set add_rate(value:Number) : void{
			_anti["add_rate"] = value;
		}
		
		
		
		public function get up_material() : String{
			return _anti["up_material"];
		}
		public function set up_material(value:String) : void{
			_anti["up_material"] = value;
		}

		public function get up_number() : String{
			return _anti["up_number"];
		}
		public function set up_number(value:String) : void{
			_anti["up_number"] = value;
		}
		
		public function get up_card() : int{
			return _anti["up_card"];
		}
		public function set up_card(value:int) : void{
			_anti["up_card"] = value;
		}
		
		public function get up_money() : int{
			return _anti["up_money"];
		}
		public function set up_money(value:int) : void{
			_anti["up_money"] = value;
		}
		
		public function get up_soul() : int{
			return _anti["up_soul"];
		}
		public function set up_soul(value:int) : void{
			_anti["up_soul"] = value;
		}
		
		public function get pass_soul() : int{
			return _anti["pass_soul"];
		}
		public function set pass_soul(value:int) : void{
			_anti["pass_soul"] = value;
		}

	}
}