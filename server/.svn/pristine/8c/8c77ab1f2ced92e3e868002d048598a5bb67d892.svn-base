var simpleClientClass = require("./../../net/SimpleClient.js");


var pControlClass = require("./../../controllor/ProtocalControllor.js");
var comm = require("./const/common.js");

var EventEmitter = require('events').EventEmitter;


//用于和客户端映射的类，每个客户端（socket）对应一个这样的对象
function FbClient(socket,msgFiles) {
    simpleClientClass.call(this,socket);

    //文件加载器
    this.msgFiles = msgFiles;

    this.pControl = new pControlClass([3,3,5,6,7,2,2],[2,2,3,7,2,5,8]);

    this.timeoutTime = comm.CLIENT_TIMEOUT;
    this.type = 'CLIENT';

    var self = this;

    //连接上后X秒内没有发送登录信息，直接断开
    this.loginTimeoutIndex = setTimeout(function(){
        require("Log").info("连接后未即时发送登录消息，踢掉！");
        self.destroy();
    },30000);
}

require('util').inherits(FbClient,simpleClientClass);

FbClient.prototype.user;//用户信息
FbClient.prototype.pControl;//加密解密key


//当收到过大的数据的时候
FbClient.prototype.onPackageTooLarge = function(){
    var gameKey = "NO";
    if(this.user){
        gameKey = this.user.gameKey;
    }
    require("Log").error("收到过大的包！gameKey:"+gameKey);
    this.destroy();
}

//将收到的包打印出来
FbClient.prototype.logReceiveData = function(fileName,funcName,buf){
    var gameKey;
    if(this.user){
        gameKey = this.user.gameKey;
    }else{
        gameKey = "NONE";
    }
    if(funcName != "OperationGet"){
        require("Log").info("收到玩家发来消息包！玩家:"+gameKey+",路径:"+fileName+"."+funcName+",包体:"+buf.toString());
    }
}

//执行登录(加入房间)
FbClient.prototype.doLogin = function(){
    clearTimeout(this.loginTimeoutIndex);
}


FbClient.prototype.doWhenQuit = function(){
    if(this.isDestroyed){
        return;
    }

    clearTimeout(this.loginTimeoutIndex);

    if(this.user){
        //退出房间
        if(this.user.room){
            this.user.room.removeClient(this);
        }
        //退出副本
        if(this.user.fb){
            this.user.fb.removeClient(this);
        }
        this.user.destroy();
        this.user = null;
    }
    if(this.pControl){
        this.pControl.destroy();
        this.pControl = null;
    }

    simpleClientClass.prototype.doWhenQuit.bind(this)();
}


//获取加密密钥
FbClient.prototype.GetEncodeProtocolKey = function(){
    return this.pControl.GetEncodeProtocolKey();
}
//获取解密密钥
FbClient.prototype.GetDecodeProtocolKey = function(){
    return this.pControl.GetDecodeProtocolKey();
}


//根据protocol.json解析协议字典
FbClient.prototype.analysePath = function(path){
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

//加密
FbClient.prototype.encrypt = function(buffer){
    //加密
    var len = buffer.length;
    //加密key
    var key = this.GetEncodeProtocolKey();
    for(var i=6;i<len;i++){
        buffer[i] = buffer[i]^key;
    }
}
//解密
FbClient.prototype.decrypt = function(encodeType,buffer){
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
FbClient.prototype.send = function(buffer){
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
//        require('Log').trace('====================path:'+path);
//        if(path != "2.0"){
//            var pathArr = path.split(".");
//            //还原path
//            var fileName;
//            var funcName;
//            var fileObj = require('BufferTools').protocol["protocolToClientFile"];
//            Object.keys(fileObj).forEach(function(key){
//                if(fileObj[key] == pathArr[0]){
//                    fileName = key;
//                }
//            });
//            require('Log').trace('====================fileName:'+fileName);
//            var funcObj = require('BufferTools').protocol["protocolToClientFunc"][fileName];
//            Object.keys(funcObj).forEach(function(key){
//                if(funcObj[key] == pathArr[1]){
//                    funcName = key;
//                }
//            });
//            //if(funcName != "StartGame"){
//                require("Log").info("发送数据包给玩家！玩家:"+this.user.gameKey+",路径:"+fileName+"."+funcName+",包体:"+data);
//            //}else{
//                //require("Log").info("发送数据包给玩家！玩家:"+this.user.gameKey+",路径:"+fileName+"."+funcName+",包体:");
//            //}
//        }
//    }
    simpleClientClass.prototype.send.bind(this)(buffer);
}



module.exports = FbClient;