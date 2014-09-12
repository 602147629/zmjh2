/**
 * Created by lijun on 14-6-13.
 */
var sm = require("../sm/SMRoom.js");
var smPublicNotice = require("../sm/SMPublicNotice.js");
var cdc = require("../../../../../controllor/ConfigDataControllor.js");
var rpcConnectorControllor = require("../../../../../controllor/RpcConnectorControllor.js");

module.exports = {
    //接收客户端公告请求
    GetPublicNotice : function(buffer,client){
        if(!client.user){
            require("Log").error("RMRoom->CancelAutoPipei() 没找到user对象");
            return;
        }
        if(!client.currentPlayer){
            require("Log").error("RMRoom->CancelAutoPipei() 没找到player对象");
            return;
        }


        var str = buffer.toString();
        var jObj = JSON.parse(str);

        require("Log").trace("玩家："+client.currentPlayer.gameKey+" 发来公告数据:"+jObj.publicNotice);
        var data = {
            "gameKey":client.currentPlayer.gameKey,
            "type": jObj.type,
            "name":jObj.name,
            "info":jObj.info
        }

        var cb = function(err,data){
            if(!err){
               if(data.err){
                    client.send(smPublicNotice.PublicNoticeReturn(data.err));
                }
            }else{
                require("Log").error("发送公告出错！"+err+"gameKey:"+client.currentPlayer.gameKey);
            }
        }
        rpcConnectorControllor.BrocastByPath("PublicNoticeManager","RMPublicNotice","GetPubliNoticeData",data,cb);
    }
}
