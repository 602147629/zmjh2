module.exports = {
    //加入房间返回
    JoinRoomReturn : function(result){
        var info = {
            "result" : result
        };

        return require('BufferTools').getJsonPathBufferByDict("MyRoomReceiveControl","JoinRoomReturn",info);
    },
    //退出房间返回
    LeftRoomReturn : function(result){
        var info = {
            "result" : result
        };

        return require('BufferTools').getJsonPathBufferByDict("MyRoomReceiveControl","LeftRoomReturn",info);
    },
    //房间信息变化，发给房间内所有人
    RoomChanged : function(room){
        var jObj = {
            "room" : room.getRoomJsonInfo()
        }
        return require('BufferTools').getJsonPathBufferByDict("MyRoomReceiveControl","RoomChanged",jObj);
    },
    //通知客户端游戏结束
    GameAccountReturn : function(data){
        var jObj = {
            "data" : data
        }
        return require('BufferTools').getJsonPathBufferByDict("MyRoomReceiveControl","GameAccount",jObj);
    }
}