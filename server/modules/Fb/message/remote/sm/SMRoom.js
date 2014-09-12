
module.exports = {
    //房间信息变化
    RoomChanged : function(room){
        var info = {
            "room" : room.getRoomJsonInfo()
        };

        return info;
    },
//    //发送所有的房间信息
//    AllRooms : function(jsonObj){
//        var pathBuffer = require('BufferTools').getJsonPathBufferByDict("RMGate","GetServerInfo",jsonObj,true);
//
//        //封装包头
//        return require('BufferTools').addPackageHead(pathBuffer);
//    },
    //发送给game，让其告诉玩家key和房间id
    SendKeyAndIdToGame : function(err,room){
        var info;
        if(err == null){
            info = {
                "err" : err,
                "roomId" : room.id,
                "key" : room.key
            };
        }else{
            info = {
                "err" : err
            };
        }

        return info;
    },
    //玩家离开房间
    PlayerLeftRoom : function(gameKey){
        var info = {
            "gameKey" : gameKey
        };

        return info;
    }
}