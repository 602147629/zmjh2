var clientClass = require('./../GameClient.js');
var webClientClass = require('../../../net/WebsocketClient.js');
var smLogin = require("../message/handler/sm/SMLogin.js")

var allClients = [];

module.exports = {
    //有客户端连接上来
    ClientConnected : function(socket,files,type){
        type = type || "socket";
        var client;
        if(type == "websocket"){
            client = new webClientClass(socket,files);
        }else{
            //2317101591
            client = new clientClass(socket,files);
        }
        client.on("destroy",function(){
            allClients.splice(allClients.indexOf(client),1);
        })
        allClients.push(client);
    },
    KillAll : function(cb){
        require("Log").trace("=========GAME-KillAll========");
        var len = Object.keys(allClients).length;
        require("Log").trace("=========GAME-KillAll-len:"+len);
        if(len === 0){
            //结束完毕
            if(cb){
                cb();
            }
            return;
        }
        //杀掉游戏
        var temp = allClients.concat();
        require("SuperUtils").forEachInArray(temp,function(client){
            client.beKicked(smLogin.ServerStop());
            client.on("writeAllComplete",function(){
                require("Log").trace("=========GAME-KillAll-writeAllComplete-len:"+len);
                len--;
                if(len === 0){
                    //结束完毕
                    if(cb){
                        //延迟一帧执行，让log落实
                        setImmediate(function(){
                            cb();
                        });
                    }
                }
            })
        });
    }
}