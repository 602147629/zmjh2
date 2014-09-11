package com.test.game.Mvc.Vo{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Const.NumberConst;
	import com.test.game.Mvc.Configuration.Book;
	import com.test.game.Mvc.Configuration.BossCard;
	import com.test.game.Mvc.Configuration.BossCardUp;
	import com.test.game.Mvc.Configuration.Equipment;
	import com.test.game.Mvc.Configuration.Fashion;
	import com.test.game.Mvc.Configuration.Material;
	import com.test.game.Mvc.Configuration.Prop;
	import com.test.game.Mvc.Configuration.Special;
	import com.test.game.Mvc.Configuration.Strengthen;
	
	public class ItemVo extends BaseVO{
		private var _anti:Antiwear;
		public var equipConfig:Equipment;
		public var strengthen:Strengthen;
		
		public var materialConfig:Material;
		public var specialConfig:Special;
		public var propConfig:Prop;
		public var bookConfig:Book;
		
		public var bossConfig:BossCard;
		public var bossUp:BossCardUp;
		
		public var fashionConfig:Fashion;
		
		public function ItemVo(){
			_anti = new Antiwear(new binaryEncrypt());
/*			equipConfig = new Equipment();
			strengthen = new Strengthen();
			materialConfig = new Material();
			specialConfig = new Special();
			propConfig = new Prop();
		    bookConfig = new Book();
			bossConfig = new BossCard();
			bossUp = new BossCardUp();*/
			time = "";
			num = NumberConst.getIns().one;
			maxNum=NumberConst.getIns().itemNumMax;
			sale_money = NumberConst.getIns().zero;
			isNew = false;
			mid = NumberConst.getIns().negativeOne;
			isPriceShow = true;
		}

		
		
		/**
		 * 物品种类
		 */	
		public function get type():String
		{
			return _anti["type"];
		}

		public function set type(value:String):void
		{
			_anti["type"] = value;
		}
		
		
		/**
		 * 物品名称 
		 */		
		public function get name() : String
		{
			return 	_anti["name"];
		}
		public function set name(value:String) : void
		{
			_anti["name"] = value;
		}
		
		
		/**
		 * 时装购买时间
		 */	
		public function get time():String
		{
			return _anti["time"];
		}
		
		public function set time(value:String):void
		{
			_anti["time"] = value;
		}
		
		
		/**
		 * 物品ID 
		 */	
		public function get id():int
		{
			return _anti["itemId"];
		}

		public function set id(value:int):void
		{
			_anti["itemId"] = value;
		}
		
		/**
		 * 唯一ID  >=0 背包里位置  -1装备栏   -2援护栏  -3前锋附体 -4中坚附体 -5大将附体
		 */		
		public function get mid() : int
		{
			return 	_anti["mid"];
		}
		public function set mid(value:int) : void
		{
			_anti["mid"] = value;
		}
		
		
		/**
		 * boss卡片背包ID 
		 */		
		public function get cid() : int
		{
			return 	_anti["cid"];
		}
		public function set cid(value:int) : void
		{
			_anti["cid"] = value;
		}
		
		
		/**
		 * 物品强化等级
		 */	
		public function get lv():int
		{
			return _anti["lv"];
		}
		
		public function set lv(value:int):void
		{
			_anti["lv"] = value;
		}

		
		/**
		 * 物品堆叠数量 
		 */	
		public function get num():int
		{
			return _anti["num"];
		}

		public function set num(value:int):void
		{
			_anti["num"] = value;
		}

		
		
		/**
		 * 物品最大堆叠数量 
		 */	
		public function get maxNum():int
		{
			return _anti["maxNum"];
		}

		public function set maxNum(value:int):void
		{
			_anti["maxNum"] = value;
		}
		
		
		
		/**
		 * 售价 
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
		 * 是否装备在身上了 
		 */		
		private  var _isEquiped:Boolean;
		public function get isEquiped() : Boolean
		{
			return _isEquiped;
		}
		public function set isEquiped(value:Boolean) : void
		{
			_isEquiped = value;
			isNew = false;
		}
		
		/**
		 * 是否装备在附体了 
		 */		
		private  var _isAttached:Boolean;
		public function get isAttached() : Boolean
		{
			return _isAttached;
		}
		public function set isAttached(value:Boolean) : void
		{
			_isAttached = value;
		}
		
		/**
		 * 是否装备在支援了 
		 */		
		private  var _isAssisted:Boolean;
		public function get isAssisted() : Boolean
		{
			return _isAssisted;
		}
		public function set isAssisted(value:Boolean) : void
		{
			_isAssisted = value;
		}
		
		/**
		 * 是否显示售价 
		 */		
		private  var _isPriceShow:Boolean;
		public function get isPriceShow() : Boolean
		{
			return _isPriceShow;
		}
		public function set isPriceShow(value:Boolean) : void
		{
			_isPriceShow = value;
		}
		
		public var isNew:Boolean;
		
		
		public function copy():ItemVo{
			var item:ItemVo = new ItemVo();
			
			item.equipConfig = this.equipConfig;
			item.propConfig = this.propConfig;
			item.bookConfig = this.bookConfig;
			item.materialConfig = this.materialConfig;
			item.specialConfig = this.specialConfig;
			item.bossConfig = this.bossConfig;
			item.bossUp = this.bossUp;
			item.strengthen = this.strengthen;
			item.fashionConfig = this.fashionConfig;
			item.num = this.num;
			item.id = this.id;
			item.mid = this.mid;
			item.cid = this.cid;
			item.name = this.name;
			item.type = this.type;
			item.lv = this.lv;
			item.time = this.time;
			item.isEquiped = this.isEquiped;
			item.isAttached = this.isAttached;
			item.isAssisted = this.isAssisted;
			item.sale_money = this.sale_money;
			item.isPriceShow = this.isPriceShow;
			
			return item;
		}


	}
}