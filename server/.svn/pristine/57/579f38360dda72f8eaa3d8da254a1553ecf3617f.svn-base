var EventEmitter = require("events").EventEmitter;
var pControllorClass = require('../controllor/PropertyControllor.js');
var eControllorClass = require('../controllor/EquipmentControllor.js');
var bControllorClass = require('../controllor/BagControllor.js');
var sControllorClass = require("../controllor/SaveControllor.js");
var rcc = require("../../../controllor/RpcConnectorControllor.js");
var db = require("../../../db/DataBase.js");


function Player(){
	EventEmitter.call(this);

	this.loginTime = 0;
    this.logoutTime = 0;
    this.loginTimes = 0;
    this.continueLoginTime = 0;
	this._name = "default";
	this.exp = 0;

	var self = this;

	this.propertyControllor = new pControllorClass();

	this.bagControllor = new bControllorClass();
    this.bagControllor.on("SAVE",function(){
        self.saveControllor.doSave("BAG");
    });

	this.equipControllor = new eControllorClass();
	//装备更改事件
	this.equipControllor.on('change',function(equipVo){
		self.propertyControllor.updateEquip(equipVo);
	});

    //存档管理器
    this.saveControllor = new sControllorClass();
    this.saveControllor.on("BAG",function(){
        self.currentSaveNums ++;
        //存档背包
        var data = {
            "gameKey" : self.gameKey,
            "record" : self.bagControllor.getItemsJsonInfoForRedis()
        };
        rcc.BrocastByPath("Rediss","RMRedis","SaveBagData",data,function(err){
            if(err){
                //背包存档失败
                require("Log").error("背包存档失败！gameKey:"+self.gameKey+",data:"+self.bagControllor.getItemsJsonInfo()+",err:"+err);
            }
            self.currentSaveNums --;
            self.checkSaveComplete();
        });
    });

    this.saveControllor.on("PLAYER",function(){
        self.currentSaveNums ++;
        var pid = parseInt((self.gameKey.split("|")).pop());
        //存档角色
        var data = {
            "loginKey" : self.loginKey,
            "pid" : pid,
            "record" : self.getInfoJsonForRedis()
        };
        rcc.BrocastByPath("Rediss","RMRedis","SavePlayerData",data,function(err){
            if(err){
                //角色存档失败
                require("Log").error("角色存档失败！data:"+self.getInfoJson()+",err:"+err);
            }
            self.currentSaveNums --;
            self.checkSaveComplete();
        });
    })
    //初始化等级
    this.level = 1;

    this.roomId = -1;
    this.roomServerId = -1;
    this.currentSaveNums = 0;
    this.loginState = 0;
    this.roomJoinCooldown = false;
    this.isLoginComplete = false;
    this.roomJoinCooldownSI = -1;
}

require('util').inherits(Player, EventEmitter);

Player.prototype.isReadComplete;//是否从数据库中赋值完毕（赋值完毕后，某些值的改变会引发存档）
Player.prototype.currentSaveNums;//当前正在存档的数目（用于判定所有存档均完成）


Player.prototype.loginKey;//用于区分玩家是否重复登录的key
Player.prototype.gameKey;//游戏内用于区别玩家身份的key
Player.prototype.pid;//玩家角色id（多角色使用）
Player.prototype.index;//角色相对索引(相对玩家所有角色的索引)
Player.prototype._level;//角色等级
Player.prototype._exp;//角色当前经验
Player.prototype._name;//角色名

Player.prototype.loginState;//角色登录阶段(0:开始,1:创建角色（选择老角色则跳过这个阶段）,2:读取bag表,3:读取offline表,4:完成)


Player.prototype.roomId;//所在房间
Player.prototype.roomServerId;//所在房间的fb进程id
Player.prototype.roomJoinCooldown;//成功加入房间冷却(每当成功加入房间，则有10秒cd，防止玩家没有连接上副本，导致无法再次进入副本)
Player.prototype.roomJoinCooldownSI;//加入房间冷却计时器索引
Player.prototype.line;//所在线

Player.prototype.propertyControllor;//玩家属性管理
Player.prototype.equipControllor;//玩家装备管理
Player.prototype.bagControllor;//玩家背包管理
Player.prototype.saveControllor;//存档管理


Player.prototype.loginTime;//登录时间
Player.prototype.logoutTime;//登出时间
Player.prototype.loginTimes;//登入次数，为零则是新玩家
Player.prototype.continueLoginTime;//累计在线时间（毫秒数）

Player.prototype.isLoginComplete;//是否完成了登录流程


Player.prototype.playerData;//客户端发上来的玩家数据


