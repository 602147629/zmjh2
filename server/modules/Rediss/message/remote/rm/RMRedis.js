var ctmc = require("../../../controllor/CopyToMysqlControllor.js");

var RMRedis = {};

RMRedis.GetUserData = function(buffer,rpcClient){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var rpcData = jObj.rpcData;
    var data = jObj.data;

    var loginKey = data.loginKey;

    ctmc.GetUserData(loginKey,function(err,data){
        if(!err){
            rpcClient.send(data,rpcData);
        }else{
            rpcClient.send("",rpcData);
        }
    });
}


RMRedis.GetPlayerData = function(buffer,rpcClient){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var rpcData = jObj.rpcData;
    var data = jObj.data;

    var loginKey = data.loginKey;

    ctmc.GetPlayerData(loginKey,function(err,data){
        if(!err){
            rpcClient.send(data,rpcData);
        }else{
            rpcClient.send([],rpcData);
        }
    });
}


RMRedis.CreatePlayerData = function(buffer,rpcClient){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var rpcData = jObj.rpcData;
    var data = jObj.data;

    var loginKey = data.loginKey;
    var name = data.name;


    ctmc.CreatePlayerData(loginKey,name,function(err,data){
        if(!err){
            rpcClient.send(data,rpcData);
        }else{
            rpcClient.send("",rpcData);
        }
    });
}



RMRedis.CreateBagData = function(buffer,rpcClient){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var rpcData = jObj.rpcData;
    var data = jObj.data;

    var gameKey = data.gameKey;


    ctmc.CreateBagData(gameKey,function(err,data){
        if(!err){
            rpcClient.send(data,rpcData);
        }else{
            rpcClient.send("",rpcData);
        }
    });
}




RMRedis.GetBagData = function(buffer,rpcClient){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var rpcData = jObj.rpcData;
    var data = jObj.data;

    var gameKey = data.gameKey;

    ctmc.GetBagData(gameKey,function(err,data){
        if(!err){
            rpcClient.send(data,rpcData);
        }else{
            rpcClient.send("",rpcData);
        }
    });
}



RMRedis.SaveUserData = function(buffer,rpcClient){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var rpcData = jObj.rpcData;
    var data = jObj.data;

    var uid = data.uid;
    var serverId = data.serverId;
    var record = data.record;

    require("Log").trace("==============================SaveUserData-record:"+JSON.stringify(record))

    ctmc.SetUserData(uid,serverId,record);

    rpcClient.send({},rpcData);
}


RMRedis.SavePlayerData = function(buffer,rpcClient){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var rpcData = jObj.rpcData;
    var data = jObj.data;

    var loginKey = data.loginKey;
    var pid = data.pid;
    var record = data.record;


    require("Log").trace("==============================SavePlayerData-record:"+JSON.stringify(record))
    ctmc.SetPlayerData(loginKey,pid,record);

    rpcClient.send({},rpcData);
}


RMRedis.SaveBagData = function(buffer,rpcClient){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var rpcData = jObj.rpcData;
    var data = jObj.data;

    var gameKey = data.gameKey;
    var record = data.record;

    require("Log").trace("==============================SaveBagData-record:"+JSON.stringify(record))

    ctmc.SetBagData(gameKey,record);

    rpcClient.send({},rpcData);
}

//增加离线处理消息(1:单人匹配pk结算消息)
RMRedis.AddOfflineDeal = function(buffer,rpcClient){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var rpcData = jObj.rpcData;
    var data = jObj.data;

    var gameKey = data.data.gameKey;

    require("Log").trace("==============================SetOfflineDeal-offlineData:"+JSON.stringify(data))

    ctmc.AddOfflineDeal(gameKey,data);
}


RMRedis.GetOfflineData = function(buffer,rpcClient){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var rpcData = jObj.rpcData;
    var data = jObj.data;

    var pid = data.pid;

    ctmc.GetOfflineData(pid,function(err,data){
        if(!err){
            rpcClient.send(data,rpcData);
        }else{
            rpcClient.send("",rpcData);
        }
    });
}


RMRedis.ClearOfflineData = function(buffer,rpcClient){
    var str = buffer.toString();
    var jObj = JSON.parse(str);
    var rpcData = jObj.rpcData;
    var data = jObj.data;

    var pid = data.pid;

    ctmc.ClearOfflineDeal(pid);
}




module.exports = RMRedis;