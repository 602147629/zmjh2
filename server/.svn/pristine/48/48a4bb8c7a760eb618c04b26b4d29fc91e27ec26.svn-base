var RMAutoPipei = {};
var autoC = require("../../../controllor/AutoPipeiControllor.js");

//申请自动匹配
RMAutoPipei.AutoPipei = function(buffer,client){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var data = jObj.data;
    var rpcData = jObj.rpcData;
    var gameKey = data.gameKey;
    var gameServerId = data.gameServerId;
    var pipeiData = data.pipeiData;

    var obj = {
        "gameKey" : gameKey,
        "gameServerId" : gameServerId,
        "pipeiData" : pipeiData,
        "pipeiCount" : 1
    }

    autoC.AddClient(obj,function(err,result){
        client.send({"err":err},rpcData);
    });
}

//取消自动匹配
RMAutoPipei.CancelAutoPipei = function(buffer,client){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var data = jObj.data;
    var rpcData = jObj.rpcData;
    var gameKey = data.gameKey;


    autoC.RemoveClient(gameKey,function(err){
        client.send({"err":err},rpcData);
    });

//    var result = 0;
//    if(autoC.GetPipeiUser(gameKey)){
//        autoC.RemoveClient(gameKey);
//        result = 1;
//    }
//    client.send({"result":result},rpcData);
}


module.exports = RMAutoPipei;