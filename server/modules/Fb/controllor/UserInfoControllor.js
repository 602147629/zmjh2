var allClients = [];//所有玩家数组
var totalNums = 0;

module.exports = {
    AddClient : function(gameKey,client){
        if(!allClients[gameKey]){
            require("Log").trace("玩家成功加入用户管理器！gameKey:"+gameKey);
            allClients[gameKey] = client;
            totalNums++;
        }else{
            require("Log").error("玩家加入用户管理器出错！玩家已经在用户管理器内 gameKey:"+gameKey);
        }
    },
    RemoveClient : function(gameKey){
        if(allClients[gameKey]){
            require("Log").trace("玩家成功离开用户管理器！gameKey:"+gameKey);
            delete allClients[gameKey];
            totalNums--;
        }else{
            require("Log").error("玩家离开用户管理器出错！玩家不在用户管理器内 gameKey:"+gameKey);
        }
    },
    //获取玩家对象
    GetClientByUid : function(gameKey){
        return allClients[gameKey];
    },
    //获取玩家总数
    GetTotalNums : function(){
        return totalNums;
    }
}