var cp = require('child_process');


var gameConfig = require("./const/config.json");
var gameTelnetClass = require('./GameTelnet.js');
var net = require('net');
var works = [];
var fs = require('fs');

var Game = {};

Game.serverConfig;//系统配置
Game.serverId;//服务器ID
Game.gameTelnet;//telnet处理
Game.logTime;//日志生成时间
Game.logPath;//日志路径
Game.serverPath;//服务器路径后缀(157,222等)
Game.env;//develop/deploy

Game.telnetPort = 4000;//后台管理接入端口


process.title = 'ZMJH2-Main';

Game.Start = function(config){
    //服务器ID
    Game.serverId = config.serverId;
    Game.telnetPort = config.telnetPort;

    console.log("1111:"+JSON.stringify(process.argv))
    if(process.argv.length == 2){
        //本地运行
        process.argv.push("107");
        process.argv.push("develop");
    }

    Game.serverPath = process.argv[3];
    Game.env = process.argv[2];

    //日志生成时间，区分日志路径
    var d = new Date();
    var date = d.getFullYear()+"-"+ (d.getMonth()+1) + "-" + d.getDate();
    var time = d.toLocaleTimeString();
    while(time.indexOf(":") != -1){
        time = time.replace(":","-");
    }
    //生成日志文件名
    Game.logTime = date + " " + time;
    //日志路径
    Game.logPath = 'logs/'+Game.serverId;
    var exist = fs.existsSync(Game.logPath);
    if(!exist){
        fs.mkdirSync(Game.logPath);
    }
    require('Log').initLevel("Main",Game.logPath,gameConfig.log.logLevel,Game.logTime);


    Game.gameTelnet = new gameTelnetClass(Game.serverId,Game.serverPath,Game.env);

    var series = [];

    series.push(function(cb){
        Game.loadConfig(cb)
    });

    series.push(function(cb){
        Game.startTelnet(cb);
    });

    series.push(function(cb){
        Game.startServer(cb);
    });

    require('async').series(series,null);
}

//启动服务器
Game.startServer = function(){
    Game.gameTelnet.on('StartProcess',function(config){
        Game.startProcessByConfig(config);
    });

    //根据服务器配置，启动进程
    for(var i=0;i<Game.serverConfig.length;i++){
        var cc = Game.serverConfig[i];
        if(cc.self === 1){
            Game.startProcessByConfig(cc);
        }
    }

    Game.gameTelnet.workers = works;
}

//加载/更新配置
Game.loadConfig = function(cb){
    var file = require("fs").readFileSync("./config/"+Game.serverId+"/Servers_"+Game.serverPath+"_"+Game.env+".json",'utf8');
    Game.serverConfig = JSON.parse(file);
    Game.gameTelnet.serverConfig = Game.serverConfig;
    if(cb){
        cb();
    }
}

//根据配置启动进程
Game.startProcessByConfig = function(cc){
    var work = cp.fork('Server.js');
    work.config = cc;

    var onExit = function(temp,err){
        require('Log').info("Process exit!err:"+err+",config:"+JSON.stringify(temp.config));

        works.splice(works.indexOf(temp),1);
        Game.gameTelnet.workers = works;
    }

    //子进程退出
    work.on('exit',onExit.bind(null,work));
    var data = {
        'msg' : 'start',
        'data' : cc,
        'serverId' : Game.serverId,
        'gameConfig' : gameConfig,
        'logTime' : Game.logTime,
        'logPath' : Game.logPath,
        'env' : Game.env,
        'serverPath' : Game.serverPath
    }
    work.send(data);
    works.push(work);
}

//telnet
Game.startTelnet = function(cb){
    var server = net.createServer();
    server.maxConnections = 0;//最大连接数限制
    server.listen(Game.telnetPort);
    server.on('connection',function(socket){
        socket.on('data', function(d) {
            data = d.toString('utf8').trim();

            if(data == ""){
                return;
            }
            //解析命令
            var arr = data.split(' ');
            var funcName = arr.shift();

            Game.gameTelnet.TelnetCommand(funcName,arr,socket);
        });

        socket.on('close', function() {
            socket.destroy();
        });
    });

    if(cb){
        cb();
    }
}


//启动
Game.Start({'serverId':"1",'telnetPort':4000});


process.on('message',function(data){
    if(data.msg === 'Start'){
        //启动服务器
        var cg = data.serverConfig;
        Game.Start(cg);
    }else if(data.msg === 'KillGame'){
        //温柔的杀死进程
        Game.gameTelnet.KillGame();
    }
});


process.on('SIGTERM',function(){
    Game.gameTelnet.KillGame();
//    works.forEach(function(work){
//        process.kill(work.pid);
//    });
//    process.exit(0);
});

//process.on('exit',function(){
//    works.forEach(function(work){
//        process.kill(work.pid);
//    });
//});

process.on('uncaughtException',function(err){
    require('Log').error('uncaughtException->'+err.stack);
});