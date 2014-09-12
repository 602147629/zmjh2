//rpc连接
var rpcConnectorClass = require("../net/RpcConnector.js");
//文件加载器
var filesLoader = require("../tools/FilesLoader.js");
var cdc = require("./ConfigDataControllor.js");

var connectors = [];//rpc连接数组
var pathConfig;

module.exports = {
    //更新服务器配置(根据path划分数组)
    UpdateConfig : function(){
        pathConfig = {};
        cdc.AllServersConfig.forEach(function(config){
            if(!pathConfig[config.path]){
                pathConfig[config.path] = [];
            }
//            if(config.self === 1){
                pathConfig[config.path].push(config);
//            }
        });
    },
    //根据路径获取对应的服务器数组
    GetPathArrayByPath : function(path){
        return pathConfig[path].concat();
    },
    //按照配置获取rpc连接
    GetConnector : function(config,cb){
        //判定是否是本身
        if(config.id == cdc.ServerConfig.id){
            if(cb){
                cb('CAN_NOT_CONNECT_TO_SELF');
            }
            return;
        }

        if(connectors[config.id]){
            //已经存在的连接
            if(cb){
                cb(null,connectors[config.id]);
            }
        }else{
            //新建链接
            var rpcConnector = new rpcConnectorClass(filesLoader.Load("./modules/"+cdc.ServerConfig.path+"/message/remote/rm"));
            rpcConnector.connect(config);
            rpcConnector.on("connect",function(){
                //发送服务器信息
                if(cb){
                    cb(null,rpcConnector);
                }
            });
            rpcConnector.on("destroy",function(){
                connectors.splice(connectors.indexOf(rpcConnector),1);
            });
            connectors[config.id] = rpcConnector;
        }
    },
    //向X类型服务器发送消息，带回调函数,each:每个符合条件的情况下，回调一次
    BrocastByPath : function(path,fileName,funcName,data,cb,each){
        var paths = pathConfig[path];
        if(!paths){
            require('Log').error('RCC->BrocastByPath() NOT THIS PATH:'+path);
            return;
        }
        paths.forEach(function(config){
            if(config.path == path){
                //不能跟自己连接
                if(config.id != cdc.ServerConfig.id){
                    module.exports.GetConnector(config,function(err,rpcConnector){
                        if(!err){
                            if(each){
                                each();
                            }
                            if(cb){
                                rpcConnector.sendWithCb(fileName,funcName,data,cb);
                            }else{
                                rpcConnector.send(fileName,funcName,data);
                            }
                        }else{
                            if(cb){
                                cb(err);
                            }
                        }
                    });
                }
            }
        });
    },
    //发送到指定id的服务器
    SendByServerId : function(id,fileName,funcName,data,cb,each){
        var bool = false;
        require("SuperUtils").forEachInArray(cdc.AllServersConfig,function(config){
            if(config.id == id){
                bool = true;
                module.exports.GetConnector(config,function(err,rpcConnector){
                    if(!err){
                        if(each){
                            each(config);
                        }
                        if(cb){
                            rpcConnector.sendWithCb(fileName,funcName,data,cb);
                        }else{
                            rpcConnector.send(fileName,funcName,data);
                        }
                    }else{
                        if(cb){
                            cb(err);
                        }
                    }
                });
                return true;
            }
        });
    },
    //发送到指定配置的服务器
    SendByConfig : function(config,fileName,funcName,data,cb,each){
        module.exports.GetConnector(config,function(err,rpcConnector){
            if(!err){
                if(each){
                    each();
                }
                if(cb){
                    rpcConnector.sendWithCb(fileName,funcName,data,cb);
                }else{
                    rpcConnector.send(fileName,funcName,data);
                }
            }else{
                if(cb){
                    cb(err);
                }
            }
        });
    },
    KillAll : function(cb){
        require("Log").trace("=========KillAll========");
        //杀掉游戏
        require("SuperUtils").forEachInArray(connectors,function(client){
            client.destroy();
        });
        if(cb){
            cb();
        }
    }
}