var EventEmitter = require("events").EventEmitter;
var smPlayer = require("../message/handler/sm/SMPlayer.js");


function Line(){
	EventEmitter.call(this);
	this.clients = [];
	this.current = 0;
    this.isHide = false;

    this.onPlayerUpgradeBind = this.onPlayerUpgrade.bind(this);
}

require('util').inherits(Line, EventEmitter);


Line.prototype.id;//id
Line.prototype.name;//名称
Line.prototype.max;//玩家上限
Line.prototype.isHide;//是否隐藏（可以动态更新配置来隐藏某些线,但不影响广播等功能，只是客户端看不到）
Line.prototype.current;//当前玩家人数
Line.prototype.clients;//玩家列表



//新增一个玩家
Line.prototype.addClient = function(client,cb){
    if(!client.currentPlayer){
        if(cb){
            cb('NOT_PLAYER');
        }
        return;
    }
	if(!this.clients[client.currentPlayer.gameKey]){
        if(this.current >= this.max){
            require("Log").error("本线已经满了");
            //通知玩家该线已经满了
//            client.send(sm.ChooseLineFull());

            if(cb){
                cb('NOW_FULL');
            }
            return;
        }

		this.clients[client.currentPlayer.gameKey] = client;

		client.currentPlayer.line = this;

        //广播升级
        client.on("playerUpgrade",this.onPlayerUpgradeBind);

		this.current++;

        require("Log").trace("玩家:"+client.currentPlayer.gameKey+"加入了"+this.id+"线，本线当前人数："+this.current);
        if(cb){
            cb(null);
        }
	}else{
        //此处通知玩家
		require("Log").error('您当前已经在这个线中:'+client.currentPlayer.gameKey);
        if(cb){
            cb('ALREADY_IN_THIS_LINE');
        }
	}
}

//当玩家升级时，广播给本线所有玩家
Line.prototype.onPlayerUpgrade = function(player){
    this.brocast(smPlayer.UpgradeLevelTo(player.gameKey,player.level));
}

//移除
Line.prototype.removeClient = function(client,cb){
    if(!client.currentPlayer){
        if(cb){
            cb('NOT_PLAYER');
        }
        return;
    }
	if(this.clients[client.currentPlayer.gameKey]){
        if(client.currentPlayer.line){
            client.currentPlayer.line = null;
        }
		delete this.clients[client.currentPlayer.gameKey];
		this.current--;

        require("Log").trace("玩家:"+client.currentPlayer.gameKey+"离开了"+this.id+"线，本线当前人数："+this.current);
        //广播升级
        client.removeListener("playerUpgrade",this.onPlayerUpgradeBind);

        if(cb){
            cb('null');
        }
	}else{
        require("Log").error('Line->removePlayer error!gameKey:%d not in this line!lineId:%d',client.currentPlayer.gameKey,this.id);
        if(cb){
            cb('NOT_IN_THIS_LINE');
        }
	}
}

//根据uid获取client
Line.prototype.getClientByUid = function(gameKey){
	return this.clients[gameKey];
}

//广播
Line.prototype.brocast = function(buffer){
    var cb = function(client){
        client.send(buffer);
    }
    require("SuperUtils").forEachInArray(this.clients,cb);
}

Line.prototype.brocastExceptUid = function(buffer,gameKey){
    var cb = function(client){
        if(client.user.gameKey != gameKey){
            client.send(buffer);
        }
    }
    require("SuperUtils").forEachInArray(this.clients,cb);
}

////获取本线所有玩家数据
//Line.prototype.getAllPlayersJson = function(){
//	var players = [];
//
//    var cb = function(client){
//        players.push(client.currentPlayer.getInfoJson());
//    }
//    require("SuperUtils").forEachInArray(this.clients,cb);
//
//	return {
//		"players" : players
//	};
//}

//获取本线登录的时候所有玩家数据
Line.prototype.getAllPlayersJsonInLogin = function(){
    var players = [];

    var cb = function(client){
        players.push(client.currentPlayer.getInfoJsonInLogin());
    }

    require("SuperUtils").forEachInArray(this.clients,cb);

    return {
        "players" : players
    };
}


//获取玩家信息-发给客户端使用
Line.prototype.getJsonInfo = function(){
	return {
		"id" : this.id,
		"name" : this.name,
		"max" : this.max,
		"current" : this.current
	};
}

module.exports = Line;