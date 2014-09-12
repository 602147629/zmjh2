var EventEmitter = require("events").EventEmitter;
var db = require("../../../db/DataBase.js");
var rcc = require("../../../controllor/RpcConnectorControllor.js")

function User(){
	EventEmitter.call(this);


    this.lastLogoutTime = 0;
    this.lastLoginTime = 0;
    this.loginTimes = 1;
    this.continueLoginDays = 0;
    this.totalLoginDays = 0;
    this.maxContinueLogindays = 0;
}

require('util').inherits(User, EventEmitter);

User.prototype.loginKey;//用于区分玩家是否重复登录的key
//User.prototype.gameKey;//游戏内用于区别玩家身份的key
User.prototype.key;//向gate验证登录的key
User.prototype.uid;//玩家uid(每次登录后User重新生成的，内存中用于区分玩家的uid)
User.prototype.platformUid;//玩家uid(平台uid)
User.prototype.serverId;//服务器区号id
User.prototype.gameServerId;//游戏场景服务器id
User.prototype.lastLoginTime;//上次登录时间
User.prototype.lastLogoutTime;//上次登出时间
User.prototype.loginTimes;//登录次数
User.prototype.continueLoginDays;//当前连续登录天数
User.prototype.totalLoginDays;//总登录天数
User.prototype.maxContinueLogindays;//历史最大连续登录天数


//
//User.prototype.getInfo = function(){
//	var buf = new Buffer(4);
//	buf.writeInt32LE(this.uid,0);
//
//	return buf;
//}


//存档use表
User.prototype.save = function(cb){
    var data = {
        "uid" : this.uid,
        "serverId" : this.serverId,
        "record" : this.getInfoJsonForRedis()
    };
    var self = this;
    rcc.BrocastByPath("Rediss","RMRedis","SaveUserData",data,function(err){
        if(err){
            //背包存档失败
            require("Log").error("帐号存档失败！data:"+JSON.stringify(data)+",err:"+err);
        }
        if(cb){
            cb();
        }
    });
}

//获取json格式玩家信息
User.prototype.getInfoJson = function(){
	return {
		"loginKey" : this.loginKey
	};
}

//获取json格式玩家信息，用户存入redis
User.prototype.getInfoJsonForRedis = function(){
    return {
        "uid" : this.uid,
        "serverId" : this.serverId,
        "lastLoginTime" : this.lastLoginTime,
        "lastLogoutTime" : this.lastLogoutTime,
        "loginTimes" : this.loginTimes,
        "continueLoginDays" : this.continueLoginDays,
        "totalLoginDays" : this.totalLoginDays,
        "maxContinueLogindays" : this.maxContinueLogindays
    };
}

User.prototype.getErrorSaveInfo = function(){
	return "User->getErrorSaveInfo loginKey:"+this.loginKey;
}



User.prototype.destroy = function(){
	
}

module.exports = User;