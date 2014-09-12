var lineControllor = require("../../../controllor/LineControllor.js");
var loginControllor = require("../../../controllor/LoginControllor.js");
var smRoomToClient = require("../../handler/sm/SMRoom.js");
var roomControllor = require("../../../controllor/RoomControllor.js");


module.exports = {
    //房间信息变化
    RoomChanged : function(buffer,rpcClient){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var data = jObj.data;

        var roomInfo = data.room;
        //更新本地缓存
        roomControllor.UpdateRoomn(roomInfo);
        //通知客户端
        lineControllor.Brocast(smRoomToClient.RoomChanged(roomInfo));
    },
    //fb服务器发来的请求玩家数据
    GetUserDataByUid : function(buffer,rpcClient){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;
        var data = jObj.data;

        var returnObj;

        var gameKey = data.gameKey;
        var client = loginControllor.GetClientByGameKey(gameKey);
        if(client && client.currentPlayer){
            var playerData = client.currentPlayer.playerData;
            if(playerData){
                returnObj = {
                    "gameKey" : gameKey,
                    "result" : 1,
                    "playerData" : playerData
                }
            }else{
                require("Log").error("GetUserDataByUid error!playerData:"+playerData);
                returnObj = {
                    "result" : 0
                }
            }
        }else{
            require("Log").error("GetUserDataByUid error!client:"+client+",client.currentPlayer:"+client.currentPlayer);
            returnObj = {
                "result" : 0
            }
        }

        rpcClient.send(returnObj,rpcData);
    },
    //玩家离开房间
    PlayerLeftRoom : function(buffer,rpcClient){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var data = jObj.data;
        var gameKey = data.gameKey;

        require("Log").trace("收到玩家 :"+gameKey+" 离开房间的消息！");

        var client = loginControllor.GetClientByGameKey(gameKey);
        if(client){
            require("Log").trace("玩家 :"+gameKey+" 离开了房间！");
            if(client.currentPlayer){
                client.currentPlayer.leftRoom();
            }
        }
    }
//    ,
//    PlayerJoinRoom : function(buffer,rpcClient){
//        var str = buffer.toString();
//        var jObj = JSON.parse(str);
//        var data = jObj.data;
//        var gameKey = data.gameKey;
//        var roomId = data.roomId;
//        var roomServerId = data.roomServerId;
//
//        require("Log").trace("收到玩家 :"+gameKey+" 加入房间的消息！");
//
//        var client = loginControllor.GetClientByGameKey(gameKey);
//        if(client){
//            require("Log").trace("玩家 :"+gameKey+" 加入了房间！");
//            client.currentPlayer.joinRoom(roomId,roomServerId);
//        }
//    }
}