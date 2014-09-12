var EventEmitter = require("events").EventEmitter;

function Seat(){
	EventEmitter.call(this);

	this.index = 0;
}

require('util').inherits(Seat, EventEmitter);

Seat.prototype.client;
Seat.prototype.index;

//获取玩家信息-发给客户端使用
Seat.prototype.getJsonInfo = function(){
	return {
		"index" : this.index,
		"gameKey" : (this.client?this.client.user.gameKey:null)
	};
}

//销毁
Seat.prototype.destroy = function(){
    this.client = null;
}

module.exports = Seat;