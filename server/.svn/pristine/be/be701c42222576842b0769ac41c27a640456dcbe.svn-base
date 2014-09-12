var smGate = require("../sm/SMGate.js");
var rcc = require("../../../../../controllor/RpcConnectorControllor.js");

var configDataControllor = require("../../../../../controllor/ConfigDataControllor.js");
var uic = require("../../../controllor/UserInfoControllor.js");


module.exports = {
    //客户端获取服务器信息
//    GetServers : function(buffer,client){
//        client.send(smGate.SendServersInfo());
//    }
    //登录网关服务器
    Login : function(buffer,client){
        var str = buffer.toString();
        require("Log").trace("RMGate->Login()---str:"+str)
        var jObj = JSON.parse(str);
        var uid = parseInt(jObj.uid);
        var serverId = parseInt(jObj.serverId);
        var version = jObj.version;//版本号


        var gameJson = configDataControllor.GetConfigByName("Game.json");
        console.log('================gameJson.version:'+gameJson.version);
        if(version != gameJson.version){
            //不是最新版
            client.send(smGate.VersionWrong());
            client.destroy();
            return;
        }


        if(isNaN(uid) || isNaN(serverId)){
            client.destroy();
            return;
        }

        var loginKey = uid + "|" + serverId;

        var key = "key"+Math.ceil(Math.random()*1000000);
        uic.UpdateKey(loginKey,key);
//        //通知客户端服务器信息以及发送登录key
//        var sendKeyToUser = function(){
//            //将key和本服务器id发送给玩家，玩家登录游戏服务器的时候需要发给游戏服务器，游戏服务器根据服务器id找到对应的网关服务器，然后找其验证key
//            client.send(smGate.SendServersInfo(key,configDataControllor.ServerConfig.id));
//            client.destroy();
//        }
//      //查询这个玩家所在服务器id(玩家只有真正登录完成后才会在这查询到。登录过程中的重复判定在UserInfoControllor.UserLogin()中判定)
//        var user = uic.GetUserByUid(uid);
//        if(!user){
//            require("Log").trace("未找到玩家信息");
//            //该玩家还未登录上游戏服务器,直接返回服务器信息
//            sendKeyToUser();
//        }else{
//            //游戏服务器返回回调
//            var loginReturn = function(err,data){
//                if(!err){
//                    //查询完毕,发送key
//                    sendKeyToUser();
//                }
//            }
//            require("Log").trace("玩家："+uid+" 已经在线，踢掉！")
//            //通知相应服务器，踢掉这个玩家
//            rcc.SendByServerId(user.serverId,"RMFromGate","UserLogin",{"uid" : uid},loginReturn);
//        }

        //将key和本服务器id发送给玩家，玩家登录游戏服务器的时候需要发给游戏服务器，游戏服务器根据服务器id找到对应的网关服务器，然后找其验证key
        client.send(smGate.SendServersInfo(key,configDataControllor.ServerConfig.id));
        client.destroy();
    }
}