package com.test.game.Manager{
	import com.superkaka.Tools.Singleton;
	import com.test.game.Mvc.Vo.Player;
	
	public class FbPlayersManager extends Singleton{
		private var _players:Vector.<Player>;
		
		private var _playerDatas:Array;//副本玩家数据数组
		
		public function FbPlayersManager(){
			super();
			_players = new Vector.<Player>();
		}
		
		
		public static function getIns():FbPlayersManager{
			return Singleton.getIns(FbPlayersManager);
		}
		
		/**
		 * 更新副本内所有玩家信息
		 * @param rooms
		 * 
		 */		
		public function updatePlayers(players:Vector.<Player>):void{
			_players = players;
		}
		
		
		/**
		 * 清空副本内玩家数据 
		 * 
		 */		
		public function clear():void{
			if(this._players){
				for each(var player:Player in this._players){
					player.destroy();
				}
				this._players.length = 0;
			}
		}
		

		public function get players():Vector.<Player>
		{
			return _players;
		}

		public function get playerDatas():Array
		{
			return _playerDatas;
		}

		public function set playerDatas(value:Array):void
		{
			_playerDatas = value;
			if(_playerDatas != null){
				_playerDatas.sortOn("index");
			}
		}

		
	}
}