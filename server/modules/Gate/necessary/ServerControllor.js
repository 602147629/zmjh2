

var killGame = function(){

}


module.exports = {
    StartWithConfig : function(config,cb){
        require("Log").trace("Gate ServerControllor StartWithConfig config:"+JSON.stringify(config));

        if(cb){
            cb(null);
        }
    },
    //解析telnet命令
    TelnetCommand : function(msg,data){
        require("Log").trace("Gate TelnetCommand msg:"+msg+",data:"+JSON.stringify(data));
        switch(msg){
            case "KillGame":
                //停止服务器
                killGame();
            break;
        }
    }
}