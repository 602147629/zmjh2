package com.test.game.Mvc.Vo
{
	import com.edgarcai.encrypt.binaryEncrypt;
	import com.edgarcai.gamelogic.Antiwear;
	import com.superkaka.game.Base.BaseVO;
	
	public class ShopVo extends BaseVO
	{
		
/*		propId
		propAction
		price
		propType*/
		
		public function ShopVo()
		{
			_anti = new Antiwear(new binaryEncrypt());
			
		}
		
		private var _anti:Antiwear;	
		
		/**
		 * 商城id
		 */
		public function get propId() : int
		{
			return _anti["propId"];
		}
		public function set propId(value:int) : void
		{
			_anti["propId"] = value;
		}
		
		/**
		 * 商城动作
		 */
		public function get propAction() : Object
		{
			return _anti["propAction"];
		}
		public function set propAction(value:Object) : void
		{
			_anti["propAction"] = value;
		}
		
		/**
		 * 商城价格
		 */
		public function get price() : int
		{
			return _anti["price"];
		}
		public function set price(value:int) : void
		{
			_anti["price"] = value;
		}
		
		/**
		 * 商城物品类型
		 */
		public function get propType() : int
		{
			return _anti["propType"];
		}
		public function set propType(value:int) : void
		{
			_anti["propType"] = value;
		}
		
		/**
		 * 物品类型    
		 */
		public function get type() : String
		{
			return _anti["type"];
		}
		public function set type(value:String) : void
		{
			_anti["type"] = value;
		}


	}
}