package com.test.game.Mvc.Vo{
	import com.superkaka.game.Base.BaseVO;
	import com.test.game.Manager.MyUserManager;
	
	public class Room extends BaseVO{
		private var _id:int;
		private var _maxChildren:int;//最多玩家数目
		private var _isFight:Boolean;//是否已经开始游戏
		private var _seats:Vector.<Seat>;
		
		public function Room(){
			super();
			
		}
		
		public function init():void{
			_seats = new Vector.<Seat>();
		}
		
		/**
		 * 根据更新玩家数据
		 * @param user
		 * @param index
		 * 
		 */		
		public function updateSeat(seat:Seat):void{
			var len:uint = _seats.length;
			for(var i:uint=0;i<len;i++){
				var s:Seat = _seats[i];
				if(s.index == seat.index){
					//替换
					_seats[i] = seat;
					return;
				}
			}
			//新增
			_seats.push(seat);
		}
		
		/**
		 * 获取房间内玩家人数 
		 * @return 
		 * 
		 */		
		public function GetUsersLen():int{
			return _seats.length;
		}
		
		
		public function getInfo():String{
			var str:String = "第："+this.id+"房间\n";
			for each(var seat:Seat in _seats){
				str += "gameKey:"+seat.player.gameKey;
				if(seat.player.gameKey == MyUserManager.getIns().player.gameKey){
					//我自己
					str += "(我)\n";
				}else{
					//别人
					str += "\n";
				}
			}
			return str;
		}
		
		/**
		 * 根据uid获取座位信息 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getSeatByUid(gameKey:String):Seat{
			for each(var seat:Seat in _seats){
				if(seat.player.gameKey == gameKey){
					return seat;
				}
			}
			return null;
		}
		
		
		/**
		 * 获取房间玩家数组 
		 * @return 
		 * 
		 */		
		public function getUserVec():Vector.<PlayerVo>{
			var vec:Vector.<PlayerVo> = new Vector.<PlayerVo>();
			for each(var seat:Seat in _seats){
				if(seat.player){
					vec.push(seat.player);
				}
			}
			return vec;
		}
		
		
		
		/**
		 * 获取房间座位数组 
		 * @return 
		 * 
		 */		
		public function getSeatVec():Vector.<Seat>{
			var vec:Vector.<Seat> = new Vector.<Seat>();
			for each(var seat:Seat in _seats){
				vec.push(seat);
			}
			return vec;
		}
		
		
		public function destroy():void{
			for each(var seat:Seat in _seats){
				seat.destroy();
			}
			this._seats = null;
		}
		
		
		
		

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get seats():Vector.<Seat>
		{
			return _seats;
		}

		public function get maxChildren():int
		{
			return _maxChildren;
		}

		public function set maxChildren(value:int):void
		{
			_maxChildren = value;
		}

		public function get isFight():Boolean
		{
			return _isFight;
		}

		public function set isFight(value:Boolean):void
		{
			_isFight = value;
		}


	}
}