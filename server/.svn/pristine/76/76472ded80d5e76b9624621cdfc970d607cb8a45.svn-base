var keyClass = require('./Key.js');
var sm = require('../message/handler/sm/SMGame.js');
var comm = require('../const/common.js');
var EventEmitter = require("events").EventEmitter;


function Fb(){
	EventEmitter.call(this);

	this.keys = [];
	this.clients = [];
//    this.overClients = [];
	this.isStartAfterLoadint = false;
    this.si = -1;
    this.maxLoadingTimeIndex = -1;
    this.maxTimeoutTime = comm.FB_TIMEOUT;
    this.maxLoadingTime = comm.FB_LOADING_TIMEOUT;
    this.camps = {};
    this.accountedUidArr = [];

    //开始加载倒计时
    this.maxLoadingTimeIndex = setTimeout(this.byondLading.bind(this),this.maxLoadingTime);
}

require('util').inherits(Fb, EventEmitter);

//副本id
Fb.prototype.id;
//当前操作数组
Fb.prototype.keys;
//当前副本种类,与房间种类相同
Fb.prototype.type;
//当前玩家数组
Fb.prototype.clients;
//当前是否开始游戏(加载后真正开始游戏)
Fb.prototype.isStartAfterLoadint;
//副本超时时间(帧)
Fb.prototype.maxTimeoutTime;
//加载等待超时(秒)
Fb.prototype.maxLoadingTime;
//加载等待超时计时器索引
Fb.prototype.maxLoadingTimeIndex;
//玩家阵营数组
Fb.prototype.camps;
//已经结算了的uid数组
Fb.prototype.accountedUidArr;




const CAMP1 = '1';
const CAMP2 = '2';


//接受玩家操作，keyCode：按键code，如果为-1，则是特殊操作,oper,keyCode为-1的时候，2代表玩家离开
Fb.prototype.acceptOperation = function(uid,keyCode,oper){
	if(!this.isStartAfterLoadint){
		return;
	}
    this.acceptOperationForSelf(uid,keyCode,oper);
}


//接受操作，程序内部调用，非对外接口
Fb.prototype.acceptOperationForSelf = function(uid,keyCode,oper){
    var keylen = this.keys.length;
    var keyTemp;
    for(var i=0;i<keylen;i++){
        if(this.keys[i].uid == uid){
            keyTemp = this.keys[i];
            break;
        }
    }
    if(!keyTemp){
        keyTemp = new keyClass();
        keyTemp.uid = uid;
        keyTemp.keyCodes = [];
        keyTemp.opers = [];
        this.keys.push(keyTemp);
    }

    keyTemp.keyCodes.push(keyCode);
    keyTemp.opers.push(oper);
}

//某位玩家离开了副本(通过命令方式通知玩家,整合在操作集中)
Fb.prototype.playersLeft = function(uid){
	this.acceptOperationForSelf(uid,-1,comm.KeyOperationType.PLAYER_LEFT);
}
//增加玩家
Fb.prototype.addClient = function(client){
    if(this.clients.indexOf(client) != -1){
        require("Log").error("Fb->addClient() error!this client has in this Fb!");
        return;
    }
    client.user.fb = this;
	this.clients.push(client);
	client.user.fbLoadingComplete = false;

    //将玩家加入阵营
    if(this.type == 0){
        //单人匹配pk
        if(!this.camps[CAMP1]){
            this.camps[CAMP1] = [];
        }else if(!this.camps[CAMP2]){
            this.camps[CAMP2] = [];
        }
        if(this.camps[CAMP1].length == 0){
            this.camps[CAMP1].push(client.user);
        }else if(this.camps[CAMP2].length == 0){
            this.camps[CAMP2].push(client.user);
        }else{
            require("Log").error("玩家加入阵营出错！uid:"+client.user.uid);
        }

    }else if(this.type == 1){
        //普通组队闯关
        if(!this.camps[CAMP1]){
            this.camps[CAMP1] = [];
        }

        this.camps[CAMP1].push(client.user);
    }
}

