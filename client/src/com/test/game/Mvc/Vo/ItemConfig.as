package com.test.game.Mvc.Vo{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	
	/**
	 * 
	 * 物品配置数据
	 * 
	 */
	public class ItemConfig extends Object{
		
		public function ItemConfig()
		{
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["name"] = "";
			
			_anti["id"] = 0;
			
			_anti["sale_money"] = 0;
			
			_anti["hit"] = 0;
			
			_anti["evasion"] = "";
			
			_anti["hp"] = "";
			
			_anti["mp"] = "";
			
			_anti["crit"] = "";
			
			_anti["antiCrit"] = 0;
			
		}
		
		private var _anti:Antiwear;


		
		/**
		 * 装备的品级颜色，白，绿，蓝，紫
		 */
		public var color:String;
		
		
		/**
		 * 装备类别:武器,衣着,饰品
		 */
		public var type:String;
		
		
		/**
		 * 该物品可以卖多少钱
		 */
		public function get sale_money() : int
		{
			return _anti["sale_money"];
		}
		public function set sale_money(value:int) : void
		{
			_anti["sale_money"] = value;
		}
		
		

		
		
		/**
		 * 物品名称
		 */
		public function get name() : String
		{
			return _anti["name"];
		}
		public function set name(value:String) : void
		{
			_anti["name"] = value;
		}
		
		
		
		/**
		 * ID
		 */
		public function get id() : int
		{
			return _anti["id"];
		}
		public function set id(value:int) : void
		{
			_anti["id"] = value;
		}
		
		/**
		 * 命中率
		 */
		public function get hit() : int
		{
			return _anti["hit"];
		}
		public function set hit(value:int) : void
		{
			_anti["hit"] = value;
		}
		
		/**
		 * 闪避率
		 */
		public function get evasion() : String
		{
			return _anti["evasion"];
		}
		public function set evasion(value:String) : void
		{
			_anti["evasion"] = value;
		}
		

		/**
		 * 生命增加值
		 */
		public function get hp() : String
		{
			return _anti["hp"];
		}
		public function set hp(value:String) : void
		{
			_anti["hp"] = value;
		}
		

		
		/**
		 * 魔力增加值
		 */
		public function get mp() : String
		{
			return _anti["mp"];
		}
		public function set mp(value:String) : void
		{
			_anti["mp"] = value;
		}
		
		/**
		 * 攻击增加值
		 */
		public function get atk() : int
		{
			return _anti["atk"];
		}
		public function set atk(value:int) : void
		{
			_anti["atk"] = value;
		}
		
		/**
		 * 防御增加值
		 */
		public function get def() : int
		{
			return _anti["def"];
		}
		public function set def(value:int) : void
		{
			_anti["def"] = value;
		}
		
		/**
		 * 内功增加值
		 */
		public function get ats() : int
		{
			return _anti["ats"];
		}
		public function set ats(value:int) : void
		{
			_anti["ats"] = value;
		}
		
		/**
		 * 罡气增加值
		 */
		public function get adf() : int
		{
			return _anti["adf"];
		}
		public function set adf(value:int) : void
		{
			_anti["adf"] = value;
		}
		
		
		/**
		 * 暴击增加值
		 */
		public function get crit() : int
		{
			return _anti["crit"];
		}
		public function set crit(value:int) : void
		{
			_anti["crit"] = value;
		}

		
		/**
		 * 韧性增加值
		 */
		public function get toughness() : int
		{
			return _anti["toughness"];
		}
		public function set toughness(value:int) : void
		{
			_anti["toughness"] = value;
		}
		
		

		
		public function assign(dataJson:Object) : void
		{
			
			
			
			name = dataJson["name"];
			
			type = dataJson["type"];
			
			id = dataJson["id"];
			
			sale_money = dataJson["sale_money"];
			
			color = dataJson["color"];
			
			
			
			hp = dataJson["hp"];
			
			mp = dataJson["mp"];
			
			atk = dataJson["atk"];
			
			def = dataJson["def"];
			
			ats = dataJson["ats"];
			
			adf = dataJson["adf"];
			
			crit = dataJson["crit"];
			
			toughness = dataJson["toughness"];
			
			hit = dataJson["hit"];
			
			evasion = dataJson["evasion"];
			
			
			
		}
		
		public function copy() : ItemConfig
		{
			var target:ItemConfig = new ItemConfig();
			
			
			target.sale_money = this.sale_money;

			target.hit = this.hit;

			target.name = this.name;

			target.evasion = this.evasion;

			target.color = this.color;

			target.hp = this.hp;

			target.mp = this.mp;
			
			target.atk = this.atk;
			
			target.def = this.def;

			target.crit = this.crit;

			target.type = this.type;

			target.id = this.id;
	
			target.toughness = this.toughness;
			
			return target;
		}
	}
}
