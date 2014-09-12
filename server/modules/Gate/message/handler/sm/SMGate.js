var sic = require("../../../controllor/ServerInfoControllor.js");


module.exports = {
    //获取
    SendServersInfo : function(key,serverId){
        var info = sic.GetServerInfo();
        var obj = {
            "key" : key,
            "serverId" : serverId,
            "servers" : info
        }

        return require('BufferTools').getJsonPathBufferByDict("MyGateReceiveControl","GetServerInfoReturn",obj);
    },
    //不是最新版本
    VersionWrong : function(){
        var obj = {

        }

        return require('BufferTools').getJsonPathBufferByDict("MyGateReceiveControl","VersionWrong",obj);
    }
}