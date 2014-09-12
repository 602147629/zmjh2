var loginControl = require('../../../controllor/LoginControllor.js');
var smRoom = require("../../handler/sm/SMRoom.js");

module.exports = {
    //自动匹配返回
    AutoPipeiReturn : function(buffer,rpcClient){
        var str = buffer.toString();
        var jObj = JSON.parse(str);
        var data = jObj.data;
        var rpcData = jObj.rpcData;
        var gameKey = data.gameKey;
        var pipeiData = data.data;
        var config = data.config;
        var rocResult = data.result;

        var client = loginControl.GetClientByGameKey(gameKey);
        if(rocResult == 1){
            var key = pipeiData.key;
            var err = pipeiData.err;
            var roomId = pipeiData.roomId;

            if(client){
                if(err == null){
                    //成功
                    client.send(smRoom.CreateRoomReturn(err,key,roomId,config,1));
                    //加入房间冷却中
                    client.currentPlayer.intoRoomJoinCoolDown();
                }else{
                    //失败
                    client.send(smRoom.CreateRoomReturn(err));
                }
            }
        }else{
            //申请创建房间失败失败
            if(client){
                client.send(smRoom.CreateRoomReturn(rocResult));
            }
        }
    }
}