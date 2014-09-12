var smPlayer = require("./message/handler/sm/SMPlayer.js");

var simpleClientClass = require("./../../net/SimpleClient.js");


var lc = require("./controllor/LineControllor.js");
var loginc = require("./controllor/LoginControllor.js");
var pControlClass = require("./../../controllor/ProtocalControllor.js");
var cdc = require("../../controllor/ConfigDataControllor.js");


var EventEmitter = require('events').EventEmitter;

var comm = require("./const/common.js")


//用于和客户端映射的类，每个客户端（socket）对应一个这样的对象
function GameClient(socket,msgFiles) {
    simpleClientClass.call(this,socket);

    //文件加载器
    this.msgFiles = msgFiles;

    this.pControl = new pControlClass([3,3,5,6,7,2,2],[2,2,3,7,2,5,8]);

    this.players = [];
    this.onUpgradeBind = this.onUpgrade.bind(this);

    this.timeoutTime = comm.CLIENT_TIMEOUT;
    this.type = 'CLIENT';

    var self = this;

    //连接上后X秒内没有发送登录信息，直接断开
    this.loginTimeoutIndex = setTimeout(function(){
        require("Log").info("连接后未即时发送登录消息，踢掉！");
        self.destroy();
    },30000);
}

require('util').inherits(GameClient,simpleClientClass);

GameClient.prototype.user;//用户信息
GameClient.prototype.players;//玩家角色数组
GameClient.prototype._currentPlayer;//当前角色
GameClient.prototype.pControl;//加密解密key


GameClient.prototype.__defineGetter__('currentPlayer',function(){
	return this._currentPlayer;
});
GameClient.prototype.__defineSetter__('currentPlayer',function(v){
    if(this._currentPlayer){
        this._currentPlayer.destroy();
    }
	this._currentPlayer = v;

    //玩家升级
    if(this._currentPlayer){
        this._currentPlayer.on('upgrade',this.onUpgradeBind);
    }
});

//执行登录
GameClient.prototype.doLogin = function(){
    clearTimeout(this.loginTimeoutIndex);
}

GameClient.prototype.onUpgrade = function(player){
//    //广播升级
//    this.brocast(smPlayer.UpgradeLevelTo(client.user.uid,client.currentPlayer.level));
    this.emit("playerUpgrade",player);
    //告诉客户端玩家属性变化
    this.send(smPlayer.PlayerProperty(player.propertyControllor.propertyVo));
}


//当收到过大的数据的时候
GameClient.prototype.onPackageTooLarge = function(dlen){
    var loginKey = "NO";
    if(this.user){
        loginKey = this.user.loginKey;
    }
    require("Log").error("收到过大的包！loginKey:"+loginKey+",dlen:"+dlen);
    this.destroy();
}


GameClient.prototype.doWhenQuit = function(){
    require("Log").trace("=============doWhenQuit============this.isQuit:"+this.isQuit);
    if(this.isQuit){
        return;
    }
    this.isQuit = true;

    clearTimeout(this.loginTimeoutIndex);

    var self = this;

    //从所有人数组中删除(只有对已经开始登录的玩家才进行此项操作)
    if(this.isStartLogin){
        loginc.RemoveClient(this);
    }


    if(this.user){
        this.user.lastLogoutTime = new Date().getTime();

        var daysBetween = require("SuperUtils").daysBetween(this.user.lastLoginTime,this.user.lastLogoutTime);
        if(daysBetween > 1){
            var addDays = daysBetween - 1;
            this.user.totalLoginDays += addDays;
            this.user.continueLoginDays += addDays;
            if(this.user.maxContinueLogindays < this.user.continueLoginDays){
                this.user.maxContinueLogindays = this.user.continueLoginDays
            }
        }
    }

    if(this.currentPlayer){
        //只对登录完成的人进行角色相关存档
        if(this.currentPlayer.isLoginComplete){
            //记录登出时间
            this.currentPlayer.logoutTime = new Date().getTime();
            //立即存档(现存user，存完再存player相关)

            var playerSave = function(){
                self.currentPlayer.save();//player表必须存一次（记录下线时间）
                self.currentPlayer.saveControllor.saveImmediately();//立马执行所有需要的存档
                //全部都存档完成
                self.currentPlayer.on("AllSaveComplete",function(){
                    require("Log").trace("玩家所有存档均已完成！uid:"+self.currentPlayer.gameKey);
                    self.writeAllComplete(self);
                });
                //停止存档计时器
                self.currentPlayer.saveControllor.clearAllTimeouts();
            }

            //只有角色登录成功后，才会对user进行存档
            if(this.user){
                this.user.save(playerSave);
            }else{
                playerSave();
            }
        }else{
            //非登录成功，直接调用存档完毕事件
            this.writeAllComplete(this);
        }
    }else{
        //不该走这边
        this.writeAllComplete(this);
    }
}



//获取加密密钥
GameClient.prototype.GetEncodeProtocolKey = function(){
    return this.pControl.GetEncodeProtocolKey();
}
//获取解密密钥
GameClient.prototype.GetDecodeProtocolKey = function(){
    return this.pControl.GetDecodeProtocolKey();
}


