package com.test.game.Manager{
	import com.superkaka.Tools.Singleton;
	import com.test.game.Mvc.Vo.Player;
	
	public class PlayersManager extends Singleton{
		private var _players:Vector.<Player>;//所有玩家
		
		public function PlayersManager(){
			super();
			_players = new Vector.<Player>();
		}
		
		
		public static function getIns():PlayersManager{
			return Singleton.getIns(PlayersManager);
		}
		
		/**
		 * 增加一个玩家 
		 * @param player
		 * 
		 */		
		public function addPlayer(player:Player):void{
			for each(var p:Player in this._players){
				if(p.gameKey == player.gameKey){
					throw new Error("PlayersManager->addPlayer() error!this player has exsit in players vector!gameKey:"+p.gameKey);
					return;
				}
			}
			_players.push(player);
		}
		
		
		/**
		 * 移除一个玩家 
		 * @param uid
		 * 
		 */		
		public function removePlayer(gameKey:String):void{
			for each(var p:Player in this._players){
				if(p.gameKey == gameKey){
					var idx:int = this._players.indexOf(p);
					this._players.splice(idx,1);
					return;
				}
			}
			throw new Error("PlayersManager->removePlayer() error!this player has not exsit in players vector!gameKey:"+p.gameKey);
		}
		
		/**
		 * 更新玩家等级 
		 * @param uid
		 * @param level
		 * 
		 */		
		public function UpdatePlayerLevel(gameKey:String,level:int):void{
			var p:Player = this.getPlayerByUid(gameKey);
			if(p){
				p.level = level;
			}
		}
		
		/**
		 * 根据uid获取玩家信息 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getPlayerByUid(gameKey:String):Player{
			for each(var player:Player in this._players){
				if(player.gameKey == gameKey){
					return player;
				}
			}
			return null;	
		}
		
		public function get players():Vector.<Player>{
			return _players;
		}
		
		
		public function clear():void{
			this._players.length = 0;
		}
		
	}
}