//移除某个玩家
Fb.prototype.removeClient = function(client){
	var idx = this.clients.indexOf(client);
	if(idx != -1){
		this.clients.splice(idx,1);
        //以命令形式通知其他玩家，有玩家离开
        client.user.fb.playersLeft(client.user.uid);
        client.user.fb = null;
        client.user.fbLoadingComplete = false;

        //还没开始游戏的时候，玩家离开，踢出阵营
        if(!this.isStartAfterLoadint){
            var idx1 = -1;
            var idx2 = -1;
            if(this.camps[CAMP1]){
                idx1 = this.camps[CAMP1].indexOf(client.user);
                this.camps[CAMP1].splice(idx1,1);
            }
            if(this.camps[CAMP2]){
                idx2 = this.camps[CAMP2].indexOf(client.user);
                this.camps[CAMP2].splice(idx2,1);
            }
        }


		if(this.currentPlayersLen() === 0){
			//销毁
			this.emit('destroy',this);
		}else{
            //已经开始游戏了，有玩家退出
            if(this.type == 0){
                //单人匹配pk模式
                if(this.accountedUidArr.indexOf(client.user.uid) != -1){
                    //这个退出的玩家，已经结算过了。正常，不做处理

                }else{
                    //半路逃跑的玩家,另外一个人胜利
                    var winClient = this.clients[0];
                    if(this.accountedUidArr.indexOf(client.user.uid) == -1){
                        require("Log").info("单人PK，玩家uid:"+client.user.uid+",pid:"+client.user.pid+" 半路逃跑，判负!");
                    }
                    if(this.accountedUidArr.indexOf(winClient.user.uid) == -1){
                        require("Log").info("单人PK，玩家uid:"+winClient.user.uid+",pid:"+winClient.user.pid+" 由于对方逃跑，胜利!");
                    }
                    this.GameOverByUid(winClient.user,1);
                    //退出的人算输
                    this.GameOverByUid(client.user,0);
                }
            }
            if(!this.isStartAfterLoadint){
                //还没开始游戏,检查其他玩家的加载情况
                this.checkLoading();
            }
        }
		return true;
	}
	require("Log").error('Fb->removeClient error!not this client in fb!uid:'+client.user.uid);
	return false;
}

//某个玩家加载完毕
Fb.prototype.loadingComplete = function(client){
	client.user.fbLoadingComplete = true;
	this.checkLoading();
}

//加载等待超时
Fb.prototype.byondLading = function(){
    var self = this;
    this.clients.forEach(function(client){
        //移除未加载完成的玩家
        if(client.user.fbLoadingComplete == false){
            client.send(sm.ByondLoading());
            self.removeClient(client);
        }
    })
}


//检查玩家是否都加载完毕（1：有玩家发送加载完毕上来，2：有玩家退出）
Fb.prototype.checkLoading = function(){
    if(this.isStartAfterLoadint){
        return;
    }
    var len = this.clients.length;
    for(var i=0;i<len;i++){
        var c = this.clients[i];
        if(c.user.fbLoadingComplete == false){
            //有人还未加载完
            return;
        }
    }
    this.start();
}

//真正开始游戏
Fb.prototype.start = function(){
    require("Log").trace("玩家全部加载完毕！游戏开始");
    if(this.isStartAfterLoadint){
        return;
    }
    //统统加载完毕
    this.isStartAfterLoadint = true;
    //清除加载超时倒计时
    clearTimeout(this.maxLoadingTimeIndex);
    if(this.si == -1){
        //发送游戏开始
        this.brocast(sm.StartGameAfterLoading());
        var enterframe = this.step.bind(this);
        this.si = setInterval(enterframe,33);
    }
}

//返回当前副本内玩家数量
Fb.prototype.currentPlayersLen = function(){
	return this.clients.length;
}

Fb.prototype.step = function(){
	if(!this.isStartAfterLoadint){
		return;
	}
    if(this.maxTimeoutTime > 0){
        this.maxTimeoutTime--;
        if(this.maxTimeoutTime === 0){
            //广播
            this.brocast(sm.FbTimeout());
            //结算
            if(this.type == 0){
                //单人匹配pk,时间到，都算输
                var self = this;
                require("SuperUtils").forEachInArray(this.camps,function(camp,key){
                    Object.keys(camp).forEach(function(user){
                        if(this.accountedUidArr.indexOf(user.uid) == -1){
                            require("Log").info("单人PK，玩家uid:"+user.uid+",pid:"+user.pid+" 时间到，判负!");
                        }
                        self.GameOverByUid(user,0);
                    });
                });
            }

            //超时,结束副本
           this.emit("destroy",this);
            return;
        }
    }
	//计算总操作命令长度
	var totalLen = 0;
    var comLen = this.keys.length;


    var keyTemp;
    var keyLen;
    for(var m=0;m<comLen;m++){
        keyTemp = this.keys[m];
        totalLen += 6;
        keyLen = keyTemp.keyCodes.length;
        for(var n=0;n<keyLen;n++){
            totalLen += 4;
        }
    }


	var command = new Buffer(totalLen);
	var offfset = 0;
	for(var j=0;j<comLen;j++){
		keyTemp = this.keys[j];
		keyLen = keyTemp.keyCodes.length;
		command.writeInt16LE(4+keyLen*8,offfset);//数据长度
		offfset += 2;
		command.writeInt32LE(keyTemp.uid,offfset);//uid
		offfset += 4;

		for(var i=0;i<keyLen;i++){
			var keyCode = keyTemp.keyCodes[i];
			var oper = keyTemp.opers[i];
			command.writeInt16LE(keyCode,offfset);//操作keycode
			offfset += 2;
			command.writeInt16LE(oper,offfset);//操作类型
			offfset += 2;
		}
	}
	this.brocast(sm.SendOperation(command));

    this.destroyKeys();
}

