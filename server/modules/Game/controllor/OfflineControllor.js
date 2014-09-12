var OfflineControllor = {};

var rcc = require("../../../controllor/RpcConnectorControllor.js")

OfflineControllor.deal = function(player,offlines){
    require("Log").trace("处理离线消息,gameKey:"+player.gameKey+",消息数:"+offlines.length);
    require("Log").trace("offlines:"+JSON.stringify(offlines))


    if(offlines.length > 0){
        //清除离线消息
        var data = {
            "gameKey" : player.gameKey
        }
        rcc.BrocastByPath("Rediss","RMRedis","ClearOfflineData",data);
    }
}


module.exports = OfflineControllor;