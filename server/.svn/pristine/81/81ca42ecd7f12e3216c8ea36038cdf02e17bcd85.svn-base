var uic = require("../../../controllor/UserInfoControllor.js");
var rcc = require("../../../../../controllor/RpcConnectorControllor.js")

module.exports = {
    //玩家进入房间
    UserIntoRoom : function(buffer,client){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;
        var data = jObj.data;
        var gameKey = data.gameKey;
        var roomServerId = data.roomServerId;

        uic.UserIntoRoom(gameKey,roomServerId);
    },
    //玩家退出房间
    UserOutRoom : function(buffer,client){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;
        var data = jObj.data;
        var gameKey = data.gameKey;

        uic.UserOutRoom(gameKey);
    },
    //玩家副本结算
    UserFbAccount : function(buffer,client){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;
        var data = jObj.data;

        var gameKey = data.gameKey;

        var obj = uic.GetUserByGameKey(gameKey);
        if(obj){
            //在线,通知场景
            require("Log").trace("网关-副本结算，玩家在线，通知场景");
            rcc.SendByServerId(obj.serverId,"RMFromGate","FbAccount",data);
        }else{
            //离线，写入redis
            require("Log").trace("网关-副本结算，玩家不在线，通知写入redis");
            var offline = {
                "type" : "1",
                "data" : data
            }
            rcc.BrocastByPath("Rediss","RMRedis","AddOfflineDeal",offline);
        }
    }
}