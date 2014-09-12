
module.exports = {
    RoomChanged : function(roomInfo){
        var jObj = {
            "room" : roomInfo
        }
        return require('BufferTools').getJsonPathBufferByDict("MyRoomReceiveControl","RoomChanged",jObj);

    },
    //创建房间返回和加入房间返回共用（type（0：创建，1：加入））
    CreateRoomReturn : function(err,key,roomId,config,type){
        var jObj;
        if(err == null){
            jObj = {
                "err" : err,
                "key" : key,
                "roomId" : roomId,
                "ip" : config.ip,
                "port" : config.client.port,
                "type" : type
            }
        }else{
            jObj = {
                "err" : err,
                "type" : type
            }
        }
        return require('BufferTools').getJsonPathBufferByDict("MyRoomReceiveControl","CreateRoomReturn",jObj);
    },
    JoinRoomFail : function(buffer,client){
        var jObj = {
            "errId" : 0
        }
        return require('BufferTools').getJsonPathBufferByDict("MyRoomReceiveControl","JoinRoomFail",jObj);
    },
    AutoPipeiReturn : function(result){
        var jObj = {
            "result" : result
        }
        return require('BufferTools').getJsonPathBufferByDict("MyRoomReceiveControl","AutoPipeiReturn",jObj);
    },
    CancelAutoPipeiReturn : function(result){
        var jObj = {
            "result" : result
        }
        return require('BufferTools').getJsonPathBufferByDict("MyRoomReceiveControl","CancelAutoPipeiReturn",jObj);
    }
}
