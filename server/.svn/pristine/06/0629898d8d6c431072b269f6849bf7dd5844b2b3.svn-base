var cdc = require("../../../../../controllor/ConfigDataControllor.js");

module.exports = {
    //向gate发送本服信息
    SendServerInfo : function(current){
        var jObj = {
            "id" : cdc.ServerConfig.id,
            "name" : cdc.ServerConfig.name,
            "max" : cdc.ServerConfig.max,
            "current" : current,
            "ip" : cdc.ServerConfig.ip,
            "port" : cdc.ServerConfig.client.port
        };

        return jObj;
    },
    //玩家退出，通知gate
    UserLogout : function(loginKey){
        var jObj = {
            "loginKey" : loginKey
        }

        return jObj;
    }

}