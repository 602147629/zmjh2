var loginControl = require('../../../controllor/LoginControllor.js');
var fbControl = require('../../../controllor/FbAccountControllor.js');
var rcc = require('../../../../../controllor/RpcConnectorControllor.js');
var smLogin = require("../../handler/sm/SMLogin.js");

module.exports = {
    //网关服务器发来玩家要登录
    UserLogin : function(buffer,rpcClient){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var data = jObj.data;
        var rpcData = jObj.rpcData;
        var loginKey = data.loginKey;

        var kickOk = function(){
            require("Log").trace("玩家下线完成");
            rpcClient.send({},rpcData);
        }

        require("Log").trace("网关请求踢掉玩家 loginKey："+loginKey);
        var oldClient = loginControl.GetClientByLoginKey(loginKey);
        if(oldClient){
            require("Log").trace("通知玩家下线");
            //踢掉
            oldClient.on('writeAllComplete',kickOk);
            oldClient.beKicked(smLogin.PlayerBeKicked());
        }else{
            require("Log").trace("没找到这个玩家");
            //没这个玩家，直接返回成功
            kickOk();
        }
    },
    //副本结算
    FbAccount : function(buffer,rpcClient){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var data = jObj.data;
        var rpcData = jObj.rpcData;
        var gameKey = data.gameKey;


        var client = loginControl.GetClientByGameKey(gameKey);
        if(client){
            //在线
            require("Log").trace("场景-副本结算，玩家在线，进行结算处理");
            fbControl.fbAccount(client.currentPlayer,data);
        }else{
            //离线，写入redis
            require("Log").trace("场景-副本结算，玩家不在线，写入redis");
            var offline = {
                "type" : "1",
                "data" : data
            }
            rcc.BrocastByPath("Rediss","RMRedis","AddOfflineDeal",offline);
        }
    }
}