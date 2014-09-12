var roomControllor = require("../../../controllor/RoomControllor.js");
var smRoom = require("../sm/SMRoom.js");

module.exports = {
    //获取所有房间信息
    GetAllRooms : function(buffer,client){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;

        var rooms = roomControllor.GetAllRoomsInfo();

        var sendData = {
            "rooms" : rooms
        }

        client.send(sendData,rpcData);
    },
    //创建房间
    CreateRoom : function(buffer,client){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;
        var data = jObj.data;


        roomControllor.CreateRoom(data,function(err,room){
            client.send(smRoom.SendKeyAndIdToGame(err,room),rpcData);
        });
    },
    //加入房间
    JoinRoom : function(buffer,client){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var rpcData = jObj.rpcData;
        var data = jObj.data;

        var roomId = data.roomId;

        var result;
        var room = roomControllor.CanJoinRoom(roomId)
        if(room){
            //加入成功
            result = 1;
        }else{
            //加入失败
            result = 0;
        }
        require("Log").trace("加入房间 result:"+result+",当前房间总数:"+roomControllor.GetTotalNum());
        client.send(smRoom.SendKeyAndIdToGame(result,room),rpcData);
    }
}