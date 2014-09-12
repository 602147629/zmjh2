package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class Equipment extends BaseConfiguration
	{
		private var _anti:Antiwear;
		public function Equipment(){
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["type"] = "";
			_anti["color"] = "";
			_anti["atk"] = 0;
			_anti["ats"] = 0;
			_anti["hp"] = 0;
			_anti["def"] = 0;
			_anti["adf"] = 0;
			_anti["mp"] = 0;
			_anti["evasion"] = 0;
			_anti["crit"] = 0;
			_anti["hit"] = 0;
			_anti["toughness"] = 0;
			_anti["exclusive_character"] = "";
			_anti["sale_money"] = 0;
			_anti["money_add"] = 0;
			_anti["need_equipment"] = "";
			_anti["need_material"] = "";
			_anti["material_number"] = "";
			_anti["need_soul"] = 0;
			_anti["need_book"] = 0;
			_anti["fodder"] = 0;
			_anti["chargeLvArr"] = [0,0,0,0];
			
		}
		
		override public function assign(data:Object):void{
			id = data.id;
			name = data.name;
			type = data.type;
			color = data.color;
			atk = data.atk;
			ats = data.ats;
			hp = data.hp;
			def = data.def;
			adf = data.adf;
			mp = data.mp;
			evasion = data.evasion;
			crit = data.crit;
			hit = data.hit;
			toughness = data.toughness;
			exclusive_character = data.exclusive_character;
			sale_money = data.sale_money;
			money_add = data.money_add;
			need_equipment = data.need_equipment;
			need_material = data.need_material;
			material_number = data.material_number;
			need_soul = data.need_soul;
			need_book = data.need_book;
			fodder = data.fodder;
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
		
		public function get type() : String{
			return _anti["type"];
		}
		public function set type(value:String) : void{
			_anti["type"] = value;
		}
		
		public function get color() : String{
			return _anti["color"];
		}
		public function set color(value:String) : void{
			_anti["color"] = value;
		}
		
		public function get atk() : int{
			return _anti["atk"];
		}
		public function set atk(value:int) : void{
			_anti["atk"] = value;
		}
		
		public function get ats() : int{
			return _anti["ats"];
		}
		public function set ats(value:int) : void{
			_anti["ats"] = value;
		}
		
		public function get hp() : int{
			return _anti["hp"];
		}
		public function set hp(value:int) : void{
			_anti["hp"] = value;
		}
		
		public function get def() : int{
			return _anti["def"];
		}
		public function set def(value:int) : void{
			_anti["def"] = value;
		}
		
		public function get adf() : int{
			return _anti["adf"];
		}
		public function set adf(value:int) : void{
			_anti["adf"] = value;
		}
		
		public function get mp() : int{
			return _anti["mp"];
		}
		public function set mp(value:int) : void{
			_anti["mp"] = value;
		}
		
		public function get evasion() : int{
			return _anti["evasion"];
		}
		public function set evasion(value:int) : void{
			_anti["evasion"] = value;
		}
		
		public function get crit() : int{
			return _anti["crit"];
		}
		public function set crit(value:int) : void{
			_anti["crit"] = value;
		}
		
		public function get hit() : int{
			return _anti["hit"];
		}
		public function set hit(value:int) : void{
			_anti["hit"] = value;
		}
		
		public function get toughness() : int{
			return _anti["toughness"];
		}
		public function set toughness(value:int) : void{
			_anti["toughness"] = value;
		}
		
		public function get exclusive_character() : String{
			return _anti["exclusive_character"];
		}
		public function set exclusive_character(value:String) : void{
			_anti["exclusive_character"] = value;
		}
		
		public function get sale_money() : int{
			return _anti["sale_money"];
		}
		public function set sale_money(value:int) : void{
			_anti["sale_money"] = value;
		}
		
		public function get money_add() : int{
			return _anti["money_add"];
		}
		public function set money_add(value:int) : void{
			_anti["money_add"] = value;
		}
		
		public function get need_equipment() : int{
			return _anti["need_equipment"];
		}
		public function set need_equipment(value:int) : void{
			_anti["need_equipment"] = value;
		}
		
		public function get need_material() : String{
			return _anti["need_material"];
		}
		public function set need_material(value:String) : void{
			_anti["need_material"] = value;
		}
		
		public function get material_number() : String{
			return _anti["material_number"];
		}
		public function set material_number(value:String) : void{
			_anti["material_number"] = value;
		}
		
		public function get need_soul() : int{
			return _anti["need_soul"];
		}
		public function set need_soul(value:int) : void{
			_anti["need_soul"] = value;
		}
		
		public function get need_book() : int{
			return _anti["need_book"];
		}
		public function set need_book(value:int) : void{
			_anti["need_book"] = value;
		}
		
		public function get fodder() : String{
			return _anti["fodder"];
		}
		public function set fodder(value:String) : void{
			_anti["fodder"] = value;
		}
		
		public function get chargeLvArr() : Array{
			return _anti["chargeLvArr"];
		}
		public function set chargeLvArr(value:Array) : void{
			_anti["chargeLvArr"] = value;
		}
	}
}   