var loginC = require("../controllor/LoginControllor.js");
//var lineC = require("../controllor/LineControllor.js");
//var rpc = require("../../../controllor/RpcConnectorControllor.js");


//用户通过telnet直连本服的处理
module.exports = {
    //解析telnet命令
    TelnetCommand : function(data,socket){
        switch(data){
            //登录管理器总人数
            case "LoginClientTotalNum":
                console.log("LoginControllor->LoginClientTotalNum():"+loginC.GetTotalNum());
                break;
            //每条线目前的总人数
            case "LineTotalNum":

                break;
        }
    }
}