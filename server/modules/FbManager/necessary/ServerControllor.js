var apc = require('../controllor/AutoPipeiControllor.js');



module.exports = {
    StartWithConfig : function(config,cb){
        require("Log").trace("FbManager ServerControllor StartWithConfig config:"+JSON.stringify(config));

        cb();
    },
    //解析telnet命令
    TelnetCommand : function(msg,data){
        require("Log").trace("FbManager TelnetCommand msg:"+msg+",data:"+JSON.stringify(data));
        switch(msg){
            case "UpdateConfig":
                //更新线配置
                break;
            case "StartToGate":
                //开始向网关服务器注册
                break;
            case "KillGame":
                //关闭游戏
                break;
            case "ReadyToKill":
                //准备关闭游戏
                apc.IsReadyToKill = true;
                break
        }
    }
}