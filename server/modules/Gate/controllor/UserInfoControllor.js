var rcc = require("../../../controllor/RpcConnectorControllor.js");

//所有玩家的共用信息管理（在线与否、上线下线通知等）
var loginUsers = [];//当前在线的玩家数组
var keys = [];
var current = 0;
//var keyUsers = [];//key验证成功的玩家数组(用于重复登录判定，登录成功后移除)


module.exports = {
    //有玩家登录
    UserLogin : function(loginKey,gameKey,gameServerId){
        var obj;
        if(!loginUsers[loginKey]){
            obj = {
                "loginKey" : loginKey,
                "gameKey" : gameKey,
                "gameServerId" : gameServerId,//场景服务器id
                "roomServerId" : -1
            };
            loginUsers[loginKey] = obj;
            loginUsers[gameKey] = obj;

            current++;
            require("Log").trace("Gate->UserInfoControllor->UserLogin() 有玩家登录！loginKey:"+loginKey+",gameKey:"+gameKey+",当前玩家总数："+current);

            //发送给master进程
            rcc.BrocastByPath("Master","RMLog","UpdateTotalPlayers",{totalPlayers:current});
        }else{
            //不应该存在这个情况
            obj = loginUsers[loginKey];
            obj.loginKey = loginKey;
            obj.gameKey = gameKey;
            obj.gameServerId = gameServerId;
            obj.roomServerId = -1;

            require("Log").error("Gate->UserInfoControllor->UserLogin() error!user has logined!");
        }

//        delete keyUsers[loginKey];
    },
    //有玩家离开了
    UserLogout : function(loginKey){
        var user = loginUsers[loginKey];
        if(user){
            var gameKey = user.gameKey;
            if(gameKey){
                //通知fb服务器，玩家下线
                if(user.roomServerId != -1){
                    rcc.SendByServerId(user.roomServerId,"RMFromGate","UserLogout",{"gameKey":gameKey});
                }
            }

            delete loginUsers[gameKey];
            delete loginUsers[loginKey];
            current--;

            require("Log").trace("Gate->UserInfoControllor->UserLogout() 有玩家离开！loginKey:"+loginKey+",当前玩家总数："+current);

            //发送给master进程
            rcc.BrocastByPath("Master","RMLog","UpdateTotalPlayers",{totalPlayers:current});
        }else{
            require("Log").error("Gate->UserInfoControllor->UserLogout() 玩家未登录！loginKey:"+loginKey);
        }
    },
    //玩家进入房间
    UserIntoRoom : function(gameKey,roomServerId){
        var user = loginUsers[gameKey];
        if(user){
            user.roomServerId = roomServerId;//玩家所连接的fb服务器id
        }
    },
    //玩家离开房间
    UserOutRoom : function(gameKey){
        var user = loginUsers[gameKey];
        if(user){
            user.roomServerId = -1;
        }
    },
    //获取已经登录的玩家信息
    GetUserByGameKey : function(gameKey){
        return loginUsers[gameKey];
    },
    //获取已经登录的玩家信息
    GetUserByLoginKey : function(loginKey){
        return loginUsers[loginKey];
    },
    //更新玩家登录key
    UpdateKey : function(loginKey,key){
        require("Log").trace("UpdateKey loginKey:"+loginKey+",key:"+key);
        keys[loginKey] = key;
    },
    //game请求验证key
    CkeckKey : function(loginKey,key){
        var myKey = keys[loginKey];
        require("Log").trace("CkeckKey loginKey:"+loginKey+",myKey:"+myKey+",key:"+key);
        if(myKey && myKey == key){
            return true;
        }
        return false;
    },
    //game在玩家登录成功时再次验证登录key
    CheckKeyAfterLogin : function(loginKey,key){
        var myKey = keys[loginKey];
        require("Log").trace("CheckKeyAfterLogin loginKey:"+loginKey+",myKey:"+myKey+",key:"+key);
        if(myKey && myKey == key){
            //玩家验证成功后，删除这个key
            delete keys[loginKey];

            return true;
        }
        return false;
    }
}