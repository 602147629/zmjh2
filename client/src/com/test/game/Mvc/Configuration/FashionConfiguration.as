package com.test.game.Mvc.Configuration
{
	public class FashionConfiguration extends BaseConfiguration
	{
		public function FashionConfiguration(){
			super();
		}
		
		public var id:int;
		public var fashion_id:int;
		public var fodder:String;
		public var weapon:String;
		public var head:String;
		public var shoulder:String;
		public var clothes:String;
		
		override public function assign(data:Object):void{
			id = data.id;
			fashion_id = data.fashion_id;
			fodder = data.fodder;
			weapon = data.weapon;
			head = data.head;
			shoulder = data.shoulder;
			clothes = data.clothes;
		}
	}
}