//等级
Player.prototype.__defineGetter__('level',function(){
	return this._level;
});
Player.prototype.__defineSetter__('level',function(v){
    if(this._level != v){
        this.save();
    }
	this._level = v;

	//计算属性
	this.propertyControllor.updateBase(v);
});

//经验
Player.prototype.__defineGetter__('exp',function(){
    return this._exp;
});
Player.prototype.__defineSetter__('exp',function(v){
    if(this._exp != v){
        this.save();
    }
    this._exp = v;
});

//角色名
Player.prototype.__defineGetter__('name',function(){
    return this._name;
});
Player.prototype.__defineSetter__('name',function(v){
    if(this._name != v){
        this.save();
    }
    this._name = v;
});


//读档初始化
Player.prototype.initWithData = function(results){
    this.gameKey = results.loginKey + "|" + results.pid;
    this._name = results.name;

//    this.serverId = results.serverId;
    this.pid = results.pid;
    this._level = results.level;
    this._exp = results.exp;
    this.loginTimes = results.loginTimes+1;
    this.continueLoginTime = results.continueLoginTime;


    //计算属性
    this.propertyControllor.updateBase(this._level);
}

Player.prototype.checkSaveComplete = function(){
    if(this.currentSaveNums == 0){
        this.emit("AllSaveComplete");
    }
}

Player.prototype.save = function(){
    if(this.isReadComplete){
        this.saveControllor.doSave("PLAYER");
    }
}

//进入加入房间冷却中（防止玩家成功加入房间，但是不加入，不断的申请加入）
Player.prototype.intoRoomJoinCoolDown = function(){
    clearTimeout(this.roomJoinCooldownSI);
    this.roomJoinCooldown = true;
    this.roomJoinCooldownSI = setTimeout(function(self){
        self.roomJoinCooldown = false;
    },10000,this);
}

//进入了房间
Player.prototype.joinRoom = function(roomId,roomServerId){
    clearTimeout(this.roomJoinCooldownSI);
    //清除加入房间冷却
    this.roomJoinCooldown = false;

    this.roomId = roomId;
    this.roomServerId = roomServerId;
}

//离开了房间
Player.prototype.leftRoom = function(){
    this.roomId = -1;
    this.roomServerId = -1;
}



Player.prototype.addExp = function(value){
	var nextLevelExp = function(level){
		return 100*level;
	}

	this._exp += value;
	//计算升级
	var nle = nextLevelExp(this.level)
    var lvUpVal = 0;
	while(this._exp >= nle){
		this._exp -= nle;
        lvUpVal++;
		nle = nextLevelExp(this.level+lvUpVal);
	}
	if(lvUpVal > 0){
        this._level += lvUpVal;
		this.emit('upgrade',this);
	}

    //提交存档
    this.save();
}


//获取json格式玩家信息
Player.prototype.getInfoJson = function(){
	return {
		"gameKey" : this.gameKey,
		"name" : this.name,
		"index" : this.index,
		"level" : this.level,
		"exp" : this.exp,
		"property" : this.propertyControllor.propertyVo.getJsonInfo()
	};
}


//获取json格式玩家信息,用户存入redis
Player.prototype.getInfoJsonForRedis = function(){
    return {
//        "uid" : this.uid,
//        "serverId" : this.serverId,
        "loginKey" : this.loginKey,
        "pid" : this.pid,
        "lastLoginTime" : this.loginTime,
        "lastLogoutTime" : this.logoutTime,
        "continueLoginTime" : this.continueLoginTime + (this.logoutTime - this.loginTime),
        "loginTimes" : this.loginTimes,
        "level" : this.level,
        "name" : this.name,
        "exp" : this.exp
    }
}


//获取json格式玩家信息(登录时)
Player.prototype.getInfoJsonInLogin = function(){
    return {
        "gameKey" : this.gameKey,
        "name" : this.name,
        "level" : this.level
    };
}

//获取json格式玩家信息(房间内)
Player.prototype.getInfoJsonInRoom = function(){
    return {
        "gameKey" : this.gameKey,
        "name" : this.name
    };
}


Player.prototype.getErrorSaveInfo = function(){
	return this.getInfoJson();
}

Player.prototype.destroy = function(){
	this.removeAllListeners();
	this.line = null;
	if(this.propertyControllor){
		this.propertyControllor.destroy();
		this.propertyControllor = null;
	}
	
	if(this.bagControllor){
		this.bagControllor.destroy();
		this.bagControllor = null;
	}
	
	if(this.equipControllor){
		this.equipControllor.destroy();
		this.equipControllor = null;
	}
    if(this.saveControllor){
        this.saveControllor.destroy();
        this.saveControllor = null;
    }
    this.playerData = null
}

module.exports = Player;