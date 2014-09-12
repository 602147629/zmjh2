var seatClass = require('./Seat.js');
var cdc = require("../../../controllor/ConfigDataControllor.js")
var EventEmitter = require("events").EventEmitter;
var comm = require("../const/common.js");

function Room(){
    EventEmitter.call(this);

    this.seats = [];
    this.id;
    this.maxChildren = 2;
    this.currentChildren = 0;
    this.key = parseInt(Math.random()*1000000);
    this.autoDestroyIndex = -1;
    this.isAutoStartWhenFull = false;
    this.isDestroy = false;
}

require('util').inherits(Room, EventEmitter);

// Room.prototype.__defineGetter__('players',function(){
// 	return this._players;
// });
// Room.prototype.__defineSetter__('players',function(v){
// 	this._players = v;
// });

Room.prototype.type;//房间种类（0：自动匹配pk，1：自由房间）
//座位数组
Room.prototype.seats;
//id
Room.prototype.id;
//对应副本变量
Room.prototype.fb;
//最多成员数目
Room.prototype.maxChildren;
//当前成员数目
Room.prototype.currentChildren;
//加入密钥
Room.prototype.key;
//自动销毁副本索引
Room.prototype.autoDestroyIndex;
//人满是否自动开始
Room.prototype.isAutoStartWhenFull;
//是否已经销毁
Room.prototype.isDestroy;


//初始化
Room.prototype.init = function(){
    var seat;
    for(var i=0;i<this.maxChildren;i++){
        seat = new seatClass();
        seat.index = i;
        this.seats[i] = seat;
    }

    var self = this;

    //房间信息发生变化
    this.emit('roomChanged',this);

    //5秒内没有玩家加入，则自动销毁副本
    this.autoDestroyIndex = setTimeout(function(){
        self.emit("destroy",this);
    },comm.ROOM_AUTO_DESTROY_TIME);
}

//增加一个成员
Room.prototype.addClient = function(client,cb){
    if(this.fb){
        require("Log").error("这个房间已经开始游戏！");
        //已经开始游戏
        if(cb){
            cb('GAME_HAS_START');
        }
        return;
    }
    if(this.currentChildren >= this.maxChildren){
        //人数已满
        require("Log").error("人数已经满了！");
        if(cb){
            cb('ROOM_FULL');
        }
        return;
    }

    //清除自动销毁副本计时器
    if(this.autoDestroyIndex != -1){
        clearTimeout(this.autoDestroyIndex);
    }

    //搜索空余的索引
    var seat;
    for(var i=0;i<this.maxChildren;i++){
        seat = this.seats[i];
        if(seat.client == null){
            seat.client = client;
            seat.client.user.room = this;
            break;
        }
    }

    this.currentChildren++;

    //有玩家加入
    this.emit("UserIntoRoom",client);

    //房间信息发生变化
    this.emit('roomChanged',this);


    //判定自动开始
    if(this.isAutoStartWhenFull){
        if(this.currentChildren == this.maxChildren){
            this.emit("autoStart");
        }
    }

    if(cb){
        cb(null);
    }
}

//移除一个成员
Room.prototype.removeClient = function(client,cb){
    var s = this.getSeatByGameKey(client.user.gameKey);
    if(!s){
        //该玩家不在这个房间内
        if(cb){
            cb('NOT_IN_THIS_ROOM');
        }
    }else{
        s.client.user.room = null;
        s.client = null;
        this.currentChildren--;

        this.emit("UserOutFromRoom",client);

        //房间信息发生变化
        this.emit('roomChanged',this);

        if(this.isEmpty()){
            //销毁
            this.emit('destroy',this);
        }
        if(cb){
            cb(null);
        }
    }
}

//获取所有的玩家客户端对象
Room.prototype.getAllClients = function(){
    var result = [];
    var len = this.seats.length;
    for(var i=0;i<len;i++){
        var seat = this.seats[i];
        if(seat.client){
            result.push(seat.client);
        }
    }
    return result;
}

//获取房间玩家人数
Room.prototype.playersLen = function(){
    return this.currentChildren;
}

//是否是空房间
Room.prototype.isEmpty = function(){
    return this.currentChildren==0;
}

//是否是满房间
Room.prototype.isFull = function(){
    return this.currentChildren == this.maxChildren;
}

//是否可以加入
Room.prototype.canJoin = function(){
    return !this.isFull() && !this.fb && !this.isDestroy;
}


//是否让玩家看到这个房间
Room.prototype.canSee = function(){
    //已经开始的房间、自动匹配pk房间、空房间、销毁的房间不让玩家看到
    return this.type != 0 && !this.fb && this.currentChildren == 0 && !this.isDestroy;
}


//获取房间内所有玩家的玩家数据
Room.prototype.getPlayerDatas = function(){
    var json = [];
    var cb = function(seat){
        if(seat.client){
            var data = {
                "data" : seat.client.user.data,
                "index" : seat.client.user.index,
                "gameKey" : seat.client.user.gameKey
            }
            json.push(data);
        }
    }

    require("SuperUtils").forEachInArray(this.seats,cb);

    return json;
}


//获取房间信息
Room.prototype.getRoomJsonInfo = function(){
    var seatsJson = [];
    var cb = function(seat){
        if(seat.client){
            seatsJson.push(seat.getJsonInfo());
        }
    }

    require("SuperUtils").forEachInArray(this.seats,cb);

    return {
        "id" : this.id,
        "seats" : seatsJson,
        "type" : this.type,
        "isFight" : (this.fb?1:0),
        "maxChildren" : this.maxChildren,
        "current" : this.currentChildren,
        "serverId" : cdc.ServerConfig.id
    };
}


Room.prototype.getSeatByGameKey = function(gameKey){
    var seat;
    for(var i=0;i<this.maxChildren;i++){
        seat = this.seats[i];
        if(seat.client && seat.client.user.gameKey == gameKey){
            return seat;
        }
    }
    return null;
}


Room.prototype.startFb = function(fb){
    this.fb = fb;
    var self = this;

    //副本销毁（结束）
    this.fb.on("destroy",function(){
        self.onFbDestroy.bind(self)();
    })
    this.emit("roomChanged",this);
}

Room.prototype.onFbDestroy = function(){
    this.fb = null;
    this.emit("roomChanged",this);


    //如果是单人匹配pk，自动销毁房间
    if(this.type === 0){
        this.emit('destroy');
    }
}



//房间内广播
Room.prototype.brocast = function(buffer){
    var cb = function(seat){
        if(seat.client){
            seat.client.send(buffer);
        }
    }

    require("SuperUtils").forEachInArray(this.seats,cb);
}


//销毁
Room.prototype.destroy = function(){
    if(this.isDestroy){
        return;
    }
    this.isDestroy = true;
    var self = this;
    if(this.seats){
        var cb = function(seat){
            //销毁的时候房间还有人，踢掉(自动匹配的房间)
            if(seat.client){

                self.emit("UserOutFromRoom",seat.client);

                if(seat.client.user){
                    if(seat.client.user.room){
                        seat.client.user.room = null;
                    }
                }
            }
            seat.destroy();
        }
        require("SuperUtils").forEachInArray(this.seats,cb);

        this.seats.length = 0;
        this.seats = null;
    }
    this.fb = null;
    this.removeAllListeners();
}



module.exports = Room;