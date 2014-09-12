var EventEmitter = require("events").EventEmitter;

function User(){
	EventEmitter.call(this);

    this.loginTimes = 1;
    this.gameServerId = -1;
}

require('util').inherits(User, EventEmitter);

User.prototype.gameKey;//玩家gameKey
User.prototype.index;//房间内的索引(用于区分副本内玩家的操作命令)
User.prototype.key;//房间key
User.prototype.gameServerId;//玩家所在game服务器id

User.prototype.room;//房间索引
User.prototype.fb;//副本索引
User.prototype.data;//玩家数据



//
//User.prototype.getInfo = function(){
//	var buf = new Buffer(4);
//	buf.writeInt32LE(this.uid,0);
//
//	return buf;
//}

//获取json格式玩家信息
User.prototype.getInfoJson = function(){
	return {
		"loginKey" : loginKey
	};
}

User.prototype.getErrorSaveInfo = function(){
	return "User->getErrorSaveInfo gameKey:"+this.gameKey;
}



User.prototype.destroy = function(){
	this.fb = null;
    this.room = null;
    this.data = null;
}

module.exports = User;