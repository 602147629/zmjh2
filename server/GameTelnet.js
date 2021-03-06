var EventEmitter = require("events").EventEmitter;

var gameConfig = require("./const/config.json");

var GameTelnet = function(serverId,serverPath,env){
    EventEmitter.call(this);

    var file = require("fs").readFileSync("./config/"+serverId+"/Servers_"+serverPath+"_"+env+".json",'utf8');
    this.serverConfig = JSON.parse(file);
};


require('util').inherits(GameTelnet, EventEmitter);


GameTelnet.prototype.workers;//进程集
GameTelnet.prototype.serverConfig;


GameTelnet.prototype.TelnetCommand = function(funcName,params,socket){
    if(this[funcName]){
        if(funcName != 'Login'){
            if(!socket.isLogin){
                //密码不对的连接，直接掐掉
                socket.destroy();
                return;
            }
        }
        require('Log').info('TelnetCommand funcName:'+funcName+',params:'+JSON.stringify(params));
        this[funcName](params,socket);

        var buf = new Buffer(funcName,'utf8');
        socket.write(buf);
    }
}


GameTelnet.prototype.Login = function(params,socket){
    var pwd = params[0];
    if(pwd === 'iamagoodboy'){
        socket.isLogin = true;
    }
}


GameTelnet.prototype.StartToGate = function(params,socket){
    require('Log').info('TelnetCommand StartToGate!');
    this.workers.forEach(function(worker){
        worker.send({msg:"StartToGate"});
    });
}

//更新配置
GameTelnet.prototype.UpdateConfig = function(params,socket){
    require('Log').info('TelnetCommand UpdateConfig!');

    this.workers.forEach(function(worker){
        worker.send({msg:"UpdateConfig"});
    });
}

//公告转发
GameTelnet.prototype.BrocastMsg = function(params,socket){
    require('Log').info('TelnetCommand BrocastMsg!');

    this.workers.forEach(function(worker){
        worker.send({msg:"BrocastMsg","data" : params});
    });
}

//杀掉一个进程
GameTelnet.prototype.KillOneProcess = function(params,socket){
    require('Log').info('TelnetCommand KillOneProcess!');

    var serverId = params[0];
    this.workers.forEach(function(worker){
        if(worker.config.id == serverId){
            worker.send({msg:"KillGame"});

            worker.on("message",function(msg){
                //游戏杀完，整个over掉
                if(msg == "KillGameFinish"){
                    worker.exit(0);
                }
            })
        }
    });
}

//启动一个进程
GameTelnet.prototype.StartOneProcess = function(params,socket){
    require('Log').info("StartOneProcess params:"+JSON.stringify(params));

    var bool = true;
    var serverId = params[0];
    this.workers.forEach(function(worker){
        if(worker.config.id == serverId){
            require('Log').info("这个id的服务器已经启动了 serverId:"+serverId);
            bool = false;
            //这个id的服务器已经启动了
        }
    });
    if(bool){
        var cg;
        this.serverConfig.forEach(function(config){
            if(config.id == serverId){
                cg = config;
            }
        });
        //启动
        if(cg){
            require('Log').info("StartOneProcess success!");
            this.emit('StartProcess',cg);
        }else{
            require('Log').error("StartOneProcess fail!Not this config exist!");
        }
    }
}

GameTelnet.prototype.SaveToMysql = function(params,socket){
    require('Log').info('TelnetCommand SaveToMysql!');

    this.workers.forEach(function(worker){
        worker.send({msg:"SaveToMysql"});
    });
}

//准备关闭服务器了
GameTelnet.prototype.ReadyToKill = function(params,socket){
    require('Log').info('TelnetCommand ReadyToKill!');

    this.workers.forEach(function(worker){
        worker.send({msg:"ReadyToKill"});
    });
}

//杀掉游戏
GameTelnet.prototype.KillGame = function(params,socket){
    console.log('KillGame');
    this.workers.forEach(function(work){
        console.log('pid:'+work.pid);
    });
    var len = Object.keys(this.workers).length;

    var pids = [];
    this.workers.forEach(function(worker){
        worker.send({msg:"KillGame"});
        worker.on("message",function(msg){
            //游戏杀完，整个over掉
            if(msg === "KillGameFinish"){
                pids.push(worker.pid);
                //process.kill(worker.pid);
                len--;
                require('Log').info("KillGameFinish!currentLen:"+ len);
                if(len === 0){
                    //退出完毕,杀掉子进程
                    pids.forEach(function(pid){
                        process.kill(pid);
                    });
                    //关闭主进程
                    process.exit(0);
                }
            }
        })
    });
}



module.exports = GameTelnet;