package com.test.game.Manager{
	import com.superkaka.Tools.Singleton;
	import com.test.game.Mvc.Vo.Connector;
	import com.test.game.Mvc.Vo.Player;
	import com.test.game.Mvc.Vo.PlayerVo;
	import com.test.game.Mvc.Vo.User;
	
	public class MyUserManager extends Singleton{
		/**
		 * 帐号信息 
		 */		
		private var _user:User;
		/**
		 * 角色信息 
		 */		
		private var _player:PlayerVo;
		private var _partnerPlayer:PlayerVo;
		private var _curConnector:Connector;
		
		private var _socketPlayer:Player;
		
		public function MyUserManager(){
			super();
		}
		
		public static function getIns():MyUserManager{
			return Singleton.getIns(MyUserManager);
		}

		public function get user():User
		{
			return _user;
		}

		public function set user(value:User):void
		{
			_user = value;
		}

		public function get curConnector():Connector
		{
			return _curConnector;
		}

		public function set curConnector(value:Connector):void
		{
			_curConnector = value;
		}

		public function get player():PlayerVo
		{
			return _player;
		}

		public function set player(value:PlayerVo):void
		{
			_player = value;
		}
		
		public function get partnerPlayer() : PlayerVo{
			return _partnerPlayer;
		}
		public function set partnerPlayer(value:PlayerVo) : void{
			_partnerPlayer = value;
		}

		public function get socketPlayer():Player
		{
			return _socketPlayer;
		}

		public function set socketPlayer(value:Player):void
		{
			_socketPlayer = value;
		}

		
	}
}