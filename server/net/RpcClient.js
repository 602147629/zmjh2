var EventEmitter = require("events").EventEmitter;
var simpleClientClass = require("./SimpleClient.js");
var cdc = require("../controllor/ConfigDataControllor.js");



function RpcClient(socket,msgFiles){
    simpleClientClass.call(this,socket);

    this.timeoutTime = -1;
    this.msgFiles = msgFiles;
    this.type = 'RPC';
}

require('util').inherits(RpcClient, simpleClientClass);


//将收到的包打印出来
RpcClient.prototype.logReceiveData = function(fileName,funcName,buf){
    require("Log").trace("RPC收到:"+fileName+"."+funcName+",data:"+buf.toString());
}


RpcClient.prototype.send = function(data,rpcData){
    var newObj = {
        "data" : data,
        "rpcData" : rpcData
    };
    var curPath = cdc.ServerConfig.path;
    var curId = cdc.ServerConfig.id;
    var targetPath = rpcData.path;
    var targetId = rpcData.serverId;
    require("Log").trace("RPC回复（"+curPath+curId+"->"+targetPath+targetId+" 回调索引:"+rpcData.cbIdx+"） data:"+JSON.stringify(newObj));
    //封装包头
    var buffer = require('BufferTools').addPackageHead(require("SuperUtils").jsonToBuffer(newObj),0,0);

    simpleClientClass.prototype.send.bind(this)(buffer);
}




module.exports = RpcClient;