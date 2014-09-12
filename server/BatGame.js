var cp = require('child_process');
var fs = require('fs');


var BatGame = {};

//服务器配置
BatGame.servers = [{
    'serverId' : 1,
    'telnetPort' : 4000
}];



BatGame.works = [];

BatGame.Start = function(){
    //生成日志
    var logPath = 'logs/Bat';
    var exist = fs.existsSync(logPath);
    if(!exist){
        fs.mkdirSync(logPath);
    }
    require('Log').initLevel("Bat",logPath,'trace','1');
    //启动服务器
    BatGame.servers.forEach(function(serverCg){
        var data = {
            'msg' : 'Start',
            'serverConfig' : serverCg
        }

        var onExit = function(temp,err){
            BatGame.works.splice(BatGame.works.indexOf(temp),1);

            if(BatGame.works.length == 0){
                //子进程全部都退出了，主进程也退出
                process.exit(0);
            }
        }

        var game = cp.fork('Game.js');
        game.cg = serverCg;
        game.on('exit',onExit.bind(null,game));
        BatGame.works.push(game);
        game.send(data);
    });
}


process.on('SIGTERM',function(){
    BatGame.works.forEach(function(worker){
        worker.send({msg:'KillGame'});
    });
});



process.on('uncaughtException',function(err){
    require('Log').error('uncaughtException->'+err.stack);
});


BatGame.Start();
