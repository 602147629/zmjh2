var sic = require("../../../controllor/ServerInfoControllor.js");
var uic = require("../../../controllor/UserInfoControllor.js");
var rcc = require("../../../../../controllor/RpcConnectorControllor.js");
var sm = require("../sm/SMGate.js");


module.exports = {
    //接收到服务器发来的信息
    GetServerInfo : function(buffer,client){
        var str = buffer.toString();
        require("Log").trace("RMGate->GetServerInfo()---str:"+str)
        var jObj = JSON.parse(str);
//        var rpcData = jObj.rpcData;
        var data = jObj.data;

        //更新服务器信息
        sic.UpdateServerInfo(data,client);
    },
    //游戏服务器玩家下线后通知
    UserLogout : function(buffer,client){
        var str = buffer.toString();
        require("Log").trace("RMGate->UserLogout()---str:"+str)
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;
        var data = jObj.data;
        var loginKey = data.loginKey;

        uic.UserLogout(loginKey);
    },
    //验证玩家key,返回给game服务器(验证成功后，销毁key，并且玩家算是登录了)
    CheckKey : function(buffer,client){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;
        var data = jObj.data;
        var loginKey = data.loginKey;
        var key = data.key;
//        var serverId = data.serverId;//大服id
//
//        var gameServerId = rpcData.serverId;//场景服id

        var bool = uic.CkeckKey(loginKey,key);
        var result = bool?1:0;
        if(bool){
            //已经登录完毕的玩家
            var user = uic.GetUserByLoginKey(loginKey);
            if(!user){
                require("Log").trace("未找到玩家信息");
                //该玩家还未登录上游戏服务器
                client.send({"result" : result},rpcData);
            }else{
                //游戏服务器返回回调
                var loginReturn = function(err,data){
                    if(!err){
                        client.send({"result" : result},rpcData);
                    }
                }
                require("Log").trace("玩家："+loginKey+" 已经在线，踢掉！");
                //通知相应服务器，踢掉这个玩家
                rcc.SendByServerId(user.gameServerId,"RMFromGate","UserLogin",{"loginKey" : loginKey},loginReturn);
            }
        }else{
            //验证失败
            client.send({"result" : result},rpcData);
        }
    },
    //玩家登录后的key验证,(验证成功后，表示登录成功)
    CheckKeyAfterLogin : function(buffer,client){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;
        var data = jObj.data;
        var loginKey = data.loginKey;
        var gameKey = data.gameKey;
        var key = data.key;

        var bool = uic.CheckKeyAfterLogin(loginKey,key);
        var result = bool?1:0;
        if(bool){
            //玩家登录gate
            uic.UserLogin(loginKey,gameKey,rpcData.serverId);
        }
        client.send({"result" : result},rpcData);
    },
    //根据uid获取该玩家数据
    GetUserInfoByUid : function(buffer,client){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;
        var data = jObj.data;
        var gameKey = data.gameKey;

        var returnObj;
        var user = uic.GetUserByGameKey(gameKey);
        if(user){
            returnObj = {
                "result" : 1,
                "user" : user
            }
        }else{
            returnObj = {
                "result" : 0
            }
        }
        client.send(returnObj,rpcData);
    }
}