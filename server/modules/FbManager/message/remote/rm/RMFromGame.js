var RMFromGame = {};
var autoC = require("../../../controllor/AutoPipeiControllor.js");
var roomC = require("../../../controllor/RoomControllor.js");

//玩家离开游戏
RMFromGame.UserLogout = function(buffer,client){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var data = jObj.data;
    var rpcData = jObj.rpcData;
    var gameKey = data.gameKey;

    //离开自动匹配
    if(autoC.GetPipeiUser(gameKey)){
        autoC.RemoveClient(gameKey);
    }
}

//申请创建房间
RMFromGame.CreateRoom = function(buffer,client){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var data = jObj.data;
    var rpcData = jObj.rpcData;
    var roomType = data.type;

    var send = {
        "type" : roomType
    }

    roomC.ApplyRoom(send,function(err,config,data){
        var returnData;
        if(!err){
            if(data.result == 1){
                //成功
                returnData = {
                    "result" : 1,
                    "config" : config,
                    "data" : data
                }

                client.send(returnData,rpcData);
            }else{
                //失败
                returnData = {
                    "result" : 0
                }

                client.send(returnData,rpcData);
            }
        }else{
            returnData = {
                "result" : 0
            }

            client.send(returnData,rpcData);
        }
    });
}


module.exports = RMFromGame;