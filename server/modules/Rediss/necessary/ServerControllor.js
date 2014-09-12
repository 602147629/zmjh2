var ctmc = require("../controllor/CopyToMysqlControllor.js")
var scheduler = require("pomelo-scheduler");
var db = require("../../../db/DataBase.js");


var killGame = function(){

}

var SaveToMysql = function(){
    ctmc.copyToMysql(null);
}


module.exports = {
    StartWithConfig : function(config,cb){
        require("Log").trace("Redis ServerControllor StartWithConfig config:"+JSON.stringify(config));

        //启动数据库
        db.InitPool(function(){
            //初始化
            ctmc.Init();

            var cronJob = function(data){
                ctmc.copyToMysql(null);
            }
            //启动自动拷贝到mysql服务(凌晨三点)
            scheduler.scheduleJob("0 0 3 * * *", cronJob, {});
            cb();
        });
    },
    //解析telnet命令
    TelnetCommand : function(msg,data){
        require("Log").trace("Master TelnetCommand msg:"+msg+",data:"+JSON.stringify(data));
        switch(msg){
            case "KillGame":
                //停止服务器
                killGame();
            break;
            case "SaveToMysql":
                //将redis数据入库
                SaveToMysql();
                break;
        }
    }
}