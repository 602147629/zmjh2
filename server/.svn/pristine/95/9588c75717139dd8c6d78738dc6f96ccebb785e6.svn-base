var roomControllor = require("../controllor/RoomControllor.js");
var configDataControllor = require("../../../controllor/ConfigDataControllor.js");


module.exports = {
    StartWithConfig : function(config,cb){
        require("Log").trace("Fb ServerControllor StartWithConfig config:"+JSON.stringify(config));
        var fbConfig = configDataControllor.GetConfigByName("Fb.json");
        require("SuperUtils").forEachInArray(fbConfig,function(fb){
            if(fb.serverid == config.id){
                //初始化房间管理器
                roomControllor.InitWithConfig(fb);
                return true;
            }
        });
        if(cb){
            cb();
        }
    },
    //解析telnet命令
    TelnetCommand : function(msg,data){
        switch(msg){

        }
    }
}