//存档结束
GameClient.prototype.writeAllComplete = function(_self){
    require("Log").trace("=============writeAllComplete============");
    if(_self.players){
        _self.players.forEach(function(player){
            //防止重复销毁当前玩家player
            if(_self.currentPlayer){
                if(player != _self.currentPlayer){
                    player.destroy();
                }
            }else{
                player.destroy();
            }
        });
        _self.players = null;
    }


     if(_self.currentPlayer){
         //通知其他玩家
         if(_self.currentPlayer.line){
             //离开线
             _self.currentPlayer.line.removeClient(_self,function(err){
                 if(!err){
//                     lineTemp.brocastExceptUid(smLine.PlayerLeft(_self.currentPlayer),_self.currentPlayer.gameKey);
                 }
             });
         }

         if(_self.onUpgradeBind){
             _self.currentPlayer.removeListener('upgrade',_self.onUpgradeBind);
             _self.onUpgradeBind = null;
         }

//         //离开房间
//        if(_self.currentPlayer.room){
//            _self.currentPlayer.room.removeClient(_self);
//        }
//         //离开副本
//        if(_self.currentPlayer.fb){
//            _self.currentPlayer.fb.removeClient(_self);
//        }

        _self.currentPlayer.destroy();
        _self.currentPlayer = null;
     }else{
        //只是socket连接，并没有登录游戏

     }

     if(_self.user){
        _self.user.destroy();
        _self.user = null;
     }

    if(_self.pControl){
        _self.pControl.destroy();
        _self.pControl = null;
    }
    _self.emit('writeAllComplete');
    simpleClientClass.prototype.doWhenQuit.bind(_self)();
}


//被踢掉
GameClient.prototype.beKicked = function(buffer){
    this.send(buffer);
    if(this.socket){
        this.socket.destroy();
    }
}

//根据protocol.json解析协议字典
GameClient.prototype.analysePath = function(path){
    var pathArr = path.split(".");
    if(pathArr.length == 2){
        //按字典解析path
        var fileName = require('BufferTools').protocol["protocolToServerFile"][pathArr[0]];
        if(!fileName){
            require("Log").error("fileName--not found:"+pathArr[0]+",gameKey:"+this.user.gameKey);
            return [];
        }
        var funcName = require('BufferTools').protocol["protocolToServerFunc"][fileName][pathArr[1]];
        if(!funcName){
            require("Log").error("funcName--not found:"+pathArr[1]+",gameKey:"+this.user.gameKey);
            return [];
        }

        return [fileName,funcName];
    }else{
        require("Log").error("协议路径错误!path:"+path+",gameKey:"+this.user.gameKey);
        this.destroy();
    }
    return [];
}

//将收到的包打印出来
GameClient.prototype.logReceiveData = function(fileName,funcName,buf){
    var loginKey;
    if(this.user){
        loginKey = this.user.loginKey;
    }else{
        loginKey = "NONE";
    }
    require("Log").info("收到玩家发来消息包！玩家:"+loginKey+",路径:"+fileName+"."+funcName+",包体:"+buf.toString());
}

//加密
GameClient.prototype.encrypt = function(buffer){
    //加密
    var len = buffer.length;
    //加密key
    var key = this.GetEncodeProtocolKey();
    for(var i=6;i<len;i++){
        buffer[i] = buffer[i]^key;
    }
}
//解密
GameClient.prototype.decrypt = function(encodeType,buffer){
    if(encodeType == 1){
        var len = buffer.length;
        //解密密钥
        var key = this.GetDecodeProtocolKey();
        for(var i=2;i<len;i++){
            buffer[i] = buffer[i]^key;
        }
    }
}


//发送消息
GameClient.prototype.send = function(buffer){
    if(this.isDestroyed){
        return;
    }
    //console.log("---send----length:"+buffer.length);
    //打印调试(消耗性能，正式场合关掉)
//    var pathLen = buffer.readInt16LE(4);
//    var path = buffer.toString("utf8",6,6+pathLen);
//    var data = buffer.toString("utf8",6+pathLen);
//    if(this.user){
//        //副本内操作不打印日志
//        if(path != "2.2"){
//            var pathArr = path.split(".");
//            //还原path
//            var fileName;
//            var funcName;
//            var fileObj = pDict.GetData("protocolToClientFile");
//            Object.keys(fileObj).forEach(function(key){
//                if(fileObj[key] == pathArr[0]){
//                    fileName = key;
//                }
//            });
//            var funcObj = pDict.GetData("protocolToClientFunc")[fileName];
//            Object.keys(funcObj).forEach(function(key){
//                if(funcObj[key] == pathArr[1]){
//                    funcName = key;
//                }
//            });
//            require("Log").info("发送数据包给玩家！玩家:"+this.user.loginKey+",路径:"+fileName+"."+funcName+",包体:"+data);
//        }
//    }
    simpleClientClass.prototype.send.bind(this)(buffer);
}


module.exports = GameClient;