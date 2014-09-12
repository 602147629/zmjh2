var loginControl = require('../../../controllor/LoginControllor.js');
var smEscort = require("../../handler/sm/SMEscort.js");

module.exports = {
    //自动匹配返回
    AutoPipeiEscortReturn : function(buffer,rpcClient){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var data = jObj.data;
        var gameKey = data.gameKey;
        var otherPlayerData = data.otherPlayerData;
        var escortType = data.escortType;
        var escortData = data.escortData;
        var rocResult = data.result;
        var obj;
        //成功
        obj = {
            "escortType":escortType,
            "otherPlayerData":otherPlayerData,
            "escortData":escortData
        }



        require("Log").trace("data："+JSON.stringify(data));

        var client = loginControl.GetClientByGameKey(gameKey);
        if(rocResult == 1){
            require("Log").info("客户端"+client);
            if(client){
                require("Log").info("玩家数据！"+ JSON.stringify(otherPlayerData));
                require("Log").info("向玩家"+gameKey+"发送护镖数据！");
                //成功
                client.send(smEscort.MatchEscortReturn(obj));
            }
        }else{
            //申请创建房间失败失败
            if(client){
                client.send(smEscort.MatchEscortReturn(rocResult));
            }
        }
    }
}