////某个玩家发来游戏结束
//Fb.prototype.gameOver = function(client){
////    if(this.overClients.indexOf(client) == -1){
////        this.overClients.push(client);
////
////        //判定副本是否结束
////        var isFbOver = true;
////        var self = this;
////        this.clients.forEach(function(c){
////            if(self.overClients.indexOf(c) == -1){
////                isFbOver = false;
////            }
////        });
////        if(isFbOver){
////            //副本结束
////            this.emit("destroy",this);
////        }
////    }
//    this.removeClient(client);
//}

//某个玩家发上来他游戏结束了
Fb.prototype.PlayerSendGameOver = function(data,client){
    require("Log").trace("=================PlayerSendGameOver=====================");
    var result = data.result;//结果
    var totalFrames = data.totalFrames;//游戏结束时的帧数

    var idx = this.clients.indexOf(client);
    if(idx != -1){
        //发送游戏结束的玩家还在副本内
        if(this.type == 0){
            //单人匹配pk
            if(this.accountedUidArr.indexOf(client.user.uid) == -1){
                require("Log").info("单人PK，玩家uid:"+client.user.uid+",pid:"+client.user.pid+" 客户端发送结果!result:"+result);
            }
            this.GameOverByUid(client.user,result);
        }
    }
}

//判定游戏结局
Fb.prototype.GameOverByUid = function(user,result){
    if(this.accountedUidArr.indexOf(user.uid) != -1){
        //这个玩家已经结算过了
        return;
    }
    require("Log").trace("=================GameOverByUid=================");
    var data;
    var wincamp = "";//胜利的阵营
    var losecamp = "";//失败的阵营
    var camps = {};

    require("SuperUtils").forEachInArray(this.camps,function(camp,key){
        if(camp.indexOf(user) != -1){
            //这个阵营胜利了
            if(result == 1){
                //win
                wincamp = key;
            }else{
                //lose
                losecamp = key;
            }
        }
        //统计阵营的uid
        camps[key] = [];
        Object.keys(camp).forEach(function(k){
            camps[key].push({
                "uid" : camp[k].uid,
                "pid" : camp[k].pid
            });
        });
    });

    if(wincamp != "" || losecamp != ""){
        data = {
            "uid" : user.uid,
            "pid" : user.pid,
            "type" : this.type,
            "wincamp" : wincamp,
            "losecamp" : losecamp,
            "camps" : camps
        }
        //提交结算
        this.emit('account',data);

        this.accountedUidArr.push(user.uid);
    }else{
        require("Log").error("GameOverByUid error!uid:"+user.uid+",result:"+result);
    }
}


//副本内广播
Fb.prototype.brocast = function(buffer){
	this.clients.forEach(function(client){
		client.send(buffer);
	});
}

//副本内广播除了某个uid
Fb.prototype.brocastExceptUid = function(uid,buffer){
	this.clients.forEach(function(client){
		if(client.user.uid != uid){
			client.send(buffer);
		}
	});
}


Fb.prototype.destroyKeys = function(){
    this.keys.forEach(function(key){
        key.destroy();
    });
    this.keys.length = 0;
}


Fb.prototype.destroy = function(){
    if(this.si != -1){
        clearInterval(this.si);
    }
    if(this.maxLoadingTimeIndex != -1){
        clearTimeout(this.maxLoadingTimeIndex);
    }
    if(this.clients){
        this.clients.forEach(function(client){
            if(client.user){
                client.user.fb = null;
                client.user.fbLoadingComplete = false;
            }
        })
        this.clients.length = 0;
        this.clients = null;
    }
//    if(this.overClients){
//        this.overClients = null;
//    }
	if(this.keys){
        this.destroyKeys();
        this.keys = null;
    }

	this.removeAllListeners();
}


module.exports = Fb;