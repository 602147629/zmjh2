var cdc = require("../../../../../controllor/ConfigDataControllor.js");

module.exports = {
	//发送提示信息
	GetMsgId: function(msgType){
        var msgJson = cdc.GetConfigByName("Msg.json");
        var msgId =  msgJson[msgType];

        var info;
        if(!msgId){
            require('Log').error("GetMsgId error!id:%d not found!",msgId);
            info = {
                //未知错误
                "id" : msgJson["UNKNOW_ERROR"]
            };
        }else{
            info = {
                "id" : msgId
            };
        }

		return require('BufferTools').getJsonPathBufferByDict("MyCommonReceiveControl","GetMsg",info);
	},
    //发送公告信息
    SendNotice : function(data){
        var notice = data[0];
        var info = {
            "notice" : notice
        };
        return require('BufferTools').getJsonPathBufferByDict("MyCommonReceiveControl","GetNotice",info);
    }
}
