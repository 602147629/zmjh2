package com.test.game.Mvc.Vo{
	import com.superkaka.game.Base.BaseVO;
	
	public class Item extends BaseVO{
		private var _itemType:int;//物品类型，读表获取
		
		private var _id:int;//物品id
		private var _num:int;//物品数量
		private var _maxNum:int;//物品最大数量
		private var _index:int;//所处背包索引
		
		public function Item(){
			super();
			
			this.maxNum = 999;
		}

		
		

		public function get itemType():int
		{
			return _itemType;
		}

		public function set itemType(value:int):void
		{
			_itemType = value;
		}


		public function get num():int
		{
			return _num;
		}

		public function set num(value:int):void
		{
			_num = value;
		}

		public function get maxNum():int
		{
			return _maxNum;
		}

		public function set maxNum(value:int):void
		{
			_maxNum = value;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}


	}
}