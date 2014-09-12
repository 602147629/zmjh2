var gateClientClass = require("../GateClient.js");

var gateClients = [];

module.exports = {
    //有客户端连接上来
    ClientConnected : function(socket,files){
        require("Log").trace("=========player connect to Gate========");
        var client = new gateClientClass(socket,files);
        gateClients.push(client);

        client.on("destroy",function(){
            gateClients.splice(gateClients.indexOf(client),1);
        });
    },
    KillAll : function(cb){
        require("Log").trace("=========KillAll========");
        //杀掉游戏
        var temp = gateClients.concat();
        require("SuperUtils").forEachInArray(temp,function(client){
            client.destroy();
        });
        if(cb){
            cb();
        }
    }
}