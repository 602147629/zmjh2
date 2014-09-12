var smGate = require("../message/remote/sm/SMToGate.js")
var rcc = require("../../../controllor/RpcConnectorControllor.js");



var allClients = [];//用loginKey做索引数组(loginKey)
var currentNum = 0;//当前总人数

module.exports = {
	//加入到所有玩家的数组中
	AddClient : function(client){
        if(!allClients[client.user.loginKey]){
            allClients[client.user.loginKey] = client;
            currentNum++;
            require("Log").trace("玩家加入登录管理器中!uid:"+client.user.loginKey+"，当前玩家总数:"+currentNum);

            return true;
        }
        require("Log").error("LoginControllor->AddClient()  error!");
		return false;
	},
	//移除一位玩家
	RemoveClient : function(client){
        if(allClients[client.user.loginKey]){
            delete allClients[client.user.loginKey];

            if(client.currentPlayer){
                delete allClients[client.currentPlayer.gameKey];
            }

            currentNum--;

            if(client.currentPlayer){
                if(client.currentPlayer.isLoginComplete){
                    //通知副本管理器
                    rcc.BrocastByPath("FbManager","RMFromGame","UserLogout",{"gameKey" : client.currentPlayer.gameKey});
                    //通知GATE，有玩家下线了
                    rcc.BrocastByPath("Gate","RMGate","UserLogout",smGate.UserLogout(client.user.loginKey));
                    //通知护镖、劫镖
                    rcc.BrocastByPath("EscortManager","RMFromGame","UserLogout",{"gameKey" : client.currentPlayer.gameKey});

                    //rcc.BrocastByPath("PublicNoticeManager","RMFromGame","UserLogout",{"gameKey" :client.currentPlayer.gameKey});
                }
            }

            require("Log").trace("从登录管理器内移除loginKey:"+client.user.loginKey+"  登录管理器内还剩人数:"+currentNum);
            return true;
        }
        require("Log").error("玩家不在登录管理器内!");
        return false;
	},
    //根据游戏uid获取玩家
	GetClientByLoginKey : function(loginKey){
		return allClients[loginKey];
	},
    //更新玩家的gamekey
    UpdateGameKey : function(client){
        if(client.currentPlayer){
            allClients[client.currentPlayer.gameKey] = client;
        }
    },
    //根据游戏uid获取玩家
    GetClientByGameKey : function(gameKey){
        return allClients[gameKey];
    },
//    //根据平台uid获取玩家
//    GetClientByPlatformUid : function(uid){
//        return allPlatformClients[uid];
//    },
    //获取总人数
    GetTotalNum : function(){
        return currentNum;
    }
}