var net = require('net');
//连接管理器
var clientSocketControllor;
var rpcSocketControllor;
var filesLoader = require("../tools/FilesLoader.js");

var configDataControllor = require("../controllor/ConfigDataControllor.js");
var rpcConnectorControllor = require("../controllor/RpcConnectorControllor.js");

var cs = require("./ConnectionServer.js");

var gameConfig = require("../const/config.json");

var clientFiles;
var rpcFiles;

var serverControllor;


module.exports = {
    StartWithConfig : function(data,cb){
        require('Log').trace("Server Start At Server(StartWithConfig) init");
        var config = data.data;
        var env = data.env;
        var serverPath = data.serverPath;


        var _self = this;
        var start = function(err){
            if(err){
                require('Log').error("server StartWithConfig callback error!");
                return;
            }
            require('Log').trace("Server Start At Server(StartWithConfig) start");
            clientSocketControllor = require("../modules/"+config.path+"/necessary/ClientSocketControllor.js");
            rpcSocketControllor = require("../modules/"+config.path+"/necessary/RpcSocketControllor.js");

            var clientConfig = config.client;
            if(clientConfig.socketType && clientConfig.port){
                //配置与客户端的连接server
                //与客户端的连接
                clientFiles = filesLoader.Load("./modules/"+config.path+"/message/handler/rm");

                var clientType = clientConfig.socketType;
                _self.clientServer = new cs(clientType);
                _self.clientServer.maxConnections = config.max;//最大连接数限制
                _self.clientServer.listen(config.client.port);
                _self.clientServer.on('connection',function(socket){
                    clientSocketControllor.ClientConnected(socket,clientFiles,clientType);
                });
            }

            var rpcConfig = config.rpc;
            if(rpcConfig.port){
                rpcFiles = filesLoader.Load("./modules/"+config.path+"/message/remote/rm");
                //与服务端的连接
                _self.rpcServer = new cs("socket");
                _self.rpcServer.maxConnections = config.max;//最大连接数限制
                _self.rpcServer.listen(config.rpc.port);
                _self.rpcServer.on('connection',function(socket){
                    rpcSocketControllor.AddReceiveSocket(socket,rpcFiles);
                });
            }

            require('BufferTools').InitWithProtocol(configDataControllor.GetConfigByName('protocal.json'));

            require('Log').trace("Server Start At Server(StartWithConfig) complete");

            if(cb){
                cb();
            }
        }

        require('Log').trace("Server Start At Server(StartWithConfig) loading files");
        //本服配置
        configDataControllor.ServerConfig = config;

        //读取全服配置
        configDataControllor.LoadFile("./config/"+configDataControllor.ServerId+"/","Servers_"+serverPath+"_"+env+".json","Servers.json");
        configDataControllor.AllServersConfig = configDataControllor.GetConfigByName("Servers.json");

        //更新连接服配置
        rpcConnectorControllor.UpdateConfig();


        //读取本服所需配置
        require('Log').trace("进程启动中！加载通用配置");
        configDataControllor.LoadByPath("./common/"+configDataControllor.ServerId+"/",function(){
            //配置完成，通知逻辑层启动
            serverControllor = require("../modules/"+config.path+"/necessary/ServerControllor.js");
            serverControllor.StartWithConfig(config,start);
        });
    },
    TelnetCommand : function(d){
        var msg = d.msg;
        var data = d.data;
        var commandCb = function(){
            //往下通知
            serverControllor.TelnetCommand(msg,data);
        }

        if(msg == "KillGame"){
            commandCb();
            //停止客户端连接服务
            if(this.clientServer){
                this.clientServer.close(function(){
                    require("Log").trace("ClientServer serverId:"+configDataControllor.ServerConfig.id+" close!")
                });
            }

            var self = this;

            require("async").series([
                function(cb){
                    require("Log").trace("Killing clientSocketControllor!");

                    var func = function(){
                        require("Log").trace("Killing clientSocketControllor comlpete!");
                        cb();
                    }
                    clientSocketControllor.KillAll(func);
                }
            ],function(err,results){
                //游戏顺利结束
                if(err){
                    require("Log").error("Server KillGame error!");
                }
                require("Log").trace("KillGameFinish!");
                process.send("KillGameFinish");
            });
        }else if(msg == "UpdateConfig"){
            //重新读取全服配置
            configDataControllor.LoadFileWithCB("./config/"+configDataControllor.ServerId+"/","Servers_"+gameConfig.env+".json","Servers.json",function(err){
                if(!err){
                    configDataControllor.AllServersConfig = configDataControllor.GetConfigByName("Servers.json");

                    //更新本服配置
                    configDataControllor.AllServersConfig.forEach(function(config){
                        if(config.id == configDataControllor.ServerConfig.id){
                            configDataControllor.ServerConfig = config;
                        }
                    });


                    //更新连接管理器path配置
                    rpcConnectorControllor.UpdateConfig();


                    //更新配置文件
                    configDataControllor.LoadByPath("./common/",function(){
                        //往下传
                        commandCb();
                    });
                }else{
                    require("Log").error("Error when UpdateConfig-Loading Servers.json!err:"+err);
                }
            });
        }else{
            //往下传
            commandCb();
        }
    }
}
