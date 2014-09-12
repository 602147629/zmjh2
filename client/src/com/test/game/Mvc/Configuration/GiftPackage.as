package com.test.game.Mvc.Configuration
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;

	public class GiftPackage extends BaseConfiguration
	{
		public function GiftPackage()
		{
			super();
			_anti = new Antiwear(new binaryEncrypt());
			
			_anti["id"] = 0;
			_anti["name"] = "";
			_anti["type"] = "";
			_anti["itemIds"] = "";
			_anti["itemIds"] = "";
			_anti["gold"] = 0;
			_anti["soul"] = 0;
		}
		
		
		private var _anti:Antiwear;
		
		
		override public function assign(data:Object):void{
			id = data.id;
			name = data.name;
			type = data.type;
			itemIds = data.prop_id;
			itemNums = data.prop_number;
			gold = data.gold;
			soul = data.soul;
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
		
		public function get itemIds() : String{
			return _anti["itemIds"];
		}
		public function set itemIds(value:String) : void{
			_anti["itemIds"] = value;
		}
		
		public function get itemNums() : String{
			return _anti["itemNums"];
		}
		public function set itemNums(value:String) : void{
			_anti["itemNums"] = value;
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
		
	}
}