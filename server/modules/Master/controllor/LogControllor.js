var totalPlayers = 0;//总登录的玩家人数
var interval = -1;
var maxInHistory = 0;//历史同时在线最高人数

var servers = [];

var Logcontrollor = {};

Logcontrollor.Init = function(){
    if(interval === -1){
        interval = setInterval(function(){
            require("Log").info("当前玩家总数:"+totalPlayers);
        },60000);
    }
}
Logcontrollor.UpdateTotalPlayers = function(serverId,current){
    totalPlayers = 0;
    servers[serverId] = current;

    require("SuperUtils").forEachInArray(servers,function(count){
        totalPlayers += count;
    });
    if(totalPlayers > maxInHistory){
        maxInHistory = totalPlayers;
        require("Log").info("当前玩家在线创新高:"+maxInHistory);
    }
}

module.exports = Logcontrollor;