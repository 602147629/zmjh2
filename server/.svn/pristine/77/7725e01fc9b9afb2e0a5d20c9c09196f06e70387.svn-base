process.on('uncaughtException',function(err){
    require('Log').error('uncaughtException->'+err.stack);
});


//主程序监听端口
var server = require('./net/Server.js');
//配置文件
var cdc = require('./controllor/ConfigDataControllor.js');


process.on('message',function(data){
    if(data.msg === 'start'){
        var config = data.data;
        var gameConfig = data.gameConfig;
        var logTime = data.logTime;
        var logPath = data.logPath;
        var serverId = data.serverId;

        //生成日志文件名
        require('Log').initLevel(config.path+"_"+config.id,logPath,gameConfig.log.logLevel,logTime);

        //启动进程
        require('Log').info('启动进程!配置:'+JSON.stringify(config));

        //进程名
        process.title = config.preTitle+"-"+config.path;

        //本服配置
        cdc.ServerId = serverId;
        cdc.ServerConfig = config;
        //启动完毕
        var complete = function(){
            require('Log').trace("进程启动中！启动完成");
        }

        var series = [];
        //加载配置
        series.push(function(cb){
            require('Log').trace("进程启动中！加载服务器配置");
            cdc.LoadByPath("./config/"+cdc.ServerId+"/",cb);
        });

        //启动服务
        series.push(function(cb){
            require('Log').trace("进程启动中！启动服务");
            server.StartWithConfig(data,cb);
        });

        require('async').series(series,complete);
    }else{
        server.TelnetCommand(data);
    }
});