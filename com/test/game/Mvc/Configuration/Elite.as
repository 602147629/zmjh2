package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Elite extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function Elite()
		{
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["level_id"] = "";
			_anti["material"] = "";
			_anti["strengthen"] = "";
			_anti["book"] = "";
			_anti["book_rate"] = 0;
			_anti["exp"] = 0;
			_anti["money"] = 0;
			_anti["soul"] = 0;
			_anti["level_lv"] = 0;
			_anti["fodder"] = "";
			_anti["bonus"] = "";
			_anti["loading_fodder"] = "";
			_anti["boss_name"] = "";
			_anti["collection"] = "";
			_anti["collection_rate"] = 0;
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			level_id = data.level_id;
			level_name = data.level_name;
			level_lv = data.level_lv;
			scene_name = data.scene_name;
			level_message = data.level_message;
			material = data.material;
			special = data.special;
			book = data.book;
			book_rate = data.book_rate;
			exp = data.exp;
			money = data.money;
			soul = data.soul;
			fodder = data.fodder;
			bonus = data.bonus;
			loading_fodder = data.loading_fodder;
			boss_name = data.boss_name;
			collection = data.collection;
			collection_rate = data.collection_rate;
		}
		
		public function get id() : int{
			return _anti["id"];
		}
		public function set id(value:int) : void{
			_anti["id"] = value;
		}
		
		public function get level_id() : String{
			return _anti["level_id"];
		}
		public function set level_id(value:String) : void{
			_anti["level_id"] = value;
		}
		
		public var level_name : String;
		public var scene_name : String;
		public var level_message : String;
		
		public function get material() : String{
			return _anti["material"];
		}
		public function set material(value:String) : void{
			_anti["material"] = value;
		}
		
		public function get special() : String{
			return _anti["special"];
		}
		public function set special(value:String) : void{
			_anti["special"] = value;
		}
		
		public function get book() : String{
			return _anti["book"];
		}
		public function set book(value:String) : void{
			_anti["book"] = value;
		}
		
		public function get book_rate() : Number{
			return _anti["book_rate"];
		}
		public function set book_rate(value:Number) : void{
			_anti["book_rate"] = value;
		}
		
		public function get exp() : int{
			return _anti["exp"];
		}
		public function set exp(value:int) : void{
			_anti["exp"] = value;
		}
		
		public function get money() : int{
			return _anti["money"];
		}
		public function set money(value:int) : void{
			_anti["money"] = value;
		}
		
		public function get soul() : int{
			return _anti["soul"];
		}
		public function set soul(value:int) : void{
			_anti["soul"] = value;
		}
		
		public function get level_lv() : int{
			return _anti["level_lv"];
		}
		public function set level_lv(value:int) : void{
			_anti["level_lv"] = value;
		}
		
		public function get fodder() : String{
			return _anti["fodder"];
		}
		public function set fodder(value:String) : void{
			_anti["fodder"] = value;
		}
		
		public function get bonus() : String{
			return _anti["bonus"];
		}
		public function set bonus(value:String) : void{
			_anti["bonus"] = value;
		}
		
		public function get loading_fodder() : String{
			return _anti["loading_fodder"];
		}
		public function set loading_fodder(value:String) : void{
			_anti["loading_fodder"] = value;
		}
		
		public function get boss_name() : String{
			return _anti["boss_name"];
		}
		public function set boss_name(value:String) : void{
			_anti["boss_name"] = value;
		}
		
		public function get collection() : String{
			return _anti["collection"];
		}
		public function set collection(value:String) : void{
			_anti["collection"] = value;
		}
		
		public function get collection_rate() : Number{
			return _anti["collection_rate"];
		}
		public function set collection_rate(value:Number) : void{
			_anti["collection_rate"] = value;
		}
		
	}
}