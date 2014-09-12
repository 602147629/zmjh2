var rpcClientClass = require("../../../net/RpcClient.js");

var rpcReceiveConnectors = [];//其他服务器连接上本服务器的联机数组


module.exports = {
    AddReceiveSocket : function(socket,rpcFiles){
        require("Log").trace("=================AddReceiveSocket==================socket:"+socket.remotePort)
        var client = new rpcClientClass(socket,rpcFiles);
        rpcReceiveConnectors.push(client);
        client.on("destroy",function(){
            rpcReceiveConnectors.splice(rpcReceiveConnectors.indexOf(client),1);
        });
    },
    KillAll : function(cb){
        require("Log").trace("=========KillAll========");
        //杀掉游戏
        var temp = rpcReceiveConnectors.concat();
        require("SuperUtils").forEachInArray(temp,function(client){
            client.destroy();
        });
        if(cb){
            cb();
        }
    }
};