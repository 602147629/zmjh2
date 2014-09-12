var clientClass = require('./../FbClient.js');

var allClients = [];

module.exports = {
    //有客户端连接上来
    ClientConnected : function(socket,files){
        var client = new clientClass(socket,files);
        client.on("destroy",function(){
            allClients.splice(allClients.indexOf(client),1);
        })
        allClients.push(client);
    },
    KillAll : function(cb){
        require("Log").trace("=========KillAll========");
        //杀掉游戏
        var temp = allClients.concat();
        require("SuperUtils").forEachInArray(temp,function(client){
            client.destroy();
        });
        if(cb){
            cb();
        }
    }
}