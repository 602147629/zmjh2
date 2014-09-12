var uic = require("../../../controllor/UserInfoControllor.js");

module.exports = {
    //玩家退出场景了
    UserLogout : function(buffer,client){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;
        var data = jObj.data;

        var gameKey = data.gameKey;

        var client = uic.GetClientByUid(gameKey);
        require("Log").trace("场景断开连接！gameKey:"+gameKey);
        //断开连接
        if(client){
            require("Log").trace("玩家正在副本中，但是场景断开连接了！gameKey:"+gameKey);
            client.destroy();
        }else{
            require("Log").trace("场景断开连接，但是没找到这个玩家！gameKey:"+gameKey);
        }
    }
}