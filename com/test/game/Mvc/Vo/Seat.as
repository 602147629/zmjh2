package com.test.game.Mvc.Vo{
	import com.superkaka.game.Base.BaseVO;
	
	public class Seat extends BaseVO{
		private var _index:int;
		private var _player:Player;
		
		public function Seat(){
			super();
		}
		
		/**
		 * 是否是空座位 
		 * @return 
		 * 
		 */		
		public function isEmpty():Boolean{
			return this._player == null;
		}
		
		
		public function destroy():void{
			this._player = null;
		}
		

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

		public function get player():Player
		{
			return _player;
		}

		public function set player(value:Player):void
		{
			_player = value;
		}


	}
}